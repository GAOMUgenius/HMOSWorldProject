import { webview } from "@kit.ArkWeb"

@Component
export struct CourseLearning {
  private webviewController: webview.WebviewController = new webview.WebviewController()
  build() {
    Column() {
      //浏览本地页面，$rawfile加载刚刚放入rawfile目录下的course_learning资源
      Web({ src: $rawfile('course_learning/index.html'), controller: this.webviewController })
        .domStorageAccess(true)//开启文档对象模型存储接口权限
    }
  }
}