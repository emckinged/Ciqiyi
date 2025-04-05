@Component
export default struct ShortVideo {
  @State i : string[] = ['https://v-cdn.zjol.com.cn/280443.mp4','https://v-cdn.zjol.com.cn/276982.mp4','https://v-cdn.zjol.com.cn/276984.mp4']
  @State speed: number = 1
  @State key1 : number = 0
  @State xun : boolean = false
  @State videoNumber : number = 0
  controller: VideoController = new VideoController()
  controller1: VideoController = new VideoController()
  SwiperController: SwiperController = new SwiperController()
  build() {
    Column() {
      Swiper(this.SwiperController) {
        // 改写为懒加载时尽量用AVPlayer只预加载后一个视频
        ForEach(this.i,(item:string,Index) => {
          Stack({ alignContent : Alignment.Center }) {
            // if (Index == this.key1) {
                if (this.videoNumber === Index) {
                  Video({
                    controller: this.controller,
                    currentProgressRate: this.speed,
                    src: `${this.i[Index]}`
                  })
                    .width('100%')
                    .aspectRatio(1.6)
                    .autoPlay(true)
                    .objectFit(ImageFit.Contain)
                }
                else {
                  Video({
                    currentProgressRate: this.speed,
                    src: `${this.i[Index]}`,
                  })
                    .width('100%')
                    .aspectRatio(1.6)
                    .objectFit(ImageFit.Contain)
                }
                  // .controls(false)


                  // .autoPlay(true)
                // .controls(false)  //播放栏是否显示
            // }
            // else {
            //   Video({
            //     currentProgressRate: this.speed,
            //     controller: this.controller1,
            //     src: `${this.i[Index]}`
            //     // src: $rawfile('dijia.mp4')
            //   })
            //     .width('100%')
            //     .aspectRatio(1.6)
            //    // .autoPlay(true)   //自动播放
            //    // .controls(false)  //播放栏是否显示
            // }
            Column() {
              Slider({
                value: this.speed,
                min: 0.75,
                step: 0.25,
                max: 2,
                style: SliderStyle.InSet
              })
                .showSteps(true)
                .onChange(value => {
                  this.speed = value
                })
              Text(this.speed+"倍速").fontSize(14).textAlign(TextAlign.Center).width('100%').fontColor(Color.Blue)
              Row({ space: 20 }) {
                Button("播放")
                  .onClick(() => {
                    this.controller.start()
                  })
                Button("暂停")
                  .onClick(() => {
                    this.controller.pause()
                  })
                Button("移动进度")
                  .onClick(() => {
                    this.controller.setCurrentTime(30) // 这里的单位为秒
                  })
                Button("结束")
                  .onClick(() => {
                    this.controller.stop()
                  })
              }
            }
            .width('100%')
            .height('100%')
            .padding(10)
            .justifyContent(FlexAlign.End)
          }
        })
      }
      .width('100%')
      .height('100%')
      .autoPlay(false)
      .vertical(true)
      .indicator(false)   //不显示导航点
      .loop(false)
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        if (index === targetIndex) {
          return
        }
        else {
          this.videoNumber = targetIndex
          this.controller.setCurrentTime(0)
        }
      })
      // .onAnimationStart(() => {
      //   this.key1++
      //   this.controller.setCurrentTime(0)
      //   this.controller.reset()
      //   this.controller1.setCurrentTime(0)
      //   // this.controller.reset()
      // })
      // .disableSwipe(true) //是否允许滑动切换


      //以下为刚开是感觉可以绑定手势的代码，目前看没什么用
      // .onChange(() => {
      //   this.key1++
      //   this.controller.setCurrentTime(0)
      //   this.controller1.setCurrentTime(0)
      //   // this.controller.reset()
      // })
      // .onTouch((event) => {
      //   let a = event.type
      //   if (a == TouchType.Up) {
      //     this.xun = true
      //   }
      // })
      // .onGestureSwipe((Index1,event) => {
      //   const currentOffset = event.currentOffset;
      //   const targetOffset = event.targetOffset;
      //   const velocity = event.velocity;
      //   if (this.xun == false) return;
      //   if (currentOffset > 50) {
      //     this.SwiperController.showPrevious()
      //     this.controller.setCurrentTime(0)
      //     console.log('111')
      //     this.xun = false
      //   }
      //   if (currentOffset < -50) {
      //     this.SwiperController.showNext()
      //     this.controller.setCurrentTime(0)
      //     console.log('222')
      //     this.xun = false
      //   }
      // })
    }
    .width('100%').height('100%')
  }
}