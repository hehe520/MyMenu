//
//  CircleMenu.h
//  弹出菜单
//
//  Created by caokun on 16/8/6.
//  Copyright © 2016年 caokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleMenuDelegate <NSObject>

- (void)didClickAtIndex:(NSInteger)index;

@end

@interface CircleMenu : UIView

@property (weak, nonatomic) id<CircleMenuDelegate> delegate;
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *imageName;

- (void)show;
- (void)hide;
- (BOOL)isShow;

@end
