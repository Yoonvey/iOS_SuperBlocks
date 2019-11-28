//
//  UIFunctionListViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIFunctionListViewController.h"

#import "UITableViewCellObject.h"
#import "UITableHeaderView.h"

static NSString * const cellId = @"UITableViewCell";

@interface UIFunctionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray<NSArray *> *functionNames;
@property (nonatomic, strong) NSArray<NSArray *> *functionGroups;

@end

@implementation UIFunctionListViewController

//#pragma mark - <导航栏设置>
//- (NSMutableAttributedString *)setTitle
//{
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"功能中心"];
//    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
//    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(17) range:NSMakeRange(0, title.length)];
//    return title;
//}

#pragma mark - <viewDidLoad>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupListView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置滑动手势开启
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //设置滑动手势关闭
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"功能中心";
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    self.functionNames = [NSArray arrayWithObjects:@[@"UIMapKit -- 系统地图基础使用", @"UITalbleView -- 表格自定义拓展", @"Excel -- 办公表格视图", @"UIImageCropper -- 图片裁剪", @"UIPopupView -- 弹出视图", @"PopupObserver -- 弹出视图"] , @[@"CLMDAlert -- 开源框架CLMDAlertView"], @[@"MMDrawerController -- 抽屉视图", @"KeyboardMonitor -- 键盘监听"], nil];
    self.functionGroups = [NSArray arrayWithObjects:@[@"UIMapKitController", @"UITableViewFunctionListViewController", @"ExcelViewController", @"UIImageCropperViewController", @"UIPopupViewController", @"PopupObserverViewController"], @[@"CLMDAlertViewController"], @[@"", @"KeyboardMonitorViewController"], nil];
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    self.listView.backgroundColor = [UIColor clearColor];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.bounces = YES;
    
    //设定值一定要大于1， 否则在某些系统上在收缩变化的时候会出现头部偏移的异常情况
    self.listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.1)];
    self.listView.tableFooterView = [UIView new];
    self.listView.estimatedRowHeight = 1.1;
    self.listView.estimatedSectionHeaderHeight = 1.1;
    self.listView.estimatedSectionFooterHeight = 1.1;
    self.listView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.listView];
    
    //注册可用的Cell
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    //去除多余的cell
    [UITableViewCellObject setExtraCellLineHidden:self.listView];
}

#pragma mark - <表格代理>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.functionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *names = self.functionNames[section];
    return names.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = (section == 0) ? 0.1 : 25;
    UITableHeaderView *headerView = [[UITableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    headerView.tableView = tableView;
    headerView.section = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *names = self.functionNames[indexPath.section];
    cell.textLabel.text = names[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0.1 : 25;
}

//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1.1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

// 隐藏UITableViewStyleGrouped下边多余的间隔
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *groups = self.functionGroups[indexPath.section];
    UIViewController *viewControl = (UIViewController *)[[NSClassFromString(groups[indexPath.row]) alloc] init];
    if (viewControl)
    {
        [self.navigationController pushViewController:viewControl animated:YES];
    }
    else
    {
        [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}


@end
