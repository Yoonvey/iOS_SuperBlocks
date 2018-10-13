//
//  CLMDGuidePageView.m
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/18.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import "CLMDGuidePageView.h"

#define MainScreen_Width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_Height [UIScreen mainScreen].bounds.size.height//高

@interface CLMDGuidePageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *bigScrollView;
@property (nonatomic        ) NSArray       *imageArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation CLMDGuidePageView

-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images {
    if (self = [super initWithFrame:frame]) {
        self.imageArray=images;
        [self loadPageView];
    }
    return self;
}

-(void)loadPageView {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_Width, MainScreen_Height)];
    
    scrollView.contentSize = CGSizeMake((_imageArray.count + 1)*MainScreen_Width, MainScreen_Height);
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    scrollView.pagingEnabled = YES;//设置分页
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _bigScrollView = scrollView;
    
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i * MainScreen_Width, 0, MainScreen_Width, MainScreen_Height);
        UIImage *image = [UIImage imageNamed:_imageArray[i]];
        imageView.image = image;
        
        [scrollView addSubview:imageView];
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreen_Width/2, MainScreen_Height - 60, 0, 40)];
    pageControl.numberOfPages = _imageArray.count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.backgroundColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:pageControl];
    
    _pageControl = pageControl;
    
    //添加手势
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:singleRecognizer];
}

//左划退出引导页
-(void)handleSingleTapFrom {
    if (_pageControl.currentPage == self.imageArray.count-1) {
        [self removeFromSuperview];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _bigScrollView) {
        CGPoint offSet = scrollView.contentOffset;
        _pageControl.currentPage = offSet.x/(self.bounds.size.width);//计算当前的页码
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width * (_pageControl.currentPage), scrollView.contentOffset.y) animated:YES];
    }
    if (scrollView.contentOffset.x == (_imageArray.count) *MainScreen_Width) {
        [self removeFromSuperview];
    }
}

@end


@interface CLMDGuidePageHelper()
@property (nonatomic) UIWindow *rootWindow;
@property(nonatomic,strong)CLMDGuidePageView *guidePageView;
@end


@implementation CLMDGuidePageHelper

+ (instancetype)shareInstance {
    static CLMDGuidePageHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[CLMDGuidePageHelper alloc] init];
    });
    
    return shareInstance;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)showGuidePageView:(NSArray *)imageArray {
    if (![CLMDGuidePageHelper shareInstance].guidePageView) {
        [CLMDGuidePageHelper shareInstance].guidePageView=[[CLMDGuidePageView alloc] initPagesViewWithFrame:CGRectMake(0, 0, MainScreen_Width, MainScreen_Height) Images:imageArray];
    }
    
    [CLMDGuidePageHelper shareInstance].rootWindow = [UIApplication sharedApplication].keyWindow;
    [[CLMDGuidePageHelper shareInstance].rootWindow addSubview:[CLMDGuidePageHelper shareInstance].guidePageView];
}

@end