//
//  AppDelegate.m
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/13.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import "AppDelegate.h"

#import "CLMDGuidePageView.h"

#import "UISignInViewController.h"
#import "UIFunctionListViewController.h"

#import "UIBaseNavigationController.h"

#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "CLMDAdvertiseView.h"

#define kPersonalBGMWidth [UIScreen mainScreen].bounds.size.width*0.75

@interface AppDelegate ()

@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //加载页面
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //需要放一个根视图到窗口上
    [self setupLoginViewController];
    
    //引导页面加载
    [self setupGuidePage];
    
    //启动广告（记得放最后，才可以盖在页面上面）
    [self setupAdveriseView];
    
    return YES;
}

#pragma mark 引导页
-(void)setupGuidePage {
    // app版本
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
// 用版本号作为判断依据，以便覆盖安装后仍能使用
    if (!CLMDUserDefault.app_Version || (![app_Version isEqualToString:CLMDUserDefault.app_Version]))
    {
        CLMDUserDefault.app_Version = app_Version;
        NSArray *images=@[@"启动1",@"启动2",@"启动3"];
        [CLMDGuidePageHelper showGuidePageView:images];
    }
}

#pragma mark 启动广告
-(void)setupAdveriseView
{
#warning 预留 请求广告接口 获取广告图片
    
    //现在采用一些固定的图片url代替
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    
    [CLMDAdvertiseHelper showAdvertiseView:imageArray];
}
#pragma mark 自定义跳转不同的页面
//登录界面
-(void)setupLoginViewController
{
#warning 暂时为空白界面，直接在内部跳转至tabBar界面，后续需要可直接调用，没有附属关系
    UISignInViewController *signInVC = [[UISignInViewController alloc]init];
    self.window.rootViewController = signInVC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

//首页界面
- (void)setupHomeViewController
{
    if (!_drawerController)
    {
        __weak id mySelf = self;
        //添加中心视图控制器
        UIFunctionListViewController *functionListControl = [[UIFunctionListViewController alloc] init];
        UIBaseNavigationController *functionNavigationControl = [[UIBaseNavigationController alloc] initWithRootViewController:functionListControl];

        //添加左边栏视图控制器
        UIViewController *leftControl = [[UIViewController alloc]init];
        [leftControl.view setBackgroundColor:[UIColor whiteColor]];
        [leftControl.view setFrame:CGRectMake(0, 0, kPersonalBGMWidth, [UIScreen mainScreen].bounds.size.height)];
        //添加提示内容
        UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, leftControl.view.frame.size.height/2, leftControl.view.frame.size.width, 30)];
        [promptLabel setText:@"这是侧边栏界面!"];
        [promptLabel setTextColor:[UIColor redColor]];
        [promptLabel setFont:[UIFont systemFontOfSize:17.0]];
        [promptLabel setTextAlignment:NSTextAlignmentCenter];
        [leftControl.view addSubview:promptLabel];
        
        //添加蒙版
        _maskView = [[UIView alloc]initWithFrame:self.window.bounds];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        [_maskView setAlpha:0.0];
        [functionNavigationControl.view addSubview:_maskView];
        //包装控制器
        UIBaseNavigationController *leftNavigationControl = [[UIBaseNavigationController alloc] initWithRootViewController:leftControl];
        //添加管理者(控制两个导航栏控制器的监控控制器)
        _drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:functionNavigationControl
                             leftDrawerViewController:leftNavigationControl
                             rightDrawerViewController:nil];
        [_drawerController setShowsShadow:NO];//是否有阴影
        [_drawerController setMaximumLeftDrawerWidth:kPersonalBGMWidth];//设置左边栏视图控制最大宽度
        [_drawerController setRestorationIdentifier:@"MMDrawer"];
        //设置滑动手势开启(MMOpenDrawerGestureModeNone时,在其它任何界面默认都是无法侧滑拉出侧边栏的,只有手动设置才能打开响应事件)
        [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        //左边栏控制器滑动回调,用来检测左视图的visible值
        [_drawerController
         setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
        {
             SLog(@"Block!!!! percentVisible= %f ",percentVisible);
             CGFloat alpha = percentVisible;
             if (alpha > 1.0)
             {
                 alpha = 1.0 ;
             }
             //修改蒙版的透明度
             [mySelf reSetAlpha:alpha/2.5];
             MMDrawerControllerDrawerVisualStateBlock block;
             block = [[MMExampleDrawerVisualStateManager sharedManager]
                      drawerVisualStateBlockForDrawerSide:drawerSide];
             if(block)
             {
                 block(drawerController, drawerSide, percentVisible);
             }
         }];
    }
    [self.window setRootViewController:_drawerController];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyWindow];
}

- (void)reSetAlpha:(CGFloat)alpha
{
    [_maskView setAlpha:alpha];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}





#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ModouTechnology.iOS_SuperBlocks" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iOS_SuperBlocks" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iOS_SuperBlocks.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        SLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            SLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
