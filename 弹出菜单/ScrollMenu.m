//
//  ScrollMenu.m
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/2.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import "ScrollMenu.h"

@interface ScrollMenu () {
    CGFloat height;
    CGFloat isShow;
    CGFloat initCode;
}

@property (strong, nonatomic) UIButton *mainButton;     // 主按钮
@property (strong, nonatomic) NSArray *buttons;         // 子按钮
@property (strong, nonatomic) NSMutableArray *startFrame;      // 子按钮起始位
@property (strong, nonatomic) NSMutableArray *endFrame;        // 子按钮终点位

@end


@implementation ScrollMenu

- (instancetype)init {
    if (self = [super init]) {
        initCode = 0;
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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isShow = 0;
        height = 50;
        if (initCode == 0) {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            self.frame = CGRectMake(0, CGRectGetHeight(screenBounds) - height, CGRectGetWidth(screenBounds), height);
        }
        self.backgroundColor = [UIColor clearColor];
        
        // n 个菜单按钮
        UIButton *button1 = [self buttonWithImageName:@"01" diameter:height color:[UIColor yellowColor] action:@selector(button1Action:)];
        UIButton *button2 = [self buttonWithImageName:@"02" diameter:height color:[UIColor yellowColor] action:@selector(button2Action:)];
        UIButton *button3 = [self buttonWithImageName:@"03" diameter:height color:[UIColor yellowColor] action:@selector(button3Action:)];
        UIButton *button4 = [self buttonWithImageName:@"04" diameter:height color:[UIColor yellowColor] action:@selector(button4Action:)];
        
        // 可以动态添加子按钮，自动计算位置
        self.buttons = @[button1, button2, button3, button4];
        for (UIButton *btn in self.buttons) {
            [self addSubview:btn];
        }
        
        // 主按钮
        self.mainButton = [self buttonWithImageName:@"Add" diameter:height color:[UIColor greenColor] action:@selector(buttonClicked:)];
        [self addSubview:self.mainButton];
    });
}

// 返回一个格式化 button
- (UIButton *)buttonWithImageName:(NSString *)image diameter:(CGFloat)d color:(UIColor *)color action:(SEL)selector {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, d, d)];
    button.layer.cornerRadius = d * 0.5;
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    button.backgroundColor = color;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonClicked:(UIButton *)button {
    if (isShow) {
        isShow = 0;     // 缩回
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI - 0.001, 0, 0, 1)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)];
        animation.duration = 0.2;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.mainButton.layer addAnimation:animation forKey:@"mainButton2"];
        
        NSUInteger count = [self.buttons count];
        for (int i=0; i<count; i++) {
            UIButton *btn = [self.buttons objectAtIndex:i];
            
            CGRect start = [self.startFrame[i] CGRectValue];
            CGRect end = [self.endFrame[i] CGRectValue];
            CAAnimationGroup *group = [self groupWithStartFrame:end endFrame:start t:btn.layer.transform];
            [btn.layer addAnimation:group forKey:@"myAnimate2"];
        }
    } else {
        isShow = 1;     // 展开
        
        // 主按钮动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI - 0.001, 0, 0, 1)];
        animation.duration = 0.2;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.mainButton.layer addAnimation:animation forKey:@"mainButton"];
        
        // 子按钮的展开
        NSUInteger count = [self.buttons count];
        for (int i=0; i<count; i++) {
            UIButton *btn = [self.buttons objectAtIndex:i];
            
            CGRect start = [self.startFrame[i] CGRectValue];
            CGRect end = [self.endFrame[i] CGRectValue];
            CAAnimationGroup *group = [self groupWithStartFrame:start endFrame:end t:btn.layer.transform];
            [btn.layer addAnimation:group forKey:@"myAnimate1"];
        }
    }
}

// 返回按钮移动的动画
- (CAAnimationGroup *)groupWithStartFrame:(CGRect)startFrame endFrame:(CGRect)endFrame t:(CATransform3D)t {
    CGFloat offset = height * 0.5;
    // 平移
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    transform.values = @[[NSValue valueWithCGPoint:CGPointMake(startFrame.origin.x + offset, offset)],
                         [NSValue valueWithCGPoint:CGPointMake(endFrame.origin.x + 8 + offset, offset)],
                         [NSValue valueWithCGPoint:CGPointMake(endFrame.origin.x - 3 + offset, offset)],
                         [NSValue valueWithCGPoint:CGPointMake(endFrame.origin.x + offset, offset)]];
    transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 旋转
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.values = @[@(0), @(2 * M_PI)];
    rotate.duration = 0.4;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[transform, rotate];
    group.duration = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    return group;
}

- (void)setButtons:(NSArray *)buttons {
    if (_buttons != buttons) {
        _buttons = buttons;
    }
    
    NSUInteger count = [_buttons count];
    if (count > 0) {
        _startFrame = [[NSMutableArray alloc] init];
        _endFrame = [[NSMutableArray alloc] init];
        
        // 计算子按钮起始，终点位
        for (UIButton *btn in _buttons) {
            [_startFrame addObject:[NSValue valueWithCGRect:btn.frame]];
        }
        
        CGFloat width = CGRectGetWidth(self.frame) - height;
        CGFloat buttonWidth = height;
        if (count) {
            UIButton *btn = _buttons[0];
            buttonWidth = CGRectGetWidth(btn.frame);
        }
        CGFloat margin = (width - count * buttonWidth) / (count + 1);
        CGFloat pos = height + margin;
        
        for (UIButton *btn in _buttons) {
            CGRect frame = btn.frame;
            frame.origin.x = pos;
            pos += (CGRectGetWidth(frame) + margin);
            
            [_endFrame addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}

// 动画停止时，重新设置 frame 到动画最后的状态
// 因为核心动画不会改变控件的值，比如frame，它只是在独立的空间制造的假象，要手动设置按钮最后的位置，以便能够点击到
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSUInteger count = [self.buttons count];
    if (isShow) {
        for (int i=0; i<count; i++) {
            UIButton *btn = self.buttons[i];
            btn.frame = [self.endFrame[i] CGRectValue];
        }
    } else {
        for (int i=0; i<count; i++) {
            UIButton *btn = self.buttons[i];
            btn.frame = [self.startFrame[i] CGRectValue];
        }
    }
}

// 在动画准备收起时，就可以改变 frame 了
- (void)animationDidStart:(CAAnimation *)anim {
    NSUInteger count = [self.buttons count];
    if (!isShow) {
        for (int i=0; i<count; i++) {
            UIButton *btn = self.buttons[i];
            btn.frame = [self.startFrame[i] CGRectValue];
        }
    }
}

- (void)button1Action:(UIButton *)button {
    NSLog(@"%s", __func__);
}

- (void)button2Action:(UIButton *)button {
    NSLog(@"%s", __func__);
}

- (void)button3Action:(UIButton *)button {
    NSLog(@"%s", __func__);
}

- (void)button4Action:(UIButton *)button {
    NSLog(@"%s", __func__);
}

@end

