//
//  UIPopupViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIPopupViewController.h"

#import "YVPopupView.h"

@interface UIPopupViewController ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UITableView *listView;

@end

@implementation UIPopupViewController

#pragma mark - <viewDidLoad>
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCommon];
    [self setupSubViews];
}

#pragma makr - <设置基础样式>
- (void)setupCommon
{
    self.title = @"弹出视图";
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

#pragma makr - <加载子控件>
- (void)setupSubViews
{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setTitle:@"Hello" forState:UIControlStateNormal];
    self.btn.frame = CGRectMake(200, 100, 100, 100);
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
    [self.btn setBackgroundColor:[UIColor cyanColor]];
    
    self.downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downBtn setTitle:@"world" forState:UIControlStateNormal];
    self.downBtn.frame = CGRectMake(10, 400, 100, 100);
    [self.view addSubview:self.downBtn];
    [self.downBtn addTarget:self action:@selector(showPopover1) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn setBackgroundColor:[UIColor purpleColor]];
    
    self.listView = [[UITableView alloc] init];
    self.listView.frame = CGRectMake(0, 0, 280, 350);
}

- (void)showPopover
{
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.btn.frame), CGRectGetMaxY(self.btn.frame));
    [[YVPopupView popupView] showPopupViewWithPoint:startPoint popupDirection:YVPopupDirectionDown contentView:self.listView inView:self.view];
    __weak typeof(self) weakSelf = self;
    [YVPopupView popupView].didDismissHandler = ^
    {
        [weakSelf bounceTargetView:weakSelf.btn];
    };
}

- (void)showPopover1
{
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.downBtn.frame) + 30, CGRectGetMinY(self.downBtn.frame) - 5);
    [[YVPopupView popupView] showPopupViewWithPoint:startPoint popupDirection:YVPopupDirectionUp contentView:self.listView inView:self.view];
    
    __weak typeof(self) weakSelf = self;
    [YVPopupView popupView].didDismissHandler = ^
    {
        [weakSelf bounceTargetView:weakSelf.downBtn];
    };
}

- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^
    {
        targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}


@end
