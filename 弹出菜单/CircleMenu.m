//
//  CircleMenu.m
//  弹出菜单
//
//  Created by caokun on 16/8/6.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import "CircleMenu.h"

@interface CircleMenu ()

@property (assign, nonatomic) CGRect mainFrame;
@property (assign, nonatomic) CGSize mainSize;
@property (assign, nonatomic) CGSize bigSize;
@property (strong, nonatomic) CAShapeLayer *bottomLayer;
@property (strong, nonatomic) UIBezierPath *startPath;
@property (strong, nonatomic) UIBezierPath *endPath;
@property (strong, nonatomic) CABasicAnimation *showAnimation;
@property (strong, nonatomic) CABasicAnimation *hideAnimation;
@property (strong, nonatomic) UIImageView *showImageView;
@property (strong, nonatomic) UIButton *showButton;
@property (strong, nonatomic) UIButton *button1;
@property (strong, nonatomic) UIButton *button2;
@property (strong, nonatomic) UILabel *titleLabel1;
@property (strong, nonatomic) UILabel *titleLabel2;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation CircleMenu

- (instancetype)init {
    if (self = [super init]) {
        self.mainSize = CGSizeMake(40, 40);
        self.bigSize = CGSizeMake(170, 65);
        self.mainFrame = CGRectMake(0, 0, 170, 65);
        [self myInit];
    }
    return self;
}

// 强制设为 40 * 40 的大小
- (instancetype)initWithFrame:(CGRect)frame {
    self.mainSize = CGSizeMake(40, 40);
    self.bigSize = CGSizeMake(170, 65);
    frame.size = self.bigSize;
    frame.origin.y -= (self.bigSize.height - self.mainSize.height);
    self.mainFrame = frame;
    if (self = [super initWithFrame:self.mainFrame]) {
        [self myInit];
    }
    return self;
}

- (UIImageView *)showImageView {
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bigSize.height - self.mainSize.height + 10, 20, 20)];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.backgroundColor = [UIColor clearColor];
    }
    return _showImageView;
}

- (UIBezierPath *)startPath {
    if (_startPath == nil) {
        CGFloat width = self.mainSize.width;
        CGFloat height = self.mainSize.height;
        _startPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, self.bigSize.height - height, width, height) cornerRadius:width * 0.5];
    }
    return _startPath;
}

- (UIBezierPath *)endPath {
    if (_endPath == nil) {
        CGFloat height_2 = self.bigSize.height * 0.5;
        _endPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:height_2];
    }
    return _endPath;
}

- (CABasicAnimation *)showAnimation {
    if (_showAnimation == nil) {
        _showAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        _showAnimation.fromValue = (id)self.startPath.CGPath;
        _showAnimation.toValue = (id)self.endPath.CGPath;
        _showAnimation.duration = 0.15;
        _showAnimation.fillMode = kCAFillModeForwards;
        _showAnimation.removedOnCompletion = NO;
    }
    return _showAnimation;
}

- (CABasicAnimation *)hideAnimation {
    if (_hideAnimation == nil) {
        _hideAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        _hideAnimation.fromValue = (id)self.endPath.CGPath;
        _hideAnimation.toValue = (id)self.startPath.CGPath;
        _hideAnimation.duration = 0.15;
        _hideAnimation.fillMode = kCAFillModeForwards;
        _hideAnimation.removedOnCompletion = NO;
    }
    return _hideAnimation;
}

- (CAShapeLayer *)bottomLayer {
    if (_bottomLayer == nil) {
        _bottomLayer = [CAShapeLayer layer];
        _bottomLayer.frame = self.bounds;
        _bottomLayer.fillColor = self.bgColor.CGColor;
        _bottomLayer.strokeStart = 0.0;
        _bottomLayer.strokeEnd = 1.0;
        _bottomLayer.path = self.startPath.CGPath;
    }
    return _bottomLayer;
}

