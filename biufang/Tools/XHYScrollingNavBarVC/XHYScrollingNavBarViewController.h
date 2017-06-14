//
//  XHYScrollingNavBarViewController.h
//  XHYScrollingNavBarViewController
//
//  Created by 娄耀文 on 16/10/11.
//  Copyright (c) 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕高度
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#pragma mark - 判断是否ios7
#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

@interface XHYScrollingNavBarViewController : UIViewController

- (void)followRollingScrollView:(UIView *)scrollView;
- (void)showNavigation;
- (void)hideOverLay;

@end
