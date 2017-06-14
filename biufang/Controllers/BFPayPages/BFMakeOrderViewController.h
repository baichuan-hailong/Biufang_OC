//
//  BFMakeOrderViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
//private mac
@interface BFMakeOrderViewController : BFBaseViewController
{
    NSInteger limitCount;
    NSInteger biuPriceCount;  //单价
    NSInteger totalProceCou;  //总价
    
}

//数量
@property (nonatomic,copy)NSString    *orderCount;

//总价
@property (nonatomic,copy)NSString    *totalPriceCountStr;

@property (nonatomic , copy) NSString *fang_id;

@property (nonatomic , copy) NSString *issue_number;

//红包
@property (nonatomic , strong) NSArray *redmoneyArray;
//档位
@property (nonatomic , strong) NSArray *fixArray;
//标题
@property (nonatomic,copy)NSString *fang_title;
//期号
@property (nonatomic,copy)NSString *fang_sn;
//fang url
@property (nonatomic,copy)NSString *fang_url;
//iswechat
@property (nonatomic,copy)NSString *isWechatonLine;

@end
