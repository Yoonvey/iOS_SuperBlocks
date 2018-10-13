//
//  CLMDAdvertiseView.h
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/19.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMDAdvertiseView : UIView
/**
 *  广告页图片路径
 */
@property (nonatomic, strong) NSString *filePath;

/**
 *  显示广告页
 */
- (void)show;


@end

/**
 *  处理事件在AdvertiseView里面有个NotificationContants_Advertise_Key通知，可以在首页进行获取通知，然后进行处理，比如进行跳转功能
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:NotificationContants_Advertise_Key object:nil];
 */
@interface CLMDAdvertiseHelper : NSObject

+ (instancetype)sharedInstance;

+ (void)showAdvertiseView:(NSArray *)imageArray;

@end
