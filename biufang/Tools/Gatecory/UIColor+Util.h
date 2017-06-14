//
//  UIColor+Util.h
//  pic
//
//  Created by xxxxx on 13-7-31.
//  Copyright (c) 2013年 xxxxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIColor (Util)

+ (UIColor *) colorWithHex:(NSString *)hexColor;

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue;
-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;
-(CGFloat)alpha;
-(int)rgb;
-(NSString*)webRgb;
-(NSString*)toWebString;
+(UIColor*)fromWebString:(NSString*)str;
@end

void BkLog_UIColor(UIColor * c);
UIColor* rgb255(int r,int g,int b,int a);
void CGContextSetStrokeColorWithUIColor(CGContextRef ctx,UIColor * color);
void CGContextSetFillColorWithUIColor(CGContextRef ctx,UIColor * color);
void CGContextDrawRoundRect(CGContextRef context ,CGRect rect,float radius ,CGPathDrawingMode mode);