import { router } from '@kit.ArkUI'
import {PageIDInfo} from '../model/PageIDInfo'
import {PageNumber , PageName , PageSVG} from '../ViewModel/PageNumber'
import Mine from '../view/Mine'

@Entry
@Component
struct Index {

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

  aboutToAppear(): void {
    const params = router.getParams() as PageIDInfo
    console.log(params.pageID.toString())
    // 打印参数 params 打印出来是一个对象
    this.Select = params.pageID
  }

  build() {
    Column() {
      Tabs({ index: 4}) {

        ForEach(PageName,(item : string,Index) => {
          TabContent() {
            if (Index == 4) {
              Column() {
                Mine()
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