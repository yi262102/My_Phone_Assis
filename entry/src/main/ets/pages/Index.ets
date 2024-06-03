import { HomeTabsComp } from './Tabs/HomeTabsComp'
import { MyTabsComp } from './Tabs/MyTabsComp'

@Entry
@Component
struct Index {
  @Provide currentIndex: number = 0
  @StorageLink('bottomHeight') bottomHeight: number = 0

  // @Builder
  // TabBuilder(title: string, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
  //   Column() {
  //     Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
  //       .width(20)
  //       .aspectRatio(1)
  //     Text(title)
  //       .fontSize(10)
  //       .fontColor(this.currentIndex === targetIndex ? $r('app.color.brand') : $r('app.color.font'))
  //       .margin({ top: 4 })
  //   }
  //   .width('100%')
  //   .height(56)
  //   .border({ width: { top: 1 }, color: '#eee' })
  //   .justifyContent(FlexAlign.Center)
  //   .onClick(() => {
  //     this.currentIndex = targetIndex;
  //   })
  // }

  build() {
    Tabs({ index: this.currentIndex, barPosition: BarPosition.End }) {
      TabContent() {
        //首页
        HomeTabsComp()
        // Text('首页')
      }
      // .tabBar(this.TabBuilder('首页', 0, $r('app.media.ic_tab_shouye_filled'), $r('app.media.ic_tab_shouye')))
      .tabBar('首页')

      TabContent() {
        // GuardTabsComp()
        Text('守护中心')
      }
      .tabBar('守护中心')


      TabContent() {
        //我的
        // Text('功能开发中')
        MyTabsComp()
      }
      // .tabBar(this.TabBuilder('我的', 2, $r('app.media.ic_tab_wode_filled'), $r('app.media.ic_tab_wode')))
      .tabBar('我的')
    }
    .barMode(BarMode.Fixed) // 默认值 Fixed
    .scrollable(false) // 限制滑动
    .padding({ bottom: this.bottomHeight })
  }
}