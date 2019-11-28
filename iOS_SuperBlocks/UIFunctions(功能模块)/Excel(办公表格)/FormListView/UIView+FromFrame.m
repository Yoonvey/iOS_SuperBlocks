//
//  UIView+FromFrame.m
//  IOTUnitedPlatform
//
//  Created by Yoonvey on 2019/11/25.
//  Copyright © 2019 ModouTech. All rights reserved.
//

#import "UIView+FromFrame.h"

@implementation UIView (FromFrame)

-(CGFloat)form_x {
    return self.frame.origin.x;
}

-(void)setForm_x:(CGFloat)form_x {
    CGRect rect = self.frame;
    rect.origin.x = form_x;
    self.frame = rect;
}

-(CGFloat)form_y {
    return self.frame.origin.y;
}

-(void)setForm_y:(CGFloat)form_y {
    CGRect rect = self.frame;
    rect.origin.y = form_y;
    self.frame = rect;
}

-(CGFloat)form_width {
    return self.frame.size.width;
}

-(void)setForm_width:(CGFloat)form_width {
    CGRect rect = self.frame;
    rect.size.width = form_width;
    self.frame = rect;
}

-(CGFloat)form_height {
    return self.frame.size.height;
}

-(void)setForm_height:(CGFloat)form_height {
    CGRect rect = self.frame;
    rect.size.height = form_height;
    self.frame = rect;
}

-(CGFloat)form_centerX {
    return self.center.x;
}

-(void)setForm_centerX:(CGFloat)form_centerX {
    CGPoint center = self.center;
    center.x = form_centerX;
    self.center = center;
}

-(CGFloat)form_centerY {
    return self.center.y;
}

-(void)setForm_centerY:(CGFloat)form_centerY {
    CGPoint center = self.center;
    center.y = form_centerY;
    self.center = center;
}

- (void)setForm_size:(CGSize)form_size {
    CGRect frame = self.frame;
    frame.size = form_size;
    self.frame = frame;
}

- (CGSize)form_size {
    return self.frame.size;
}

- (void)setForm_top:(CGFloat)form_top {
    self.frame = CGRectMake(self.form_left, form_top, self.form_width, self.form_height);
}

- (CGFloat)form_top {
    return self.frame.origin.y;
}

- (void)setForm_bottom:(CGFloat)form_bottom {
    self.frame = CGRectMake(self.form_left, form_bottom - self.form_height, self.form_width, self.form_height);
}

- (CGFloat)form_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setForm_left:(CGFloat)form_left {
    self.frame = CGRectMake(form_left, self.form_top, self.form_width, self.form_height);
}

- (CGFloat)form_left {
    return self.frame.origin.x;
}

- (void)setForm_right:(CGFloat)form_right {
    self.frame = CGRectMake(form_right - self.form_width, self.form_top, self.form_width, self.form_height);
}

- (CGFloat)form_right {
    return self.frame.origin.x + self.frame.size.width;
}

@end
