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

import { EnablementView } from '../view/EnablementView';
import { Banner } from '../view/Banner';
import { TutorailView } from '../view/TutorialView';


@Component
export struct QuickStartPage {
  @State message: string = '快速入门';

  build() {
    Column() {
      Text(this.message)
        .fontSize(24)
        .fontWeight('700')
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
          //HarmonyHeiTi-Bold字体为较粗的鸿蒙黑体
        .fontFamily('HarmonyHeiTi-Bold')
          //设置lineHeight行高属性为33。
        .lineHeight(33)

      Scroll(){
        Column(){
          Banner()
          EnablementView()
          TutorailView()
        }
      }.layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.TopStart)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1f3f5')
  }
}





