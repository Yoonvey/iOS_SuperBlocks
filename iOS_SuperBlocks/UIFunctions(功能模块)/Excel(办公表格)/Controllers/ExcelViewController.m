//
//  ExcelViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2019/11/28.
//  Copyright © 2019 EdwinChen. All rights reserved.
//

#import "ExcelViewController.h"

#import "YVFormListView.h"

@class CustomCell;

static const NSString *cellId = @"CustomCell";

@interface ExcelViewController () <YVFormListDataSource>

@property (nonatomic, strong) YVFormListView * formListView;
@property (nonatomic, strong) UIActivityIndicatorView * indicator;

@end

@implementation ExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Excel";
    [self initViews];
}

- (void)initViews {
    NSArray * topMenus  = @[@"10:10 - 10:30",
                            @"10:30 - 10:50",
                            @"10:50 - 11:20",
                            @"11:20 - 11:50",
                            @"11:50 - 12:20",
                            @"12:20 - 12:50",
                            @"12:50 - 13:20"];
    NSArray * sideMenus = @[@"起床跑步",
                            @"吃早饭",
                            @"上班",
                            @"中午吃饭",
                            @"午休",
                            @"上班",
                            @"回家做饭"];
    NSMutableArray * cellColors = [NSMutableArray arrayWithCapacity:sideMenus.count];
    for (int i = 0; i < sideMenus.count; i ++) {
        NSMutableArray * colors = [NSMutableArray arrayWithCapacity:topMenus.count];
        for (int j = 0; j < topMenus.count; j ++) {
            [colors addObject:[NSString stringWithFormat:@"%i-%i", i, j]];
        }
        [cellColors addObject:colors];
    }
    NSLog(@"cell 的颜色数据是：%@",cellColors);
    
//    self.formListView = [[YVFormListView alloc] initWithFrame:CGRectMake(10, 100, 355, 200)];
    self.formListView = [[YVFormListView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, ScreenWidth, ScreenHeight - SafeAreaTopHeight)];
    self.formListView.dataSource = self;
    
    self.formListView.title = @"区域/设备";
    
    self.formListView.topMenuHeight = 50.f;
    self.formListView.topMenuBGColor = [UIColor cyanColor];
    self.formListView.topMenuTitleColor = [UIColor purpleColor];
    
//    self.formListView.sideMenuHeight = 150.f;
//    self.formListView.itemForSideMultiply = 0.2f;
    
    [self.view addSubview:_formListView];
    [self.formListView registerCustomCell:CustomCell.class forCellWithReuseIdentifier:(NSString *)cellId];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _indicator.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    _indicator.layer.cornerRadius = 8;
    _indicator.layer.masksToBounds = YES;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.formListView.topMenus = topMenus;
        self.formListView.sideMenus = sideMenus;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.formListView.dataSources = cellColors;
        [self.indicator stopAnimating];
        [self.indicator removeFromSuperview];
    });
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _indicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:(NSString *)cellId forIndexPath:indexPath];
    [cell sizeForValue:self.formListView.itemSize];
    NSString *value = _formListView.dataSources[indexPath.section][indexPath.row];
    cell.value.text = value;
    return cell;
}

@end

@implementation CustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    _value = [[UILabel alloc] init];
    _value.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_value];
    
    return self;
}

- (void)sizeForValue:(CGSize)size {
    _value.frame = CGRectMake(0, 0, size.width, size.height);
}

@end
