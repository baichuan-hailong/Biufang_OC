//
//  myToolsClass.h
//  gdmbxt
//
//  Created by 娄耀文 on 16/3/30.
//  Copyright © 2016年 娄耀文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myToolsClass : NSObject

/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
+ (NSString *)getCurrentTime;


/**
 *  将字符串进行encode编码
 *
 *  @param input 需要编码的字符串
 *
 *  @return 编码后的字符换
 */
+ (NSString *)encodeToPercentEscapeString:(NSString *) input;

//将颜色转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//将字符串转为为字典格式json
+ (NSDictionary *)nsstringToJson: (NSString *)jsonString;


//评分正则
+ (NSString *)rateStr: (NSString *)commentStr;

//*** 金额字段加千位分隔符方法 ***//
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString;

//*** 获取URL内指定参数 ***//
+ (NSString *)paramValueOfUrl:(NSString *)url withParam:(NSString *)param;

//*** 时间戳转换为标准时间 ***//
+ (NSString *)changeTime:(NSString *)timeStr;



@end




