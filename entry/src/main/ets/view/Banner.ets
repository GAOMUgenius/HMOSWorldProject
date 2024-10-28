import { BannerClass } from '../model/BannerClass'

@Component
export struct Banner {
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