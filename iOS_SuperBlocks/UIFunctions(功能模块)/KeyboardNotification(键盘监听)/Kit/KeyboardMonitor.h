//
//  KeyboardMonitor.h
//  YVKeyboardMonitor
//
//  Created by Yoonvey on 2019/11/18.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - <创建单例声明>
/**!
 *  声明创建单例到方法
 *  温柔的告知调用者，alloc，new，copy，mutableCopy方法不可以直接调用, 必须调用sltObject方法进行单例对象的创建。 否则编译不过。
 *  需要调用单例的时候请使用    [Class sltObject] 或 Class.sltObject   获取这个单例对象
 *
 *  PS: 需要在.h文件的定义中调用方法 YV_SINGLETON_DEF(class), class为调用的类
 **/
#define YV_SINGLETON_DEF(_type_) +(_type_ *)sltObject; +(instancetype) alloc __attribute__((unavailable("call sharedInstance instead"))); +(instancetype) new __attribute__((unavailable("call sharedInstance instead"))); -(instancetype) copy __attribute__((unavailable("call sharedInstance instead"))); -(instancetype) mutableCopy __attribute__((unavailable("call sharedInstance instead")));
/**!
 *  创建单例
 *
 *  PS: 需要在.m文件的实现中调用方法 YV_SINGLETON_IMP(class, dispatch_once_t, object), class为调用的类、dispatch_once_t为单例创建的多线程计数、 object为单里对象
 **/
#define YV_SINGLETON_IMP(_type_, onceToken, object) +(_type_ *)sltObject{dispatch_once(&onceToken, ^{object = [[super alloc] init];}); return object;}

NS_ASSUME_NONNULL_BEGIN

/// 代理
@protocol KeyboardDelegate <NSObject>

- (void)keyBoardWillChanged:(CGFloat)deviant;
- (void)keyBoardWillDismiss;

@end


@interface KeyboardMonitor : NSObject

/// 声明创建单例
YV_SINGLETON_DEF(KeyboardMonitor);

/// 释放单例
- (void)deallocSltObject;

#warning 无论使用代理方式还是block方式监听键盘事件，都需要在使用的控制的生命周期viewWillAppear和viewWillDisappear中注册/注销监听。
/** 注册遵守代理方式实现获取键盘监听 */
@property (nonatomic, weak, nullable) id<KeyboardDelegate> delegate;

/**
 *  block方式实现获取键盘监听
 *  keyboardChanged代表键盘已弹出或者键盘结构改变事件，会回调一个偏移值
 *  
 */
@property (nonatomic, copy, nullable) void(^keyboardChanged)(CGFloat deviant);
@property (nonatomic, copy, nullable) void(^keyboardDismiss)(void);

/**
 *  校准高度的参照对象结构
 */
@property (nonatomic) CGRect targetBounds;

/** 键盘属性 */
@property (nonatomic, readonly) CGFloat keyBoardHeight;
@property (nonatomic, readonly) CGFloat animationTime;
@property (nonatomic, readonly) UIViewAnimationCurve animationCurve;

@end

NS_ASSUME_NONNULL_END
