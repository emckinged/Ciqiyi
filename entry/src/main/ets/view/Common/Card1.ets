@Preview
@Component
export default struct Card1 {
  build() {
    Column() {
      Stack({ alignContent : Alignment.Start }) {
        Image($r('app.media.dijia'))
          .width(220)
          .height(8*3)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Blue)
  }
}