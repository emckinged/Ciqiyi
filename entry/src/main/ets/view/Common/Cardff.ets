import { router } from "@kit.ArkUI"
import {CardName,CardSource} from '../../ViewModel/CardNumber'
@Preview
@Component
export default struct Card {
  @Prop n1:number
  build() {
    Column() {
      Row() {
        Column() {
          Image($r("app.media.vip"))
            .height(20)
            .padding({
              top : '2%',
              left : '1%'
            })

          Text("全52集")
            .fontSize(20)
            .fontColor(Color.White)
            .padding(5)
            .alignSelf(ItemAlign.End)
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        .height('100%')
        .width(300)

      }
      .width('100%')
      .height('15%')
      .backgroundImage($r(CardSource[this.n1]))
      .backgroundImageSize({
        width : '200',
        height : '100'
      })
      .alignItems(VerticalAlign.Bottom)
      .borderRadius(8)

      Column() {
        Text(CardName[this.n1])
          .fontSize(18)
        Text('观看至第二集')
          .fontSize(15)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({
        top : 5,
        left : 5
      })
    }
    .width('100%')
    .padding(5)
    .onClick(() => {
      router.pushUrl({
        url : 'pages/PlayPage'
      })
    })
  }
}