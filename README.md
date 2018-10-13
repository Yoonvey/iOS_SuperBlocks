#iOS_SuperBlocks
##工程添加规则(持续更新)
**文件/文件夹添加规则:**首先在Finder中新建文件夹,再拖拽至Xcode左栏对应的文件夹下(推荐:对新建文件/文件夹右键"Show in Finder"以确保添加正确)

**文件/文件夹名字说明:**Finder中文件/文件夹纯英文,Xcode中文件架构与Finder中保持一致性,没有数字或者符号,Xcode工程中可添加英文括号进行说明,例如:GuidePageView(引导页)

**头文件引用:**头文件引用统一都在.h文件中，便于查看

##Vender(第三方)
`JKCategories`: 收集了`UIKit``CoreData``quartzcore``CoreLocation``MapKit`等系统类的category，需要对系统类添加额外功能时可先进入寻找，哪里使用哪里引用，不要在pch或者Macro中添加。*后续对其中进行方法说明的详尽*

`Masonry`:工程中约束的编写除xib和frame以外均采用此方法，次方法的约束制定详见其[github](https://github.com/SnapKit/Masonry)小组会在后期添加简单的说明

`MBProgressHUD`提示框的三方组件，在Expend-Category中带有分类以便快速调用

`GVUserDefaults`系统提供的UserDefaults需要采用KVC的方式调用，硬性编码的问题在后续修改中会比较麻烦，该类在其基础上封装的点语法，并集中管理了UserDefaults字段，使其更易用

`CYLTabBarController`对TabBarVC进行封装以便更快速得定制界面，后续会加入梳理后的说明文档

`MJRefresh`下拉刷新和上拉加载的动画与回调封装，便于快速生成动态列表，很常用的封装库，对照GitHub中的工程demo学习使用，此工程中不再附加案例

`LBXScan`二维码扫描的解码库，并附带一些公开属性克用于绘制二维码界面样式，在funtion中有界面实例

##Expend(扩展)
###Macro(宏)
所有用到的宏统一放在这个文件中，但是在用到宏的文件中自行再添加一份，以便在抽取时不需要再寻找添加这些宏内容
###Category(分类)
主要集中存放一些系统类的category，便于后期查看和调用，由于该文件夹中功能块较多，会再单独添加说明文档以便查看
###Tool(工具类)
存放一些简单性功能类，封装成工具以便调用，同时也会有些工具型第三方文件包含其中
`AlertTool(系统提醒框)`对系统的`UIAlertViewcontroller`和`UIActionsheet`的高度封装，仅需传入显示数组和按钮响应即可呈现系统提示框，并在不传入按钮数组时，作为提示框使用，在默认时间后自动消失，在function中有案例

`PopUpView(模态View)`模态View的弹出封装，并公开出足够多的可控属性用以定制自己所需的样式，在function中有案例

`Reachability(网络状态)`以广播为消息传递方式的工具类，便于在应用各处随时查看当前设备的网络状态

`GuidePageView(引导页)`仅需传入图片名字即可集成的引导页组件，逻辑判断为首次安装或者版本更新时可见，图片资源封装在安装包中，不可联网换取和更新

`AdvertiseView(广告页)`全屏模式的广告页，与引导页逻辑互斥，一次启动中，有且只有一项可见，页面显示时间为三秒(可跳过)，并在广告页面时，后台进行主界面的缓冲。广告页预留网络接口，可根据需要进行联网更新，逻辑上采用当前下载，下次呈现
##Main(主控制）
###Map(地图)
暂调用系统地图类实现实时定位功能，后期加入和地图有关各项小功能
###Base(基类)
`BaseNavigation`一般均继承此类，其中实现了二级菜单隐藏tabBar的功能

`BaseViewController`一般均继承此类，并开放Navigation定制的属性以便在各自控制器中定制样式，function中大部分都有使用，可作为案例查看
###TabBar
在多数二级界面中会隐去，但仍作为这个工程的最底层控制器，同时也作为`CYLTabBarController`的案例，后期会在其中添加各类异性按钮和敲击手势
###Function(功能块)
基本对照`Tool`的功能封装，对view类功能块给出定制案例，对model类功能块给出基本功能展示，以便后期调用作为example查看，方便功能块学习
###Login(登录)

##Resource(资源)
###AppDelegate
因为后期许多三方功能需要在此文件中配置，所以单独存放
###Image
所有`图片`资源放入该文件夹中  
所有`图标`资源都存入Assets中

###Global
暂时存有pch文件，coredata模型文件，storyboard文件，工程说明文档

###Plist
暂时仅有Info.plist用以工程的配置

