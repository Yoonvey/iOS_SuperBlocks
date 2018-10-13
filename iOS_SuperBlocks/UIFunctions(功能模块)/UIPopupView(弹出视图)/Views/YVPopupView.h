//
//  YVPopupView.h
//  YVPopupView
//
//  Created by 周荣飞 on 16/9/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YVPopupDirection)
{
    YVPopupDirectionUp = 1,/* 向上退推出 */
    YVPopupDirectionDown/* 向下退推出 */
};

typedef NS_ENUM(NSUInteger, YVPopupMaskType)
{
    YVPopuMaskTypeBlack,
    YVPopuMaskTypeNone,  // 透明蒙版并且不支持点击事件
};


@interface YVPopupView : UIView

+ (instancetype)popupView;


/**
 *  内容视图在容器视图中的位置,默认设置为0
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/** 
 *  popupView的推出方向,默认设置为乡下推出
 **/
@property (nonatomic, assign, readonly) YVPopupDirection *popupDirection;

/**
 *  箭头大小,默认设置为{10.0, 10.0};
 **/
@property (nonatomic, assign) CGSize arrowSize;

/**
 *  popupView的切角度,默认设置为(8.0,8.0)
 **/
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  popupView的弹出动画时长,默认设置为0.4秒
 */
@property (nonatomic, assign) CGFloat animationIn;

/**
 *  popupView的隐藏动画时长,默认设置为0.3秒
 */
@property (nonatomic, assign) CGFloat animationOut;

/**
 *  是否允许弹出动画的弹簧效果,默认设置为Yes
 */
@property (nonatomic, assign) BOOL animationSpring;

/**
 *  popupView的背景设置,默认设置为YVPopupMaskTypeBlack;
 */
@property (nonatomic, assign) YVPopupMaskType maskType;

/**
 *  如果maskType不满足你的需要,你可以使用blackoverylay控制权限(userInterfaceEnabled)来开放定制背景颜色
 */
@property (nonatomic, strong, readonly) UIControl *blackOverlay;

/**
 *  如果弹出窗口有其背后的阴影,默认是Yes。
 *  你可以通过设置它的 popover.layer、shadowColor、shadowOffset shadowOpacity shadowRadius 来定制你想要的背景图层样式。
 */
@property (nonatomic, assign) BOOL applyShadow;

/**
 *  当你使用atView显示API时,这个值将被用作弹窗'arrow和atView之间的距离。
 *  注意:当弹出窗口显示使用atPoint API,这个值是无效的
 */
@property (nonatomic, assign) CGFloat betweenAtViewAndArrowHeight;

/**
 * 决定弹出窗口与containerView边界之间的最近的边框,默认是4.0
 */
@property (nonatomic, assign) CGFloat sideEdge;

/**
 *  当popupView从展示视图显示的时候执行的回调
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  当popupView从展示视图消失的时候执行的回调
 */
@property (nonatomic, copy) dispatch_block_t didDismissHandler;


#pragma mark - publicMethod(公开方法)
/**
 *  showPopupView(展示PopupView)
 *  @param:point    弹出起点
 *  @param:popupDirection    弹出方向
 *  @param:contentView    内容视图
 *  @param:containerView    容器视图
 **/
- (void)showPopupViewWithPoint:(CGPoint)point
                popupDirection:(YVPopupDirection)popupDirection
                   contentView:(UIView *)contentView
                        inView:(UIView *)containerView;

/**
 *  showPopupView(展示PopupView)
 *  @param:atView    指定展示到一个视图上
 *  @param:popupDirection    弹出方向
 *  @param:contentView    内容视图
 *  @param:containerView    容器视图
 **/
- (void)showAtView:(UIView *)atView
    popoverPostion:(YVPopupDirection)popupDirection
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView;


/**  showPopupView(无法指定显示方向, 内容容器和指定对象)
*  @param:atView    指定展示到一个视图上
*  @param:contentView    内容视图
*  @param:containerView    容器视图
**/
- (void)showAtView:(UIView *)atView
   withContentView:(UIView *)contentView
            inView:(UIView *)containerView;

/**  showPopupView(无法指定内容容器和指定对象,只能展示到根视图上面)
 *  @param:atView    指定展示到一个视图上
 *  @param:contentView    内容视图
 **/
- (void)showAtView:(UIView *)atView withContentView:(UIView *)contentView;

/**  showPopupView(默认展示到一个标签控制器中,无法指定内容视图和容器视图)
 *  @param:atView    指定展示到一个视图上
 *  @param:abs   内容文本
 **/
- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs;

/**  showPopupView(默认展示到一个标签控制器中,无法指定内容视图)
 *  @param:atView    指定展示到一个视图上
 *  @param:abs   内容文本
*   @param:container   容器视图
 **/
- (void)showAtView:(UIView *)atView withText:(NSAttributedString *)abs inView:(UIView *)container;

- (void)dismiss;

@end
