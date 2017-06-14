//
//  BFRegularManage.h
//  biufang
//
//  Created by 杜海龙 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFRegularManage : NSObject
+ (BOOL) checkMobile:(NSString *)mobileNumbel;
+ (BOOL) checkUserIdCard :(NSString *)idCard;
+ (BOOL) checkPassword:(NSString *) password;
+ (BOOL) checkURL : (NSString *) url;
+ (BOOL) checkUserName : (NSString *) userName;
+ (BOOL) checkEmail:(NSString *)email;
@end
