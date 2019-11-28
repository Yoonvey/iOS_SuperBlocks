//
//  UIView+FromFrame.h
//  IOTUnitedPlatform
//
//  Created by Yoonvey on 2019/11/25.
//  Copyright © 2019 ModouTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (FromFrame)

@property (nonatomic, assign) CGFloat form_x;
@property (nonatomic, assign) CGFloat form_y;
@property (nonatomic, assign) CGFloat form_width;
@property (nonatomic, assign) CGFloat form_height;
@property (nonatomic, assign) CGFloat form_centerX;
@property (nonatomic, assign) CGFloat form_centerY;
@property (nonatomic, assign) CGSize form_size;
@property (nonatomic, assign) CGFloat form_top;
@property (nonatomic, assign) CGFloat form_bottom;
@property (nonatomic, assign) CGFloat form_left;
@property (nonatomic, assign) CGFloat form_right;

@end

NS_ASSUME_NONNULL_END
