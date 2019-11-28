//
//  YVFormListView.h
//  YVFormListView
//
//  Created by Yoonvey on 2019/11/23.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YVFormListDataSource <NSObject>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface YVFormListView : UIView

@property (nonatomic, strong) UIColor *titleBGColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, weak) id<YVFormListDataSource> dataSource;

@property (nonatomic, assign) CGFloat topMenuHeight;
@property (nonatomic, strong) UIColor *topMenuBGColor;
@property (nonatomic, strong) NSArray <NSString *>* topMenus;
@property (nonatomic, strong) UIFont *topMenuTitleFont;
@property (nonatomic, strong) UIColor *topMenuTitleColor;

@property (nonatomic, assign) CGFloat sideMenuHeight;
@property (nonatomic, strong) UIColor *sideMenuBGColor;
@property (nonatomic, strong) NSArray <NSString *>* sideMenus;
@property (nonatomic, strong) UIFont *sideMenuTitleFont;
@property (nonatomic, strong) UIColor *sideMenuTitleColor;

@property (nonatomic, assign) CGFloat itemForSideMultiply;// item相对于side的高度比例，默认1.0
@property (nonatomic, assign, readonly) CGSize itemSize;

@property (nonatomic, strong) NSArray * dataSources;

- (instancetype)initWithFrame:(CGRect)frame topMenus:(NSArray <NSString *>*)topMenus sideMenus:(NSArray <NSString *>*)sideMenus;
- (void)registerCustomCell:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
