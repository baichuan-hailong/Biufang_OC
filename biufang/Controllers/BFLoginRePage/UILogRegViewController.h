//
//  UILogRegViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPresentBaseViewController.h"

//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://geo.itunes.apple.com/cn/app/id1136978764"]];
@interface UILogRegViewController : BFPresentBaseViewController

/*
 
 BEX            兑换记录
 
 BiuBEX         Biu币首页兑换
 
 BClassEX       分类页兑换
 
 BDetailEX      详情页
 
 FangDetailPage 房屋详情页
 
 FangCategaryPage 分类页
 
 MySelf         我的
 
 MyMoney        我的红包页
 
 MyBiuRecord    我的biu房记录
 
 DetailBiuNumbers 房屋详情进入我的Biu房号码
 
 NewUserRed       新人红包页登录
 
 */

//入口
@property (nonatomic , strong) NSString *entranceType;





@end
