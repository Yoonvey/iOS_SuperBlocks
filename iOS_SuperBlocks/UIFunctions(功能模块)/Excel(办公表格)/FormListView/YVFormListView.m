//
//  YVFormListView.m
//  YVFormListView
//
//  Created by Yoonvey on 2019/11/23.
//  Copyright © 2019 Yoonvey. All rights reserved.
//

#import "YVFormListView.h"

#import "YVCollectionViewLayout.h"
#import "YVCollectionView.h"

#import "UIView+FromFrame.h"

@interface YVFormViewCell : UICollectionViewCell

@end

@implementation YVFormViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end

@interface YVFormListView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UICollectionView * contentView;
@property (nonatomic, strong) YVCollectionViewLayout * layout;
@property (nonatomic, strong) YVCollectionView * topMenuBar;
@property (nonatomic, strong) YVCollectionView * sideMenuBar;
@property (nonatomic, assign) CGFloat topMenuWidth;
@property (nonatomic, assign) CGFloat sideMenuWidth;
@property (nonatomic, assign, readwrite) CGSize itemSize;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) BOOL shouldChangeMenuOffset;
@property (nonatomic, assign) BOOL shouldChangeChartViewOffset;

@property (nonatomic, strong) UILabel * leftCornerLabel;

@end

static void *FormViewConstentOffsetContext  = &FormViewConstentOffsetContext;
static void *TopMenuConstentOffsetContext    = &TopMenuConstentOffsetContext;
static void *SideMenuConstentOffsetContext   = &SideMenuConstentOffsetContext;
static NSString * ChartViewCellIdfy = @"ChartViewCellIdfy";

@implementation YVFormListView

- (void)dealloc {
    [_topMenuBar removeObserver:self forKeyPath:@"contentOffset"];
    [_sideMenuBar removeObserver:self forKeyPath:@"contentOffset"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.topMenuHeight = 30.f;
    self.sideMenuHeight = 30.f;
    self.itemForSideMultiply = 1.0;
    self.shouldChangeMenuOffset = YES;
    self.shouldChangeChartViewOffset = YES;
    [self setupViews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame topMenus:(NSArray <NSString *>*)topMenus sideMenus:(NSArray <NSString *>*)sideMenus {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.topMenuHeight = 30.f;
    self.sideMenuHeight = 30.f;
    self.itemForSideMultiply = 1.0;
    self.topMenus = topMenus;
    self.sideMenus = sideMenus;
    self.shouldChangeMenuOffset = YES;
    self.shouldChangeChartViewOffset = YES;
    [self setupViews];
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    _topMenuWidth = [self getMaxWidthFrom:_topMenus maxHeight:self.topMenuHeight];
    _sideMenuWidth = [self getMaxWidthFrom:_sideMenus maxHeight:self.sideMenuHeight];
    CGFloat itemWidth = _topMenuWidth;
    // container
    self.containerView = ({
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        view;
    });
    // list
    self.contentView = ({
        self.layout.itemSize = CGSizeMake(itemWidth, self.sideMenuHeight);
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:_containerView.bounds collectionViewLayout:self.layout];
        collectionView.backgroundColor = kLineColor;
        collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        collectionView.contentInset = UIEdgeInsetsMake(self.topMenuHeight + 2 *kLineWidth, _sideMenuWidth + 2 *kLineWidth, 0, 0);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.showsVerticalScrollIndicator = false;
        collectionView.showsHorizontalScrollIndicator = false;
        [collectionView registerClass:YVFormViewCell.class forCellWithReuseIdentifier:ChartViewCellIdfy];
        [collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:FormViewConstentOffsetContext];
        collectionView;
    });
    
    // left corner view
    UIView * leftCornerBgView = [UIView new];
    leftCornerBgView.tag = 500;
    leftCornerBgView.backgroundColor = kLineColor;
    leftCornerBgView.clipsToBounds = YES;
    UILabel * leftCornerLabel = [UILabel new];
    leftCornerLabel.backgroundColor = [UIColor whiteColor];
    leftCornerLabel.font = [UIFont systemFontOfSize:15.f];
    leftCornerLabel.textAlignment = NSTextAlignmentCenter;
    leftCornerLabel.form_top = kLineWidth;
    leftCornerLabel.form_left = kLineWidth;
    [leftCornerBgView addSubview:leftCornerLabel];
    _leftCornerLabel = leftCornerLabel;
    
    // top menu
    self.topMenuBar = ({
        YVCollectionView* topMenu = [YVCollectionView new];
        topMenu.form_size = CGSizeMake(self.form_width - leftCornerBgView.form_right , self.topMenuHeight + 2 *kLineWidth);
        topMenu.form_top = 0;
        topMenu.form_left = leftCornerLabel.form_right + kLineWidth;
        topMenu.contentInset = UIEdgeInsetsZero;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)topMenu.collectionViewLayout;
        layout.itemSize = CGSizeMake(_topMenuWidth, self.topMenuHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(kLineWidth, 0, kLineWidth, kLineWidth);
        [topMenu addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:TopMenuConstentOffsetContext];
        [topMenu setMenus:_topMenus];
        topMenu;
    });
    
    // side menu
    self.sideMenuBar = ({
        YVCollectionView * sideMenu = [YVCollectionView new];
        sideMenu.form_size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, self.form_height - leftCornerBgView.form_bottom);
        sideMenu.form_top = leftCornerLabel.form_bottom + kLineWidth;
        sideMenu.form_left = 0;
        sideMenu.contentInset = UIEdgeInsetsZero;
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)sideMenu.collectionViewLayout;
        layout.itemSize = CGSizeMake(_sideMenuWidth, self.sideMenuHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, kLineWidth, kLineWidth, kLineWidth);
        [sideMenu addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:SideMenuConstentOffsetContext];
        [sideMenu setMenus:_sideMenus];
        sideMenu;
    });
    
    [self addSubview:_containerView];
    [_containerView addSubview:_contentView];
    [_containerView addSubview:leftCornerBgView];
    [_containerView addSubview:_topMenuBar];
    [_containerView addSubview:_sideMenuBar];
}

