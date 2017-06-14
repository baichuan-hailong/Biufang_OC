//
//  UIColor+Util.m
//  pic
//
//  Created by xxxxx on 13-7-31.
//  Copyright (c) 2013年 xxxxxx. All rights reserved.
//

#import "UIColor+Util.h"
//#import "BkLog.h"

void CGContextSetStrokeColorWithUIColor(CGContextRef ctx,UIColor * color)
{
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
}
void CGContextSetFillColorWithUIColor(CGContextRef ctx,UIColor * color)
{
    CGContextSetFillColorWithColor(ctx, color.CGColor);
}
void CGContextDrawRoundRect(CGContextRef context ,CGRect rect,float radius ,CGPathDrawingMode mode)
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;

    // 移动到初始点
    CGContextMoveToPoint(context, radius, 0);
    
    // 绘制第1条线和第1个1/4圆弧
    CGContextAddLineToPoint(context, width - radius, 0);
    CGContextAddArc(context, width - radius, radius, radius, -0.5 * M_PI, 0.0, 0);
    
    // 绘制第2条线和第2个1/4圆弧
    CGContextAddLineToPoint(context, width, height - radius);
    CGContextAddArc(context, width - radius, height - radius, radius, 0.0, 0.5 * M_PI, 0);
    
    // 绘制第3条线和第3个1/4圆弧
    CGContextAddLineToPoint(context, radius, height);
    CGContextAddArc(context, radius, height - radius, radius, 0.5 * M_PI, M_PI, 0);
    
    // 绘制第4条线和第4个1/4圆弧
    CGContextAddLineToPoint(context, 0, radius);
    CGContextAddArc(context, radius, radius, radius, M_PI, 1.5 * M_PI, 0);
    
    // 闭合路径
    CGContextClosePath(context);
    // 填充半透明黑色
    CGContextDrawPath(context, mode);
}
UIColor* rgb255(int r,int g,int b,int a)
{
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}
//void BkLog_UIColor(UIColor * c)
//{
//    BkLog(@"r:%d,g:%d,b:%d,a:%d",(int)(c.red*255),(int)(c.green*255),(int)(c.blue*255),(int)(c.alpha*255));
//}

@implementation UIColor (Util)


+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(hexValue & 0xFF))/255.0
						   alpha:alpha];
}

+ (UIColor *) colorWithHex:(NSString *)hexColor {
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];

    
}


+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue
{
	return [UIColor colorWithRed:((float)((ARGBValue & 0xFF0000) >> 16)) / 255.0
						   green:((float)((ARGBValue & 0xFF00) >> 8)) / 255.0
							blue:((float)(ARGBValue & 0xFF))/255.0
						   alpha:((float)((ARGBValue & 0xFF000000) >> 24)) / 255.0];
}
-(NSString*)toWebString
{
    int r = self.red * 255;
    int g = self.green * 255;
    int b = self.blue * 255;
    int a = self.alpha * 255;
    return [NSString stringWithFormat:@"#%02x%02x%02x%02x",r,g,b,a];
}
- (UIColor *) getColor: (NSString *) hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}
+(UIColor*)fromWebString:(NSString*)str
{
    unsigned int r=0, g=0, b=0,a=0;
    NSRange range;
    if(str.length == 4 || str.length == 5)
    {
        range.length = 1;
        range.location = 1;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&r];
        range.location = 2;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&g];
        range.location = 3;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&b];
        if(str.length == 5)
        {
            range.location = 4;
            [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&a];
        }
        else
            a = 255;
    }
    else if(str.length == 7 || str.length == 9)
    {
        range.length = 2;
        range.location = 1;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&r];
        range.location = 3;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&g];
        range.location = 5;
        [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&b];
        if(str.length == 9)
        {
            range.location = 7;
            [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&a];
        }
        else
            a = 255;
    }
    return [UIColor colorWithRed:(float)(r/255.0f) green:(float)(g/255.0f) blue:(float)(b/255.0f) alpha:(float)(a/255.0f)];
}
-(int)rgb
{
    int r = self.red*255;
    int g = self.green*255;
    int b = self.blue*255;
    return (r<<16) + (g<<8) + b;
}
-(NSString*)webRgb
{
    int r = self.red*255;
    int g = self.green*255;
    int b = self.blue*255;
    return [NSString stringWithFormat:@"#%02x%02x%02x",r,g,b];
}
-(CGFloat)red
{
    CGColorRef color = self.CGColor;
    CGColorSpaceRef color_space = CGColorGetColorSpace(color);
    CGColorSpaceModel color_space_model = CGColorSpaceGetModel(color_space);
    const CGFloat *color_components = CGColorGetComponents(color);
//    int color_component_count = CGColorGetNumberOfComponents(color);
    
    switch (color_space_model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            return color_components[0];
        }break;
        case kCGColorSpaceModelRGB:
        {
            return color_components[0];
        }break;
        default:
            return 0;
    }
    return 0;
}
-(CGFloat)green
{
    CGColorRef color = self.CGColor;
    CGColorSpaceRef color_space = CGColorGetColorSpace(color);
    CGColorSpaceModel color_space_model = CGColorSpaceGetModel(color_space);
    const CGFloat *color_components = CGColorGetComponents(color);
//    int color_component_count = CGColorGetNumberOfComponents(color);
    
    switch (color_space_model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            return color_components[0];
        }break;
        case kCGColorSpaceModelRGB:
        {
            return color_components[1];
        }break;
        default:
            return 0;
    }
    return 0;
}
-(CGFloat)blue
{
    CGColorRef color = self.CGColor;
    CGColorSpaceRef color_space = CGColorGetColorSpace(color);
    CGColorSpaceModel color_space_model = CGColorSpaceGetModel(color_space);
    const CGFloat *color_components = CGColorGetComponents(color);
//    int color_component_count = CGColorGetNumberOfComponents(color);
    
    switch (color_space_model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            return color_components[0];
        }break;
        case kCGColorSpaceModelRGB:
        {
            return color_components[2];
        }break;
        default:
            return 0;
    }
    return 0;
}
-(CGFloat)alpha
{
    CGColorRef color = self.CGColor;
    CGColorSpaceRef color_space = CGColorGetColorSpace(color);
    CGColorSpaceModel color_space_model = CGColorSpaceGetModel(color_space);
    const CGFloat *color_components = CGColorGetComponents(color);
//    int color_component_count = CGColorGetNumberOfComponents(color);
    
    switch (color_space_model)
    {
        case kCGColorSpaceModelMonochrome:
        {
            return color_components[1];
        }break;
        case kCGColorSpaceModelRGB:
        {
            return color_components[3];
        }break;
        default:
            return 0;
    }
    return 0;
}

@end
