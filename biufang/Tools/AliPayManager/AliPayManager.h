//
//  AliPayManager.h
//  biufang
//
//  Created by 杜海龙 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayManager : NSObject
+ (instancetype)sharedManager;


//parameter = @{@"gateway":@"alipay",
//@"fang_id":self.fang_id,
//@"final_price":actualMoneyCountStr,
//@"discount_id":self.redID,
//@"quantity":self.makeOrderView.orderCountTextField.text};

//pay
- (void)aliPayGateway:(NSString *)alipay fangID:(NSString *)fang_id finalPrice:(NSString *)actualMoneyCountStr discountID:(NSString *)redID quantity:(NSString *)quantityCount;
@end
