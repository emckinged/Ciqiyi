import Play from '../view/Play/Play'
@Entry
@Component
struct PlayPage {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Play()
    }
    .width('100%')
    .height('100%')
  }
}