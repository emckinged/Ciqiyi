import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { pauseVideo, playVideo, releaseVideo, secondToTime, setSeek } from '../common/utils/CommonUtils';
import { CommonConstants as Const } from '../common/CommonConstants';

const TAG = '[VideoPlayer]';

@Preview
@Component
export struct VideoPlayView {
  @State aspRatio: number = 0.5;
  @State XComponentHeight: number = Const.SURFACE_HEIGHT;
  @State XComponentWidth: number = Const.SURFACE_WIDTH;
  @State isPlaying: boolean = true;
  @State isTimeDisplay: number = 0;
  @State trackThicknessSize: number = Const.TRACK_SIZE_MIN;
  @State flag: boolean = false;
  @State currentTime: number = 0;
  @State durationTime: number = 0;
  @State durationStringTime: string = '00:00';
  @State currentStringTime: string = '00:00';
  @State screenHeight: number = display.getDefaultDisplaySync().height;
  @State screenWidth: number = display.getDefaultDisplaySync().width;
  @Link firstFlag: boolean;
  public index: number = 0;
  public curSource: media.AVFileDescriptor | string = '';
  private duration: number = 0;
  private surfaceID: string = '';
  private xComponentController = new XComponentController();
  private avPlayer: media.AVPlayer | undefined = undefined;
  private isSliderMoving: boolean = false;
  private videoHeight: number = Const.SURFACE_HEIGHT;
  private videoWidth: number = Const.SURFACE_WIDTH;

  @Prop @Watch('onIndexChange') curIndex: number = -1;
  // 页面不可见的时候暂停视频
  @Prop @Watch('onPageShowWatch') isPageShow: boolean = false;
  // 调节尺寸
  @Prop @Watch('onFoldStatusChange') foldStatus: number = 0;

  aboutToDisappear(): void {
    hilog.info(0x0000, TAG,
      `aboutToDisappear curIndex: ${this.curIndex}, index: ${this.index}, isPageShow: ${this.isPageShow}.`);
    releaseVideo(this.avPlayer, this.curIndex, this.index);
  }

  onPageShowWatch() {
    if (!this.isPageShow && this.curIndex === this.index) {
      pauseVideo(this.avPlayer, this.curIndex, this.index);
      this.isPlaying = false;
      this.trackThicknessSize = Const.TRACK_SIZE_MIN;
    }
  }

  onIndexChange() {
    hilog.info(0x0000, TAG,
      `enter onIndexChange. curIndex: ${this.curIndex}, index: ${this.index}, isPageShow: ${this.isPageShow}.`);
    if (this.curIndex !== this.index) {
      pauseVideo(this.avPlayer, this.curIndex, this.index);
      this.isPlaying = false;
      this.trackThicknessSize = Const.TRACK_SIZE_MIN;
    } else {
      hilog.info(0x0000, TAG,
        `enter indexChange play. curIndex: ${this.curIndex}, index: ${this.index}, isPageShow: ${this.isPageShow}.`);
      if (this.flag === true) {
        playVideo(this.avPlayer, this.curIndex, this.index);
        this.isPlaying = true;
        this.trackThicknessSize = Const.TRACK_SIZE_MIN;
      } else {
        let countNum = 0;
        let intervalFlag = setInterval(() => {
          countNum++;
          if (this.curIndex !== this.index) {
            hilog.info(0x0000, TAG, `enter indexChange play error, clearIntreval. flag: ${this.flag},
            curIndex: ${this.curIndex}, index: ${this.index}.`);
            clearInterval(intervalFlag);
          }
          if (this.flag === true && this.isPageShow) {
            countNum = 0;
            playVideo(this.avPlayer, this.curIndex, this.index);
            this.isPlaying = true;
            this.trackThicknessSize = Const.TRACK_SIZE_MIN;
            clearInterval(intervalFlag);
          } else {
            hilog.info(0x0000, TAG, `enter indexChange play error, clearIntreval. countNum: ${countNum},
             flag: ${this.flag}, curIndex: ${this.curIndex}, index: ${this.index}.`);
            if (countNum > 15) {
              hilog.info(0x0000, TAG,
                `enter indexChange play error, reinit initAVPlayer. countNum: ${countNum}, flag: ${this.flag},
                curIndex: ${this.curIndex}, index: ${this.index}.`);
              countNum = 0;
              this.initAVPlayer();
            }
          }
        }, 100);
      }
    }
  }

  onFoldStatusChange() {
    this.autoVideoSize();
  }

