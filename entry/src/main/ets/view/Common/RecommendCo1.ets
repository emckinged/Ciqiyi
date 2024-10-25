//两列，横向海报
import Card from '../Common/Card'
@Preview
@Component
export default struct RecommendCo1 {
  @State Name : string[] = []
  @State Image : string[] = []
  @State i : string[] = ['1','2','3','4','1','2','3','4']
  build() {
    Column() {
      List() {
        ForEach(this.i,(item : string,Index) => {
          ListItem() {
            Card()
          }
        })
      }
      .lanes(2)
    }
    // .width('100%')
    // .height('100%')
  }
}