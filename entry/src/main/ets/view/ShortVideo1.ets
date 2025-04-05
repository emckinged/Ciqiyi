@Component
export default struct ShortVideo {
  @State i : string[] = ['https://v-cdn.zjol.com.cn/280443.mp4','https://v-cdn.zjol.com.cn/276982.mp4','https://v-cdn.zjol.com.cn/276984.mp4']
  @State speed: number = 1
  @State key1 : number = 0
  @State xun : boolean = false
  controller: VideoController = new VideoController()
  SwiperController: SwiperController = new SwiperController()
  build() {
    Column() {
      Swiper(this.SwiperController) {
        ForEach(this.i,(item:string,Index) => {
          Stack({ alignContent : Alignment.Center }) {
            // if (Index == this.key1) {

              Video({
                controller: this.controller,
                currentProgressRate: this.speed,
                src: `${this.i[Index]}`
              })
                .width('100%')
                .aspectRatio(1.6)
                .autoPlay(true)
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
                    this.controller.setCurrentTime(30)
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
      .indicator(false)
      .loop(false)
      .onAnimationStart(() => {
        this.key1++
        this.controller.setCurrentTime(0)
      })
    }
    .width('100%').height('100%')
  }
}