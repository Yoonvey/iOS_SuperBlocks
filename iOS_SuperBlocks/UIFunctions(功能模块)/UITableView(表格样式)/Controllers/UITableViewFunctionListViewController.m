//
//  UITableViewFunctionListViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UITableViewFunctionListViewController.h"

#import "UITableViewCellObject.h"

static NSString * const cellId = @"UITableViewCell";

@interface UITableViewFunctionListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) NSArray *functionNames;
@property (nonatomic, strong) NSArray *functionGroups;

@end

@implementation UITableViewFunctionListViewController

//#pragma mark - <导航栏设置>
//- (NSMutableAttributedString *)setTitle
//{
//    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"UITalbleView"];
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

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"表格拓展";
    self.view.backgroundColor = [UIColor colorWithRed:234 green:234 blue:234 alpha:1.0];
    
    self.functionNames = [NSArray arrayWithObjects:@"嵌套表格", @"拖动排序", @"分组列表", @"加载样式", @"单行删除", nil];
    self.functionGroups = [NSArray arrayWithObjects:@"UINestedTableViewController", @"UIDraggingSortTableViewController", @"UIGroupedTableViewController", @"UILoadingStyleTableViewController", @"UIDeleteCellTableViewController", nil];
}

#pragma makr - <加载子控件>
- (void)setupListView
{
    self.listView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight)];
    self.listView.dataSource = self;
    self.listView.delegate = self;
    [self.view addSubview:self.listView];
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    [UITableViewCellObject setExtraCellLineHidden:self.listView];
}

#pragma makr - <表格代理>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.functionNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.functionNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewControl = (UIViewController *)[[NSClassFromString(self.functionGroups[indexPath.row]) alloc] init];
    [self.navigationController pushViewController:viewControl animated:YES];
}

@end
