//
//  CheckNetManage.m
//  biufang
//
//  Created by 杜海龙 on 16/10/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "CheckNetManage.h"

@implementation CheckNetManage


+(void)checkCurrentNetStateWindow:(UIWindow *)window{

    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowNetPross"];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //未知
                //[self showProgress:@"未知" window:window];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //没有网络
                [self showProgress:@"网络连接失败，请检查您的网络" window:window];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_NetWork];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //3G|4G
                [self showProgress:@"已切换至移动网络环境" window:window];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //WIFI
                [self showProgress:@"已切换至WIFI" window:window];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
                break;
            default:
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
                break;
        }
    }];
    [manager startMonitoring];
}



//MBProgress
+ (void)showProgress:(NSString *)tipStr window:(UIWindow *)window{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShowNetPross"]) {
        //只显示文字
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = tipStr;
        hud.margin = 20.f;
        //hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1];
    }else{
    
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowNetPross"];
        
    }
    
    
}

@end
