import { router } from '@kit.ArkUI'
import {PageIDInfo} from '../model/PageIDInfo'
import {PageNumber , PageName , PageSVG} from '../ViewModel/PageNumber'
import VIP from '../view/VIP/VIP'
import { display, window } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { VideoPlayView } from '../view/VideoPlayView'
import { AVDataSource } from '../model/AVDataSource';
import { CommonConstants as Const } from '../common/CommonConstants';

@Entry
@Component
struct Index {

  @State curIndex: number = 0;
  //是否首次加载
  @State firstFlag: boolean = true;
  @State isPageShow: boolean = false;
  @State foldStatus: number = 0;
  @Provide isFirstAVPlayer: boolean = true;
  private swiperController: SwiperController = new SwiperController();

  @Builder
  tabBarBuilder(itemIndex : number) {
    Column() {
      if (itemIndex == this.Select) {
        Image($r(`app.media.${PageSVG[itemIndex]}2`))
          .width(30)
      }
      else {
        Image($r(`app.media.${PageSVG[itemIndex]}1`))
          .width(30)
      }
      Text(PageName[itemIndex])
        .fontSize(15)
        .fontColor(itemIndex == this.Select ? Color.Black : '#D6DFEA')
    }
    .width('100%')
    .height("100%")
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      router.replaceUrl({
        // url : "pages/Index",
        // params : { name:'haha',age:4}
        url : `${PageNumber[itemIndex]}`,
        params : { pageID : itemIndex}
      })
    })
  }

  @State Select : Number = 0
  // aboutToAppear(): void {
  //
  //   const params = router.getParams() as PageIDInfo
  //   console.log(params.pageID.toString())
  //   // 打印参数 params 打印出来是一个对象
  //   this.Select = params.pageID
  //
  // }

  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as PageIDInfo
    console.log(params.pageID.toString())
    // 打印参数 params 打印出来是一个对象
    this.Select = params.pageID
    let context = getContext(this);
    let windowClass = await window.getLastWindow(context);
    await windowClass.setWindowKeepScreenOn(true);
    display.on('foldStatusChange', (foldStatus: display.FoldStatus) => {
      this.foldStatus = foldStatus;
    })
  }

  onPageHide(): void {
    this.isPageShow = false;
  }

  onPageShow(): void {
    this.isPageShow = true;
  }

  build() {
    Column() {
      Tabs({ index: 2}) {

        ForEach(PageName,(item : string,Index) => {
          TabContent() {
            if (Index == 2) {
              // VIP()
              Swiper(this.swiperController) {
                LazyForEach(new AVDataSource(Const.VIDEO_SOURCE), (item: string, index: number) => {
                  VideoPlayView({
                    curSource: item,
                    curIndex: this.curIndex,
                    index: index,
                    firstFlag: this.firstFlag,
                    isPageShow: this.isPageShow,
                    foldStatus: this.foldStatus
                  })
                }, (item: string, index: number) => JSON.stringify(item) + index)
              }
              .cachedCount(this.firstFlag ? 0 : 2)
              .width('100%')
              .height('100%')
              .vertical(true)
              .loop(true)
              .curve(Curve.Ease)
              .duration(300)
              .indicator(false)
              .backgroundColor(Color.Black)
              .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
                this.curIndex = targetIndex;
              })
            }
          }
          .tabBar(this.tabBarBuilder(Index))
        })
      }
      .onChange((Index : number) => {
        this.Select = Index
      })
      .width('100%')
      .height('100%')
      .scrollable(false)
      .barPosition(BarPosition.End)
    }
    .width("100%")
    .height("100%")
  }
}