  //自动调整屏幕尺寸
  autoVideoSize() {
    display.getAllDisplays((err, data) => {
      this.screenWidth = data[0].width;
      this.screenHeight = data[0].height;
      let videoRatio: number = Number(this.videoWidth) / Number(this.videoHeight);
      let screenRatio = this.screenWidth / this.screenHeight;
      if (videoRatio > screenRatio) {
        this.XComponentWidth = px2vp(this.screenWidth);
        this.XComponentHeight = px2vp(this.videoHeight * this.screenWidth / this.videoWidth);
      } else {
        this.XComponentWidth = px2vp(this.videoWidth * this.screenHeight / this.videoHeight);
        this.XComponentHeight = px2vp(this.screenHeight);
      }
    });
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Stack() {
          if (!this.isPlaying) {
            Image($r('app.media.play'))
              .width('56vp')
              .height('56vp')
              .zIndex(2)
          }

          Column() {
            XComponent({
              id: 'player',
              type: XComponentType.SURFACE,
              controller: this.xComponentController
            })
              .width(this.XComponentWidth)
              .height(this.XComponentHeight)
              .onLoad(async () => {
                this.surfaceID = this.xComponentController.getXComponentSurfaceId();
                hilog.info(0x0000, TAG,
                  `surfaceID: ${this.surfaceID}, curIndex: ${this.curIndex}, index: ${this.index}.`);
                this.initAVPlayer();
              })
          }
          .zIndex(1)
        }

        this.playControl()
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .width('100%')
    .height('100%')
    .onClick(() => {
      this.iconOnClick();
    })
  }

  //播放控制组件
  @Builder
  playControl() {
    Column() {
      Blank('600vp')

      Row() {
        Text(this.currentStringTime)
          .fontSize('20vp')
          .fontColor(Color.White)
          .margin({ left: '2vp' })
          .width('45%')
          .textAlign(TextAlign.End)
          .zIndex(3)

        Divider()
          .vertical(true)
          .height('14vp')
          .width('2vp')
          .backgroundBlurStyle(BlurStyle.Regular, { colorMode: ThemeColorMode.LIGHT })
          .color(Color.White)
          .opacity(0.5)
          .margin({ left: 8, right: 8 })
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '50%',
            centerY: '50%',
            angle: 30
          })

        Text(this.durationStringTime)
          .fontSize('20vp')
          .fontColor(Color.White)
          .margin({ left: '2vp' })
          .width('45%')
          .textAlign(TextAlign.Start)
          .opacity(0.5)
          .zIndex(3)
      }
      .width('100%')
      .opacity(this.isTimeDisplay)

      Blank('50vp')

