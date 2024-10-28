import { ArticleClass } from '../model/ArticleClass';
import { bufferToString } from '../util/BufferUtil';

@Preview
@Component
export struct TutorailView {
  @State tutorialList: Array<ArticleClass> = [];

  aboutToAppear(): void {
    this.getTutorailDataFromJSON()
  }

  getTutorailDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('TutorialData.json').then(value => {
      this.tutorialList = JSON.parse(bufferToString(value)) as ArticleClass[]
    })
  }

  build() {
    Column() {
      Text('入门教程')
        .fontColor('#182431')
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .margin({ bottom: 8.5 })
      List({ space: 12 }) {
        ForEach(this.tutorialList, (item: ArticleClass) => {
          ListItem() {
            Tutorialitem({ tutorialitem: item })
          }
        }, (item: ArticleClass) => item.id)

      }
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })

    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)
  }
}

//入门教程列表视图
@Preview
@Component
struct Tutorialitem {
  @Prop tutorialitem: ArticleClass
  build() {
    Row(){
      Column(){
        Text(this.tutorialitem.title)
          .height(19)
          .width('100%')
          .fontSize(14)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
        Text(this.tutorialitem.brief)
          .height(32)
          .width('100%')
          .fontSize(12)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .fontWeight(400)
          .fontColor('rgba(0, 0, 0, 0.6)')
          .margin({ top: 5 })
      }
      .height('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ right: 12 })
      Image($r(this.tutorialitem.imageSrc))
        .height(64)
        .width(108)
          //保持宽高比进行缩小或者放大，使得图片两边都大于或等于显示边界。
        .objectFit(ImageFit.Cover)
        .borderRadius(16)
    }
    .width('100%')
    .height(88)
    .borderRadius(16)
    .backgroundColor(Color.White)
    .padding(12)
    .alignItems(VerticalAlign.Top)
  }
}