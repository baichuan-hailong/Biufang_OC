//
//  BFMakeOrderView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMakeOrderView : UIView

//刷新
@property (nonatomic , strong) UILabel *refresh;

//community name
@property (nonatomic , strong) UILabel *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel *issueNumberLabel;
//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;

//还可购买次数
@property (nonatomic , strong) UILabel *willBuyCountLabel;
//count -
@property (nonatomic , strong) UIButton *leftCountButton;
//count +
@property (nonatomic , strong) UIButton *rightCountButton;
//order count
@property (nonatomic , strong) UITextField *orderCountTextField;
//100/人次
@property (nonatomic , strong) UILabel *renciLabel;

//滑杆
@property (nonatomic , strong) UIButton *oneGearButton;
@property (nonatomic , strong) UIButton *towGearButton;
@property (nonatomic , strong) UIButton *threeGearButton;
@property (nonatomic , strong) UIButton *fourGearButton;

@property (nonatomic , strong) UILabel *towGearLabel;
@property (nonatomic , strong) UILabel *threeGearLabel;
@property (nonatomic , strong) UILabel *fourGearLabel;

//3
//红包3
@property (nonatomic , strong) UIView *redenvelopeView;
//红包优惠
@property (nonatomic , strong) UILabel *redMoneyLabel;


//订单金额
@property (nonatomic , strong) UILabel *orderMoneyLabel;
//优惠金额
@property (nonatomic , strong) UILabel *preferentialMoneyLabel;
//合计付款
@property (nonatomic , strong) UILabel *combinedMoneyLabel;
//送价值¥240.00的Biu币
@property (nonatomic , strong) UILabel *biuMoneyLabel;

//订单4
@property (nonatomic , strong) UIView *orderView;
//方式5
@property (nonatomic , strong) UIView *payTypeView;
//付款方式
@property (nonatomic , strong) UIView *payLine;
//付款方式
//wechat
@property (nonatomic , strong) UIView *wechatTypeView;
@property (nonatomic , strong) UIImageView *wechatTypeImageView;
//ali
@property (nonatomic , strong) UIView *aliTypeView;
@property (nonatomic , strong) UIImageView *aliTypeImageView;


//结算
//实付款
@property (nonatomic , strong) UILabel *actualMoneyLabel;
@property (nonatomic , strong) UIButton *settlementButton;


//结算6
@property (nonatomic , strong) UIView *sureView;
@end
