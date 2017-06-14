//
//  UMManager.h
//  biufang
//
//  Created by 杜海龙 on 16/10/8.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMManager : NSObject
+ (instancetype)sharedManager;

//友盟统计
- (void)loadingAnalytics;
//账号统计
- (void)accountStatistics;
//分享统计
- (void)shareAnalytics;


//UM Share --- QQ Weibo
- (void)loadingShareSettingAction;
@end
