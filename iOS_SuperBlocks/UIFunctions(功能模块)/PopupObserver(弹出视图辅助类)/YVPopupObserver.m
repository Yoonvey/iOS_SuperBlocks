//
//  YVPopupObserver.m
//  YVPopupObserver
//
//  Created by Yoonvey on 2018/7/24.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "YVPopupObserver.h"

#define PopupScreenWidth [UIScreen mainScreen].bounds.size.width
#define PopupScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - <YVPopupObserver>
@interface YVPopupObserver ()

@property (nonatomic, weak) UIView *customView;
@property (nonatomic) CGPoint initialCenter;
@property (nonatomic) CGFloat deviantDuration;
@property (nonatomic) BOOL isPopup;

@end

@implementation YVPopupObserver

static YVPopupObserver *observer = nil;

#pragma mark - <Singleton>
+ (instancetype)sharedObserver
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[YVPopupObserver alloc]init];
    });
    return observer;
}

+ (id)alloc
{
    if (observer == nil) {
        return [super alloc];
    }
    else {
        return nil;
    }
}

- (id)init
{
    if (self = [super init]) {

    }
    return self;
}

#pragma mark PopupAnimation
- (void)showAlertWithAnimationParam:(YVAnimationParam *)animationParam customView:(UIView *)customView
{
    self.customView = customView;
    self.isPopup = YES;
    
    UIView *superView = (UIView *)[UIApplication sharedApplication].delegate.window;
    YVAnimationParam *animeParam = animationParam ? animationParam : [[YVAnimationParam alloc] init] ;
    
    UIView *maskView = nil;
    if (animeParam.isMask) {
        maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PopupScreenWidth, PopupScreenHeight)];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        YVTapGestureRecognizer *tapGS = [[YVTapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAlert:)];
        tapGS.delegate = self;
        tapGS.subObject = animeParam;
        [maskView addGestureRecognizer:tapGS];
        [maskView addSubview:customView];
        [superView addSubview:maskView];
    }
    else {
        [superView addSubview:customView];
    }
    
    customView.alpha = 0;
    customView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
    customView.center = superView.center;
    
    [UIView animateWithDuration:animeParam.showDuration
                          delay:animeParam.delay
         usingSpringWithDamping:animeParam.springDamping
          initialSpringVelocity:animeParam.springVelocity
                        options:animeParam.options
                     animations:^{
         customView.alpha = 1;
         customView.layer.transform = CATransform3DMakeScale(1, 1, 1);
         customView.center = superView.center;
         self.initialCenter = customView.center;
         if (maskView) {
             maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:animeParam.maskAlpha];
         }
     }
                     completion:nil];
}

- (void)dismissAlert:(YVTapGestureRecognizer *)tapGS
{
    self.customView = nil;
    self.isPopup = NO;
    
    YVAnimationParam *animeParam = (YVAnimationParam *)tapGS.subObject;
    UIView *maskView = (UIView *)tapGS.view;
    UIView *customView = (UIView *)[[maskView subviews] lastObject];
    
    CGPoint touchPoint = [tapGS locationOfTouch:0 inView:maskView];
    BOOL touch = [customView.layer containsPoint:touchPoint];
    NSLog(@"touchPoint.x>%f, touch>%i", touchPoint.x, touch);
    
    [UIView animateWithDuration:animeParam.dismissDuration
                     animations:^{
         customView.alpha = 0;
         customView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
         customView.center = maskView.center;
         maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
     } completion:^(BOOL finished) {
        self.initialCenter = CGPointZero;
         if (finished) {
             [maskView removeFromSuperview];
         }
     }];
}

- (void)dismissAlertWithAnimationParam:(YVAnimationParam *)animationParam customView:(UIView *)customView
{
    self.customView = nil;
    self.isPopup = NO;
    
    YVAnimationParam *animeParam = animationParam ? animationParam : [[YVAnimationParam alloc] init] ;
    UIView *superView = (UIView *)[customView superview];
    
    [UIView animateWithDuration:animeParam.dismissDuration
                     animations:^{
         customView.alpha = 0;
         customView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
         customView.center = superView.center;
         if (animeParam.isMask) {
             superView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
         }
     } completion:^(BOOL finished) {
        self.initialCenter = CGPointZero;
         if (finished) {
             [customView removeFromSuperview];
             if (animeParam.isMask) {
                 [superView removeFromSuperview];
             }
         }
     }];
}

