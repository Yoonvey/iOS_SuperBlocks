//
//  UITableHeaderView.m
//  MDSmartHouseHoldLock
//
//  Created by Yoonvey on 2018/6/25.
//  Copyright © 2018年 Yoonvey. All rights reserved.
//

#import "UITableHeaderView.h"

#pragma mark - <UITableHeaderView>
@interface UITableHeaderView ()

@property (nonatomic) BOOL suspension;

@end

@implementation UITableHeaderView

#pragma mark 初始化方法
- (instancetype)initWithFrame:(CGRect)frame suspension:(BOOL)suspension
{
    self = [super init];
    if (self)
    {
        self.suspension = suspension;
        self.frame = frame;
    }
    return self;
}

- (UITableHeaderButton *)actionButton
{
    if (!_actionButton)
    {
        _actionButton = [UITableHeaderButton buttonWithType:UIButtonTypeCustom];
        _actionButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _actionButton.adjustsImageWhenHighlighted = NO;
        [self addSubview:_actionButton];
    }
    return _actionButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self insertSubview:_titleLabel atIndex:0];
    }
    return _titleLabel;
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
