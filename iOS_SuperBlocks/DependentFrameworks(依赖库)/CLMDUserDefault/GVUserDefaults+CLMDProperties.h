//
//  GVUserDefaults+CLMDProperties.h
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/18.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import "GVUserDefaults.h"

#define CLMDUserDefault [GVUserDefaults standardUserDefaults]

@interface GVUserDefaults (CLMDProperties)



#pragma mark --是否是第一次启动APP程序
@property (nonatomic,assign) BOOL isNoFirstLaunch;
/** app版本号 */
@property (nonnull, strong)NSString *app_Version;
@end
