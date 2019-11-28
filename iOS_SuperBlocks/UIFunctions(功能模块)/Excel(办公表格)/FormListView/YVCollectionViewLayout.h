//
//  YVCollectionViewLayout.h
//  YVFormListView
//
//  Created by Yoonvey on 2019/11/23.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YVCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionInset; //设置内边距

@end

NS_ASSUME_NONNULL_END
