//
//  UIBaseViewController.m
//  IOTUnitedPlatform
//
//  Created by 周荣飞 on 17/12/13.
//  Copyright © 2017年 ModouTech. All rights reserved.
//

#import "UIBaseViewController.h"

@interface UIBaseViewController ()
{
    CGFloat navigationY;
    CGFloat navBarY;
    CGFloat verticalY;
    BOOL _isShowMenu;
}
@property CGFloat original_height;
//@property (nonatomic, strong) Reachability *hostReach;

@end

@implementation UIBaseViewController

- (instancetype)init
{
    if (self == [super init])
    {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
        navBarY = 0;
        navigationY = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    //注释该句会使navi在iOS8.0以后下移64个点
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置默认的导航栏
    if ([self respondsToSelector:@selector(backgroundImage)])
    {
        UIImage *bgImage = [self navBackgroundImage];
        [self setNavigationBack:bgImage];
    }
    if ([self respondsToSelector:@selector(setTitle)])
    {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    if (![self leftButton])
    {
        [self configLeftBarItemWithImage];
    }
    if (![self rightButton])
    {
        [self configRightBaritemWithImage];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(set_colorBackground)])
    {
        UIColor *backgroundColor = [self set_colorBackground];
        UIImage *bgimage = [self createdImageWithColor:backgroundColor];
        if (backgroundColor == [UIColor clearColor])//显示默认的颜色
        {
            bgimage = [self createdImageWithColor:backgroundColor];
        }
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImageView *blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认黑线是显示的
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)])
    {
        if ([self hideNavigationBottomLine])
        {
            blackLineImageView.hidden = YES;
        }
    }
    if ([self respondsToSelector:@selector(set_bottomView)]) {
        [self customView];
    }
}
//Navigation的背景，不是返回键
- (void)setNavigationBack:(UIImage *)image
{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image];
    [self.navigationController.navigationBar setShadowImage:image];
}

#pragma mark - nav中的title设置和点击事件
- (void)set_Title:(NSMutableAttributedString *)title
{
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines = 0;//可能需要多行的标题
    navTitleLabel.textAlignment = NSTextAlignmentCenter;//居中
    navTitleLabel.backgroundColor = [UIColor clearColor];//背景无色
    navTitleLabel.userInteractionEnabled = YES;//用户交互开启
    [navTitleLabel setAttributedText:title];
    
    //标题点击事件，遵守协议，实现title_click_event方法即可
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}

- (void)titleClick:(UIGestureRecognizer *)tap
{
    UIView *view = tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}

#pragma mark - <customView>
- (void)customView
{
    //    self.navigationController.navigationItem.titleView = [self set_bottomView];
    self.navigationItem.titleView = [self set_bottomView];
}

#pragma mark - leftButton
- (BOOL)leftButton
{
    BOOL isLeft = [self respondsToSelector:@selector(set_leftButton)];
    if (isLeft)
    {
        UIButton *leftButton = [self set_leftButton];
        [leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        // 让按钮内部的所有内容左对齐
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        
        self.navigationItem.leftBarButtonItem = item;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,self.navigationItem.leftBarButtonItem];
    }
    return isLeft;
}

- (void)configLeftBarItemWithImage
{
    if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)])
    {
        UIImage *image = [self set_leftBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(leftClick:)];
        self.navigationItem.backBarButtonItem = item;
    }
}

- (void)leftClick:(id)sender
{
    if ([self respondsToSelector:@selector(left_button_event:)])
    {
        [self left_button_event:sender];
    }
}

#pragma mark - rightButton
- (BOOL)rightButton
{
    BOOL isRight = [self respondsToSelector:@selector(set_rightButton)];
    if (isRight)
    {
        UIButton *rightButton = [self set_rightButton];
        [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = item;
    }
    return  isRight;
}

- (void)configRightBaritemWithImage
{
    if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
        UIImage *image = [self set_rightBarButtonItemWithImage];
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(rightClick:)];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)rightClick:(id)sender
{
    if ([self respondsToSelector:@selector(right_button_event:)])
    {
        [self right_button_event:sender];
    }
}
#pragma mark - tool
- (void)changeNavigationBarHeight:(CGFloat)offset
{
    [UIView animateWithDuration:0.3f animations:^
     {
         self.navigationController.navigationBar.frame  = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
                                                                     navigationY,
                                                                     self.navigationController.navigationBar.frame.size.width,
                                                                     offset
                                                                     );
     }];
    
}

- (void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews)
    {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView)
        {
            return imageView;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark 自定义代码
- (NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(15) range:NSMakeRange(0, title.length)];
    return title;
}

/*!
 * @brief  根据颜色生成纯色图片
 * @param color 颜色
 * @return 纯色图片
 */
-  (UIImage *)createdImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
