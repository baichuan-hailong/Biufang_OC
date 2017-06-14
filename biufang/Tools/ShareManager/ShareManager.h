//
//  ShareManager.h
//  biufang
//
//  Created by 杜海龙 on 16/10/25.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShareManager : NSObject<MFMessageComposeViewControllerDelegate>

/*
 约定
 GBN 赠送Biu房号码
 FDS 房屋详情
 GRE 赠送红包
 
 INF 邀请奖励
 */

+ (instancetype)defaulShaer;

- (void)shareWechatSession:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
- (void)shareWechatTimeLine:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
- (void)shareQQ:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
- (void)shareQQZone:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
- (void)shareWebo:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
- (void)shareSms:(UIViewController *)vc type:(NSString *)type sn:(NSString *)sn token:(NSString *)token biuNumCount:(NSString *)biuNumCount;
@end
