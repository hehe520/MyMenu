//
//  SlideMenu.m
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/11.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import "SlideMenu.h"
#import "SlideButton.h"

@interface SlideMenu () {
    CGFloat buttonHeight;
    CGFloat bottomHeight;       // 滑动的 view 高度
    CGFloat width;
    CGFloat height;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *slideView;
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) SlideButton *selectedButton;

@end

@implementation SlideMenu

- (instancetype)init {
    if (self = [super init]) {
        [self myInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self myInit];
    }
    return self;
}

// 从 xib 等等地方加载会调用此方法，控制器也是用归档方式存储 xib 的
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self myInit];
    }
    return self;
}

- (void)myInit {
    width = CGRectGetWidth(self.frame);
    height = CGRectGetHeight(self.frame);
    bottomHeight = 3;
    buttonHeight = height - bottomHeight;
    
    self.backgroundColor = [UIColor whiteColor];
    _buttonArray = [[NSMutableArray alloc] init];
    
    // 创建一个 scrollView, 上面放按钮
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0, 0, width, height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    // 下面一个滑动的 view
    self.slideView = [[UIView alloc] init];
    self.slideView.frame = CGRectMake(0, buttonHeight, width, bottomHeight);
    [self.scrollView addSubview:self.slideView];
    
    // 创建好控件，设置默认值
    self.bgColor = [UIColor whiteColor];
    self.titleColor = [UIColor redColor];
    self.selectedTitleColor = [UIColor grayColor];
    self.viewColor = [UIColor redColor];
    self.fontSize = 17;
}

// 布局控件, init 和 滚动 ScrollView 会触发 layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
}

- (void)setButtons:(NSArray *)buttons {
    if (_buttons != buttons) {
        _buttons = buttons;
        
        // 创建按钮放 scrollView 上, 超过 scrollView 的长度要能滑动，有阴影
        CGFloat pos_x = 0;
        NSInteger i = 0;
        for (NSString *title in _buttons) {
            CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(width, buttonHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.fontSize]} context:nil].size.width;
            
            SlideButton *button = [[SlideButton alloc] init];
            button.tag = i++;
            button.frame = CGRectMake(pos_x, 0, titleWidth + 24, buttonHeight);
            pos_x += CGRectGetWidth(button.frame);
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buttonArray addObject:button];    // 加到数据源中
            [_scrollView addSubview:button];
        }
        _scrollView.contentSize = CGSizeMake(pos_x, height);    // 设置 scrollView 大小
        _selectedButton = _buttonArray[0];      // 默认 button
        _selectedButton.selected = YES;
        CGRect frame = _slideView.frame;        // 设置 slideView
        frame.origin.x = CGRectGetMinX(_selectedButton.frame);
        frame.size.width = CGRectGetWidth(_selectedButton.frame);
        _slideView.frame = frame;
        
        // 加阴影
        if (_scrollView.contentSize.width > CGRectGetWidth(_scrollView.frame)) {
            CALayer *shape = [CALayer layer];
            shape.frame = CGRectMake(width - 1, 0, 1, height);
            shape.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
            shape.shadowColor = [UIColor blackColor].CGColor;
            shape.shadowOffset = CGSizeMake(-1, 0);
            shape.shadowOpacity = 1;
            shape.shadowRadius = 5;
            
            [self.layer addSublayer:shape];
        }
        [self flash];
    }
}

// 按钮点击
- (void)buttonAction:(SlideButton *)button {
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideView.frame = CGRectMake(CGRectGetMinX(button.frame), buttonHeight, CGRectGetWidth(button.frame), bottomHeight);
    }];
    
    // 滚到特定 rect 显示
    [self.scrollView scrollRectToVisible:button.frame animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didClickButton:slideMenu:)]) {
        [self.delegate didClickButton:button.tag slideMenu:self];
    }
}

// 重绘菜单样式
- (void)flash {
    _scrollView.backgroundColor = _bgColor;
    _slideView.backgroundColor = _viewColor;
    
    for (SlideButton *btn in self.buttonArray) {
        btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        if (selectedIndex < [self.buttonArray count]) {
            SlideButton *btn = self.buttonArray[selectedIndex];
            [self buttonAction:btn];
        }
    }
}

- (void)setFontSize:(NSInteger)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        [self flash];
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        [self flash];
    }
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    if (_selectedTitleColor != selectedTitleColor) {
        _selectedTitleColor = selectedTitleColor;
        [self flash];
    }
}

- (void)setViewColor:(UIColor *)viewColor {
    if (_viewColor != viewColor) {
        _viewColor = viewColor;
        [self flash];
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    if (_bgColor != bgColor) {
        _bgColor = bgColor;
        [self flash];
    }
}

@end

