//
//  UIBarButtonItem+Item.h
//  WeiBo
//
//  Created by lanou3g on 15/9/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)hightImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
