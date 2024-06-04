import { promptAction, router } from '@kit.ArkUI'
import { BizType, postCodeGraphicCheckAPI, postCodeSmsSendAPI, postUserLoginVerifyCodeAPI } from '../../api'
import { BASE_URL, LoginInfoResponse, LOGIN_INFO } from '../../common/constants'


@Entry
@Component
struct UserLoginPage {
  // 用户信息持久化
  @StorageLink(LOGIN_INFO) loginInfo: LoginInfoResponse = {}
  // 手机号（12位）- 用自己的手机号做一些变体，避免跟别的同学手机号冲突，也方便后续查阅短信
  @State phoneNumber: string = '135353330123'
  // 短信验证码
  @State verifyCode: string = ''
  // 显示半模态转场结构
  @State isShowSheet: boolean = false
  // 用于更新验证码的时间戳
  @State timestamp: number = Date.now()
  // 图形验证码
  @State graphicCode: string = ''
  // 倒计时数值
  @State count: number = 0
  // 倒计时定时器
  private intervalID: number = -1

  // 图形验证码提交
  async onGraphicCodeSubmit() {
    try {
      // 1. 把手机号，图形验证码发送到后端，校验图形验证码（防机器）
      await postCodeGraphicCheckAPI({
        bizType: BizType.PhoneLogin, // 业务类型，1：手机号短信验证码登录
        phone: this.phoneNumber, // 手机号
        verifyCode: this.graphicCode // 图形验证码  后门:1234 必定通过
      })
      // 2. 关闭半模态转场
      this.isShowSheet = false
      // 3. 清空输入框
      this.graphicCode = ''
      // 4. 调用发送短信接口
      this.onSendSmsCode()
      // promptAction.showToast({ message: '图形验证成功' })
    } catch (error) {
      // 拦截器处理了通用的错误，业务中还可以继续通过 try catch 捕获错误，更新验证码的图片
      this.timestamp = Date.now()
    }
  }

  // 图形验证码通过后，发送短信验证码
  async onSendSmsCode() {
    // 发送请求，通知后端，你可以往这个手机号，发送短信了
    await postCodeSmsSendAPI({
      bizType: BizType.PhoneLogin,
      phone: this.phoneNumber
    })
    // 倒计时效果
    this.startCountDown()
    // 发送成功轻提示
    promptAction.showToast({ message: '短信发送到手机上，请注意查收' })
  }

  // 开始倒计时，倒计时效果
  startCountDown() {
    // 初始化倒计时秒数
    this.count = 120
    // 清理以前的定时器
    clearInterval(this.intervalID)
    // 开启定时器
    this.intervalID = setInterval(() => {
      this.count--
      if (this.count <= 0) {
        clearInterval(this.intervalID)
      }
    }, 1000)
  }

  // 页面销毁，停止倒计时，释放资源
  aboutToDisappear() {
    clearInterval(this.intervalID)
  }

  // 登录表单提交（手机号+短信验证码）
  async onLoginSubmit() {
    // 登录表单请求
    const res = await postUserLoginVerifyCodeAPI({
      phone: this.phoneNumber,
      verifyCode: this.verifyCode
    })
    // 保存用户登录信息
    this.loginInfo = res.data.result
    // 轻提示
    promptAction.showToast({ message: '登录成功' })
    // 页面跳转
    router.back()
  }

  // 半模态转场
  @Builder
  SheetBuilder() {
    Column() {
      Text('图形验证码')
        .fontSize(16)
        .fontColor($r('app.color.font'))
        .margin({ top: 20, bottom: 50 })

      Column({ space: 20 }) {
        Row({ space: 10 }) {
          TextInput({ placeholder: '图形验证码', text: this.graphicCode })
            .fontSize(14)
            .height(42)
            .layoutWeight(1)
            .maxLength(4)
            .onChange((value) => {
              this.graphicCode = value
            })
            .onSubmit(() => {
              // TODO:提交图形验证码
              this.onGraphicCodeSubmit()
            })
          //图形验证码
          Image(`${BASE_URL}/code/graphic?phone=${this.phoneNumber}&bizType=${1}&timestamp=${this.timestamp}`)
            .width(108)
            .height(42)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              // 更新 @State 的值，视图就会更新，Image 为了获取到图片，会自动向服务器新的图片请求
              this.timestamp = Date.now()
            })
        }

        Button("提交")
          .height(42)
          .backgroundColor($r('app.color.brand'))
          .width('100%')
          .enabled(this.graphicCode.length > 0)
          .onClick(() => {
            // TODO:提交图形验证码
            this.onGraphicCodeSubmit()
          })
      }
    }
    .padding({ left: 30, right: 30 })
    .width('100%')
    .height('100%')
  }

  build() {
    Navigation() {
      Column() {
        Row({ space: 30 }) {
          Text('验证码登录')
            .fontSize(22)
            .fontWeight(500)
            .fontColor($r('app.color.font'))
        }
        .width('100%')

        Column({ space: 10 }) {
          TextInput({ placeholder: '请输入手机号', text: this.phoneNumber })
            .type(InputType.PhoneNumber)
            .maxLength(12)
            .fontSize(14)
            .height(50)
            .backgroundColor(Color.Transparent)
            .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
            .padding(0)
            .onChange((value) => {
              this.phoneNumber = value
            })

          Stack({ alignContent: Alignment.End }) {
            TextInput({ placeholder: '请输入验证码', text: this.verifyCode })
              .type(InputType.Number)
              .maxLength(6)
              .fontSize(14)
              .height(50)
              .backgroundColor(Color.Transparent)
              .border({ width: { bottom: 1 }, color: $r('app.color.border'), radius: 0 })
              .padding(0)
              .onChange((value) => {
                this.verifyCode = value
              })
            if (this.count > 0) {
              Text(this.count + '秒后重发')
                .fontSize(14)
                .fontColor($r('app.color.font_sub'))
            } else {
              Text('获取验证码')
                .fontSize(14)
                .fontColor($r('app.color.brand'))
                .enabled(this.phoneNumber.length > 0)
                .onClick(() => {
                  this.isShowSheet = true
                })
            }
          }
        }
        .margin({ top: 40, bottom: 40 })

        Column({ space: 20 }) {
          Button('登录')
            .backgroundColor($r('app.color.brand'))
            .height(42)
            .width('100%')
            .enabled(this.phoneNumber.length > 0 && this.verifyCode.length > 0)
            .onClick(() => {
              // TODO:登录表单提交
              this.onLoginSubmit()
            })

          Text('仅用于IT培训教学使用，为保障您的个人信息安全请勿向平台录入任何个人敏感信息（如手机号、身份证号等）！')
            .fontSize(14)
            .width('100%')
            .fontColor($r('app.color.danger'))
            .margin({ top: 50 })
        }
      }
      .padding({ left: 30, right: 30, top: 30 })
      .width('100%')
      .height('100%')
    }
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .bindSheet($$this.isShowSheet, this.SheetBuilder(), {
      // 半模态转场,屏幕高度一半，无法修改关闭图标样式
      detents: [SheetSize.MEDIUM],
      backgroundColor: $r('app.color.white')
    })
  }
}

