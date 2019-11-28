//
//  UITableHeaderView.h
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableHeaderButton;
@class UITableHeaderLabel;

@interface UITableHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic) BOOL suspension;// 是否悬停

/// 顶部分割线
@property (nonatomic) BOOL topSeparator;//是否需要分割线（UITableViewStylePlain下表头没有分割线，需要的话设置为YES即可）
@property (nonatomic, strong) UILabel *topSeparatorLine;
@property (nonatomic, strong) UIColor *topSeparatorColor;//
@property (nonatomic) UIEdgeInsets topSeparatorInsets;

/// 底部分割线
@property (nonatomic) BOOL bottomSeparator;//是否需要分割线（UITableViewStylePlain下表头没有分割线，需要的话设置为YES即可）
@property (nonatomic, strong) UILabel *bottomSeparatorLine;
@property (nonatomic, strong) UIColor *bottomSeparatorColor;//
@property (nonatomic) UIEdgeInsets bottomSeparatorInsets;

//表头标题
@property (nonatomic, strong) UITableHeaderLabel *titleLabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat titleSize;// default is 15
@property (nonatomic, strong) UIColor *titleColor;// default is grayColor
@property (nonatomic, strong) UIFont *titleFont;// defailt is systemFontOfSize
@property (nonatomic, assign) NSTextAlignment titleAlignment;// default is NSTextAlignmentLeft

//表头右方图标
@property (nonatomic, strong) UITableHeaderButton *actionButton;
@property (nonatomic, strong) UIImage *normalImage;//默认状态显示图标
@property (nonatomic, strong) UIImage *hightlightedImage;//高亮状态显示图标
@property (nonatomic, strong) UIImage *selectedImage;//选中状态显示图标
@property (nonatomic, assign) CGFloat rightMargin;//距离右边的间距（大于0）

/*!
 * @brief 重写初始化方法。 (推荐使用dequeueReusableHeaderFooterViewWithIdentifier方法复用此视图以优化内存管理(若需要设置悬停，请先设置suspension属性为YES, 此项设置要在设置frame之前设置才能生效), 需要优先设置frame属性以调整约束)
 * @param frame 视图的框架大小
 * @param suspension 是否悬停(该属性仅在表格的Style为UITableViewStylePlain模式下生效, UITableViewStyleGrouped模式下悬停无效)
 */
- (instancetype)initWithFrame:(CGRect)frame
                   suspension:(BOOL)suspension;

@end

@interface UITableHeaderButton : UIButton

@property (nonatomic, assign) CGFloat rightMargin;

@end

@interface UITableHeaderLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets textInsets; // 控制字体与控件边界的间隙

@end
