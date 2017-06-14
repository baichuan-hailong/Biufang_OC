//
//  ShareManager.m
//  biufang
//
//  Created by 杜海龙 on 16/10/25.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "ShareManager.h"

//static NSString *shareUrl = [NSString stringWithFormat:@"%@/biufang-h5/detail.html",BaseH5Url];
//static NSString *sharePayUrl = @"http://dev.wanbangbang.cn/biufang-h5/redpacket.html";

@implementation ShareManager
+(instancetype)defaulShaer {
    static dispatch_once_t onceToken;
    static ShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[ShareManager alloc] init];
    });
    return instance;
}


/*
 约定
 GBN 赠送Biu房号码
 FDS 房屋详情
 GRE 赠送红包
 */

//好友
-(void)shareWechatSession:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{

    
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    //NSLog(@"ID：%@ 头像：%@ 昵称：%@",user_id,avatar,nickName);
    //打开日志
    //[UMSocialData openLog:YES];
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    
    if ([type isEqualToString:@"FDS"]) {
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        titleStr   = [NSString stringWithFormat:@"仅需1元抢？%@",token];
        contentStr = @"Biu房——让年轻人一元抢房APP，让你只需要零花钱既有机会获得百万房产，动动手指，花花小钱，百万房产等，一元开抢！";
    }else if ([type isEqualToString:@"GBN"]) {
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        titleStr   = @"亲，送钱不如送房，所以我打算送你一套，点击领取!";
        contentStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
    }else if ([type isEqualToString:@"GRE"]) {
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        titleStr   = @"快来拿红包！Biu房APP,让你一元买房！";
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
    
    }else if ([type isEqualToString:@"INF"]) {
    
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢!";
        contentStr = @"Biu房,一元买房的神奇APP，红包拿到手软！";
        
    }
    
    [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:wechatAppSecret url:urlStr];
    [UMSocialDataService defaultDataService].socialData.extConfig.wechatSessionData.title = titleStr;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:contentStr image:[UIImage imageNamed:@"shareIcon"] location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:urlStr] presentedController:vc completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
    }];
}


//shareIcon
//朋友圈
-(void)shareWechatTimeLine:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{

    
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    //NSLog(@"ID：%@ 头像：%@ 昵称：%@",user_id,avatar,nickName);
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    //打开日志
    //[UMSocialData openLog:YES];
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    if ([type isEqualToString:@"FDS"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        titleStr   = [NSString stringWithFormat:@"仅需1元抢？%@",token];
        contentStr = @"Biu房——让年轻人一元抢房APP，让你只需要零花钱既有机会获得百万房产，动动手指，花花小钱，百万房产等，一元开抢！";
    }else if ([type isEqualToString:@"GBN"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        
        titleStr   = @"亲，送钱不如送房，所以我打算送你一套，点击领取!";
        contentStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
    }else if ([type isEqualToString:@"GRE"]) {
        
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        titleStr   = @"快来拿红包！Biu房APP,让你一元买房！";
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
    }else if ([type isEqualToString:@"INF"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢!";
        contentStr = @"Biu房,一元买房的神奇APP，红包拿到手软！";
    }
    
    [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:wechatAppSecret url:urlStr];
    [UMSocialDataService defaultDataService].socialData.extConfig.wechatSessionData.title = titleStr;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:titleStr image:[UIImage imageNamed:@"shareIcon"] location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:urlStr] presentedController:vc completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"success");
        }else{
            
            NSLog(@"failed");
        }
        
    }];
}


