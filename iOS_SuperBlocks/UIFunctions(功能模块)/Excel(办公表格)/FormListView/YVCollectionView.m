//
//  YVCollectionView.m
//  YVFormListView
//
//  Created by Yoonvey on 2019/11/23.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import "YVCollectionView.h"

@interface YVCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation YVCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = kTitleFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

@end

@interface YVCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout * layout;

@end

static NSString * ChartMenuItemCellIdfy = @"ChartMenuItemCellIdfy";

@implementation YVCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:self.layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.allowsSelection = NO;
        self.backgroundColor = kLineColor;
        self.bounces = false;
        self.showsVerticalScrollIndicator = false;
        self.showsHorizontalScrollIndicator = false;
        [self registerClass:YVCollectionViewCell.class forCellWithReuseIdentifier:ChartMenuItemCellIdfy];
    }
    return self;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = kLineWidth;
        _layout.minimumInteritemSpacing = kLineWidth;
        _layout.sectionInset = UIEdgeInsetsMake(kLineWidth, kLineWidth, kLineWidth, kLineWidth);
    }
    return _layout;
}

#pragma mark -
- (void)setMenus:(NSArray<NSString *> *)menus {
    if (nil != menus) {
        _menus = menus;
        [self reloadData];
    }
}

#pragma mark - UICollectionView M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _menus.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YVCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChartMenuItemCellIdfy forIndexPath:indexPath];
    cell.backgroundColor = self.itemBGColor ? self.itemBGColor : [UIColor whiteColor];
    cell.titleLabel.textColor = self.itemTitleColor ? self.itemTitleColor : [UIColor blackColor];
    cell.titleLabel.text = _menus[indexPath.item];
    cell.titleLabel.font = self.titleFont ? self.titleFont : kTitleFont; 
    return cell;
}

@end
