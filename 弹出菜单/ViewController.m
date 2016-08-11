//
//  ViewController.m
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/2.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import "ViewController.h"
#import "ScrollMenu.h"
#import "FadeMenu.h"
#import "SlideMenu.h"
#import "CircleMenu.h"

@interface ViewController () <SlideMenuDelegate, CircleMenuDelegate>

@property (strong, nonatomic) ScrollMenu *menu1;
@property (strong, nonatomic) FadeMenu *menu2;
@property (strong, nonatomic) SlideMenu *menu3;
@property (strong, nonatomic) SlideMenu *menu4;
@property (strong, nonatomic) CircleMenu *menu5;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menu1 = [[ScrollMenu alloc] init];
    // 使用默认的 frame，menu1自动贴在底部，自己修改也行
//    CGRect frame = menu1.frame;
//    frame.origin.y = 600;
//    menu1.frame = frame;
    [self.view addSubview:self.menu1];
    
    self.menu2 = [[FadeMenu alloc] init];
    [self.view addSubview:self.menu2];
    
    self.menu3 = [[SlideMenu alloc] initWithFrame:CGRectMake(0, 500, 375, 40)];
    self.menu3.delegate = self;
    self.menu3.bgColor = [UIColor whiteColor];
    self.menu3.titleColor = [UIColor orangeColor];
    self.menu3.selectedTitleColor = [UIColor redColor];
    self.menu3.viewColor = [UIColor orangeColor];
    self.menu3.fontSize = 17;
    NSArray *buttons = @[@"测试", @"测", @"今日新闻", @"今日", @"今日今日今日今日", @"今日今日今日今日", @"今日今日今日今日"];
    self.menu3.buttons = buttons;
    [self.view addSubview:self.menu3];

    self.menu4 = [[SlideMenu alloc] initWithFrame:CGRectMake(0, 400, 300, 40)];
    self.menu4.delegate = self;
    self.menu4.bgColor = [UIColor whiteColor];
    self.menu4.titleColor = [UIColor orangeColor];
    self.menu4.selectedTitleColor = [UIColor redColor];
    self.menu4.viewColor = [UIColor orangeColor];
    self.menu4.fontSize = 17;
    NSArray *buttons2 = @[@"测试", @"测", @"今日新闻", @"今日"];
    self.menu4.buttons = buttons2;
    [self.view addSubview:self.menu4];
    
    self.menu5 = [[CircleMenu alloc] initWithFrame:CGRectMake(60, 270, 0, 0)];
    self.menu5.bgColor = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1.0];
    self.menu5.title1 = @"素材搭配";
    self.menu5.title2 = @"留言搭配";
    self.menu5.imageName = @"btn_add";
    self.menu5.delegate = self;
    [self.view addSubview:self.menu5];
    
    [self.view bringSubviewToFront:self.menu2];     // menu2 最前
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // menu2 显示逻辑
    if ([self.menu2 isHide]) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        
        [self.menu2 showAtPoint:point];     // 显示
    } else {
        [self.menu2 hide];      // 隐藏
    }
    
    // menu5 显示逻辑
    if ([self.menu5 isShow]) {
        [self.menu5 hide];
    }
}

- (void)didClickAtIndex:(NSInteger)index {
    NSLog(@"%ld", (long)index);
}

- (void)didClickButton:(NSInteger)index slideMenu:(SlideMenu *)menu {
    NSLog(@"%@, %li", menu, index);
}

- (IBAction)change:(id)sender {
    self.menu3.selectedIndex = 4;
}

@end