//QQ
-(void)shareQQ:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{

    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    //NSLog(@"ID：%@ 头像：%@ 昵称：%@",user_id,avatar,nickName);
    //打开日志
    //[UMSocialData openLog:YES];
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    if ([type isEqualToString:@"FDS"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        titleStr   = [NSString stringWithFormat:@"仅需1元抢？%@",token];
        contentStr = @"Biu房——让年轻人一元抢房APP，让你只需要零花钱既有机会获得百万房产，动动手指，花花小钱，百万房产等，一元开抢！";
    }else if ([type isEqualToString:@"GBN"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        
        titleStr   = @"亲，送钱不如送房，所以我打算送你一套，点击领取!";
        contentStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
        
        //[UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:urlStr];
    }else if ([type isEqualToString:@"GRE"]) {
        
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        titleStr   = @"快来拿红包！Biu房APP,让你一元买房！";
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
        
        //[UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:urlStr];
    }else if ([type isEqualToString:@"INF"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢!";
        contentStr = @"Biu房,一元买房的神奇APP，红包拿到手软！";
    }
    
    NSLog(@"分享H5 --- %@",urlStr);
    
    NSString *new_url=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:new_url];
    
    [UMSocialDataService defaultDataService].socialData.extConfig.qqData.title = titleStr;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:contentStr image:[UIImage imageNamed:@"shareIcon"] location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:urlStr] presentedController:vc completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
    }];
}



//QQZone
-(void)shareQQZone:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{
    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    //NSLog(@"ID：%@ 头像：%@ 昵称：%@",user_id,avatar,nickName);
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    //打开日志
    //[UMSocialData openLog:YES];
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    if ([type isEqualToString:@"FDS"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        titleStr   = [NSString stringWithFormat:@"仅需1元抢？%@",token];
        contentStr = @"Biu房——让年轻人一元抢房APP，让你只需要零花钱既有机会获得百万房产，动动手指，花花小钱，百万房产等，一元开抢！";
    }else if ([type isEqualToString:@"GBN"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        
        titleStr   = @"亲，送钱不如送房，所以我打算送你一套，点击领取!";
        contentStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
        
        
    }else if ([type isEqualToString:@"GRE"]) {
        
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        titleStr   = @"快来拿红包！Biu房APP,让你一元买房！";
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
    }else if ([type isEqualToString:@"INF"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢!";
        contentStr = @"Biu房,一元买房的神奇APP，红包拿到手软！";
    }
    NSString *new_url=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:new_url];
    
    
    [UMSocialDataService defaultDataService].socialData.extConfig.qqData.title = titleStr;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:titleStr image:[UIImage imageNamed:@"shareIcon"] location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:urlStr] presentedController:vc completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
    }];
}


-(void)shareSms:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{

    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    //@"ID：%@ 头像：%@ 昵称：%@",user_id,avatar,nickName
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    //打开日志
    //[UMSocialData openLog:YES];
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    if ([type isEqualToString:@"FDS"]) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
            
            urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        }else{
        
            urlStr = [NSString stringWithFormat:@"%@?sn=%@",BaseH5DetailUrl,sn];
        }
        
        
        
        titleStr   = [NSString stringWithFormat:@"1元抢房你信不信？%@1元开抢！详情请见：",token];
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
        
    }else if ([type isEqualToString:@"GBN"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        
        
        titleStr   = @"亲，送钱不如送房，所以我打算送你一套，点击领取!";
        contentStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
        
        
    }else if ([type isEqualToString:@"GRE"]) {
        
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        titleStr   = @"快来拿红包！Biu房APP,让你一元买房！";
        contentStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
    }else if ([type isEqualToString:@"INF"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢！详情点击URL";
        contentStr = @"邀请奖励1";
    }
    
    
    //判断是否能发短息
    if( [MFMessageComposeViewController canSendText] ){
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.recipients = [NSArray arrayWithObject:@"选择联系人"];//接收人,可以有很多,放入数组
        NSString *new_url=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        controller.body = [NSString stringWithFormat:@"%@ %@",titleStr,new_url]; //短信内容,自定义即可
        controller.messageComposeDelegate = self; //注意不是delegate
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"邀请好友"];//修改短信界面标题
        //controller.modalPresentationStyle = UIModalPresentationCurrentContext;
        [vc presentViewController:controller animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"抱歉" message:@"短信功能不可用!" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alert show];
    }
    
}




 -(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
 
     [controller dismissViewControllerAnimated:YES completion:nil];
     switch (result){
     case MessageComposeResultCancelled:{
     //cancled
     NSLog(@"cancled");
     }
     break;
     //failed
     case MessageComposeResultFailed:{
     NSLog(@"failed");
     
     }
     break;
     //successful
     case MessageComposeResultSent:{
     NSLog(@"successful");
     
     }
     break;
     default:
     break;
     }
 }
 