- (YVCollectionViewLayout *)layout {
    if (!_layout) {
        self.layout = [[YVCollectionViewLayout alloc]init];
        _layout.minimumLineSpacing = kLineWidth;
        _layout.minimumInteritemSpacing = kLineWidth;
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, kLineWidth, kLineWidth);
    }
    return _layout;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // list
    _contentView.contentInset = UIEdgeInsetsMake(self.topMenuHeight + 2 *kLineWidth, _sideMenuWidth + 2 *kLineWidth, 0, 0);
    // left corner view
    UIView * leftCornerBgView = [self viewWithTag:500];
    UILabel * leftCornerLabel = [[leftCornerBgView subviews]lastObject];
    _leftCornerLabel = leftCornerLabel;
    if (_sideMenuWidth > 0) {
        leftCornerBgView.form_size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, self.topMenuHeight + 2 *kLineWidth);
        leftCornerLabel.form_size = CGSizeMake(_sideMenuWidth, self.topMenuHeight);
    }else {
        leftCornerBgView.form_size = CGSizeZero;
    }
    // top menu
    _topMenuBar.form_size = CGSizeMake(self.form_width - (leftCornerLabel.form_right + kLineWidth) , self.topMenuHeight + 2 *kLineWidth);
    _topMenuBar.form_left = leftCornerBgView.form_right;
    UICollectionViewFlowLayout * t_layout = (UICollectionViewFlowLayout *)_topMenuBar.collectionViewLayout;
    CGFloat topMenuMaxWidth = (_topMenuWidth + kLineWidth)*_topMenus.count;
    if (topMenuMaxWidth < _topMenuBar.form_width && _sideMenuWidth > 0) {
        _topMenuWidth = (_topMenuBar.form_width)/_topMenus.count-kLineWidth;
        _topMenuWidth = round(_topMenuWidth);
    }
    t_layout.itemSize = CGSizeMake(_topMenuWidth, self.topMenuHeight);
    _layout.itemSize = CGSizeMake(_topMenuWidth, self.itemHeight);
    _itemSize = CGSizeMake(_topMenuWidth, self.itemHeight);
    
    // side menu
    _sideMenuBar.form_size = CGSizeMake(_sideMenuWidth + 2 *kLineWidth, self.form_height - (leftCornerLabel.form_bottom + kLineWidth));
    _sideMenuBar.form_top = leftCornerBgView.form_bottom;
    UICollectionViewFlowLayout * s_layout = (UICollectionViewFlowLayout *)_sideMenuBar.collectionViewLayout;
    s_layout.itemSize = CGSizeMake(_sideMenuWidth, self.sideMenuHeight);
    
    // container
    CGFloat height = (self.sideMenuHeight + kLineWidth) * _sideMenus.count * 1;
    CGFloat width  = (_topMenuWidth + kLineWidth) * _topMenus.count;
    height += _sideMenuWidth > 0?self.topMenuHeight + 2 *kLineWidth:0;
    width  += _topMenuWidth > 0?leftCornerBgView.form_width:0;
    height  = MIN(height, self.form_height);
    width   = MIN(width, self.form_width);
    _containerView.form_size = CGSizeMake(width, height);
}

