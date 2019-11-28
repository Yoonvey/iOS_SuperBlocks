//
//  YVCollectionView.h
//  YVFormListView
//
//  Created by Yoonvey on 2019/11/23.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTitleFont     [UIFont systemFontOfSize:15]
#define kLineColor     [UIColor blackColor]
#define kLineWidth     1.0f

NS_ASSUME_NONNULL_BEGIN

@interface YVCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <NSString *>* menus;
@property (nonatomic, strong) UIColor *itemBGColor;
@property (nonatomic, strong) UIColor *itemTitleColor;
@property (nonatomic, strong) UIFont *titleFont;

@end

NS_ASSUME_NONNULL_END
