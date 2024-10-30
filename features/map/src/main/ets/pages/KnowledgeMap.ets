import { NavBarItem, NavBarItemType } from "../view/NavBarItem"

@Preview
@Component
export struct KnowledgeMap {
  @State navBarList: NavBarItemType[] = [
      { order: '01', title: '准备与学习' },
      { order: '02', title: '构建应用' },
      { order: '03', title: '应用测试' },
      { order: '04', title: '上架' },
      { order: '05', title: '运营增长' },
      { order: '06', title: '商业变现' },
      { order: '07', title: '更多' }
    ]
  build() {
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
              NavBarItem({ navBarItem: item })
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
}