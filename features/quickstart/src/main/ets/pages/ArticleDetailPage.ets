import { ArticleClass } from "../model/ArticleClass"
import { webview } from "@kit.ArkWeb"


@Component
export struct ArticleDetailPage {
  @State articleDetail: ArticleClass | null = null
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    this.articleDetail = this.articlePathStack.getParamByName('articleDetail')[0] as ArticleClass;
  }
  build() {
    NavDestination() {
      Column() {
        Row() {
          Row() {
            Image($r('app.media.ic_back'))
              .width(40)
              .height(40)
              .onClick(() => {
                this.articlePathStack.pop()
              })
            Row() {
              Text(this.articleDetail?.title)
                .fontFamily('HarmonyHeiTi-Bold')
                .fontSize(20)
                .textAlign(TextAlign.Start)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
                .fontWeight(700)
                .margin({ left: 8 })
            }
          }
          .width('80%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .height(56)

        WebComponent({ articleDetail: this.articleDetail })

      }
      .padding({ left: 16, right: 16 })
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }.hideTitleBar(true)
  }
}

@Component
struct WebComponent {
  @Prop articleDetail: ArticleClass | null;
  private webviewController: webview.WebviewController = new webview.WebviewController();
  build(){
    Column() {
      Web({ src: this.articleDetail?.webUrl, controller: this.webviewController })
        .darkMode(WebDarkMode.Auto)
        .domStorageAccess(true)
        .zoomAccess(true)
        .fileAccess(false)
        .mixedMode(MixedMode.All)
        .cacheMode(CacheMode.None)
        .javaScriptAccess(true)
        .width('100%')
        .layoutWeight(1)
    }
  }
}