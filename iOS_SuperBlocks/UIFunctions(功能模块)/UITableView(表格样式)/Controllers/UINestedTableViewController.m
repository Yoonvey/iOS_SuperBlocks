//
//  UINestedTableViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UINestedTableViewController.h"

#import "NinaPagerView.h"
#import "MJRefresh.h"

#import "UITableHeaderView.h"
#import "UITableViewCellObject.h"

#import "UIDraggingSortTableViewController.h"
#import "UIGroupedTableViewController.h"
#import "UILoadingStyleTableViewController.h"
#import "UIDeleteCellTableViewController.h"

static NSString * const cellId = @"UITableViewCell";

@interface UINestedTableViewController () <UITableViewDelegate, UITableViewDataSource, UITableViewScrollDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NinaPagerView *ninaPagerView;


@property (nonatomic, strong) UIDraggingSortTableViewController *dragSortControl;
@property (nonatomic, strong) UIGroupedTableViewController *groupedControl;
@property (nonatomic, strong) UILoadingStyleTableViewController *loadingControl;
@property (nonatomic, strong) UIDeleteCellTableViewController *deleteControl;

@property (nonatomic, strong) NSMutableArray *listFunctions;

@end

@implementation UINestedTableViewController

#pragma makr - <懒加载对象>
- (UIDraggingSortTableViewController *)dragSortControl
{
    if (!_dragSortControl)
    {
        _dragSortControl = [[UIDraggingSortTableViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _dragSortControl.scrollDelegate = self;
    }
    return _dragSortControl;
}

- (UIGroupedTableViewController *)groupedControl
{
    if (!_groupedControl)
    {
        _groupedControl = [[UIGroupedTableViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _groupedControl.scrollDelegate = self;
    }
    return _groupedControl;
}

- (UILoadingStyleTableViewController *)loadingControl
{
    if (!_loadingControl)
    {
        _loadingControl = [[UILoadingStyleTableViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _loadingControl.scrollDelegate = self;
    }
    return _loadingControl;
}

- (UIDeleteCellTableViewController *)deleteControl
{
    if (!_deleteControl)
    {
        _deleteControl = [[UIDeleteCellTableViewController alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - 40)];
        _deleteControl.scrollDelegate = self;
    }
    return _deleteControl;
}

- (NinaPagerView *)ninaPagerView
{
    if (!_ninaPagerView)
    {
        NSArray *titles = [NSArray arrayWithObjects:@"拖动排序", @"分组列表", @"加载样式", @"左滑删除", nil];
        NSArray *classes = [NSArray arrayWithObjects:self.dragSortControl, self.groupedControl, self.loadingControl, self.deleteControl, nil];
        /**
         *  创建ninaPagerView，控制器第一次是根据您划的位置进行相应的添加的，类似网易新闻虎扑看球等的效果，后面再滑动到相应位置时不再重新添加，如果想刷新数据，您可以在相应的控制器里加入刷新功能。需要注意的是，在创建您的控制器时，设置的frame为FUll_CONTENT_HEIGHT，即全屏高减去导航栏高度，如果这个高度不是您想要的，您可以去在下面的frame自定义设置。
         *  A tip you should know is that when init the VCs frames,the default frame i set is FUll_CONTENT_HEIGHT,it means fullscreen height - NavigationHeight - TabbarHeight.If the frame is not what you want,just set frame as you wish.
         */
        CGRect pagerRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
        _ninaPagerView = [[NinaPagerView alloc] initWithFrame:pagerRect WithTitles:titles WithObjects:classes];
        _ninaPagerView.ninaPagerStyles = NinaPagerStyleBottomLine;
        _ninaPagerView.selectTitleColor = [UIColor redColor];
        _ninaPagerView.underlineColor = [UIColor redColor];
        _ninaPagerView.nina_autoBottomLineEnable = YES;
    }
    return _ninaPagerView;
}

#pragma mark - <viewDidLoad>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupListView];
}

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"嵌套列表";
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    self.listFunctions = [NSMutableArray arrayWithObjects:@"测试行一", @"测试行二", @"测试行三", @"测试行四", nil];
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight) style:UITableViewStyleGrouped];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.bounces = YES;
    self.listView.showsVerticalScrollIndicator = NO;
    self.listView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1.1)];
    self.listView.tableFooterView = [UIView new];//
    
    //设定值一定要大于1， 否则在某些系统上在收缩变化的时候会出现头部偏移的异常情况
    self.listView.estimatedRowHeight = 1.1;
    self.listView.estimatedSectionHeaderHeight = 1.1;
    self.listView.estimatedSectionFooterHeight = 1.1;
    self.listView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    __weak UINestedTableViewController *weakSelf = self;
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{//下拉刷新
        [weakSelf endHeaderRefresh];
    }];
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf endFooterRefresh];
    }];
}

