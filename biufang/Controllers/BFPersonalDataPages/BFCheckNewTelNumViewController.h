//
//  BFCheckNewTelNumViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFCheckNewTelNumViewController : BFBaseViewController


/*
 约定
 
 BEX            兑换记录
 
 BiuBEX         Biu币首页兑换
 
 BClassEX       分类页兑换
 
 BDetailEX      详情页
 
 FangDetailPage 房屋详情页
 */

//入口
@property (nonatomic , strong) NSString *entranceType;

@property (nonatomic , assign) BOOL     isLogin;

@property (nonatomic , strong) NSString *typeStr;

@end
