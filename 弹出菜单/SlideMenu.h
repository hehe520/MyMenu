//
//  SlideMenu.h
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/11.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideMenu;

@protocol SlideMenuDelegate <NSObject>

- (void)didClickButton:(NSInteger)index slideMenu:(SlideMenu *)menu;

@end


@interface SlideMenu : UIView

@property (weak, nonatomic) id<SlideMenuDelegate> delegate;

// 这些属性值在 init 系列函数中，还没有被赋值，所以都是空，要在 layoutSubviews 中，或者 set 方法中赋值
@property (strong, nonatomic) UIColor *titleColor;          // 文字颜色
@property (strong, nonatomic) UIColor *selectedTitleColor;  // selected 文字颜色
@property (strong, nonatomic) UIColor *viewColor;           // 滑块颜色
@property (strong, nonatomic) UIColor *bgColor;             // 背景色
@property (assign, nonatomic) NSInteger fontSize;           // 字号
@property (strong, nonatomic) NSArray *buttons;             // 按钮组
@property (assign, nonatomic) NSInteger selectedIndex;      // 默认选中的 button index

@end