- (UIButton *)showButton {
    if (_showButton == nil) {
        _showButton = [[UIButton alloc] init];
        _showButton.frame = CGRectMake(0, self.bigSize.height - self.mainSize.height, self.mainSize.width, self.mainSize.height);
        _showButton.layer.cornerRadius = self.mainSize.width * 0.5;
        _showButton.layer.masksToBounds = true;
        [_showButton addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}

- (UIButton *)button1 {
    if (_button1 == nil) {
        _button1 = [[UIButton alloc] init];
        _button1.frame = CGRectMake(0, 0, self.bigSize.width * 0.5, self.self.bigSize.height);
        _button1.layer.cornerRadius = self.bigSize.height * 0.5;
        _button1.layer.masksToBounds = true;
        _button1.hidden = true;
        [_button1 addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (_button2 == nil) {
        _button2 = [[UIButton alloc] init];
        _button2.frame = CGRectMake(self.bigSize.width * 0.5, 0, self.bigSize.width * 0.5, self.bigSize.height);
        _button2.layer.cornerRadius = self.bigSize.height * 0.5;
        _button2.layer.masksToBounds = true;
        _button2.hidden = true;
        [_button2 addTarget:self action:@selector(hideButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (void)showButtonAction:(id)sender {
    [self show];
}

- (void)hideButtonAction:(UIButton *)sender {
    [self hide];
    
    if ([sender isEqual:self.button1]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAtIndex:)]) {
            [self.delegate didClickAtIndex:0];
        }
        return ;
    }
    if ([sender isEqual:self.button2]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAtIndex:)]) {
            [self.delegate didClickAtIndex:1];
        }
        return ;
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.bottomLayer.fillColor = bgColor.CGColor;
}

- (void)setTitle1:(NSString *)title1 {
    _title1 = title1;
    self.titleLabel1.text = title1 == nil ? @"" : title1;
}

- (void)setTitle2:(NSString *)title2 {
    _title2 = title2;
    self.titleLabel2.text = title2 == nil ? @"" : title2;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName == nil ? @"" : imageName;
    self.showImageView.image = [UIImage imageNamed:_imageName];
}

- (UILabel *)titleLabel1 {
    if (_titleLabel1 == nil) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.frame = CGRectMake(self.bigSize.width * 0.25 - 14, 0, 28, self.bigSize.height);
        _titleLabel1.textColor = [UIColor whiteColor];
        _titleLabel1.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel1.numberOfLines = 2;
        _titleLabel1.alpha = 0;
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (_titleLabel2 == nil) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.frame = CGRectMake(self.bigSize.width * 0.75 - 14, 0, 28, self.bigSize.height);
        _titleLabel2.textColor = [UIColor whiteColor];
        _titleLabel2.font = [UIFont boldSystemFontOfSize:13];
        _titleLabel2.numberOfLines = 2;
        _titleLabel2.alpha = 0;
    }
    return _titleLabel2;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
        _lineView.frame = CGRectMake(self.bigSize.width * 0.5, 20, 1, self.bigSize.height - 40);
        _lineView.alpha = 0;
    }
    return _lineView;
}

- (void)myInit {
    self.frame = self.mainFrame;
    if (self.bgColor == nil) {
        self.bgColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    }
    if (self.title1 == nil) {
        self.title1 = @"";
    }
    if (self.title2 == nil) {
        self.title2 = @"";
    }
    if (self.imageName == nil) {
        self.imageName = @"";
    }
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = true;
    [self.layer addSublayer:self.bottomLayer];
    [self addSubview:self.lineView];
    [self addSubview:self.showImageView];
    [self addSubview:self.titleLabel1];
    [self addSubview:self.titleLabel2];
    [self addSubview:self.showButton];
    [self addSubview:self.button1];
    [self addSubview:self.button2];
}

- (void)show {
    [self.bottomLayer addAnimation:self.showAnimation forKey:@"show"];
    self.showImageView.alpha = 1.0;
    self.titleLabel1.frame = CGRectMake(-self.titleLabel1.frame.size.width - 1, 0, 0, 0);
    self.titleLabel1.alpha = 0;
    self.titleLabel2.frame = CGRectMake(-self.titleLabel2.frame.size.width - 1, 0, 0, 0);
    self.titleLabel2.alpha = 0;
    self.lineView.frame = CGRectMake(-2, 20, 1, self.bigSize.height - 40);
    self.lineView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.showImageView.alpha = 0.0;
        self.titleLabel1.frame = CGRectMake(self.bigSize.width * 0.25 - 14, 0, 28, self.bigSize.height);
        self.titleLabel1.alpha = 1;
        self.titleLabel2.frame = CGRectMake(self.bigSize.width * 0.75 - 14, 0, 28, self.bigSize.height);
        self.titleLabel2.alpha = 1;
        self.lineView.frame = CGRectMake(self.bigSize.width * 0.5, 20, 1, self.bigSize.height - 40);
        self.lineView.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.button1.hidden = false;
            self.button2.hidden = false;
        }
    }];
    self.showButton.hidden = true;
}

- (void)hide {
    [self.bottomLayer addAnimation:self.hideAnimation forKey:@"hide"];
    self.showImageView.alpha = 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.showImageView.alpha = 1.0;
        self.titleLabel1.frame = CGRectMake(-self.titleLabel1.frame.size.width - 1, 0, 0, 0);
        self.titleLabel1.alpha = 0;
        self.titleLabel2.frame = CGRectMake(-self.titleLabel2.frame.size.width - 1, 0, 0, 0);
        self.titleLabel2.alpha = 0;
        self.lineView.frame = CGRectMake(-2, 20, 1, self.bigSize.height - 40);
        self.lineView.alpha = 0;
    }];
    self.button1.hidden = true;
    self.button2.hidden = true;
    self.showButton.hidden = false;
}

- (BOOL)isShow {
    return self.showButton.hidden;
}

// 点击范围判断
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    if ([self isShow]) {
        // 判断点在不在矩形内
        CGFloat height = self.bigSize.height;
        CGFloat height_2 = self.bigSize.height * 0.5;
        CGFloat width = self.bigSize.width;
        if (x >= height_2 && x <= width - height_2 && y >= 0 && y <= height) {
            return true;
        }
        // 判断点在不在两个半圆内
        CGPoint center1 = CGPointMake(height_2, height_2);
        CGPoint center2 = CGPointMake(width - height_2, height_2);
        CGFloat k1 = sqrt((x - center1.x) * (x - center1.x) + (y - center1.y) * (y - center1.y));
        CGFloat k2 = sqrt((x - center2.x) * (x - center2.x) + (y - center2.y) * (y - center2.y));
        if (k1 <= height_2 || k2 <= height_2) {
            return true;
        }
    } else {
        // 判断点在不在圆内
        CGFloat width = self.mainSize.width;
        CGFloat height = self.mainSize.height;
        CGPoint center = CGPointMake(width * 0.5, self.bigSize.height - 0.5 * height);
        CGFloat k = sqrt((x - center.x) * (x - center.x) + (y - center.y) * (y - center.y));
        if (k <= width * 0.5) {
            return true;
        }
    }
    return false;
}

@end