#pragma mark -
- (void)setTitle:(NSString *)title {
    _title = title;
    _leftCornerLabel.text = title;
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _leftCornerLabel.font = titleFont;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _leftCornerLabel.textColor = titleColor;
}
- (void)setTitleBGColor:(UIColor *)titleBGColor {
    _titleBGColor = titleBGColor;
    _leftCornerLabel.backgroundColor = titleBGColor;
}

- (void)setTopMenus:(NSArray<NSString *> *)topMenus {
    if (nil != topMenus) {
        _topMenus = topMenus;
        _topMenuWidth = [self getMaxWidthFrom:_topMenus maxHeight:self.topMenuHeight];
        _layout.itemSize = CGSizeMake(_topMenuWidth, self.itemHeight);
        _itemSize = CGSizeMake(_topMenuWidth, self.itemHeight);
        [_topMenuBar setMenus:_topMenus];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [_contentView reloadData];
        [self adjustContentOffset];
    }
}
- (void)setTopMenuBGColor:(UIColor *)topMenuBGColor {
    _topMenuBGColor = topMenuBGColor;
    _topMenuBar.itemBGColor = topMenuBGColor;
}
- (void)setTopMenuTitleColor:(UIColor *)topMenuTitleColor {
    _topMenuTitleColor = topMenuTitleColor;
    _topMenuBar.itemTitleColor = topMenuTitleColor;
}
- (void)setTopMenuTitleFont:(UIFont *)topMenuTitleFont {
    _topMenuTitleFont = topMenuTitleFont;
    _topMenuBar.titleFont = topMenuTitleFont;
}

- (void)setSideMenus:(NSArray<NSString *> *)sideMenus {
    if (nil != sideMenus) {
        _sideMenus = sideMenus;
        _sideMenuWidth = [self getMaxWidthFrom:_sideMenus maxHeight:self.sideMenuHeight];
        [_sideMenuBar setMenus:_sideMenus];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [_contentView reloadData];
        [self adjustContentOffset];
    }
}
- (void)setSideMenuBGColor:(UIColor *)sideMenuBGColor {
    _sideMenuBGColor = sideMenuBGColor;
    _sideMenuBar.itemBGColor = sideMenuBGColor;
}
- (void)setSideMenuTitleColor:(UIColor *)sideMenuTitleColor {
    _sideMenuTitleColor = sideMenuTitleColor;
    _sideMenuBar.itemTitleColor = sideMenuTitleColor;
}
- (void)setSideMenuTitleFont:(UIFont *)sideMenuTitleFont {
    _sideMenuTitleFont = sideMenuTitleFont;
    _sideMenuBar.titleFont = sideMenuTitleFont;
}
- (void)setSideMenuHeight:(CGFloat)sideMenuHeight {
    _sideMenuHeight = sideMenuHeight;
    if (self.itemForSideMultiply != 0) {
        _itemHeight = (sideMenuHeight - (1/self.itemForSideMultiply-1)*kLineWidth)*self.itemForSideMultiply;
    }
}

