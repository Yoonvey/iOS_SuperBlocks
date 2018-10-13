//
//  UISignInViewController.m
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/13.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UISignInViewController.h"

#import "AppDelegate.h"

//AppDelegate对象
#define AppDelegateInstance [[UIApplication sharedApplication] delegate]

@interface UISignInViewController ()

@end

@implementation UISignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //登录成功后跳转到首页
    [((AppDelegate *) AppDelegateInstance) setupHomeViewController];
}

@end
