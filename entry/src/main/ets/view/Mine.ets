@Preview
@Component
export default struct Mine {
  build() {
    Column() {
      Row() {
       Image($r('app.media.sign'))
         .height(22)
         .fillColor(Color.Gray)
        Row({space : 5}) {
          Image($r('app.media.remind'))
            .height(22)
            .fillColor(Color.Gray)
          Image($r('app.media.scan'))
            .height(22)
            .fillColor(Color.Gray)
          Image($r('app.media.code'))
            .height(22)
            .fillColor(Color.Gray)
          Image($r('app.media.search'))
            .height(22)
            .fillColor(Color.Gray)
        }
        .height(30)
      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)

      List({space:5}) {
        ListItem(){
          Row() {
            Text('设置我的昵称')
              .fontSize(22)
            Image($r('app.media.right'))
              .width(20)
          }
          .width('100%')
          .padding({
            left : 10,
            right : 10
          })
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height(60)

        ListItem() {
          Row() {
            Column() {
              Text('黄金VIP会员')
                .fontColor('#A16E34')
              Row() {
                Text('1462 | 已持续586天')
                  .fontColor(Color.Gray)
              }
            }
            .alignItems(HorizontalAlign.Start)
            Column() {
              Text('立即抢购')
                .fontSize(18)
                .fontWeight(500)

            }
            .backgroundColor('#FCE08C')
            .padding({
              top : 5,
              bottom : 5,
              left : 15,
              right : 15
            })
            .borderRadius(15)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .padding({
            left : 10,
            right : 10
          })
        }
        .width('100%')
        .height(50)
        .borderRadius(10)
        .backgroundColor(Color.White)


        ListItemGroup() {
          ListItem() {
            Row() {
              Row() {
                Text('观看历史')
                  .fontSize(20)
                Text(' / ')
                  .fontSize(20)
                  .fontColor(Color.Gray)
                Text('下载')
                  .fontSize(20)
              }
              Image($r('app.media.right'))
                .height(30)
                .fillColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left : 10,
              right : 10
            })
          }
          .height(50)
          ListItem() {
            Row() {
              Row() {
                Text('收藏')
                  .fontSize(20)
                Text(' / ')
                  .fontSize(20)
                  .fontColor(Color.Gray)
                Text('预约')
                  .fontSize(20)
                Text(' / ')
                  .fontSize(20)
                  .fontColor(Color.Gray)
                Text('书架')
                  .fontSize(20)
              }
              Image($r('app.media.right'))
                .height(30)
                .fillColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left : 10,
              right : 10
            })
          }
          .height(50)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .divider({ strokeWidth: 0.1, color: Color.Gray, startMargin: 30, endMargin: 0 })

        ListItemGroup() {
          ListItem() {
            Row() {
              Row() {
                Text('钱包')
                  .fontSize(20)
              }
              Image($r('app.media.right'))
                .height(30)
                .fillColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left : 10,
              right : 10
            })
          }
          .height(50)
          ListItem() {
            Row() {
              Row() {
                Text('借钱额度')
                  .fontSize(20)
              }
              Image($r('app.media.right'))
                .height(30)
                .fillColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left : 10,
              right : 10
            })
          }
          .height(50)
          ListItem() {
            Row() {
              Row() {
                Text('票夹')
                  .fontSize(20)
              }
              Image($r('app.media.right'))
                .height(30)
                .fillColor(Color.Gray)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({
              left : 10,
              right : 10
            })
          }
          .height(50)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .divider({ strokeWidth: 0.05, color: Color.Gray, startMargin: 30, endMargin: 0 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(5)
    .backgroundColor('#F2F5FA')
  }
}