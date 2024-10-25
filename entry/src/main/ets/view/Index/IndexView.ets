import { HomeName} from '../../ViewModel/HomeNumber'
import {FirstName, FirstImage} from '../../ViewModel/HomeNumber'
import SwiperCo from '../Common/SwiperCo'
import RecommendCo1 from '../Common/RecommendCo1'
@Preview
@Component
export default struct IndexView {
  build() {
    Column() {
      Row() {
        Text('iQIYI')
          .fontColor("#00DC5A")
          .fontSize(20)
          .fontWeight(700)
          .width('15%')
        TextInput({
          placeholder : '成龙最新电影'
        })
          .placeholderFont({
            size : 10
          })
          .width('65%')
          .height('100%')
          .textAlign(TextAlign.Center)
        Row() {
          Image($r("app.media.clock"))
            .width(25)
          Image($r("app.media.more"))
            .width(25)
        }
        .width('20%')
        .justifyContent(FlexAlign.SpaceAround)
      }
      .width('100%')
      .height(40)
      .padding({
        left : 10,
        right : 10,
        top : 5
      })

      Tabs({index:1}) {
        ForEach(HomeName,(item : string,Index) => {
          TabContent() {
            if (Index == 1) {
              Scroll() {
                Column() {
                  SwiperCo({
                    Name : FirstName,
                    Image : FirstImage
                  })
                  RecommendCo1()
                }
              }
              .scrollBar(BarState.Off)
            }
          }
          .width('100%')
          .height('100%')
          .tabBar(HomeName[Index])
        })
      }
      .width('100%')
      .height('100%')
      .barMode(BarMode.Scrollable)
    }
    .width('100%')
    .height('100%')
  }
}