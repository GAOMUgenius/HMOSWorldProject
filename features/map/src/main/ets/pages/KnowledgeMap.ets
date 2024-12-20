import { KnowledgeMapContent, Section } from "../view/KnowledgeMapContent";
import { NavBarItem, NavBarItemType } from "../view/NavBarItem"
import { BusinessError } from "@kit.BasicServicesKit";
import { util } from '@kit.ArkTS';

@Preview
@Component
export struct KnowledgeMap {
  @Provide('knowledgeMapPageStack') knowledgeMapPageStack: NavPathStack = new NavPathStack();
  @State navBarList: NavBarItemType[] = [
      { order: '01', title: '准备与学习' },
      { order: '02', title: '构建应用' },
      { order: '03', title: '应用测试' },
      { order: '04', title: '上架' },
      { order: '05', title: '运营增长' },
      { order: '06', title: '商业变现' },
      { order: '07', title: '更多' }
    ]
  @State sections: Section[] = [];
  @State currentNavBarIndex: number = -1;

  @Builder
  PageMap(name: string) {
    if (name === 'KnowledgeMapContent') {
      KnowledgeMapContent({ section: this.sections[this.currentNavBarIndex] });
    }
  }

  private getSections() {
    try {
      getContext(this).resourceManager.getRawFileContent("MapData.json", (error: BusinessError, value: Uint8Array) => {
        const textDecoder = util.TextDecoder.create("utf-8");
        const res = textDecoder.decodeWithStream(value, { stream: false });
        this.sections = JSON.parse(res);
      });
    } catch (error) {
      console.error(`callback getRawFileContent failed, error is ${JSON.stringify(error)}`)
    }
  }

  aboutToAppear(): void {
    this.getSections();
  }

  build() {
    Navigation(this.knowledgeMapPageStack) {
      Scroll(){
        Column() {
          Text('知识地图')
            .fontFamily('HarmonyHeiTi-Bold')
            .fontSize(24)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Start)
            .lineHeight(33)
            .fontWeight(700)
            .width('100%')
          Image($r('app.media.knowledge_map_banner'))
            .width('100%')
            .borderRadius(16)
            .margin({ top: 19, bottom: 8 })
          Text('通过循序渐进的学习路径，无经验和有经验的开发者都可以轻松掌握ArkTS语言声明式开发范式，体验更简洁、更友好的HarmonyOS应用开发旅程。')
            .fontFamily('HarmonyHeiTi')
            .fontSize(14)
            .fontColor('rgba(0,0,0,0.60)')
            .fontWeight(400)
            .textAlign(TextAlign.Start)

          List({ space: 12 }) {
            ForEach(this.navBarList, (item: NavBarItemType, index: number) => {
              ListItem() {
                NavBarItem({ navBarItem: item, currentNavBarIndex: this.currentNavBarIndex })
              }
            },  (item: NavBarItemType): string => item.title)
          }
        }
        .padding({ top: 12, right: 16, bottom: 12, left: 16})
        .backgroundColor('#F1F3F5')
      }
      .backgroundColor('#F1F3F5')
      .align(Alignment.TopStart)
      /**
       * 添加constraintSize并设置minHeight为100%，
       * 可以解决当内容条数不足时，
       * Scroll组件滚动时会出现空白区域的错误效果
       */
      .constraintSize({ minHeight: '100%' })
      /**
       * 滑动到边缘后可以根据初始速度或通过触摸事件继续滑动一段距离，松手后回弹
       */
      .edgeEffect(EdgeEffect.Spring)
    }
    /**
     * 将mode属性为NavigationMode.Auto，为自适应模式，即当设备宽度大于520vp时，Navigation组件采用分栏模式，反之采用单页面模式。
     *将mode属性设置为NavigationMode.Stack，Navigation组件即可设置为单页面显示模式。
     *将mode属性设置为NavigationMode.Split，Navigation组件即可设置为分栏显示模式。
     */
    .mode(NavigationMode.Auto)
    //隐藏Navigation自带的标题
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}