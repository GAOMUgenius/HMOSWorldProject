//创建Banner的数据结构
export class BannerClass {
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