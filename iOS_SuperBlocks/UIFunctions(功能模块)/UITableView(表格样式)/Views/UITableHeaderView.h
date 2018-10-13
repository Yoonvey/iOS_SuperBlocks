//
//  UITableHeaderView.h
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableHeaderButton;

@interface UITableHeaderView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger section;

//表头标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat titleSize;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) NSTextAlignment titleAlignment;

//表头右方图标
@property (nonatomic, strong) UITableHeaderButton *actionButton;
@property (nonatomic, strong) UIImage *normalImage;//默认状态显示图标
@property (nonatomic, strong) UIImage *hightlightedImage;//高亮状态显示图标
@property (nonatomic, strong) UIImage *selectedImage;//选中状态显示图标
@property (nonatomic, assign) CGFloat rightMargin;//距离右边的间距（大于0）

/*!
 * @brief 重写初始化方法
 * @param frame 视图的框架大小
 * @param suspension 是否悬停(该属性仅在表格的Style为UITableViewStylePlain模式下生效, UITableViewStyleGrouped模式下悬停无效)
 */
- (instancetype)initWithFrame:(CGRect)frame
                   suspension:(BOOL)suspension;

@end

@interface UITableHeaderButton : UIButton

@property (nonatomic, assign) CGFloat rightMargin;

@end
