//
//  AppDelegate.m
//  biufang
//
//  Created by 娄耀文 on 16/9/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "AppDelegate.h"
#import "BFTabBarController.h"
#import "WXApiManager.h"

#import "HomeViewController.h"
#import "BFMiddleViewController.h"
#import "BFFundViewController.h"
#import "BFMyselfViewController.h"
#import "UILogRegViewController.h"

#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>

#import "BFGuideView.h"
#import "BFFlashAdView.h"

@interface AppDelegate () <UITabBarControllerDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, assign) NSInteger    fontInteger;
@property (nonatomic, strong) BFGuideView  *guideView;
@property (nonatomic, assign) NSInteger    previousClickedTag; /** 记录上一次被点击按钮的tag */
@property (nonatomic, strong) NSDictionary *adInfo;            /** 闪屏广告 **/
@property (nonatomic, strong) NSDictionary *winInfo;           /** 获奖信息 **/
@property (nonatomic, assign) BOOL         isRequestAd;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"AppLaunch"];
    
    //[NSThread sleepForTimeInterval:1];
    //友盟推送集成
    [self UMessageNotification:launchOptions];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [CheckNetManage checkCurrentNetStateWindow:self.window];
    self.window.backgroundColor = [UIColor whiteColor];

    UITabBarController *bfTabBarController = [[UITabBarController alloc] init];
    bfTabBarController.delegate = self;
    [BFTabBarController addAllChildViewController:bfTabBarController];
     self.window.rootViewController = bfTabBarController;
    [self.window makeKeyAndVisible];
    [self flashAdView];
    
    //Guide pages
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_First]) {
        
        self.guideView = [[BFGuideView alloc] initWithFrame:SCREEN_BOUNDS];
        [self.guideView.startButton addTarget:self action:@selector(guideStartButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
    }
    
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    
    //regist for WX
    [WXApi registerApp:WechatAppID withDescription:@"newbiufang"];
    return YES;
}


#pragma mark - 引导页按钮
- (void)guideStartButtonDidClicked:(UIButton *)sender{
    
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.38 animations:^{
        self.guideView.alpha = 0;
        self.guideView.frame = CGRectMake(0, 0, SCREEN_WIDTH*1.0, SCREEN_HEIGHT*1.2);
    } completion:^(BOOL finished) {
        [self.guideView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"firstSelectCity" object:nil];
    }];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //bug
    [UMSocialSnsService handleOpenURL:url];
    
    //alipay
    if ([url.host isEqualToString:@"safepay"]) {
        //call back
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //NSLog(@"result = %@",resultDic);
            //NSLog(@"result = %@",resultDic[@"memo"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            //pay successful
            if ([stateStr isEqualToString:@"9000"]) {
                //BUG
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                NSLog(@"pay successful");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
            }else{
                //BUG
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                NSLog(@"pay failed");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailed" object:nil];
            }
            
        }];
    }
    
    //wechat pay
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return result;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    if ([url.host isEqualToString:@"safepay"]) {
        
        //bug
        [UMSocialSnsService handleOpenURL:url];
        
        //AlipaySDK
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //NSLog(@"result = %@",resultDic);
            //NSLog(@"result = %@",resultDic[@"memo"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            //pay successful
            if ([stateStr isEqualToString:@"9000"]) {
                //BUG
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                NSLog(@"pay successful");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
            }else{
                //BUG
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                NSLog(@"pay failed");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailed" object:nil];
            }
        }];
    }
    
    //wechat pay
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

#pragma mark - 友盟推送集成
- (void)UMessageNotification:(NSDictionary * __nullable)launchOptions {

    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions httpsenable:YES];
    [UMessage registerForRemoteNotifications];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNAuthorizationOptions types10 = UNAuthorizationOptionBadge |  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        } else {
        }
    }];
    [UMessage setLogEnabled:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *device_token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[NSUserDefaults standardUserDefaults] setObject:device_token forKey:DEVICE_TOKEN];
    
    NSLog(@"DEVICE_TOKEN : %@",device_token);
    
    //*** 上传DEVICE_TOKEN ***//
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]&&[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
        
        NSString     *urlStr = [NSString stringWithFormat:@"%@/user/push",API];
        NSDictionary *param  = @{@"device_token":device_token,
                                 @"device_os":@"ios",
                                 @"badge":@(0)};
        
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
            
            //NSLog(@"userPush : %@",object);
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        } progress:^(float progress) {}];

    }
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSLog(@"iOS10以下userInfo: %@",userInfo);
    if ([[NSString stringWithFormat:@"%@",userInfo[@"cmd"]] isEqualToString:@"win"]) {
        //中奖弹窗
        _winInfo = userInfo;
        [self winingShow];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    });
}


//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSLog(@"iOS10%@",userInfo);
    if ([[NSString stringWithFormat:@"%@",userInfo[@"cmd"]] isEqualToString:@"win"]) {
        _winInfo = userInfo;
        [self winingShow];
    }
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [UMessage setAutoAlert:NO];
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    });
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {

        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    });
}

