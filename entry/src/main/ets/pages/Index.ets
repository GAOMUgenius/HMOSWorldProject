
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
class BannerClass {
  id: string = '';
  //添加imageSrc属性，用于存储图片地址，ResourceStr为Resource和string类型的联合体
  imageSrc: ResourceStr = '';
  //用于存储Banner图片点击后跳转到的在线网页网址
  url: string = '';

  constructor(id: string, imageSrc: ResourceStr, url: string) {
    this.id = id
    this.imageSrc = imageSrc
    this.url = url
  }
}
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
  //定义需要渲染的Banner图片数据
  @State bannerList: Array<BannerClass> = [
    new BannerClass('pic0', $r('app.media.banner_pic0'),
    'https://developer.huawei.com/consumer/cn/training/course/video/C101718352529709527'),
    new BannerClass('pic1', $r('app.media.banner_pic1'),
      'https://developer.huawei.com/consumer/cn/'),
    new BannerClass('pic2', $r('app.media.banner_pic2'),
      'https://developer.huawei.com/consumer/cn/deveco-studio/'),
    new BannerClass('pic4', $r('app.media.banner_pic4'),
      'https://developer.huawei.com/consumer/cn/arkts/'),
    new BannerClass('pic5', $r('app.media.banner_pic5'),
      'https://developer.huawei.com/consumer/cn/arkui/'),
  ]
  build() {
    Swiper(){
      ForEach(this.bannerList, (item: BannerClass, index: number) => {
        Image(item.imageSrc)
          // 设置图片的填充效果为Contain模式，即保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
          .objectFit(ImageFit.Contain)
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 11,
            bottom: 11
          })
          .borderRadius(16)
      }, (item: BannerClass, index: number) => item.id)
    }.autoPlay(true)
    .loop(true)
    .indicator(
      new DotIndicator()
        .color('#1a000000')
        .selectedColor('#0A59F7')
    )
  }
}