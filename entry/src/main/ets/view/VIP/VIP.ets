@Component
export default struct VIP {
  build() {
    Column() {
      Stack() {
        Tabs() {
          TabContent(){}
            .tabBar('111')
          TabContent(){}
            .tabBar('222')
        }
        .barBackgroundColor(Color.Yellow)
      }
    }
    .width('100%')
    .height('100%')
  }
}