#pragma mark - Winner弹窗代理
- (void)winingShow{
    
    BFWinningView *winingView = [[BFWinningView alloc] initWithFrame:SCREEN_BOUNDS];
    winingView.delegate = self;
    [winingView showWinPop];
    
    
    //请求一次中奖检测接口，防止重复弹窗
    NSString *urlStr = [NSString stringWithFormat:@"%@/common/todo",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"%@",object);
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}

-(void)lookDetail:(UIButton *)sender{

    NSDictionary *winInfo = _winInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getWinner" object:nil userInfo:winInfo];
}





#pragma mark - 闪屏广告
- (void)flashAdView {
    
    //同步请求广告，1.38秒超时时间
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/common/ad-flash",API]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:1.38];
    NSData       *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString     *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    _adInfo = (NSDictionary *)[myToolsClass nsstringToJson:str];
    
    if (![[NSString stringWithFormat:@"%@",_adInfo[@"data"]] isEqualToString:@"<null>"] && _adInfo[@"data"]) {
        
        //*** 闪屏广告 ***//
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_First]) {
            
            NSLog(@"%@",_adInfo);
            NSURL   *netUrl = [[NSURL alloc] initWithString:_adInfo[@"data"][@"img"]];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:netUrl cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:1.38];
            NSData  *data   = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            UIImage *image  = [UIImage imageWithData:data];
            
            if (image == nil) {
                
                NSLog(@"图片加载太慢，直接进入首页");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"checkUpdateWinner" object:nil];
            } else {
                
                //统计闪屏广告出现次数
                [UMSocialData setAppKey:UMAppKey];
                [MobClick event:@"ADFlashDispaly"];
                
                self.window.rootViewController.view.alpha = 0;
                BFFlashAdView *splashImageView = [BFFlashAdView sharedManager];
                [self.window addSubview:splashImageView];
                [splashImageView showFlashAdView:_adInfo andImage:image];
                
                self.window.rootViewController.view.alpha = 1.0;
                
//                [UIView animateWithDuration:3.0 animations:^{
//                    
//                    self.window.rootViewController.view.alpha = 1.0;
//                    
//                } completion:^(BOOL finished) {
//                    
//                    [UIView animateWithDuration:0.38 animations:^{
//                        [splashImageView hideFlashAdView];
//                    } completion:^(BOOL finished) {
//                        [splashImageView removeFromSuperview];
//                    }];
//                }];
            }
        }
    } else {
        NSLog(@"没有请求到广告，直接进入首页");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkUpdateWinner" object:nil];
    }
}



#pragma mark - UITabbarDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    //判断当前按钮是否为上一个按钮,再次刷新
    if (self.previousClickedTag == tabBarController.selectedIndex) {
        NSDictionary *indexDic = @{@"index":[NSNumber numberWithInteger:tabBarController.selectedIndex]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarRepeatAction" object:nil userInfo:indexDic];
    }
    
    //tabbar切换到首页的时候刷新列表
    if (self.previousClickedTag != tabBarController.selectedIndex && tabBarController.selectedIndex == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarToHome" object:nil];
    }
    
    self.previousClickedTag = tabBarController.selectedIndex;
    
    
    if (tabBarController.selectedIndex==1) {
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"PublishListPageClick"];
    }
    
    
    if (tabBarController.selectedIndex==2) {
        
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"MoneyBiuPageClick"];
    }
    
    if (tabBarController.selectedIndex==3) {
        
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"MyPageClick"];
    }
    
    if (tabBarController.selectedIndex!=3){
        _fontInteger = tabBarController.selectedIndex;
    }
    //NSLog(@"selected %ld",tabBarController.selectedIndex);
    
    
    if (tabBarController.selectedIndex==3&&![[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        [tabBarController setSelectedIndex:_fontInteger];
        
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        loginRegVC.entranceType = @"MySelf";
        //[tabBarController presentViewController:loginRegNC animated:YES completion:nil];
        [self.window.rootViewController presentViewController:loginRegNC animated:YES completion:nil];
    }
}


#pragma mark - Universal Link
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *webpageURL = userActivity.webpageURL;
        NSString *host = webpageURL.host;
        
        NSString *good_id = [myToolsClass paramValueOfUrl:[NSString stringWithFormat:@"%@",webpageURL] withParam:@"id"];
        NSLog(@"Universal Link : %@\n\n通用连接参数 : %@\n\nhost : %@\n\n",webpageURL,good_id,host);
        
        if ([host isEqualToString:@"a.biufang.cn"]) {
            //进行我们需要的处理
            
            if (good_id != nil &&
                ![good_id isEqualToString:@"0"] &&
                ![good_id isEqualToString:@"(null)"] &&
                ![good_id isEqualToString:@""]) {
                
                //有id,跳转商品详情页
                NSDictionary *dic = @{@"good_id":good_id};
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.38 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UniversalLinkJump" object:self userInfo:dic];
                });
                
            }

        } else {
            //safari打开
            //[[UIApplication sharedApplication] openURL:webpageURL];
        }
        
    }
    return YES;
    
}




- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];

}



@end
