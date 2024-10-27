
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
@Entry
@Component
struct Index {
  @State message: string = '快速入门';

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight('700')
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding( { left: 16 } )
          //HarmonyHeiTi-Bold字体为较粗的鸿蒙黑体
        .fontFamily('HarmonyHeiTi-Bold')
          //设置lineHeight行高属性为33。
        .lineHeight(33)
      Banner()
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1f3f5')
  }
}

@Preview
@Component
struct Banner {
  build() {
    Image($r('app.media.banner_pic1'))
    // 设置图片的填充效果为Contain模式，即保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
      .objectFit(ImageFit.Contain)
      .width('100%')
      .padding( { left: 16, right: 16, top: 11, bottom: 11} )
      .borderRadius(16)
  }
}