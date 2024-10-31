//赋能套件网络视图
import { ArticleClass } from '../model/ArticleClass'
import { bufferToString } from '../util/BufferUtil'

@Component
export struct EnablementView {
  @State enablementList: Array<ArticleClass> = []
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  aboutToAppear(): void {
    this.getEnablementDataFromJSON()
  }

  getEnablementDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('EnablementData.json').then(value => {
      this.enablementList = JSON.parse(bufferToString(value)) as ArticleClass[]
    })
  }

  build() {
    Column(){
      Text('赋能套件')
        .fontColor('#182431')
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .margin({ bottom: 8.5 })

      Grid() {
        ForEach(this.enablementList, (item: ArticleClass) => {
          GridItem(){
            Enablementitem({ enablementitem: item })
              .onClick(() => {
                this.articlePathStack.pushPathByName('articleDetail', item)
              })
          }
        }, (item: ArticleClass) => item.id)
      }
      .rowsTemplate('1fr')
      .columnsGap(8)
      .scrollBar(BarState.Off)
      .height(169)
      .padding({ top: 2, left: 16, right: 16 })
    }
    .margin( {top: 18 })
    .alignItems(HorizontalAlign.Start)
  }
}


@Component
struct Enablementitem {
  @Prop enablementitem: ArticleClass
  build() {
    Column(){
      Image($r(this.enablementitem.imageSrc))
        .width('100%')
        .objectFit(ImageFit.Contain)
        .height(96)
        .borderRadius({
          topLeft: 16,
          topRight: 16
        })
      Text(this.enablementitem.title)
        .height(19)
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Start)
          //文本超长时使用省略号代替
        .textOverflow({ overflow: TextOverflow.Ellipsis })
          //设置最大显示行数
        .maxLines(1)
        .fontWeight(400)
        .padding({ left: 12, right: 12 })
        .margin({ top: 8 })
      Text(this.enablementitem.brief)
        .height(32)
        .width('100%')
        .fontSize(12)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .fontWeight(400)
        .fontColor('rgba(0, 0, 0, 0.6)')
        .padding({ left: 12, right: 12 })
        .margin({ top: 2 })
    }.width(160)
    .height(169)
    .borderRadius(16)
    .backgroundColor(Color.White)
  }
}


