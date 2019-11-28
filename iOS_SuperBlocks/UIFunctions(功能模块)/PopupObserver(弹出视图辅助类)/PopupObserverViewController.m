//
//  PopupObserverViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2019/11/28.
//  Copyright © 2019 EdwinChen. All rights reserved.
//

#import "PopupObserverViewController.h"

#import "YVPopupObserver.h"

@interface PopupObserverViewController ()

@end

@implementation PopupObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"弹出视图";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *alert = [UIButton buttonWithType:UIButtonTypeCustom];
    alert.frame = CGRectMake(30, 100, 60, 40);
    [alert setTitle:@"Alert" forState:UIControlStateNormal];
    [alert setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [alert addTarget:self action:@selector(alertStyle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alert];
    
    
    UIButton *push = [UIButton buttonWithType:UIButtonTypeCustom];
    push.frame = CGRectMake(230, 100, 60, 40);
    [push setTitle:@"Push" forState:UIControlStateNormal];
    [push setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [push addTarget:self action:@selector(pushStyle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:push];
}

- (void)alertStyle {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    view.backgroundColor = [UIColor redColor];
    
    YVAnimationParam *param = [[YVAnimationParam alloc] init];
    param.isSpring = NO;
    param.maskAlpha = 0.3;
    [[YVPopupObserver sharedObserver] showAlertWithAnimationParam:param customView:view];
}

- (void)pushStyle {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor = [UIColor redColor];
    
    YVAnimationParam *param = [[YVAnimationParam alloc] init];
    param.isSpring = NO;
    param.maskAlpha = 0.3;
    [[YVPopupObserver sharedObserver] showPushWithAnimationParam:param customView:view direction:PushDirectionRight deviant:-[UIScreen mainScreen].bounds.size.width*0.25];
}

@end
