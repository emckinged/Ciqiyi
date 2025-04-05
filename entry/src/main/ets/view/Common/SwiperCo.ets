import router from '@ohos.router';
@Preview
@Component
export default struct SwiperCo {
  @State Name : string[] = []
  @State Image : string[] = []
  build() {
    Column() {
      Swiper() {
        ForEach(this.Name,(item:string,Index) => {

          Row() {
            Column() {
              Image($r("app.media.vip"))
                .height(20)
                .padding({
                  top : 5,
                  left : 3
                })

              Text(this.Name[Index])
                .fontSize(30)
                .fontColor(Color.White)
                .padding(15)
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.SpaceBetween)
            .height("100%")
            .width("100%")

          }
          .onClick(() => {
            router.pushUrl({
              url: 'pages/PlayPage'
            })
          })
          .width('100%')
          .height(200)
          .backgroundImage($r(`app.media.${this.Image[Index]}`))
          .backgroundImageSize({
            width : '100%',
            height : 200
          })
          .alignItems(VerticalAlign.Bottom)
          // .padding(15)
        })

      }
      .width('100%')
      .height(200)
      .indicator(new DotIndicator().color(Color.White).right(0))
    }
    .width('100%')
    .height('30%')
  }
}