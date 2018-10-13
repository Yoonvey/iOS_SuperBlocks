//
//  CLMDAdvertiseView.m
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/19.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import "CLMDAdvertiseView.h"
#define kAdScreenWidth         [UIScreen mainScreen].bounds.size.width
#define kAdScreenHeight        [UIScreen mainScreen].bounds.size.height
#define kAdMain_Screen_Bounds  [[UIScreen mainScreen] bounds]
#define kAdUserDefaults        [NSUserDefaults standardUserDefaults]
//广告图片存本地UserDefault的key
static NSString *const adImageName = @"adImageName";

@interface CLMDAdvertiseView ()
@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *countBtn;
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) int count;

@end

//广告显示的时间(秒)
static int const showtime = 3;
//广告页面点击跳转通知的key
static NSString* const NotificationContants_Advertise_Key=@"AdvertisePush";


@implementation CLMDAdvertiseView

- (NSTimer *)countTimer {
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
- (void)countDown {
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", _count] forState:UIControlStateNormal];
    if (_count == 0) {
        [self.countTimer invalidate];
        self.countTimer = nil;
        [self dismissAdView];
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        //点击广告界面
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdView)];
        [_adView addGestureRecognizer:tap];
        
        //点击跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(kAdScreenWidth - btnW-24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismissAdView) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.5];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
    }
    return self;
}
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (void)pushToAdView{
    
    [self dismissAdView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationContants_Advertise_Key object:nil userInfo:nil];
}

- (void)show {
    // 倒计时方法1：GCD
    //    [self startCoundown];
    
    // 倒计时方法2：定时器
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
// 定时器倒计时
- (void)startTimer {
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

// GCD倒计时
- (void)startCoundown {
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self dismissAdView];
                
            });
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//移除广告页
- (void)dismissAdView {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation CLMDAdvertiseHelper

+ (instancetype)sharedInstance {
    static CLMDAdvertiseHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CLMDAdvertiseHelper new];
    });
    return instance;
}

+ (void)showAdvertiseView:(NSArray *)imageArray {
    //判断沙盒中是否存放广告图片，如果存在，直接取用
    NSString *filePath = [[CLMDAdvertiseHelper sharedInstance] getFilePathWithImageName:[kAdUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [[CLMDAdvertiseHelper sharedInstance] isFileExistWithFilePath:filePath];
    
    if (isExist) {
        NSLog(@"用老图片");
        CLMDAdvertiseView *advertiseView = [[CLMDAdvertiseView alloc] initWithFrame:kAdMain_Screen_Bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
    }
    
    //无论沙盒中时候存在广告图片，都要重新获取广告图片
    [[CLMDAdvertiseHelper sharedInstance] getAdvertiseImage:imageArray];
}
/**
 *  获取广告图片
 */
- (void)getAdvertiseImage:(NSArray *)imageArray {
    //随机取用一张
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    //取文件名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    //拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist) {
        //如果图片不存在，则删除旧照片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
}

/**
 *  根据图片文件名，拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}


/**
 *  判断图片文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDictionary = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDictionary];
}


/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl
                     imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            NSLog(@"新广告图片保存成功");
            [self deleteOldImage];
            [kAdUserDefaults setValue:imageName forKey:adImageName];
            [kAdUserDefaults synchronize];
            //如果附带广告链接，也保存下来
        } else {
            NSLog(@"新广告图片保存失败");
        }
    });
}
/**
 *  删除旧照片
 */
- (void)deleteOldImage {
    NSString *imageName = [kAdUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}



@end
