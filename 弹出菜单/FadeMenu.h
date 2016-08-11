//
//  FadeMenu.h
//  弹出菜单
//
//  Created by LaiZhaowu on 15/11/3.
//  Copyright © 2015年 caokun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FadeMenu : UIView

@property (assign, nonatomic, getter=isHide) BOOL hide;

- (void)showAtPoint:(CGPoint)point;
- (void)hide;

@end

