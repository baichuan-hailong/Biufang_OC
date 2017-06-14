//
//  AliPayManager.m
//  biufang
//
//  Created by 杜海龙 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "AliPayManager.h"

@implementation AliPayManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AliPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AliPayManager alloc] init];
    });
    return instance;
}


//pay
- (void)aliPayGateway:(NSString *)alipay fangID:(NSString *)fang_id finalPrice:(NSString *)actualMoneyCountStr discountID:(NSString *)redID quantity:(NSString *)quantityCount{

    
    NSDictionary *parameter;
    if (redID==nil||redID==NULL) {
        parameter = @{@"gateway":alipay,
                      @"fang_id":fang_id,
                      @"final_price":actualMoneyCountStr,
                      @"quantity":quantityCount};
    }else{
        parameter = @{@"gateway":alipay,
                      @"fang_id":fang_id,
                      @"final_price":actualMoneyCountStr,
                      @"discount_id":redID,
                      @"quantity":quantityCount};
    }
    NSLog(@"传参 --- %@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/trade/pre-pay",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"order --- %@",object);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            //BUG
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wapOrderSnBool"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",object[@"data"][@"order_sn"]] forKey:@"wapOrderSn"];
            
            
            
            NSString *gateway = [NSString stringWithFormat:@"%@",object[@"data"][@"gateway"]];
            if ([gateway isEqualToString:@"biupay"]) {
                //BUG
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                //0 pay successful
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
            }else{
            
                NSString *methodStr = [NSString stringWithFormat:@"%@",object[@"data"][@"method"]];
                if ([methodStr isEqualToString:@"wap"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",object[@"data"][@"order_sn"]] forKey:@"wapOrderSn"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wapOrderSnBool"];
                    //safari pay
                    NSString *resultUrl = [NSString stringWithFormat:@"%@",object[@"data"][@"result"]];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultUrl]];
                }else{
                    [self appPayAc:object];
                }
                
            }
                
            
        }else{
            //NSLog(@"tip---tip---tip---%@",object[@"status"][@"message"]);
            [self showProgress:object[@"status"][@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"returnUseEnableSettlement" object:nil];
        }
        //BUG
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"returnUseEnableSettlement" object:nil];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        //BUG
        [[NSNotificationCenter defaultCenter] postNotificationName:@"returnUseEnableSettlement" object:nil];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        
    }];
}


//app pay
- (void)appPayAc:(NSDictionary *)object{
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alipayBiufangScheme";

    //orderString
    NSString *order = [NSString stringWithFormat:@"%@",object[@"data"][@"result"]];
    //NSLog(@"order -- %@",order);
    [[AlipaySDK defaultService] payOrder:order fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //NSLog(@"alipay --- reslut --- %@",resultDic);
        NSString *stateStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
        NSString *order_sn = [NSString stringWithFormat:@"%@",object[@"data"][@"order_sn"]];
        
        //BUG
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
        
        if ([stateStr isEqualToString:@"9000"]) {
            //successful
            [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
        }else{
            //failed
            NSString     *urlStr = [NSString stringWithFormat:@"%@/trade/order-status",API];
            NSDictionary *parm = @{@"sn":order_sn};
            [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parm withSuccessBlock:^(NSDictionary *object) {
                //NSLog(@"%@",object);
                NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
                NSString *paidStr = [NSString stringWithFormat:@"%@",object[@"data"][@"status"]];
                
                if ([stateStr isEqualToString:@"success"]) {
                    if ([paidStr isEqualToString:@"paid"]) {
                        
                        
                        
                        //NSLog(@"pay successful");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
                    }else{
                        
                        //NSLog(@"pay failed");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailed" object:nil];
                    }
                }
            } withFailureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            } progress:^(float progress) {
                NSLog(@"%f",progress);
            }];
        }
    }];
    //BUG --- 暂时取消预先弹出 支付失败 弹窗
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"advanceFailedPopup" object:nil];
}


//MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tipStr;
    hud.margin = 20.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}


@end
