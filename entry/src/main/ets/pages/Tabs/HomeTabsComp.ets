import { showDevelopingTips } from '../../common/dev/tips'
import { router } from '@kit.ArkUI'

interface IconItem {
  title: ResourceStr
  icon: ResourceStr
  url: string
}

@Component
export struct HomeTabsComp {

  build() {
    Scroll(){
      // 快捷方式
      HomeShortcut()
    }
  }
}


@Component
struct HomeShortcut {
  @StorageLink('isHidePrivacy') isHidePrivacy: boolean = false
  @State list: IconItem[] = [
    {
      title: '手机瘦身',
      icon: $r("app.media.ic_home_shortcut_sjss"),
      url: '/',
    },
    {
      title: '骚扰拦截',
      icon: $r('app.media.ic_home_shortcut_srlj'),
      url: '/'
    },
    {
      title: '隐私空间',
      icon: $r('app.media.ic_home_shortcut_yskj'),
      url: '/'
    },
    {
      title: '通讯录备份',
      icon: $r('app.media.ic_home_shortcut_txlbf'),
      url: '/pages/Contact/ContactIndexPage'
    },
    {
      title: '反诈中心',
      icon: $r('app.media.ic_home_shortcut_fzzx'),
      url: '/'
    },
    {
      title: '网络测速',
      icon: $r('app.media.ic_home_shortcut_wlcs'),
      url: '/'
    },
  ]

  async openShortcutPage(item: IconItem) {
    // 跳转页面,如果是空链接,则显示提示
    if (item.url === '/') {
      showDevelopingTips()
      return
    }
    // 如果不是空链接，pushUrl 打开页面，通过 slice(1) 截取掉开头的 /
    router.pushUrl({ url: item.url.slice(1) })
  }

  build() {
    GridRow({ gutter: 10, columns: 3 }) {
      ForEach(this.list, (item: IconItem, index: number) => {
        GridCol() {
          Column({ space: 10 }) {
            // 取消图片长按时间
            Image(item.icon)
              .width(44)
              .aspectRatio(1)
              .draggable(false)
            Text(item.title)
              .fontSize(14)
              .fontWeight(500)
              .fontColor($r('app.color.font'))
          }
          .width('100%')
          .height(100)
          .justifyContent(FlexAlign.Center)
          .borderRadius(10)
          .shadow({
            offsetX: 0,
            offsetY: 2,
            radius: 18,
            color: '#4DE4E4E4'
          })
          .onClick(() => {
            this.openShortcutPage(item)
          })
        }
      })
    }
  }
}