      Slider({
        value: this.currentTime,
        step: 0.1,
        min: 0,
        max: this.durationTime,
        style: SliderStyle.NONE
      })
        .width('100%')
        .height('20vp')
        .trackColor(Color.Gray)
        .selectedColor(Color.White)
        .showSteps(false)
        .showTips(false)
        .trackThickness(this.trackThicknessSize)
        .trackBorderRadius(2)
        .zIndex(3)
        .onChange((value: number, mode: SliderChangeMode) => {
          this.sliderOnChange(value, mode);
        })
    }
  }

  //点击事件
  async iconOnClick() {
    if (this.isPlaying) {
      pauseVideo(this.avPlayer, this.curIndex, this.index);
      this.isPlaying = false;
      this.isTimeDisplay = 0;
      this.trackThicknessSize = Const.TRACK_SIZE_MIN;
      let context = getContext(this);
      let windowClass = await window.getLastWindow(context);
      await windowClass.setWindowKeepScreenOn(false);
      return;
    }
    if (this.flag === true) {
      playVideo(this.avPlayer, this.curIndex, this.index);
      this.isPlaying = true;
      this.isTimeDisplay = 0;
      this.trackThicknessSize = Const.TRACK_SIZE_MIN;
    } else {
      let intervalFlag = setInterval(async () => {
        if (this.flag === true) {
          playVideo(this.avPlayer, this.curIndex, this.index);
          this.isPlaying = true;
          this.isTimeDisplay = 0;
          this.trackThicknessSize = Const.TRACK_SIZE_MIN;
          clearInterval(intervalFlag);
        }
      }, 100);
    }
    let context = getContext(this);
    let windowClass = await window.getLastWindow(context);
    await windowClass.setWindowKeepScreenOn(true);
  }

  //进度条变化
  sliderOnChange(value: number, mode: SliderChangeMode) {
    this.currentTime = value;
    let seekTime: number = value * this.duration / this.durationTime;
    if (mode === SliderChangeMode.Begin || mode === SliderChangeMode.Moving) {
      this.isTimeDisplay = 1;
      this.trackThicknessSize = Const.TRACK_SIZE_MAX;
    }
    if (mode === SliderChangeMode.Moving) {
      this.currentStringTime = secondToTime(Math.floor(seekTime / 1000));
      this.isSliderMoving = true;
    }
    if (mode === SliderChangeMode.End || mode === SliderChangeMode.Click) {
      this.currentStringTime = secondToTime(Math.floor(seekTime / 1000));
      setSeek(this.avPlayer, seekTime);
      this.isTimeDisplay = 0;
      this.trackThicknessSize = Const.TRACK_SIZE_MIN;
      this.isSliderMoving = false;
    }
  }

  //初始化视频播放器
  async initAVPlayer() {
    hilog.info(0x0000, TAG, `createAVPlayer begin. curIndex: ${this.curIndex}, index: ${this.index}.`);
    media.createAVPlayer().then((video: media.AVPlayer) => {
      if (video === undefined) {
        hilog.error(0x0000, TAG, `createAVPlayer fail.`);
        return;
      }
      this.avPlayer = video;
      this.setAVPlayerCallback(this.avPlayer);
      // set url into state initialized.
      if (typeof this.curSource === 'string') {
        this.avPlayer.url = this.curSource;
        hilog.info(0x0000, TAG,
          `AVPlayer state idle. source: ${this.curSource}, curIndex: ${this.curIndex}, index: ${this.index}.`);
      } else {
        this.avPlayer.fdSrc = this.curSource;
      }
      hilog.info(0x0000, TAG, `createAVPlayer success. curIndex: ${this.curIndex}, index: ${this.index}.`);
    })
  }

  //设置视频播放器回调方法
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    avPlayer.on('timeUpdate', (time: number) => {
      if (!this.isSliderMoving) {
        this.currentTime = Math.floor(time * this.durationTime / this.duration);
        this.currentStringTime = secondToTime(Math.floor(time / 1000));
      }
    })

    avPlayer.on('videoSizeChange', (width: number, height: number) => {
      this.videoHeight = height;
      this.videoWidth = width;
      this.autoVideoSize();
    })

    //error listen, when the avPlayer is error, to load reset interface
    avPlayer.on('error', (err: BusinessError) => {
      hilog.error(0x0000, TAG, `Invoke avPlayer failed, code is ${err.code}, message is ${err.message}.` +
        `----state: ${avPlayer.state}, curIndex: ${this.curIndex}, index: ${this.index}.`);
      avPlayer.reset();
    })
    this.setAVPlayerStateListen(avPlayer);
  }

  //设置视频播放器状态监听方法
  setAVPlayerStateListen(avPlayer: media.AVPlayer) {
    avPlayer.on('stateChange', async (state: string) => {
      switch (state) {
        case 'idle':
          hilog.info(0x0000, TAG, `AVPlayer state idle called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          break;
        case 'initialized':
          hilog.info(0x0000, TAG,
            `AVPlayer state initialized called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          avPlayer.surfaceId = this.surfaceID;
          avPlayer.prepare();
          break;
        case 'prepared':
          hilog.info(0x0000, TAG, `AVPlayer state prepared called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE;
          this.flag = true;
          avPlayer.loop = true;
          this.duration = avPlayer.duration;
          this.durationTime = Math.floor(this.duration / 1000);
          this.durationStringTime = secondToTime(this.durationTime);
          if (this.firstFlag && this.index === 0 && this.isPageShow) {
            avPlayer.play();
            this.firstFlag = false;
          }
          break;
        case 'playing':
          hilog.info(0x0000, TAG,
            `AVPlayer state playing called. curIndex: ${this.curIndex}, index: ${this.index},
            source: ${this.curSource}.`);
          this.isPlaying = true;
          break;
        case 'paused':
          hilog.info(0x0000, TAG, `AVPlayer state paused called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          break;
        case 'stopped':
          hilog.info(0x0000, TAG, `AVPlayer state stopped called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          break;
        case 'completed':
          hilog.info(0x0000, TAG, `AVPlayer state completed called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          this.isPlaying = false;
          break;
        case 'released':
          hilog.info(0x0000, TAG, `AVPlayer state released called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          break;
        case 'error':
          hilog.error(0x0000, TAG, `AVPlayer state error called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          avPlayer.reset();
          break;
        default:
          hilog.error(0x0000, TAG, `AVPlayer state unknown called. curIndex: ${this.curIndex}, index: ${this.index}.`);
          break;
      }
    })
  }
}