- (void)setItemForSideMultiply:(CGFloat)itemForSideMultiply {
    if (itemForSideMultiply > 1) {
        itemForSideMultiply = 1;
    }
    _itemForSideMultiply = itemForSideMultiply;
    _itemHeight = (self.sideMenuHeight - (1/itemForSideMultiply-1)*kLineWidth)*itemForSideMultiply;
}

- (void)setDataSources:(NSArray *)dataSources {
    if (nil != dataSources) {
        _dataSources = dataSources;
        [_contentView reloadData];
    }
}

- (void)registerCustomCell:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    if (cellClass && identifier.length != 0) {
        [_contentView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    }
}

- (CGFloat)getMaxWidthFrom:(NSArray <NSString *>*)menus maxHeight:(CGFloat)maxHeight{
    if (menus.count <= 0) {
        return 0;
    }
    [menus sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"length" ascending:YES]]];
    CGFloat paddingInsert = 8;
    CGFloat width = [[menus lastObject] boundingRectWithSize:CGSizeMake(MAXFLOAT, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kTitleFont} context:nil].size.width;
    width += 2 *paddingInsert;
    width  = roundf(width);
    return width;
}


- (void)adjustContentOffset {
    
    CGPoint contentOffset = _contentView.contentOffset;
    contentOffset.x = - (_sideMenuWidth + 2 *kLineWidth);
    contentOffset.y = - (self.topMenuHeight + 2 *kLineWidth);
    _shouldChangeChartViewOffset = false;
    _contentView.contentOffset   = contentOffset;
    _shouldChangeChartViewOffset = true;
    
    _shouldChangeMenuOffset    = false;
    _topMenuBar.contentOffset  = CGPointZero;
    _sideMenuBar.contentOffset = CGPointZero;
    _shouldChangeMenuOffset    = true;
}

#pragma mark - UICollectionView M

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _topMenus.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource && [_dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [_dataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    YVFormViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChartViewCellIdfy forIndexPath:indexPath];
    @try {
        UIColor * color = _dataSources[indexPath.section][indexPath.item];
        if (color) {
            cell.backgroundColor = color;
        }else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    } @catch (NSException *exception) {}
    
    return cell;
}

#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (_shouldChangeChartViewOffset) {
        if (context == FormViewConstentOffsetContext) {
            
            CGPoint contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_x = contentOffsetN.x - contentOffsetO.x;
            CGFloat delt_y = contentOffsetN.y - contentOffsetO.y;
            
            CGPoint topbar_contentOffset  = _topMenuBar.contentOffset;
            CGPoint sidebar_contentOffset = _sideMenuBar.contentOffset;
            topbar_contentOffset.x  += delt_x;
            sidebar_contentOffset.y += delt_y;
            
            _shouldChangeMenuOffset = false;
            _topMenuBar.contentOffset  = topbar_contentOffset;
            _sideMenuBar.contentOffset = sidebar_contentOffset;
            _shouldChangeMenuOffset = true;
        }
    }
    
    if (_shouldChangeMenuOffset) {
        if (context == TopMenuConstentOffsetContext) {
            
            CGPoint topbar_contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint topbar_contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_x = topbar_contentOffsetN.x - topbar_contentOffsetO.x;
            
            CGPoint content_contentOffset = _contentView.contentOffset;
            content_contentOffset.x += delt_x;
            _shouldChangeChartViewOffset = false;
            _contentView.contentOffset = content_contentOffset;
            _shouldChangeChartViewOffset = true;
            
        }
        if (context == SideMenuConstentOffsetContext) {
            
            CGPoint sidebar_contentOffsetN  = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint sidebar_contentOffsetO  = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat delt_y = sidebar_contentOffsetN.y - sidebar_contentOffsetO.y;
            
            CGPoint content_contentOffset = _contentView.contentOffset;
            content_contentOffset.y += delt_y;
            _shouldChangeChartViewOffset = false;
            _contentView.contentOffset = content_contentOffset;
            _shouldChangeChartViewOffset = true;
            
        }
    }
}


@end
