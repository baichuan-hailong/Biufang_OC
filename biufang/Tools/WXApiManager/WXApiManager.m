//
//  WXApiManager.m
//  biufang
//
//  Created by 杜海龙 on 16/9/30.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "WXApiManager.h"

@interface WXApiManager ()
@property (nonatomic , strong) MBProgressHUD *HUD;
@end

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}


#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    [WXApi registerApp:payWechatAppID withDescription:@"newbiufang"];
    
    NSLog(@"%@",resp);
    if ([resp isKindOfClass:[PayReq class]]) {//pay
        
        NSLog(@"wechat pay");
        PayResp *response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                NSLog(@"wechat pay successful");
                break;
            default:
                NSLog(@"wechat pay failed");
                break;
        }
        
        
    }else if ([resp isKindOfClass:[SendAuthResp class]]) {   //auth
        SendAuthResp *temp = (SendAuthResp *)resp;
        NSLog(@"%@",temp.code);
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.HUD = [[MBProgressHUD alloc] initWithView:keyWindow];
        [keyWindow addSubview:self.HUD];
        [self.HUD show:YES];
        
        NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WechatAppID, wechatAppSecret, temp.code];
        //wechatLoginUnionid
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:accessUrlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
            //NSLog(@"微信授权 --- %@",object);
            
            if (![object isEqual:[NSNull null]]) {
                NSDictionary *accessDict = [NSDictionary dictionaryWithDictionary:object];
                NSString *openId = [NSString stringWithFormat:@"%@",accessDict[@"openid"]];
                if (openId.length>10) {
                    [self wechatUserInfoWithToke:accessDict[@"access_token"] openID:accessDict[@"openid"]];
                }else{
                    [self.HUD hide:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLoginUnionidFailed" object:nil];
                }
            }
            
            
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.HUD hide:YES];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }
    //SendMessageToWXResp class share
}





- (void)onReq:(BaseReq *)req {
    
    NSLog(@"%@",req);
}


- (void)wechatUserInfoWithToke:(NSString *)accessToken openID:(NSString *)openid{
    
    NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken, openid];
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:accessUrlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"微信第三方信息 --- %@",object);
        [self.HUD hide:YES];
        
        if (![object isEqual:[NSNull null]]) {
            NSString *openId = [NSString stringWithFormat:@"%@",object[@"openid"]];
            if (openId.length>10) {
                [[NSUserDefaults standardUserDefaults] setObject:object[@"nickname"] forKey:@"bindUserName"];
                [[NSUserDefaults standardUserDefaults] setObject:object[@"headimgurl"] forKey:@"bindUserIconURL"];
                [[NSUserDefaults standardUserDefaults] setObject:object[@"unionid"] forKey:@"bindUserUnionid"];
                [[NSUserDefaults standardUserDefaults] setObject:object[@"openid"] forKey:@"bindUserOpenid"];
                
                NSDictionary *dic = @{@"unionid":object[@"openid"]};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatLoginUnionid" object:dic];
            }
        }
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.HUD hide:YES];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}



//wechar login
- (void)wechatLogin{

    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"App";
    [WXApi sendReq:req];
}



////wechat pay
- (void)wechatPayParameter:(NSDictionary *)payload{

    NSString *partnerId           = [NSString stringWithFormat:@"%@",payload[@"partnerid"]];
    NSString *prepayId            = [NSString stringWithFormat:@"%@",payload[@"prepayid"]];
    NSMutableString *stamp        = [payload objectForKey:@"timestamp"];
    NSString *timeStamp           = stamp;
    NSString *nonceStr            = [NSString stringWithFormat:@"%@",payload[@"noncestr"]];
    NSString *package             = [NSString stringWithFormat:@"%@",payload[@"pack"]];
    NSString *sign                = [NSString stringWithFormat:@"%@",payload[@"sign"]];
    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = partnerId;
    req.prepayId            = prepayId;
    req.timeStamp           = timeStamp.intValue;
    req.nonceStr            = nonceStr;
    req.package             = package;
    req.sign                = sign;
    [WXApi sendReq:req];
}


//wechat share
- (void)wechatShareTitle:(NSString *)title description:(NSString *)des image:(UIImage *)img url:(NSString *)url type:(BOOL)type{

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = des;
    [message setThumbImage:img];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl   = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if (type) {
        req.scene = WXSceneSession;  //好友
    }else{
        req.scene = WXSceneTimeline; //朋友圈
    }
    [WXApi sendReq:req];
}




/*
 self.partnerId           = [NSString stringWithFormat:@"%@",payload[@"partnerid"]];
 self.prepayId            = [NSString stringWithFormat:@"%@",payload[@"prepayid"]];
 NSMutableString *stamp   = [payload objectForKey:@"timestamp"];
 self.timeStamp           = stamp;
 self.nonceStr            = [NSString stringWithFormat:@"%@",payload[@"noncestr"]];
 self.package             = [NSString stringWithFormat:@"%@",payload[@"package"]];
 self.sign                = [NSString stringWithFormat:@"%@",payload[@"sign"]];
 //NSLog(@"%@ --- %@ --- %@ --- %@ --- %@ --- %@",self.partnerId,self.prepayId,self.timeStamp,self.nonceStr,self.package,self.sign);
 PayReq* req             = [[PayReq alloc] init];
 req.partnerId           = self.partnerId;
 req.prepayId            = self.prepayId;
 req.timeStamp           = self.timeStamp.intValue;
 req.nonceStr            = self.nonceStr;
 req.package             = self.package;
 req.sign                = self.sign;
 [WXApi sendReq:req];*/

@end
