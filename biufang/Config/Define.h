//
//  Define.h
//  biufang
//
//  Created by 娄耀文 on 16/9/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#ifndef Define_h
#define Define_h


//dev
#define API                  @"http://api.wanbangbang.cn/v1.0"
//UM
#define UMAppKey             @"575e8ed267e58ed681001e35"
//阿里云
#define AliBucket            @"biufang-dev"
//幸运号码计算页面
#define luckNumberUrl        @"http://dev.wanbangbang.cn/biufang-h5/luckNumMethod.html"
//房屋详情分享
#define BaseH5DetailUrl      @"http://dev.wanbangbang.cn/biufang-h5/detail.html"
//赠送Biu房号码
#define BaseH5GiveBiuNumsUrl @"http://api.wanbangbang.cn/v1.0/web/share"
//赠送红包
#define BaseH5RedpacketUrl   @"http://dev.wanbangbang.cn/biufang-h5/redpacket.html"
//支持者服务平台
#define serviceUrl           @"http://static-dev.wanbangbang.cn/web/rules/service.html"
//活动规则&新手指南
#define activityUrl          @"http://static-dev.wanbangbang.cn/web/rules/guide.html"
//邀请奖励
#define inviteReward         @"http://dev.wanbangbang.cn/biufang-h5/invite.html"
//通用连接跳转
#define UniversalLink        @"web-dev.biufang.cn"
//dev
 





//product
//#define API                  @"https://api.biufang.cn/v1.0"
////UM
//#define UMAppKey             @"584bc9b3e88bad0327001afb"
////阿里云
//#define AliBucket            @"biufang"
////幸运号码计算页面
//#define luckNumberUrl        @"https://web.biufang.cn/luckNumMethod.html"
////房屋详情分享
//#define BaseH5DetailUrl      @"https://web.biufang.cn/detail.html"
////赠送红包
//#define BaseH5RedpacketUrl   @"https://web.biufang.cn/redpacket.html"
////支持者服务平台
//#define serviceUrl           @"https://static.biufang.cn/web/rules/service.html"
////活动规则&新手指南
//#define activityUrl          @"https://static.biufang.cn/web/rules/guide.html"
////赠送Biu房号码
//#define BaseH5GiveBiuNumsUrl @"http://api.wanbangbang.cn/v1.0/web/share"
////邀请奖励
//#define inviteReward         @"https://web.biufang.cn/invite.html"
////通用连接跳转
//#define UniversalLink        @"web.biufang.cn"
//product



//版本
#define VERSION        @"1.1.2"

//登陆时间
#define LoginTimeStamp @"loginTimeStamp"

//推送弹起时间
#define notificationPopTimeStamp @"notificationPopTimeStamp"

//AppID iTuns
#define AppIDituns     @"1168501744"

//*** 屏幕尺寸 ***//
#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)


//*** NSUserDefault本地存储Key(通用) ***//
#define IS_LOGIN     @"is_user_login" //用户是否登录
#define DEVICE_TOKEN @"DEVICE_TOKEN"  //DEVICE_TOKEN
#define IS_NetWork   @"network"       //是否有网
#define WechatBugKey @"wechatBugKey"  //wechatBug

//*** 用户信息 ***//
#define TOKEN        @"user_TOKEN"     //TOKEN
#define USERNAME     @"user_name"      //用手机号
#define NICKNAME     @"nick_name"      //用户昵称
#define PASSWORD     @"user_paswer"    //用户密码
#define USER_AVATAR  @"user_avatar"    //用户头像
#define REAL_NAME    @"real_name"      //真实姓名
#define USER_ID      @"user_ID"        //用户ID
#define CARD_ID      @"card_ID"        //身份证ID
#define CITY         @"current_city"   //当前城市

#define VERIFYKEY    @"user_verify_key"//临时
#define IS_First     @"is_first"       //是否第一次启动程序

#define IS_OnSwitch  @"is_onSwitch"    //是否使用优惠红包

#define Order_Address @"order_Address" //收货地址

//hailong
#define WechatAppID     @"wxd5e0ae546fdcbc39"
#define wechatAppSecret @"06e925b838922a5e0f7866feca84297c"

//pay wechat appID
#define payWechatAppID  @"wxa928859d537f70a1"

#define QQAppKey        @"SqdsYYKSByNFf05X"
#define QQAppID         @"1105796779"
#define QQAppSecret     @""
#define SinaAppKey      @"4112314103"
#define SinaAppSecret   @"d44520c0e64a8a03acaaf6baaf855dd7"

#define PLACEHOLDERKEY  @"placeholderLabel"

//Devices
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080,1920), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750,1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)

//nslog
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#endif

//colors
#define BACK_COLOR @"f7f7f7"
//#define RED_COLOR  @"fb344c"
//#define RED_COLOR  @"ff2b6f"
#define RED_COLOR  @"fe4667"


#endif /* Define_h */
