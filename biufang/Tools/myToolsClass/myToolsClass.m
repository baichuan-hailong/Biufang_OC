//
//  myToolsClass.m
//  gdmbxt
//
//  Created by 娄耀文 on 16/3/30.
//  Copyright © 2016年 娄耀文. All rights reserved.
//

#import "myToolsClass.h"

@implementation myToolsClass


/**
*  将字符串进行encode编码
*
*  @param input 需要编码的字符串
*
*  @return 编码后的字符换
*/
+ (NSString *)encodeToPercentEscapeString: (NSString *) input {
    
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return outputStr;
}


/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSString *)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSString *time = [NSString stringWithFormat:@"%@",dateTime];
    return time;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/**
 *  将字符串转换为标书呢json
 *
 *  @param jsonString 字符串
 *
 *  @return json对象
 */
+ (NSDictionary *)nsstringToJson: (NSString *)jsonString {
    
    NSError *error;
    NSData *resData = [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];  //解析
    
    return resultDic;
}


//评分正则
+ (NSString *)rateStr:(NSString *)commentStr {

    NSString *searchedString = commentStr;
    NSRange  searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"T(\\d+\\.?\\d*).*$";
    NSError  *error = nil;
    
    NSRegularExpression  *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
    NSLog(@"group1: %@", [searchedString substringWithRange:[match rangeAtIndex:1]]);
    return [NSString stringWithFormat:@"%.2f",[[searchedString substringWithRange:[match rangeAtIndex:1]] floatValue]];
}

//*** 金额字段加千位分隔符方法 ***//
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString {
    
    if (digitString.length <= 3) {
        
        return digitString;
        
    } else {
        
        NSMutableString *processString = [NSMutableString stringWithString:digitString];
        
        NSInteger location = processString.length - 3;
        
        NSMutableArray *processArray = [NSMutableArray array];
        
        while (location >= 0) {
            
            NSString *temp = [processString substringWithRange:NSMakeRange(location, 3)];
            
            [processArray addObject:temp];
            
            if (location < 3 && location > 0) {
                
                NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
                
                [processArray addObject:t];
            }
            location -= 3;
        }
        
        NSMutableArray *resultsArray = [NSMutableArray array];
        
        int k = 0;
        for (NSString *str in processArray) {
            
            k++;
            NSMutableString *tmp = [NSMutableString stringWithString:str];
            
            if (str.length > 2 && k < processArray.count ) {
                
                [tmp insertString:@"," atIndex:0];
                
                [resultsArray addObject:tmp];
                
            } else {
                
                [resultsArray addObject:tmp];
            }
        }
        NSMutableString *resultString = [NSMutableString string];
        for (NSInteger i = resultsArray.count - 1 ; i >= 0; i--) {
            
            NSString *tmp = [resultsArray objectAtIndex:i];
            
            [resultString appendString:tmp];
        }
        return resultString;
    }
}

//*** 获取URL内指定参数 ***//
+ (NSString *)paramValueOfUrl:(NSString *)url withParam:(NSString *)param{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",param];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return nil;
}


//时间戳传唤为标准时间
+ (NSString *)changeTime:(NSString *)timeStr {
    
    NSTimeInterval timeInt = [timeStr doubleValue];// + 28800;//因为时差 == 28800
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
    NSString *currentDateStr = [formatter stringFromDate: date];
    return currentDateStr;
}


@end
