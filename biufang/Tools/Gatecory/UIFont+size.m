//
//  UIFont+size.m
//  NewChinaHealthy
//
//  Created by 段蒙 on 15/5/13.
//  Copyright (c) 2015年 NCH. All rights reserved.
//

#import "UIFont+size.h"

@implementation UIFont (size)
+ (UIFont *) pointFontOfSize:(CGFloat)sizeFont{
    float font= sizeFont*72/96*2/3;
    return [UIFont systemFontOfSize:font];
}

+ (UIFont *)pointBlodFontOfSize:(CGFloat)sizeFont{
    float font= sizeFont*72/96*2/3;
    return [UIFont boldSystemFontOfSize:font];
}
@end
