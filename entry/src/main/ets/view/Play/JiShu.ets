let b: number[] = [];
for (let i = 1; i <= 20; i++) {
  b.push(i);
}
@Component
export default struct JiShu {


  build() {
    Column() {
      // 标题行
      Row() {
        Text('选集')
          .fontSize(15)
        Text('总集数')
          .fontSize(15)
      }
      .justifyContent(FlexAlign.SpaceAround)
      .width('100%')

      // 横向滑动区域
      Scroll() {
        Row() {
          ForEach(b, (item: number) => {
            Column() {
              Text(item.toString())
                .fontSize(12)
                .fontColor(Color.Black)
                .padding(15)
                .border({
                  width: 2,
                  color: Color.Orange,
                  style: BorderStyle.Solid
                })
            }
            .width(50)
            .height(50)
            .margin(5)
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)  // 设置横向滚动
      .scrollBar(BarState.Off)  // 隐藏滚动条
      .width('100%')
      .height(70)  // 固定高度防止换行
    }
    .width('100%')
    .height('100%')
  }
}