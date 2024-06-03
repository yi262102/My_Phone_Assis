import { router } from '@kit.ArkUI'
import { contactManager } from '../../manager'
import { contact } from '@kit.ContactsKit'
import { NavigationTitleBuilder } from '../../common/builders'

@Entry
@Component
struct ContactOptimizePage {
  @State ContactNum:contact.Contact[] = []
  @State groupNum:contact.Group[] = []

  onPageShow(){
    this.getData()
  }

  async getData(){
    this.ContactNum = await contactManager.getContext()
    this.groupNum = await contactManager.getGroups()
  }

  build() {
    Navigation(){
      Column(){
        Text('联系人数量: ' + this.ContactNum.length)
          .fontSize(25)
          .fontColor(Color.White)
        Text('小分队数量: ' + this.groupNum.length)
          .fontSize(25)
          .fontColor(Color.White)
      }
      .width('100%')
      .height('30%')
      .justifyContent(FlexAlign.Center)

      Row({ space: 30 }){
      }
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center)
      .height('80%')
      .width('100%')

    }
    .title(NavigationTitleBuilder('优化的界面'))
    .hideBackButton(true)
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor('#01b6ff')
  }
}