#pragma mark PushAnimation
- (void)showPushWithAnimationParam:(YVAnimationParam *)animationParam customView:(UIView *)customView direction:(PushDirection)direction deviant:(CGFloat)deviant
{
    self.customView = customView;
    self.isPopup = NO;
    
    UIView *superView = (UIView *)[UIApplication sharedApplication].delegate.window;
    YVAnimationParam *animeParam = animationParam ? animationParam : [[YVAnimationParam alloc] init] ;

    CGFloat startCenterX = superView.center.x;
    CGFloat endCenterX = superView.center.x;
    CGFloat startCenterY = superView.center.y;
    CGFloat endCenterY = superView.center.y;
    if (direction == PushDirectionRight) {
        startCenterX = -customView.frame.size.width*0.5;
        endCenterX = customView.frame.size.width*0.5 + deviant;
    }
    else if(direction == PushDirectionLeft) {
        startCenterX = PopupScreenWidth + customView.frame.size.width*0.5;
        endCenterX = PopupScreenWidth - customView.frame.size.width*0.5 - deviant;
    }
    else {
        startCenterY = direction == PushDirectionUp ? PopupScreenHeight +  (customView.frame.size.height)*0.5: -customView.frame.size.height*0.5;
        endCenterY = direction == PushDirectionUp ? PopupScreenHeight - (customView.frame.size.height*0.5 + deviant) : (customView.frame.size.height*0.5 + deviant);
    }
    
    UIView *maskView = nil;
    if (animeParam.isMask) {
        maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PopupScreenWidth, PopupScreenHeight)];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        YVTapGestureRecognizer *tapGS = [[YVTapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPush:)];
        tapGS.delegate = self;
        tapGS.subObject = animeParam;
        tapGS.direction = direction;
        [maskView addGestureRecognizer:tapGS];
        [maskView addSubview:customView];
        [superView addSubview:maskView];
    }
    else {
        [superView addSubview:customView];
    }
    
    customView.center = CGPointMake(startCenterX, startCenterY);
    
    [UIView animateWithDuration:animeParam.showDuration
                          delay:animeParam.delay
         usingSpringWithDamping:animeParam.springDamping
          initialSpringVelocity:animeParam.springVelocity
                        options:animeParam.options
                     animations:^{
         customView.alpha = 1;
         customView.center = CGPointMake(endCenterX, endCenterY);
         self.initialCenter = customView.center;
         if (maskView) {
             maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:animeParam.maskAlpha];
         }
     }
                     completion:nil];
}

- (void)dismissPush:(YVTapGestureRecognizer *)tapGS
{
    self.customView = nil;
    self.isPopup = NO;
    
    YVAnimationParam *animeParam = (YVAnimationParam *)tapGS.subObject;
    PushDirection direction = tapGS.direction;
    
    UIView *maskView = (UIView *)tapGS.view;
    UIView *customView = (UIView *)[[maskView subviews] lastObject];
    
    CGFloat endCenterX = maskView.center.x;
    CGFloat endCenterY = maskView.center.y;
    if (direction == PushDirectionRight) {
        endCenterX = -customView.frame.size.width*0.5;
    }
    else if(direction == PushDirectionLeft) {
        endCenterX = PopupScreenWidth + customView.frame.size.width*0.5;
    }
    else {
        endCenterY = (direction == PushDirectionUp) ? PopupScreenHeight + customView.frame.size.height*0.5 : -customView.frame.size.height*0.5 ;
    }
    
    [UIView animateWithDuration:animeParam.dismissDuration
                     animations:^{
         customView.alpha = 0;
         customView.center = CGPointMake(endCenterX, endCenterY);
         maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
     } completion:^(BOOL finished) {
        self.initialCenter = CGPointZero;
         if (finished) {
             [maskView removeFromSuperview];
         }
     }];
}

