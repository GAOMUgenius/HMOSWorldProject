import { BannerClass } from '../model/BannerClass'
import { buffer } from '@kit.ArkTS'
import { bufferToString } from '../util/BufferUtil'
import { BreakpointType, BreakpointTypeEnum } from '@ohos/utils'

@Component
export struct Banner {
  @Consume('articlePathStack') articlePathStack: NavPathStack
  //定义需要渲染的Banner图片数据
  @State bannerList: Array<BannerClass> = []
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;

  aboutToAppear(): void {
    this.getBannerDataFromJSON()
  }
  /**
   * json中数据由于无法使用$r()进行资源访问，
   * 所以使用的是字符串"app.media.banner_pic0"，
   * 而在页面中直接声明时，使用的是$r('app.media.banner_pic0')，
   * 而Image组件是无法直接读取字符串"app.media.banner_pic0"的，
   * 所以这里需要进行内容调整。
   * 调整BannerClass的定义，将imageSrc的类型修改为string，(之前为ResourceStr类型)
   * 以及constructor内参数imageSrc也需要修改为string类型
   */
  //定义一个方法getBannerDataFromJson，并通过ResourceManager获取当前工程目录下rawfile中的json文件内容。
  getBannerDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('BannerData.json').then(value => {
      this.bannerList = JSON.parse(bufferToString(value)) as BannerClass[]
    })
  }
  build() {
    Swiper(){
      ForEach(this.bannerList, (item: BannerClass, index: number) => {
        Image($r(item.imageSrc))
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
          .onClick(() => {
            this.articlePathStack.pushPathByName('bannerDetailPage', item);
          })
      }, (item: BannerClass, index: number) => item.id)
    }.autoPlay(true)
    .loop(true)
    .displayCount(new BreakpointType({ sm: 1, md: 2, lg: 2 }).getValue(this.currentBreakpoint))
    .displayMode(SwiperDisplayMode.STRETCH)
    .indicator(this.currentBreakpoint === BreakpointTypeEnum.SM ?
    Indicator.dot().
    color('#1a000000').
    selectedColor('#0A59F7') :
      false)
    .nextMargin(new BreakpointType<Length>({ sm: 0, md: 12, lg: 266 }).getValue(this.currentBreakpoint))
  }
}