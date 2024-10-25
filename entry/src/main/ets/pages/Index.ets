import { router } from '@kit.ArkUI'
import { PageNumber , PageName , PageSVG} from '../ViewModel/PageNumber'
import IndexView from '../view/Index/IndexView'

@Entry
@Component
struct Index {
  @Builder
  tabBarBuilder(itemIndex : number) {
    Column() {
      // Image($r("app.media.video2"))
      //   .width(30)
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
        url : `${PageNumber[itemIndex]}`,
        params : { pageID : itemIndex}
      })
    })
  }

  @State Select : Number = 0
  build() {
    Column() {
      Tabs() {

        // ForEach(this.ite,(item : string,Index) => {
        ForEach(PageName,(item : string,Index) => {
          TabContent() {
            if (Index == 0) {
              Column() {
                IndexView()
              }
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