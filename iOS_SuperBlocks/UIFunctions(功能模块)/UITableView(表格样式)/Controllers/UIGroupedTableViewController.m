//
//  UIGroupedTableViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIGroupedTableViewController.h"

#import "UITableHeaderView.h"

static NSString * const cellId = @"UITableViewCell";

@interface UIGroupedTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listDatas;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *status;

@property (nonatomic) CGRect initFrame;

@end

@implementation UIGroupedTableViewController

#pragma mark - <生命周期>
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self)
    {
        self.initFrame = frame;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.initFrame = CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupListView];
}

- (void)setupCommon
{
    self.title = @"分组列表";
    self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    
    self.listDatas = [NSMutableArray arrayWithObjects:@(3), @(4), @(9), @(12), @(4), nil];
    self.status = [NSMutableArray arrayWithObjects:@(0), @(0), @(0), @(0), @(0),nil];
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    //    self.listView = [[UITableView alloc] initWithFrame:self.initFrame style:UITableViewStyleGrouped];
    self.listView = [[UITableView alloc] initWithFrame:self.initFrame style:UITableViewStylePlain];
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
    
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

- (void)touchHeader:(UIButton *)button
{
    NSNumber *status = self.status[button.tag];
    status = [NSNumber numberWithBool:![status boolValue]];
    button.selected = [status boolValue];
    [self.status replaceObjectAtIndex:button.tag withObject:status];
    [self.listView reloadSections:[NSIndexSet indexSetWithIndex:button.tag] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <表格代理>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *count = self.listDatas[section];
    NSNumber *status = self.status[section];
    return [status boolValue] ? [count integerValue]: [status integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSNumber *status = self.status[section];
    
    UITableHeaderView *headerView = [[UITableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40) suspension:[status boolValue]];
    headerView.backgroundColor = [status boolValue] ? [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0]: [UIColor whiteColor];
    headerView.tableView = tableView;
    headerView.section = section;
    
    headerView.actionButton.tag = section;
    headerView.actionButton.selected = [status boolValue];
    headerView.normalImage = [UIImage imageNamed:@"normal"];
    headerView.hightlightedImage = [UIImage imageNamed:@"extend"];
    headerView.selectedImage = [UIImage imageNamed:@"extend"];
    headerView.rightMargin = 10;
    [headerView.actionButton addTarget:self action:@selector(touchHeader:) forControlEvents:UIControlEventTouchUpInside];
    
    headerView.title = [NSString stringWithFormat:@"第%li组", (long)section];
    headerView.titleSize = 17.0;
    headerView.titleColor = [UIColor blackColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"第%li组, 第%li行", (long)indexPath.section, indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0);
    return cell;
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

#pragma mark - <滑动代理>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:viewController:)])
    {
        [self.scrollDelegate scrollViewDidScroll:scrollView viewController:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:viewController:)])
    {
        [self.scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate viewController:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:viewController:)])
    {
        [self.scrollDelegate scrollViewDidEndDecelerating:scrollView viewController:self];
    }
}


@end