- (void)endHeaderRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listView.mj_header endRefreshing];
    });
}

- (void)endFooterRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.listView.mj_footer endRefreshing];
    });
}

#pragma mark - <子控制器表格滑动带动主控制器表格>
- (void)scrollViewIsScrolling:(UIScrollView *)scrollView
{
    BOOL isScroll = self.listView.contentOffset.y < self.ninaPagerView.frame.origin.y;
    CGFloat offsetY = scrollView.contentOffset.y + self.listView.contentOffset.y;
    if (isScroll)
    {
        [self.listView setContentOffset:CGPointMake(0, offsetY)];
        [scrollView setContentOffset:CGPointZero];
    }
    else if (scrollView.contentOffset.y <= 0 && !isScroll)
    {
        if (self.listView.contentOffset.y >= self.ninaPagerView.frame.origin.y)
        {
            [self.listView setContentOffset:CGPointMake(0, offsetY)];
        }
    }
}

#pragma mark - <表格复位以及刷新>
- (void)scrollViewDidEndScroll
{
    if(self.listView.contentOffset.y < 0)//表格偏移量不为0,相当于下啦咯
    {
        [self.listView setContentOffset:CGPointZero animated:YES];
        if (self.listView.contentOffset.y < -32)//超过32高度的偏移量即触发下啦刷新
        {
            __weak UINestedTableViewController *weakSelf = self;
            [self.listView.mj_header beginRefreshingWithCompletionBlock:^//调用下拉刷新(子控制器的表格无法直接触发主控制器的表格的下拉刷新，因此需要主动调用)
             {
                 [weakSelf endHeaderRefresh];
             }];
        }
    }
}

#pragma mark - <表格代理>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? self.listFunctions.count: 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UITableHeaderView *headerView = [[UITableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        headerView.tableView = tableView;
        headerView.section = section;
        return headerView;
    }
    else
    {
        return self.ninaPagerView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.listFunctions[indexPath.row];
        cell.textLabel.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : ScreenHeight - SafeAreaTopHeight;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.listView.contentOffset.y > self.ninaPagerView.frame.origin.y)
    {
        [self.listView setContentOffset:CGPointMake(0, self.ninaPagerView.frame.origin.y + 0.2)];//+0.2，补充误差
    }
    else if(self.listView.contentOffset.y < -SafeAreaTopHeight)
    {
        [self.listView setContentOffset:CGPointMake(0, -SafeAreaTopHeight)];
    }
}

#pragma mark - <子控制器的滑动代理>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView viewController:(UIViewController *)viewController
{
    //视图滑动判断嵌套表格的联动性
    [self scrollViewIsScrolling:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView viewController:(UIViewController *)viewController
{
    //处理因子视图向下拖拽而导致父视图无法回到原位置
    [self scrollViewDidEndScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate viewController:(UIViewController *)viewController
{
    //处理因子视图向下拖拽而导致父视图无法回到原位置
    [self scrollViewDidEndScroll];
}

@end
