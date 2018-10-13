//
//  UILoadingStyleTableViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UILoadingStyleTableViewController.h"

#import "UITableNoneStatusCell.h"

static NSString * const cellId = @"UITableViewCell";
static NSString * const cellNoneId = @"LoadingNoneCell";

@interface UILoadingStyleTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listDatas;
@property (nonatomic) CGRect initFrame;

@property (nonatomic) BOOL loadEnd;
@property (nonatomic, copy) NSString *msg;

@end

@implementation UILoadingStyleTableViewController

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
    [self updateLocalizedDataAfterTwoSecond];
}

- (void)setupCommon
{
    self.title = @"加载样式";
    self.view.backgroundColor = [UIColor colorWithRed:234 green:234 blue:234 alpha:1.0];
}

#pragma mark - <初始化加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:self.initFrame style:UITableViewStylePlain];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.bounces = YES;
    [self.view addSubview:self.listView];
    
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [self.listView registerClass:[UITableNoneStatusCell class] forCellReuseIdentifier:cellNoneId];
}

#pragma mark - <更新数据>
- (void)updateLocalizedDataAfterTwoSecond
{
    self.loadEnd = NO;
    self.msg = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^ {
        for (int i = 1; i < 20; i++)
        {
            [self.listDatas addObject:[NSString stringWithFormat:@"%i", i]];
        }
        self.loadEnd = YES;
        self.msg = @"加载完成";
        [self.listView reloadData];
    });
}

#pragma mark - <表格代理>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDatas.count != 0 ? self.listDatas.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listDatas.count != 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.listDatas[indexPath.row];
        return cell;
    }
    else
    {
        UITableNoneStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNoneId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.indicatorColor = [UIColor redColor];
        //        cell.titleColor = [UIColor redColor];
        //        cell.titleValue = @"获取中...";
        [cell loadEnd:self.loadEnd visibleMsg:self.msg];
        return cell;
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listDatas.count != 0)
    {
        return 45.5;
    }
    else
    {
        return self.initFrame.size.height;
    }
}

@end
