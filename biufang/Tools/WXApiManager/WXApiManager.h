//
//  WXApiManager.h
//  biufang
//
//  Created by 杜海龙 on 16/9/30.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXApiManager : NSObject<WXApiDelegate>

+ (instancetype)sharedManager;

//wechat login
- (void)wechatLogin;

//wechat pay
- (void)wechatPayParameter:(NSDictionary *)payload;

//wechat share
- (void)wechatShareTitle:(NSString *)title description:(NSString *)des image:(UIImage *)img url:(NSString *)url type:(BOOL)type;

@end
