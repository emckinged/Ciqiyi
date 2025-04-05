import { PlayName } from '../../ViewModel/PageNumber'
import { router } from '@kit.ArkUI'
import RecommendCo1 from '../Common/RecommendCo1'
import JiShu from '../Play/JiShu'
import { http } from "@kit.NetworkKit";
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from "@kit.AbilityKit";
import { promptAction } from '@kit.ArkUI';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { Common } from "../../ViewModel/Common";

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

  @State contentLength: number = 0;
  @State downloadSize: number = 0;
  @State process: number = 0;
  @State isDownload: boolean = false;
  private httpRequest: http.HttpRequest = http.createHttp();
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  @State speed: number = 1.0
  @State Select: number = 0
  @State isPlayingAnimation: boolean = true;
  controller: VideoController = new VideoController()

  aboutToAppear(): void {
    console.log('Page is shown, starting timer');
    setTimeout(() => {
      console.log('Timer expired, switching to video');
      this.isPlayingAnimation = false;
      this.controller.start()
    }, 2500); // 改为 3 秒
  }
  aboutToDisappear(): void {
    this.httpRequest.destroy();
  }


  build() {

    Column() {
      // 视频预览区域（占屏幕30%高度）
      Video({ src: Common.VIDEO_SRC })
        .autoPlay(true)
        .loop(false)
        .width('100%')
        .height('30%')

      // 下载控制区域
      Column() {
        if (this.isDownload) {
          Button() {
            Row() {
              Text(`${this.process}%`)
                .fontColor(Color.White)
                .fontSize(16)
              Text('Downloading')
                .fontColor(Color.White)
                .fontSize(16)
                .margin({ left: 12 })
            }
          }
          .padding(12)
          .width('100%')
        } else {
          SaveButton({ text: SaveDescription.SAVE_TO_GALLERY })
            .padding(12)
            .width('100%')
            .onClick(() => {
              this.httpDownloadFile();
              this.isDownload = true;
            })
        }
      }
      .padding({
        left: 16,
        right: 16,
        bottom: 16
      })
    }

  }

  async httpDownloadFile() {
    // 1. 创建相册视频文件
    const helper = photoAccessHelper.getPhotoAccessHelper(this.context);
    const uri = await helper.createAsset(
      photoAccessHelper.PhotoType.VIDEO,
      'mp4',
      { title: 'HTTPVideo' }
    );
    const file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

    try {
      // 2. 监听HTTP响应头（获取文件总大小）
      this.httpRequest.on('headersReceive', (header: Object) => {
        this.downloadSize = 0;
        this.contentLength = new Map(Object.entries(header)).get('content-length') as number;
      });

      // 3. 分块接收数据并写入文件
      this.httpRequest.on('dataReceive', (data: ArrayBuffer) => {
        fs.writeSync(file.fd, data);       // 写入文件
        this.downloadSize += data.byteLength; // 累加已下载大小
        this.process = Math.floor(this.downloadSize / this.contentLength * 100); // 计算进度
      });

      // 4. 下载完成处理
      this.httpRequest.on('dataEnd', () => {
        promptAction.showToast({ message: $r('app.string.download_success') }); // 提示成功
        fs.closeSync(file); // 关闭文件
        this.isDownload = false; // 重置状态
      });

      // 5. 发起HTTP请求（支持重试）
      this.getHttpRequest(Common.VIDEO_SRC, 3);
    } catch (err) {
      fs.closeSync(file); // 异常时关闭文件
      this.isDownload = false;
    }
  }

  async getHttpRequest(url: string, retry: number): Promise<number | undefined> {
    try {
      return await this.httpRequest?.requestInStream(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 6000,  // 连接超时6秒
        readTimeout: 60000     // 读取超时60秒
      }).then((data: number) => {
        // 状态码408（超时）或500（服务器错误）时重试
        if ((data === 408 || data === 500) && retry > 0) {
          return new Promise((resolve: Function) => {
            setTimeout(() => {
              resolve(this.getHttpRequest(url, retry - 1)); // 递归重试
            }, 2000); // 间隔2秒
          });
        } else {
          return data; // 返回状态码
        }
      });
    } catch (err) {
      promptAction.showToast({ message: $r('app.string.download_error') }); // 错误提示
      this.isDownload = false;
      return;
    }
  }
}