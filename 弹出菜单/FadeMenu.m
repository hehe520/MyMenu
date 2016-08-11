//
//  FadeMenu.m
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/3.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import "FadeMenu.h"

@interface FadeMenu () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *cellData;        // 设置数据源，动态添加菜单

@end

@implementation FadeMenu

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
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _hide = YES;
        self.layer.opacity = 0;
        self.layer.anchorPoint = CGPointMake(0.5, 0);
        self.frame = CGRectMake(0, 0, 130, 150);
        self.backgroundColor = [UIColor darkGrayColor];
        
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        // tableView 初始化
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = CGRectMake(0, 25, width - 15, height - 35);
        self.tableView.backgroundColor = [UIColor darkGrayColor];
        self.tableView.rowHeight = 30;
        self.tableView.separatorColor = [UIColor whiteColor];   // 分隔线颜色
        self.tableView.showsVerticalScrollIndicator = false;
        self.tableView.showsHorizontalScrollIndicator = false;
        [self addSubview:self.tableView];
        
        // 画遮罩层
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 13, width, height - 13) cornerRadius:10];
        CGPoint center = CGPointMake(width * 0.5, 0);
        [path moveToPoint:CGPointMake(center.x - 13, center.y + 13)];
        [path addLineToPoint:center];
        [path addLineToPoint:CGPointMake(center.x + 13, center.y + 13)];
        [path closePath];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.bounds;
        layer.path = path.CGPath;
        layer.fillColor = [UIColor redColor].CGColor;
        layer.strokeStart = 0;
        layer.strokeEnd = 1;
        
        self.layer.mask = layer;
//        [self.layer addSublayer:layer];
    });
}

- (void)showAtPoint:(CGPoint)point {
    _hide = NO;
    self.layer.position = point;
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    // 渐隐效果
//    [UIView animateWithDuration:0.2 animations:^{
//        self.layer.opacity = 1;
//    }];
    
    // (x, y) 缩放
    CAKeyframeAnimation *translate = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    translate.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.85, 0.85, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],];
    translate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 透明度
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @0;
    opacity.toValue = @1;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[translate, opacity];
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;

    [self.layer addAnimation:group forKey:@"show"];
}

- (void)hide {
    _hide = YES;
    
    // 渐隐效果
//    [UIView animateWithDuration:0.2 animations:^{
//        self.layer.opacity = 0;
//    }];
    
    // 缩放
    CABasicAnimation *translate = [CABasicAnimation animationWithKeyPath:@"transform"];
    translate.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    translate.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)];
    
    // 透明度
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @1;
    opacity.toValue = @0;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[translate, opacity];
    group.duration = 0.1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    
    [self.layer addAnimation:group forKey:@"hide"];
}

// 核心动画是假象，不会改变控件的属性值，动画结束后要手动修改控件的值
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_hide) {
        self.layer.opacity = 0;
    } else {
        self.layer.opacity = 1;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 拦截 touch 事件，不发给下一响应者
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"选项";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"test");
}

@end

