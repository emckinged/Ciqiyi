import {  WaterFlowDataSource } from '../WaterFlow/WaterFlowDataSource'
import Item from '../WaterFlow/Item'
import {CardSource2,CardName2} from '../../ViewModel/CardNumber'
import router from '@ohos.router';
@Entry
@Component
export default struct  RecommendCo2{
  scroller: Scroller = new Scroller()
  dataSource:WaterFlowDataSource = new WaterFlowDataSource()

  @Builder itemFoot(){
    Column(){
      Text('-------到底了--------')
        .fontSize(10)
        .backgroundColor(Color.White)
        .width('100%')
        .textAlign(TextAlign.Center)
        .height(30)
        .margin({top:5})
    }
  }

  build() {
    Column(){
      WaterFlow({footer: ()=> this.itemFoot() ,scroller: this.scroller}){
        LazyForEach( this.dataSource, (item: Item, index) => {
          FlowItem(){
            MyItem({item:item})
          }
          // 用来避免有加载效果造成的卡顿
          .onAppear(() => {
            // 即将触底时提前增加数据
            if (index + 20 == this.dataSource.totalCount()) {
              for (let i = 0; i < 40; i++) {
                this.dataSource.addLastItem()
              }
              console.log('waterFlow ' + '即将触底了')
            }
          })
        })
      }
      .columnsTemplate('1fr 1fr')
      .columnsGap(10)
      .rowsGap(8)
      .margin({left: 15, right:15})
    }
    .margin({top:20})
  }


}

@Reusable
@Component
struct MyItem{
  @State item:Item | null = null

  aboutToReuse(params: Record<string, Item>) {
    this.item = params.item;
    console.info('Reuse item:' + this.item)
  }

  aboutToAppear() {
    console.info('item:' + this.item)
  }

  build(){
    Column(){
      if(this.item)
      {
        Text(CardName2[this.item.index])
        Image(this.item.image)
          .objectFit(ImageFit.Fill)
          .sharedTransition(`sharedImage${this.item.index}`, {duration: 300, curve: Curve.Linear,delay:50})
      }
    }
    .onClick(() => {
      router.pushUrl({
        url: 'pages/PlayPage'
      })
    })
    .backgroundColor('#ffa4eaac')
    .borderRadius(8)
  }
}