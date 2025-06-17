import { preferenceUtil } from "utils";
import { common } from "@kit.AbilityKit";


// 定义个人信息类型
interface UserProfile {
  nickname: string;
  gender: '男' | '女' | '其他';
  birthday: string;
  signature: string;
}

const PREFERENCE_NAME = 'userProfile';
const PROFILE_KEY = 'userProfile';



@Component
export struct MinePage {
  // 当前编辑的个人信息
  @State profile: UserProfile = {
    nickname: '小明',
    gender: '男',
    birthday: '1990-01-01',
    signature: '热爱生活，热爱编程'
  };

  // 编辑模式状态
  @State isEditing: boolean = false;
  // 状态消息
  @State statusMessage: string = '个人信息';
  // 消息类型
  @State messageType: 'info' | 'success' | 'error' = 'info';


  // 初始化
  aboutToAppear() {
    this.initPreferences();
  }

  // 初始化首选项
  async initPreferences() {
    try {
      // 加载首选项实例
      const context = getContext(this) as common.Context;
      await preferenceUtil.loadPreference(context, PREFERENCE_NAME);
      this.statusMessage = '数据库连接成功';
      this.messageType = 'success';
      this.loadProfile();
    } catch (e) {
      this.statusMessage = `数据库错误: ${e.message}`;
      this.messageType = 'error';
    }
  }

  // 加载个人信息
  async loadProfile() {
    try {
      // 从首选项获取数据
      const profileStr = await preferenceUtil.getPreferenceValue(
        PREFERENCE_NAME,
        PROFILE_KEY,
        ''
      ) as string;

      if (profileStr) {
        this.profile = JSON.parse(profileStr);
        this.statusMessage = '个人信息加载成功';
        this.messageType = 'success';
      } else {
        this.statusMessage = '无保存的个人信息';
        this.messageType = 'info';
      }
    } catch (e) {
      this.statusMessage = `加载失败: ${e.message}`;
      this.messageType = 'error';
    }
  }

  // 保存个人信息
  async saveProfile() {
    if (!this.profile.nickname.trim()) {
      this.statusMessage = '昵称不能为空';
      this.messageType = 'error';
      return;
    }

    try {
      // 保存到首选项
      await preferenceUtil.putPreferenceValue(
        PREFERENCE_NAME,
        PROFILE_KEY,
        JSON.stringify(this.profile)
      );

      this.statusMessage = '个人信息保存成功';
      this.messageType = 'success';
      this.isEditing = false;
    } catch (e) {
      this.statusMessage = `保存失败: ${e.message}`;
      this.messageType = 'error';
    }
  }

  // 删除个人信息
  async deleteProfile() {
    try {
      // 使用工具类删除数据
      await preferenceUtil.putPreferenceValue(PREFERENCE_NAME, PROFILE_KEY, '');

      // 重置为默认值
      this.profile = {
        nickname: '',
        gender: '男',
        birthday: '2000-01-01',
        signature: ''
      };

      this.statusMessage = '个人信息已删除';
      this.messageType = 'success';
      this.isEditing = true;
    } catch (e) {
      this.statusMessage = `删除失败: ${e.message}`;
      this.messageType = 'error';
    }
  }
  // 获取消息颜色
  getMessageColor() {
    switch (this.messageType) {
      case 'success': return '#52c41a';
      case 'error': return '#f5222d';
      default: return '#1890ff';
    }
  }

  build() {
    Column({ space: 20 }) {
      // 标题
      Text('个人信息')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      // 状态消息
      Text(this.statusMessage)
        .fontSize(16)
        .fontColor(this.getMessageColor())
        .margin({ top: 10, bottom: 10 })
        .height(30)

      // 个人信息卡片
      Column() {
        // 昵称
        Row() {
          Text('昵称：')
            .fontSize(18)
            .width(80)
          if (this.isEditing) {
            TextInput({ text: this.profile.nickname })
              .height(40)
              .layoutWeight(1)
              .onChange(value => this.profile.nickname = value)
          } else {
            Text(this.profile.nickname || '未设置')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
          }
        }
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#fafafa')
        .margin({ bottom: 10 })

        // 性别
        Row() {
          Text('性别：')
            .fontSize(18)
            .width(80)
          if (this.isEditing) {
            Row({ space: 20 }) {
              Radio({ value: '男', group: 'gender' })
                .checked(this.profile.gender === '男')
                .onChange(checked => {
                  if (checked) this.profile.gender = '男'
                })
              Text('男')

              Radio({ value: '女', group: 'gender' })
                .checked(this.profile.gender === '女')
                .onChange(checked => {
                  if (checked) this.profile.gender = '女'
                })
              Text('女')

              Radio({ value: '其他', group: 'gender' })
                .checked(this.profile.gender === '其他')
                .onChange(checked => {
                  if (checked) this.profile.gender = '其他'
                })
              Text('其他')
            }
            .layoutWeight(1)
          } else {
            Text(this.profile.gender)
              .fontSize(18)
              .layoutWeight(1)
          }
        }
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#fafafa')
        .margin({ bottom: 10 })

        // 生日
        Row() {
          Text('生日：')
            .fontSize(18)
            .width(80)
          if (this.isEditing) {
            TextInput({ text: this.profile.birthday })
              .height(40)
              .layoutWeight(1)
              .onChange(value => this.profile.birthday = value)
          } else {
            Text(this.profile.birthday)
              .fontSize(18)
              .layoutWeight(1)
          }
        }
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#fafafa')
        .margin({ bottom: 10 })

        // 个性签名
        Row() {
          Text('签名：')
            .fontSize(18)
            .width(80)
          if (this.isEditing) {
            TextArea({ text: this.profile.signature })
              .height(80)
              .layoutWeight(1)
              .onChange(value => this.profile.signature = value)
          } else {
            Text(this.profile.signature || '这个人很懒，什么也没留下')
              .fontSize(18)
              .fontColor('#666')
              .layoutWeight(1)
          }
        }
        .padding(10)
        .borderRadius(8)
        .backgroundColor('#fafafa')
        .margin({ bottom: 10 })
      }
      .width('95%')
      .padding(15)
      .borderRadius(16)
      .backgroundColor(Color.White)
      .shadow({ radius: 8, color: '#1890ff33', offsetX: 2, offsetY: 2 })

      // 操作按钮
      Row({ space: 20 }) {
        if (this.isEditing) {
          Button('保存信息')
            .width(120)
            .height(45)
            .onClick(() => this.saveProfile())

          Button('取消编辑')
            .type(ButtonType.Normal)
            .width(120)
            .height(45)
            .onClick(() => {
              this.loadProfile();
              this.isEditing = false;
              this.statusMessage = '已取消编辑';
              this.messageType = 'info';
            })
        } else {
          Button('编辑信息')
            .width(120)
            .height(45)
            .onClick(() => {
              this.isEditing = true;
              this.statusMessage = '编辑模式已启用';
              this.messageType = 'info';
            })

          Button('删除信息')
            .width(120)
            .height(45)
            .onClick(() => this.deleteProfile())
        }
      }
      .margin({ top: 10 })

      // 底部提示
      Text('数据存储在本地首选项数据库中')
        .fontSize(14)
        .fontColor('#999')
        .margin({ top: 20, bottom: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f0f2f5')
    .alignItems(HorizontalAlign.Center)
  }
}