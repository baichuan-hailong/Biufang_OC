//
//  CheckTokenManage.h
//  biufang
//
//  Created by 杜海龙 on 16/10/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckTokenManage : NSObject

+ (void)chekcToken:(NSError *)error;

+ (void)chekcToken:(NSError *)error type:(NSString *)type viewController:(UIViewController *)viewController;

@end
