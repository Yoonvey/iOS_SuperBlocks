//
//  YVImageCropperViewController.m
//  YVImageCropperViewControllerDemo
//
//  Created by 周荣飞 on 17/2/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YVImageCropperViewController.h"

#define YVScreenWidth      [UIScreen mainScreen].bounds.size.width
#define YVScreenHeight     [UIScreen mainScreen].bounds.size.height
#define YVSafeAreaTopHeight (ScreenHeight == 812.0 ? 88 : 64)
#define YVSafeAreaBottomHeight (ScreenHeight == 812.0 ? 83.5 : 49.5)
#define YVScaleImageHeight ([UIScreen mainScreen].bounds.size.height- YVSafeAreaTopHeight - YVSafeAreaBottomHeight)

@interface YVImageCropperViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScrollView *masterScrollView;
@property (nonatomic, strong) UIImage *originalImage;//原图
@property (nonatomic, weak) UIImageView *showImageView;//缩放后的图片的视图
@property (nonatomic, weak) UIView *overlayView;//覆盖视图
@property (nonatomic, weak) UIView *cropperView;//裁剪框
@property (nonatomic, weak) UIView *parentView;//容器视图(加载ImageView,使ImageView与ScrollView分离开)

@property (nonatomic, assign) CGRect cropFrame;//裁剪框的frame
@property (nonatomic, assign) CGRect oldFrame;//保存ImageView原来的frame
@property (nonatomic, assign) CGRect lastFrame;//图片ImageView最后的frame
@property (nonatomic, assign) CGPoint scrollViewOrigin;//ScrollView的origin(用来设定裁剪图片的起点)
@property (nonatomic, assign) CGFloat chageInstance;

@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;//是否水平滚动(默认是YES)
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;//是否垂直滚动(默认是YES)



@end

@implementation YVImageCropperViewController

#pragma mark初始化属性变量
//初始化控制器和属性变量
- (instancetype)initWithImage:(UIImage *)originalImage cropperSize:(CGSize)cropperSize
{
    self = [super init];
    if (self) {
        self.originalImage = [self fixOrientation:originalImage];
        CGFloat cropperWidth = cropperSize.width;
        CGFloat cropperHeight = cropperSize.height;
        if (cropperWidth > YVScreenWidth)
        {
            cropperWidth = YVScreenWidth;
        }
        if (cropperHeight > YVScaleImageHeight)
        {
            cropperHeight = YVScaleImageHeight;
        }
        self.cropFrame = CGRectMake(YVScreenWidth/2-cropperWidth/2, 64+YVScaleImageHeight/2-cropperHeight/2, cropperWidth, cropperHeight);
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = YES;
    }
    return self;
}

//计算设定图片的显示大小和位置
- (void)calculateScaleImageFrame
{
    CGSize imageScaleSize = self.originalImage.size;
    if (imageScaleSize.width < imageScaleSize.height)//竖屏显示
    {
        CGFloat oldWidth = imageScaleSize.width;
        imageScaleSize.width = YVScreenWidth;
        imageScaleSize.height = (imageScaleSize.width/oldWidth)*imageScaleSize.height;
    }
    else if (imageScaleSize.width > imageScaleSize.height)//横屏显示
    {
        CGFloat oldHeight = imageScaleSize.height;
        imageScaleSize.height = YVScaleImageHeight;
        imageScaleSize.width = (imageScaleSize.height/oldHeight)*imageScaleSize.width;
    }
    else//正方形
    {
        imageScaleSize.width = YVScaleImageHeight;
        imageScaleSize.height = YVScaleImageHeight;
    }
    //无法占满裁剪框时,设置占满
    if (imageScaleSize.height < YVScaleImageHeight)//高度
    {
        CGFloat oldHeight = imageScaleSize.height;
        imageScaleSize.height = YVScaleImageHeight;
        imageScaleSize.width = (YVScaleImageHeight/oldHeight)*imageScaleSize.width;
    }
    if (imageScaleSize.width < YVScreenWidth)
    {
        CGFloat oldWidth = imageScaleSize.width;
        imageScaleSize.width = YVScreenWidth;
        imageScaleSize.height = (YVScreenWidth/oldWidth)*imageScaleSize.height;
    }
    //保存图片视图的初始Frame值
    self.oldFrame = CGRectMake(0, 0, imageScaleSize.width, imageScaleSize.height);
    //保存图片视图的最终Frame值
    self.lastFrame = self.oldFrame;
    //设置初始滑动值
    if (imageScaleSize.width == YVScreenWidth)
    {
        if (imageScaleSize.height == YVScaleImageHeight)
        {
            self.scrollViewOrigin = CGPointMake(self.cropFrame.origin.x, self.cropFrame.origin.y-64);
        }
        else
        {
            self.scrollViewOrigin = CGPointMake(self.cropFrame.origin.x, self.cropFrame.origin.y);
        }
    }
    else
    {
        if (imageScaleSize.height == YVScaleImageHeight)
        {
            self.scrollViewOrigin = CGPointMake((self.oldFrame.size.width - YVScreenWidth)/2+self.cropFrame.origin.x, self.cropFrame.origin.y-64);
        }
        else
        {
            self.scrollViewOrigin = CGPointMake((self.oldFrame.size.width - YVScreenWidth)/2+self.cropFrame.origin.x, self.cropFrame.origin.y);
        }
    }
    //当图片视图的高度等于裁剪框高度时,禁止纵向滑动
    if(imageScaleSize.height == self.cropFrame.size.height)
    {
        self.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark 视图加载
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self calculateScaleImageFrame];
    [self SetUpScrollView];
    [self setUpImageView];
    [self setUpOverlayView];
    [self setUpCropperView];
    [self setNavigationControl];
    [self setUpOperationView];
}

