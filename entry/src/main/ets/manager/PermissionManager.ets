import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';

class PermissionManager {

  // 检查是否授权
  checkPermissions(permissions: Permissions[]): boolean {
    // 1. 程序访问控制管理
    const atManager = abilityAccessCtrl.createAtManager();
    // 2. 获取 bundle 包信息
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    // 3. 提取 tokenID 标识
    const tokenID = bundleInfo.appInfo.accessTokenId;
    // 4. 遍历权限组，检测每个权限的授权情况
    const grantStatus = permissions.map((item) => {
      // 核心 API：atManager.checkAccessTokenSync
      return atManager.checkAccessTokenSync(tokenID, item)
    })
    // 5. 返回授权状态，返回 boolean
    //   every(条件)   遍历时所有条件都成立，返回 true，有一个不成立，就返回 false
    return grantStatus.every(v => v === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
  }

  // 动态申请授权（首次弹窗申请）
  async requestPermissions(permissions: Permissions[]) {
    // 1. 程序访问控制管理
    const atManager = abilityAccessCtrl.createAtManager()
    // 2. 向用户申请授权
    const requestResult = await atManager.requestPermissionsFromUser(getContext(),permissions)
    // 3. 检查权限的结果
    const isAuth = requestResult.authResults.every(v => v === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED)
    //Promise.resolve()     表示成功,await 后续的代码继续执行
    //Promise.reject()      表示失败,await 后续的代码不执行 (可通过try catch 捕获到 reject 的错误)
    // 4.返回授权状态
    return isAuth === true ? Promise.resolve(true) : Promise.reject(false)
  }

  // 打开系统设置的权限管理页（处理授权结果）
  openPermissionSettingsPage() {
    //1. 获取 context 对象，并通过 as 断言为 UIAbilityContext，UIAbilityContext 才能调用 startAbility 这个 API
    const context = getContext() as common.UIAbilityContext
    //获取bundle(应用包)信息
    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
    //相当于启动一个设置页(应用)
    context.startAbility({
      //打开设置页的固定写法(Harmony OS Next 文档中)
      bundleName:'com.huawei.hmos.settings',
      abilityName:'com.huawei.hmos.settings.MainAbility',
      uri:'application_info_entry',
      parameters:{
        //按照包名打开对应设置页
        pushParams:bundleInfo.name
      }
    })
  }
}

// 导出 Manager
export const permissionManager = new PermissionManager()