-(void)shareWebo:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount{

    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
                                              secret:SinaAppSecret
                                         RedirectURL:@"http://www.biufang.cn"];

    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
    if (nickName.length==0) {
        nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }
    
    //设置友盟appkey
    [UMSocialData setAppKey:UMAppKey];
    
    NSString *urlStr;
    NSString *titleStr;
    NSString *contentStr;
    
    if ([type isEqualToString:@"FDS"]) {
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5DetailUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        contentStr = [NSString stringWithFormat:@"仅需1元抢？%@你绝对想象不到，一块钱抢iPhone7，还能花一块抢到房",token];
        titleStr = @"Biu房——让年轻人一元抢房APP，让你只需要零花钱既有机会获得百万房产，动动手指，花花小钱，百万房产等，一元开抢！";
    }else if ([type isEqualToString:@"GBN"]) {
        urlStr = [NSString stringWithFormat:@"%@?sn=%@&token=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5GiveBiuNumsUrl,sn,token,user_id,nickName,avatar,biuNumCount,@"biu_num"];
        contentStr = @"亲，送钱不如送房，所以我打算送你一套，点击领取!你绝对想象不到，一块钱抢iPhone7，还能花一块抢到房";
        titleStr = @"北上广房价都5万了，工资才4000怎么活？没关系，用Biu房，花一块钱买一套房";
        //[UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:urlStr];
    }else if ([type isEqualToString:@"GRE"]) {
        //urlStr = [NSString stringWithFormat:@"%@?sn=%@&id=%@&nickname=%@&avatar=%@&biu_num_count=%@&type=%@",BaseH5RedpacketUrl,sn,user_id,nickName,avatar,biuNumCount,@"redpacket"];
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&sn=%@&biu_price=%@",BaseH5RedpacketUrl,avatar,nickName,sn,token];
        contentStr   = @"快来拿红包！Biu房APP,让你一元买房！你绝对想象不到，一块钱抢iPhone7，还能花一块抢到房";
        titleStr = @"Biu房—让年轻人一元买房APP，让你只需要零花钱既有机会获得百万房产，动动手指头，花花零花钱，百万房产等你来Biu！";
        //[UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:urlStr];
    }else if ([type isEqualToString:@"INF"]) {
        
        urlStr = [NSString stringWithFormat:@"%@?avatar=%@&nickname=%@&user_id=%@&type=1",inviteReward,avatar,nickName,user_id];
        titleStr   = @"我正在一元抢房，你快来帮我一起抢!";
        contentStr = @"Biu房,一元买房的神奇APP，红包拿到手软！你绝对想象不到，一块钱抢iPhone7，还能花一块抢到房";
    }
    //NSLog(@"分享H5 --- %@",urlStr);
    NSString *new_url=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:new_url];
    
    //NSString *contStrUrl = [NSString stringWithFormat:@"%@",titleStr];
    //NSLog(@"------- %@",contStrUrl);
    //NSLog(@" -------- %ld",(unsigned long)contStrUrl.length);
    
    [UMSocialDataService defaultDataService].socialData.extConfig.title = titleStr;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:contentStr image:[UIImage imageNamed:@"shareIcon"] location:nil urlResource:[[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:new_url] presentedController:vc completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"success");
        }else{
            NSLog(@"failed");
        }
    }];
}




@end