#pragma mark - 初始化视图控件
//初始化导航栏视图
- (void)setNavigationControl
{
    UIView *navigationView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, YVScreenWidth, 64)];
    [navigationView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 32, 20, 20)];
    [backImageView setImage:[UIImage imageNamed:@"nav_back"]];
    [navigationView addSubview:backImageView];        
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(20, 20, 44, 44)];
    [backButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationView addSubview:backButton];
    [self.view addSubview:navigationView];
}

//初始化ScrollView
- (void)SetUpScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, YVScreenWidth, YVScaleImageHeight)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.userInteractionEnabled=YES;
    // 设置内容大小
    scrollView.contentSize = CGSizeMake(self.oldFrame.size.width+self.cropFrame.origin.x*2, (self.cropFrame.origin.y-64)*2);
    [scrollView setContentOffset:CGPointMake(self.scrollViewOrigin.x, self.scrollViewOrigin.y)];
    //是否可以滑动
    scrollView.scrollEnabled = YES;
    //回弹
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = NO;
    //是否分页
    scrollView.pagingEnabled = NO;
    // 是否滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    // 提示用户,Indicators flash
    [scrollView flashScrollIndicators];
    // 是否同时运动,lock
    scrollView.directionalLockEnabled = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = YES;
    //设置最大比例
    scrollView.maximumZoomScale = 2.0;
    //设置最小比例
    scrollView.minimumZoomScale = 1.0;
    
    [self.view addSubview:scrollView];
    _masterScrollView = scrollView;
}

//初始化图片展示视图
- (void)setUpImageView
{
    //加载ImageView的视图
    UIImageView *showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.cropFrame.origin.x, self.cropFrame.origin.y-64, self.oldFrame.size.width, self.oldFrame.size.height)];
    [showImageView setImage:self.originalImage];
    [showImageView setUserInteractionEnabled:YES];
    [showImageView setMultipleTouchEnabled:YES];
    self.showImageView = showImageView;
    UIView *parentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.oldFrame.size.width+self.cropFrame.origin.x*2, self.oldFrame.size.height+(self.cropFrame.origin.y-64)*2)];
    [parentView addSubview:showImageView];
    [self.masterScrollView addSubview:parentView];
    self.parentView = parentView;
}

//初始化覆盖视图
- (void)setUpOverlayView
{
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    overlayView.alpha = 0.5f;
    overlayView.backgroundColor = [UIColor blackColor];
    overlayView.userInteractionEnabled = NO;
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:overlayView];
    self.overlayView = overlayView;
}

//初始化裁剪框视图
- (void)setUpCropperView
{
    UIView *cropView = [[UIView alloc]initWithFrame:self.cropFrame];
    [cropView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cropView.layer setBorderWidth:1.0f];
    [cropView setAutoresizingMask:UIViewAutoresizingNone];
    [cropView setUserInteractionEnabled:NO];
    [self.view addSubview:cropView];
    self.cropperView = cropView;
    [self overlayClipping];
}

//修剪覆盖视图
- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.cropperView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.cropperView.frame.origin.x + self.cropperView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.cropperView.frame.origin.x - self.cropperView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.cropperView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.cropperView.frame.origin.y + self.cropperView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.cropperView.frame.origin.y + self.cropperView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

