import { Permissions } from '@kit.AbilityKit'
import { promptAction } from '@kit.ArkUI'
import { permissionManager } from './PermissionManager'
import { contact } from '@kit.ContactsKit'
import { isEmulator } from '../common/dev/isEmulator'

class ContactManager {
  private permissions: Permissions[] = [
    "ohos.permission.READ_CONTACTS",
    "ohos.permission.WRITE_CONTACTS"
  ]

  // 授权弹窗
  async requestPermissions() {
    try {
      // 申请权限
      await permissionManager.requestPermissions(this.permissions)
    } catch {
      // 未开启弹窗提示
      promptAction.showDialog({
        alignment: DialogAlignment.Center,
        title: '温馨提示',
        message: '通讯录功能需要获取权限，请在系统设置中打开通讯录开关',
        buttons: [
          { text: '取消', color: $r('app.color.font_sub') },
          { text: '立即开启', color: $r('app.color.brand') }
        ]
      })
        .then((res) => {
          // 打开设置页
          if (res.index === 1) {
            permissionManager.openPermissionSettingsPage()
          }
        })
    }
  }

  //获取所有联系人
  async getContext(): Promise<contact.Contact[]>{
    // return contact.queryContacts(getContext())
    if (isEmulator()) {
      return [
        {
          name:{fullName:'孙悟空'},
          phoneNumbers:[
            {phoneNumber:"10086"}
          ],
          key:"1",
          id:1
        },
        {
          name:{fullName:'猪八戒'},
          phoneNumbers:[
            {phoneNumber:"10000"}
          ],
          key:"2",
          id:2
        }
      ]
    }
    return contact.queryContacts(getContext())
  }

  //获取所有群组
  async getGroups(): Promise<contact.Group[]>{
    if (isEmulator()) {
      return [
        {title: '佛界小分队', groupId: 1 },
        {title: '神界小分队', groupId: 2 },
      ]
    }
    return contact.queryGroups(getContext())
  }

}

export const contactManager = new ContactManager()