//
//  YVImageCropperViewController.h
//  YVImageCropperViewControllerDemo
//
//  Created by 周荣飞 on 17/2/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YVImageCropperViewController;
@protocol YVImageCropperViewControllerDelegate <NSObject>

- (void)imageCropperController:(YVImageCropperViewController *)cropperViewController
      didFinishedWithImagePath:(NSString *)imagePath
                         andImage:(UIImage *)image;
- (void)imageCropperDidCancel:(YVImageCropperViewController *)cropperViewController;

@end

@interface YVImageCropperViewController : UIViewController

@property (nonatomic, assign) id<YVImageCropperViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)originalImage cropperSize:(CGSize)cropperSize;

@end
