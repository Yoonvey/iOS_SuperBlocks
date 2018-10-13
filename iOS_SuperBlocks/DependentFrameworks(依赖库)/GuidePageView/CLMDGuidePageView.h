//
//  CLMDGuidePageView.h
//  iOS_SuperBlocks
//
//  Created by ModouTechnology on 16/9/18.
//  Copyright © 2016年 EdwinChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMDGuidePageView : UIView

-(instancetype)initPagesViewWithFrame:(CGRect)frame Images:(NSArray *)images;

@end

@interface CLMDGuidePageHelper : NSObject

+ (instancetype)shareInstance;

+(void)showGuidePageView:(NSArray *)imageArray;

@end
