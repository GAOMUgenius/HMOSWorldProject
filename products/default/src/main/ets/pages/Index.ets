import { CourseLearning } from '@ohos/learning'
import { KnowledgeMap, KnowledgeMapContent } from '@ohos/map'
import { QuickStartPage } from '@ohos/quickstart'

@Entry
@Component
struct Index {
  build() {
    Column() {
      //QuickStartPage()
      //CourseLearning()
      // KnowledgeMap()
      KnowledgeMapContent()
    }
    .backgroundColor('#F1F3F5')
    .padding({ top: 36, bottom: 28 })
  }
}