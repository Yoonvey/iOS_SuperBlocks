//
//  UITableHeaderView.m
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "UITableHeaderView.h"

#pragma mark - <UITableHeaderView>
@implementation UITableHeaderView

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame suspension:(BOOL)suspension
{
    self = [super init];
    if (self)
    {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.suspension = suspension;
        self.frame = frame;
    }
    return self;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 32.f);
    }
    return self;
}

- (UITableHeaderButton *)actionButton
{
    if (!_actionButton)
    {
        [super layoutSubviews];
        _actionButton = [UITableHeaderButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_actionButton];
    }
    return _actionButton;
}

- (UITableHeaderLabel *)titleLabel
{
    if (!_titleLabel)
    {
        [super layoutSubviews];
        _titleLabel = [[UITableHeaderLabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self insertSubview:_titleLabel atIndex:0];
    }
    return _titleLabel;
}

/// 分割线实例化
- (UILabel *)topSeparatorLine
{
    if (!_topSeparatorLine)
    {
        [super layoutSubviews];
        _topSeparatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.3)];
        _topSeparatorLine.layer.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0].CGColor;
        [self addSubview:_topSeparatorLine];
    }
    return _topSeparatorLine;
}

- (UILabel *)bottomSeparatorLine
{
    if (!_bottomSeparatorLine)
    {
        [super layoutSubviews];
        _bottomSeparatorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.3, self.frame.size.width, 0.3)];
        _bottomSeparatorLine.layer.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0].CGColor;
        [self addSubview:_bottomSeparatorLine];
    }
    return _bottomSeparatorLine;
}

#pragma mark Setter for self
//重写View的属性
- (void)setFrame:(CGRect)frame
{
    if (!self.suspension)
    {
        CGRect sectionRect = [self.tableView rectForSection:self.section];
        CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
        [super setFrame:newFrame];
    }
    else
    {
        [super setFrame:frame];
    }
}

- (void)setTopSeparator:(BOOL)topSeparator
{
    _topSeparator = topSeparator;
    if (topSeparator)
    {
        [self topSeparatorLine];
    }
    else if(_topSeparatorLine)
    {
        [_topSeparatorLine removeFromSuperview];
        _topSeparatorLine = nil;
    }
}

/// 权限
- (void)setBottomSeparator:(BOOL)bottomSeparator
{
    _bottomSeparator = bottomSeparator;
    if (bottomSeparator)
    {
        [self bottomSeparatorLine];
    }
    else if(_bottomSeparatorLine)
    {
        [_bottomSeparatorLine removeFromSuperview];
        _bottomSeparatorLine = nil;
    }
}

/// 分割线颜色
- (void)setTopSeparatorColor:(UIColor *)topSeparatorColor
{
    _topSeparatorColor = topSeparatorColor;
    if (_topSeparatorLine)
    {
        _topSeparatorLine.layer.backgroundColor = topSeparatorColor.CGColor;
    }
}

- (void)setBottomSeparatorColor:(UIColor *)bottomSeparatorColor
{
    _bottomSeparatorColor = bottomSeparatorColor;
    if (_bottomSeparatorLine)
    {
        _bottomSeparatorLine.layer.backgroundColor = bottomSeparatorColor.CGColor;
    }
}

/// 分割线约束设置
- (void)setTopSeparatorInsets:(UIEdgeInsets)topSeparatorInsets
{
    _topSeparatorInsets = topSeparatorInsets;
    if (_topSeparatorLine)
    {
        CGRect rect = _topSeparatorLine.frame;
        _topSeparatorLine.frame = CGRectMake(rect.origin.x + topSeparatorInsets.left, rect.origin.y + topSeparatorInsets.top, rect.size.width - topSeparatorInsets.left - topSeparatorInsets.right, rect.size.height);
    }
}

- (void)setBottomSeparatorInsets:(UIEdgeInsets)bottomSeparatorInsets
{
    _bottomSeparatorInsets = bottomSeparatorInsets;
    if (_bottomSeparatorLine)
    {
        CGRect rect = _bottomSeparatorLine.frame;
        _bottomSeparatorLine.frame = CGRectMake(rect.origin.x + bottomSeparatorInsets.left, rect.origin.y + bottomSeparatorInsets.top, rect.size.width - bottomSeparatorInsets.left - bottomSeparatorInsets.right, rect.size.height);
    }
}

#pragma mark Setter for title
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setTitleSize:(CGFloat)titleSize
{
    _titleSize = titleSize;
    self.titleLabel.font = [UIFont systemFontOfSize:titleSize];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment
{
    _titleAlignment = titleAlignment;
    self.titleLabel.textAlignment = titleAlignment;
}

#pragma mark Setter for button
- (void)setNormalImage:(UIImage *)normalImage
{
    _normalImage = normalImage;
    [self.actionButton setImage:normalImage forState:UIControlStateNormal];
}

- (void)setHightlightedImage:(UIImage *)hightlightedImage
{
    _hightlightedImage = hightlightedImage;
    [self.actionButton setImage:hightlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    _selectedImage = selectedImage;
    [self.actionButton setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setRightMargin:(CGFloat)rightMargin
{
    _rightMargin = rightMargin;
    self.actionButton.rightMargin = rightMargin;
}

@end

#pragma mark - <UITableHeaderButton>
@implementation UITableHeaderButton

- (CGRect)imageRectForContentRect:(CGRect)bounds
{
    return CGRectMake(self.frame.size.width-self.currentImage.size.width - self.rightMargin, (self.frame.size.height - self.currentImage.size.height)*0.5, self.currentImage.size.width, self.currentImage.size.height);
}

@end

#pragma mark - <UITableHeaderLabel>
@implementation UITableHeaderLabel

- (instancetype)init
{
    if (self = [super init])
    {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
