//
//  UIDeleteCellTableViewController.h
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2018/10/12.
//  Copyright © 2018年 EdwinChen. All rights reserved.
//

#import "UIBaseViewController.h"

#import "UITableViewScrollDelegate.h"

@interface UIDeleteCellTableViewController : UIBaseViewController

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id<UITableViewScrollDelegate> scrollDelegate;

@end
