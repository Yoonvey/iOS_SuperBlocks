//
//  ExcelViewController.h
//  iOS_SuperBlocks
//
//  Created by Yoonvey on 2019/11/28.
//  Copyright © 2019 EdwinChen. All rights reserved.
//

#import "UIBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExcelViewController : UIBaseViewController

@end

@interface CustomCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *value;

- (void)sizeForValue:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
