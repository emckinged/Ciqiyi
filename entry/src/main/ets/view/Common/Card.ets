import { router } from "@kit.ArkUI"
import { CardName, CardSource } from '../../ViewModel/CardNumber'

@Preview
@Component
export default struct Card {
  @Prop n1: number

  build() {
    Column() {
      // 图片区域（保持原有定位）
      Row() {
        Column() {
          // VIP图标（保持左上固定位置）
          Image($r("app.media.vip"))
            .alignSelf(ItemAlign.Start)
            .height(20)
            .padding({
              top : '2%',
              left : '1%'
            })


          // 集数文字（保持右下固定位置）
          Text("全52集")
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ right: 5, bottom: 5 })
            .alignSelf(ItemAlign.End)

        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height('100%')

      }
      .aspectRatio(2) // 控制图片区域宽高比（原200x100=2:1）
      .backgroundImage($r(CardSource[this.n1]))
      .backgroundImageSize(ImageSize.Cover) // 保持图片填充方式
      .borderRadius(8)

      // 下方文字区域（保持原有布局）
      Column() {
        Text(CardName[this.n1])
          .fontSize(18)
          .margin({ left: 5 })

        Text('观看至第二集')
          .fontSize(15)
          .fontColor(Color.Gray)
          .margin({ left: 5, top: 2 })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    // .height('100%')
    .padding(5)
    .onClick(() => {
      router.pushUrl({
        url: 'pages/PlayPage'
      })
    })
  }
}