//
//  UMManager.m
//  biufang
//
//  Created by 杜海龙 on 16/10/8.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "UMManager.h"



//#import <UMSocialCore/UMSocialCore.h>

//#import "UMSocialQQHandler.h"
//#import "UMSocialSinaHandler.h"

@implementation UMManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static UMManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UMManager alloc] init];
    });
    return instance;
}

- (void)loadingAnalytics{

    UMConfigInstance.appKey    = UMAppKey;
    //UMConfigInstance.channelId = @"App Store";
    //UMConfigInstance.eSType    = E_UM_GAME;    
    //version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@",version);
    [MobClick setAppVersion:version];
    
    //错误统计
    [MobClick setCrashReportEnabled:YES];

    [MobClick startWithConfigure:UMConfigInstance];//init SDK
    
    
    
}

//账号统计
- (void)accountStatistics{

    UMConfigInstance.appKey    = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *idStr  = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    [MobClick profileSignInWithPUID:idStr];
    
    
}

//分享统计
- (void)shareAnalytics{

    //统计
    NSString *idstr  = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    MobClickSocialWeibo *QQ=[[MobClickSocialWeibo alloc] initWithPlatformType:MobClickSocialTypeSina weiboId:nil usid:idstr param:nil];
    [MobClickSocialAnalytics postWeiboCounts:@[QQ] appKey:UMAppKey topic:@"QQFriend分享" completion:nil];
}




//UM Share --- QQ Weibo
- (void)loadingShareSettingAction{
    
    
    //打开调试日志
//    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
//    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    
    //设置分享到QQ互联的appKey和appSecret
    //[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppKey  appSecret:QQAppSecret redirectURL:nil];
    
//    [[UMSocialQQHandler defaultManager] setSupportWebView:YES];
//    [[UMSocialQQHandler defaultManager] setAppId:nil appSecret:nil url:nil];
    
    
    
    //设置新浪的appKey和appSecret
    //[[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppKey  appSecret:SinaAppSecret redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//    [[UMSocialSinaHandler defaultManager] setAppId:nil appSecret:nil url:nil];
    
}























@end
