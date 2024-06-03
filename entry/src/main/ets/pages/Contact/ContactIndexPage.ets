import { router } from '@kit.ArkUI';
import { NavigationTitleBuilder } from '../../common/builders';
import { contactManager } from '../../manager';
import { contact } from '@kit.ContactsKit';

@Entry
@Component
struct ContactIndexPage {

  aboutToAppear(){
    contactManager.requestPermissions()
  }

  @Builder
  NavigationMenus() {
    Row() {
      Image($r("app.media.ic_public_settings"))
        .width(20)
        .aspectRatio(1)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Contact/ContactSettingsPage' })
        })
    }
    .height('100%')
    .padding({ right: 25 })
  }

  //备份联系人
  async backupContact(){
    //获取所有联系人
    const list = await contactManager.getContext()
    AlertDialog.show({message:JSON.stringify(list,null,2)})
  }


  //主入口
  build() {
    Navigation(){
      Column(){
      }
      .width('100%')
      .height('30%')

      Row({ space: 30 }){
        // ====================备份
        Column() {
          Image($r('app.media.ic_contact_bf'))
            .height(38)
          Text('备份')
            .fontSize(14)
            .fontColor($r('app.color.font'))
        }
        .onClick(() => {
          // TODO: 通讯录备份
          // contactManager.getContext()
          this.backupContact()
        })
        // ====================恢复
        Column() {
          Image($r('app.media.ic_contact_hf'))
            .height(38)
          Text('恢复')
            .fontSize(14)
            .fontColor($r('app.color.font'))
        }
        .onClick(() => {
          // 通讯录备份
        })
        // ====================优化
        Column() {
          Image($r('app.media.ic_contact_yh'))
            .height(38)
          Text('优化')
            .fontSize(14)
            .fontColor($r('app.color.font'))
        }
        .onClick(() => {
          router.pushUrl({ url: 'pages/Contact/ContactOptimizePage' })
        })
      }
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .height('80%')
      .width('100%')


    }
    .title(NavigationTitleBuilder('通讯录备份'))
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .menus(this.NavigationMenus())
    .backgroundColor('#01b6ff')
  }
}