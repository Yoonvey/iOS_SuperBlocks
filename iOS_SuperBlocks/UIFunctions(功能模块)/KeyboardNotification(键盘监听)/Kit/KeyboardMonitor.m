//
//  KeyboardMonitor.m
//  YVKeyboardMonitor
//
//  Created by Yoonvey on 2019/11/18.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import "KeyboardMonitor.h"

#define KBScreenHeight [UIScreen mainScreen].bounds.size.height

static KeyboardMonitor *_monitor = nil;
static dispatch_once_t _onceToken;

@interface KeyboardMonitor ()

@property (nonatomic) BOOL keyboardDidDisplay;
@property (nonatomic) CGFloat lastDevaint;
@property (nonatomic) CGFloat lastKeyBoardHeight;

/** 键盘属性(再声明为内部可读写) */
@property (nonatomic, readwrite) CGFloat keyBoardHeight;
@property (nonatomic, readwrite) CGFloat animationTime;
@property (nonatomic, readwrite) UIViewAnimationCurve animationCurve;

@end

@implementation KeyboardMonitor

#pragma mark - <单例对象的生命周期管理>
/**!
 *  使用YV_SINGLETON_IMP这个宏进行单例的创建
 *  YVKeyboardObserver 单例类
 *  _onceToken  传入对象使用次数引用计数, 用于单例的创建与释放
 *  _observer  传入单例对象, 用于单例的创建与释放
 */
YV_SINGLETON_IMP(KeyboardMonitor, _onceToken, _monitor);
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self setupCommon];
    [self registerNotification];
    
    return self;
}

/// 释放单例
- (void)deallocSltObject
{
    [self resignNotification];
    _onceToken = 0;
    _monitor = nil;
}

#pragma mark - <属性设置>
- (void)setupCommon
{
    _keyboardDidDisplay = false;
    _targetBounds = CGRectZero;
    _lastDevaint = 0;
    _lastKeyBoardHeight = 0;
    _keyBoardHeight = 0;
}

- (void)setTargetBounds:(CGRect)targetBounds
{
    _targetBounds = targetBounds;
    if (_keyboardDidDisplay) {
        // 更新偏移高度
        [self responseOffsetHeight];
    }
}

#pragma mark - <注册/注销通知>
/// 注册消息通知接收
- (void)registerNotification
{
    // 当键盘结构(样式)改变时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

/// 注销消息通知接收
- (void)resignNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - <接收到键盘事件>
/// 键盘变更
- (void)keyboardWillChanged:(NSNotification *)notification
{
    _keyboardDidDisplay = true;
    // 重新读取键盘属性
    [self readKeyboardSets:notification];
    // 计算偏移高度
    [self responseOffsetHeight];
}

/// 键盘消失事件
- (void)keyboardWillDismiss:(NSNotification *)notification
{
    _keyboardDidDisplay = false;
    [self keyboardDismissResponse];
}

#pragma mark - <回调>
/// 键盘类型变更
- (void)keyboardChangedResponse:(CGFloat)deviant {
    _lastDevaint = deviant;
    _lastKeyBoardHeight = _keyBoardHeight;
    // 注册了代理则会进行代理回调
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardWillChanged:)]) {
        [_delegate keyBoardWillChanged:deviant];
    }
    // 注册了block属性接收则会进行block回调
    if(_keyboardChanged) {
        _keyboardChanged(deviant);
    }
}

/// 键盘消失
- (void)keyboardDismissResponse {
    // 重置属性初始值
    [self setupCommon];
    // 注册了代理则会进行代理回调
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardWillDismiss)]) {
        [_delegate keyBoardWillDismiss];
    }
    // 注册了block属性接收则会进行block回调
    if (_keyboardDismiss) {
        _keyboardDismiss();
    }
}

#pragma mark - <计算偏移高度并返回>
- (void)responseOffsetHeight
{
    // 键盘高度发生变化时执行，偏移值等于上次执行时的最终偏移值+键盘高度变化值
    if (_lastKeyBoardHeight != 0 && _lastKeyBoardHeight != _keyBoardHeight) {
        [self keyboardChangedResponse:_lastDevaint + (_lastKeyBoardHeight - _keyBoardHeight)];
    }
    // target响应者发生变化时执行，偏移值等于当前偏移值+上次执行时的最终偏移值（当视图多次发生偏移时，target响应者相对Window的坐标也发生了变化，所以这里需要加上上次执行时的最终偏移值）
    else {
        // 获取参照目标底边相对屏幕的坐标
        CGFloat bottomOrigin = _targetBounds.origin.y + _targetBounds.size.height;
        // 获取参照目标底边相对屏幕底边的距离
        CGFloat bottomOffset = KBScreenHeight - bottomOrigin;
        
        //修复高度误差导致空白或黑屏的问题
        if (bottomOrigin > KBScreenHeight) {
            bottomOffset = 0;
        }
        
        CGFloat deviant = bottomOffset - _keyBoardHeight;
        //当deviant < 0时, 说明视图被键盘遮挡, 上移一部分距离, 反之则不需要进行操作
        if (deviant < 0) {
            [self keyboardChangedResponse:deviant + _lastDevaint];
        }
    }
}

#pragma mark - <读取键盘属性>
- (void)readKeyboardSets:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *frameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameValue CGRectValue];
    CGSize keyBoardSize = keyboardRect.size;
    //获取键盘的高度
    _keyBoardHeight = keyBoardSize.height;
    // 获取键盘动画时间
    _animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    /// 获取键盘曲线
    _animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
}

@end
