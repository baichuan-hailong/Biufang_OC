//
//  DeviceInfoManage.m
//  biufang
//
//  Created by 杜海龙 on 16/10/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "DeviceInfoManage.h"
#import <sys/utsname.h>

@implementation DeviceInfoManage

+ (NSString *)getDeviceInfo{
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@",sysVersion];
}



+(NSString *)deviceModelName{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //NSLog(@"设备具体型号 --- %@",deviceModel);
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"]) return @"iPhone1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([deviceModel isEqualToString:@"iPhone3,2"]) return @"VerizoniPhone4";
    if ([deviceModel isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,3"]) return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"]) return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"]) return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"]) return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([deviceModel isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([deviceModel isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([deviceModel isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,3"]) return @"iPhone7";
    if ([deviceModel isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([deviceModel isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    
    return @"iPad";
}



+ (BOOL)checkIsSettingNotification{
    
    // iOS8+
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != settings.types) {
        return YES;
    }
    return NO;
}

@end
