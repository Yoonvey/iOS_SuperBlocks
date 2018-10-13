//
//  UIDraggingSortTableViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIDraggingSortTableViewController.h"

static NSString * const cellId = @"UITableViewCell";

@interface UIDraggingSortTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listDatas;
@property (nonatomic) CGRect initFrame;

@end

@implementation UIDraggingSortTableViewController

#pragma mark - <懒加载>
- (NSMutableArray *)listDatas
{
    if (!_listDatas)
    {
        _listDatas = [NSMutableArray array];
    }
    return _listDatas;
}

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
    self.title = @"拖动排序";
    self.view.backgroundColor = [UIColor colorWithRed:234 green:234 blue:234 alpha:1.0];
    
    for (int i = 1; i < 100; i++)
    {
        [self.listDatas addObject:[NSString stringWithFormat:@"%i", i]];
    }
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:self.initFrame style:UITableViewStylePlain];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.bounces = YES;
    self.listView.editing = YES;
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.layoutMargins = UIEdgeInsetsMake(0, -30, 0, 0);
    cell.textLabel.text = self.listDatas[indexPath.row];
    return cell;
}

//开放编辑权限
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

////对cell的编辑样式进行设置, 点击cell 右边的按钮可以 拖动进行重新排序
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}

//拖动Cell对数据源进行重新排序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //对换
    //    [self.listDatas exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    
    //穿插
    NSString *sourceValue = self.listDatas[sourceIndexPath.row];
    [self.listDatas removeObjectAtIndex:sourceIndexPath.row];
    [self.listDatas insertObject:sourceValue atIndex:destinationIndexPath.row];
    
    
    [tableView reloadData];
}

//点击删除已出对应下表的数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listDatas removeObjectAtIndex:indexPath.row];
    [self.listView reloadData];
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
