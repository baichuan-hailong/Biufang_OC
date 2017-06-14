//
//  DeviceInfoManage.h
//  biufang
//
//  Created by 杜海龙 on 16/10/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DeviceInfoManage : NSObject
+ (NSString *)getDeviceInfo;

+(NSString *)deviceModelName;

+ (BOOL)checkIsSettingNotification;
@end
