//
//  CheckPopingNotificationPop.m
//  biufang
//
//  Created by 杜海龙 on 17/2/21.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "CheckPopingNotificationPop.h"

@implementation CheckPopingNotificationPop

+(void)checkPopingNotiPop{
    //取出当前系统的时间
    NSDate          *unifiedDate         = [NSDate date];//获取当前时间，日期
    NSTimeInterval  currenSyetemTimeInla = [unifiedDate timeIntervalSince1970]+28800;
    NSString *timeSystemStrla            = [NSString stringWithFormat:@"%.f", currenSyetemTimeInla];//转为字符型
    NSLog(@"%@",timeSystemStrla);
    
    //取出登陆时存储的时间
    NSString *notifiTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:notificationPopTimeStamp];
    //时间差                   当前时间                           登陆时间
    NSInteger poorTimeStamp = [timeSystemStrla integerValue] - [notifiTimeStamp integerValue];
    NSLog(@"时间差 --- %ld",(long)poorTimeStamp);
    NSLog(@"上次 --- %@",notifiTimeStamp);
    NSLog(@"%ld",(unsigned long)notifiTimeStamp.length);
    //86400
    if ((notifiTimeStamp.length>5&&poorTimeStamp>86400)||notifiTimeStamp.length==0) {
        NSLog(@"1");
        /*推送开启？*/
        if (![DeviceInfoManage checkIsSettingNotification]&&[[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
            //NSLog(@"11");
            //close
            BFNotificationPopView *notificationPopView = [[BFNotificationPopView alloc] initWithFrame:SCREEN_BOUNDS];
            [notificationPopView showPopView];
        }
    }
}


@end
