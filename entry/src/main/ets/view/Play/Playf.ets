import { PlayName } from '../../ViewModel/PageNumber'
import { router } from '@kit.ArkUI'
import RecommendCo1 from '../Common/RecommendCo1'
import JiShu from '../Play/JiShu'

@Preview
@Component
export default struct Play {
  @Builder
  tabBarBuilder(itemIndex: number) {
    Row() {
      Text(PlayName[itemIndex])
        .fontSize(15)
        .fontColor(itemIndex == this.Select ? Color.Black : '#D6DFEA')
    }
  }

  @State speed: number = 1.0
  @State Select: number = 0
  @State isPlayingAnimation: boolean = true;
  controller: VideoController = new VideoController()

  aboutToAppear(): void {
    console.log('Page is shown, starting timer');
    setTimeout(() => {
      console.log('Timer expired, switching to video');
      this.isPlayingAnimation = false;
    }, 3000); // 改为 3 秒
  }


  build() {

    Column() {
      // 顶部视频区域（固定16:9比例）
      Stack({ alignContent: Alignment.TopStart }) {
        if (this.isPlayingAnimation) {
          // 动画部分，这里用 LoadingProgress 作为示例动画
          Stack({ alignContent: Alignment.Center }) {
            LoadingProgress()
              .width(50)
              .height(50)
          }
          .width('100%')
          .height('30%') // 与视频区域高度一致
          .backgroundColor('rgba(0, 0, 0, 0.5)')
        } else {
          Video({
            controller: this.controller,
            currentProgressRate: this.speed,
            src: 'https://prod-streaming-video-msn-com.akamaized.net/a8c412fa-f696-4ff2-9c76-e8ed9cdffe0f/604a87fc-e7bc-463e-8d56-cde7e661d690.mp4'
          })
            .width('100%')
            .aspectRatio(16 / 9) // 固定视频比例为16:9
            .autoPlay(true)
            .controls(false)
        }


        // 返回按钮
        Row({space :5}) {
          Image($r('app.media.left'))
            .width(30)
            .fillColor(Color.Grey)
            .onClick(() => {
              router.back()
            })

          Image($r('app.media.home'))
            .width(30)
            .fillColor(Color.Grey)
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/Index'
              })
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.Start)

      }
      .width('100%')

      // 中间Tabs区域
      Tabs() {
        ForEach(PlayName, (item: string, Index) => {
          TabContent() {
            if (Index == 0) {

              JiShu()

            } else {
              Column() {
                Text('100')
                List() {
                  ListItem() {
                    Text('n')
                      .fontSize(500)
                  }
                }
              }
            }
          }
          .tabBar(this.tabBarBuilder(Index))
        })
      }
      .height('20%') // Tabs区域高度占比
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return
        }
        this.Select = targetIndex
        this.controller.start()
      })
      .barHeight(30)
      .width('100%')

      // 底部推荐区域
      Column() {
        RecommendCo1()
      }
      .width('100%')
      .height('50%') // 推荐区域高度占比
    }
    .width('100%')
    .height('100%')
  }
}