- (void)dismissPushWithAnimationParam:(YVAnimationParam *)animationParam direction:(PushDirection)direction customView:(UIView *)customView
{
    self.customView = nil;
    self.isPopup = NO;
    
    YVAnimationParam *animeParam = animationParam ? animationParam : [[YVAnimationParam alloc] init] ;
    UIView *superView = (UIView *)[customView superview];
    
    CGFloat endCenterX = superView.center.x;
    CGFloat endCenterY = superView.center.y;
    if (direction == PushDirectionRight) {
        endCenterX = -customView.frame.size.width*0.5;
    }
    else if (direction == PushDirectionLeft) {
        endCenterX = PopupScreenWidth + customView.frame.size.width*0.5;
    }
    else {
        endCenterY = (direction == PushDirectionUp) ? PopupScreenHeight + customView.frame.size.height*0.5 : -customView.frame.size.height*0.5;
    }
    
    [UIView animateWithDuration:animeParam.dismissDuration
                     animations:^{
         customView.alpha = 0;
         customView.center = CGPointMake(endCenterX, endCenterY);
         if (animeParam.isMask) {
             superView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
         }
     } completion:^(BOOL finished) {
        self.initialCenter = CGPointZero;
         if (finished) {
             [customView removeFromSuperview];
             if (animeParam.isMask) {
                 [superView removeFromSuperview];
             }
         }
     }];
}

#pragma mark - <视图偏移>
- (void)moveCustomViewWithDuration:(CGFloat)duration deviantDirection:(DeviantDirection)direction deviant:(CGFloat)deviant
{
    if (self.customView) {
        self.deviantDuration = duration > 0.0 ? duration: 0.3;
        [UIView animateWithDuration:duration animations:^{
             if (direction == DeviantDirectionVertical) {
                 CGFloat y = self.initialCenter.y;
                 y += deviant;
                 self.customView.center = CGPointMake(self.customView.center.x, y);
             }
             else {
                 CGFloat x = self.initialCenter.x;
                 x += deviant;
                 self.customView.center = CGPointMake(x, self.customView.center.y);
             }
         }];
    }
}

- (void)recoverCustomViewInitialCenter
{
    if (self.customView) {
        [UIView animateWithDuration:self.deviantDuration animations:^{
             self.customView.center = self.initialCenter;
         }];
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *maskView = (UIView *)gestureRecognizer.view;
    UIView *customView = (UIView *)[[maskView subviews] lastObject];
    if ([touch.view isDescendantOfView:customView]) {
        return NO;
    }
    return YES;
}

@end

#pragma mark - <YVAnimationParam>
@interface YVAnimationParam ()

@property (nonatomic) CGFloat damping;//回弹的频率, 默认为0.3
@property (nonatomic) CGFloat velocity;//回弹速度, 默认为10

@end

@implementation YVAnimationParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupCommon];
    }
    return self;
}

- (void)setupCommon
{
    self.isMask = YES;
    self.isSpring = YES;
    self.maskAlpha = 0.3;
    self.showDuration = 0.3;
    self.dismissDuration = 0.3;
    self.delay = 0.0;
    self.springDamping = 0.4;
    self.damping = 0.4;
    self.springVelocity = 10;
    self.velocity = 10;
    self.options = UIViewAnimationOptionCurveEaseInOut;
}

- (void)setMaskAlpha:(CGFloat)maskAlpha
{
    _maskAlpha = maskAlpha;
    if (maskAlpha <= 0) {
        self.isMask = NO;
    }
    else {
        self.isMask = YES;
    }
}

- (void)setIsSpring:(BOOL)isSpring
{
    _isSpring = isSpring;
    if(!isSpring) {//关闭回弹效果
        self.springDamping = 1.0f;
        self.springVelocity = 0.0;
    }
    else {
        self.springDamping = self.damping;
        self.springVelocity = self.velocity;;
    }
}

- (void)setSpringDamping:(CGFloat)springDamping
{
    _springDamping = springDamping;
    self.damping = springDamping;
    if (!self.isSpring) {
        _springDamping = 1.0f;
    }
}

- (void)setSpringVelocity:(CGFloat)springVelocity
{
    _springVelocity = springVelocity;
    self.velocity = springVelocity;
    if (!self.isSpring) {
        _springVelocity = 0.0;
    }
}

@end

#pragma mark - <YVTapGestureRecognizer>
@implementation YVTapGestureRecognizer

@end
