import { BreakpointType, BreakpointTypeEnum, preferenceUtil } from '@ohos/utils';
import { ArticleClass, ArticleIsFavorite } from '../model/ArticleClass';
import { bufferToString } from '../util/BufferUtil';
import { common } from '@kit.AbilityKit';

type FavoriteData = Record<string, boolean>;
class FavoriteChangeIml implements ArticleIsFavorite {
  public context: TutorailView;
  private prefName: string = 'favorite_articles';
  private isDataLoaded: boolean = false;

  constructor(context: TutorailView) {
    this.context = context;
  }

  async initialize() {
    if (this.isDataLoaded) return;

    try {
      await preferenceUtil.loadPreference(getContext(this.context) as common.Context, this.prefName);
      const favoritesValue = await preferenceUtil.getPreferenceValue(
        this.prefName,
        'favorites',
        '{}'
      );

      const favoritesStr = typeof favoritesValue === 'string'
        ? favoritesValue
        : JSON.stringify(favoritesValue);

      const favoritesObj: FavoriteData = JSON.parse(favoritesStr) || {};
      this.context.favoriteArticles = new Map(Object.entries(favoritesObj));
      this.isDataLoaded = true;
      console.info('收藏数据加载完成');
    } catch (error) {
      console.error('加载收藏数据失败:', error);
    }
  }

  private convertMapToObject(map: Map<string, boolean>): Record<string, boolean> {
    const obj: Record<string, boolean> = {};
    map.forEach((value, key) => {
      obj[key] = value;
    });
    return obj;
  }

  public async loadFavoriteData() {

    try {
      // 初始化偏好（如果尚未初始化）
      await preferenceUtil.loadPreference(getContext(this.context) as common.Context, this.prefName);
      // 读取收藏数据
      const favoritesValue = await preferenceUtil.getPreferenceValue(
        this.prefName,
        'favorites',
        '{}'
      );

      const favoritesStr = typeof favoritesValue === 'string'
        ? favoritesValue
        : JSON.stringify(favoritesValue);

      const favoritesObj: FavoriteData = JSON.parse(favoritesStr) || {};
      this.context.favoriteArticles = new Map(Object.entries(favoritesObj));
    } catch (error) {
      console.error('加载收藏数据失败:', error);
    }
  }

  async onStarChange(articleId: string): Promise<void> {
    // 获取当前收藏状态
    const isFavorite = this.context.favoriteArticles.get(articleId.toString()) || false;

    // 更新收藏状态
    this.context.favoriteArticles.set(articleId.toString(), !isFavorite);

    try {
      // 将Map转换为可存储的对象
      const favoritesObj = this.convertMapToObject(this.context.favoriteArticles);
      const favoritesStr = JSON.stringify(favoritesObj);

      // 保存到偏好数据库
      await preferenceUtil.putPreferenceValue(
        this.prefName,
        'favorites',
        favoritesStr
      );
    } catch (error) {
      console.error('保存收藏数据失败:', error);
    }
  }

}

@Component
export struct TutorailView {
  @State callback: FavoriteChangeIml = new FavoriteChangeIml(this)
  @State tutorialList: Array<ArticleClass> = [];
  @Consume('articlePathStack') articlePathStack: NavPathStack;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  @State isDataReady: boolean = false;

  //存储收藏ID集合
  @State favoriteArticles: Map<string, boolean> = new Map();
  aboutToAppear(): void {
    this.initializeData()
  }

  async initializeData() {
    try {
      // 先加载收藏数据
      await this.callback.initialize();

      // 再加载教程数据
      this.getTutorailDataFromJSON();

      // 数据准备就绪
      this.isDataReady = true;
    } catch (error) {
      console.error('初始化数据失败:', error);
    }
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
            Tutorialitem({
              tutorialitem: item,
              favoriteArticles: this.favoriteArticles,
              onFavoriteChange: (id: string) => this.callback.onStarChange(id)
            })
              .onClick(() => {
                this.articlePathStack.pushPathByName('articleDetail', item)
              })
          }
        }, (item: ArticleClass) => item.id)
      }
      .lanes(
        new BreakpointType<number>({ sm: 1, md: 2, lg: 3 }).getValue(this.currentBreakpoint),
        new BreakpointType<number>({ sm: 0, md: 12, lg: 16 }).getValue(this.currentBreakpoint)
      )
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })

    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)
  }
}

//入门教程列表视图

@Component
struct Tutorialitem {
  @Prop tutorialitem: ArticleClass
  @Link favoriteArticles: Map<string, boolean>
  onFavoriteChange: ( id: string ) => void = () => {
  }
  build() {
    Stack() {
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

      Image(
        this.favoriteArticles.get(this.tutorialitem.id.toString()) ?
        $r('app.media.ic_favorite_on') :
        $r('app.media.ic_favorite_off')
      )
        .size({
          width: 20,
          height: 20
        })
        .position({
          x: '92%',
          y: 5,
        })
        .onClick(() => { // 调用收藏状态变更方法
          this.onFavoriteChange(this.tutorialitem.id);
        })
    }
    .width('100%')
    .height(88)
    .backgroundColor(Color.White)
  }
}