//初始化操作栏
- (void)setUpOperationView
{
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, YVScreenHeight-50, YVScreenHeight, 50)];
    [toolView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:toolView];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [cancelBtn setTitleColor:[UIColor colorWithRed:66.0/255 green:186.0/255 blue:239.0/255 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, 0, 100, 50)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRed:66.0/255 green:186.0/255 blue:239.0/255 alpha:1.0] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:confirmBtn];
    [self.view addSubview:toolView];
}

- (void)cancel:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(YVImageCropperViewControllerDelegate)])
    {
        [self.delegate imageCropperDidCancel:self];
    }
}

- (void)confirm:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(YVImageCropperViewControllerDelegate)])
    {
        NSDictionary *imageInfo = [self getSubImage];
        [self.delegate imageCropperController:self didFinishedWithImagePath:imageInfo[@"path"] andImage:imageInfo[@"picture"]];
    }
}

//修正图片的方向
- (UIImage *)fixOrientation:(UIImage *)srcImg
{
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    switch (srcImg.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取裁剪的图片
- (NSMutableDictionary *)getSubImage
{
    CGSize originalSize=self.originalImage.size;//获取原图的大小
    CGRect squareFrame = self.cropFrame;//裁剪框的frame
    CGFloat imagesScaleRatio = (originalSize.width/self.showImageView.frame.size.width);//获取原图与展示图的比例系数
    CGFloat x = self.scrollViewOrigin.x*imagesScaleRatio;//获取截取起点(横向点)
    CGFloat y = self.scrollViewOrigin.y*imagesScaleRatio;//获取截取起点(纵向点)
    CGFloat w = squareFrame.size.width*imagesScaleRatio;//获取截取宽度
    CGFloat h = squareFrame.size.height*imagesScaleRatio;//获取截取高度
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();

    //将裁剪的图片保存到沙盒中
    NSData* imageData = UIImagePNGRepresentation(smallImage);
    NSString *fileName = [self getCurrentTimeForImageName:@"CropImage"];
    NSString* fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    BOOL save = [imageData writeToFile:fullPath atomically:YES];
    NSMutableDictionary *imageInfos = [NSMutableDictionary dictionary];
    if (save) {
        [imageInfos setValue:fullPath forKey:@"path"];
        [imageInfos setValue:smallImage forKey:@"picture"];
        return imageInfos;
    }else{//保存失败则再保存一次
        [imageData writeToFile:fullPath atomically:YES];
        [imageInfos setValue:fullPath forKey:@"path"];
        [imageInfos setValue:smallImage forKey:@"picture"];
        return imageInfos;
    }
    return nil;
}

//获取当前时间进行图片的命名
- (NSString *)getCurrentTimeForImageName:(NSString *)customLabel
{
    //获取当前时间
    NSDate* currentDate = [NSDate date];
    SLog(@"%@",currentDate);
    
    //转换时间格式
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png",customLabel,currentDateString];
    return imageName;
}

#pragma mark 实现UIScrollView的代理
//当用户进行捏合手势的时候，它会询问代理需要对其中那一个控件 进行缩放
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.showImageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale < 1.0 && scrollView.contentOffset.y != 0)//设置当缩放比例小于1.0时,使图片永远保持在顶部
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    //重新设置ScrollView的contentSize(图片进行了缩放,所以其大小也改变了,ScrollView的contentSize需要适应新的图片的大小)
    scrollView.contentSize = CGSizeMake(self.oldFrame.size.width*scrollView.zoomScale+self.cropFrame.origin.x*2, self.oldFrame.size.height*scrollView.zoomScale+(self.cropFrame.origin.y-64)*2);
    self.scrollViewOrigin = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    self.lastFrame = self.showImageView.frame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale < 1.0 && scrollView.contentOffset.y != 0)//设置当缩放比例小于1.0时,使图片永远保持在顶部
    {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
    //重新设置ScrollView的contentSize(图片进行了缩放,所以其大小也改变了,ScrollView的contentSize需要适应新的图片的大小)
    scrollView.contentSize = CGSizeMake(self.oldFrame.size.width*scrollView.zoomScale+self.cropFrame.origin.x*2, self.oldFrame.size.height*scrollView.zoomScale+(self.cropFrame.origin.y-64)*2);
    self.scrollViewOrigin = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y);
    self.lastFrame = self.showImageView.frame;
}

- (void)dealloc
{
    SLog(@"dealloc");
    self.originalImage = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
