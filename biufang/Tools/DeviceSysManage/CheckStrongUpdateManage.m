//
//  CheckStrongUpdateManage.m
//  biufang
//
//  Created by 杜海龙 on 16/11/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "CheckStrongUpdateManage.h"

@implementation CheckStrongUpdateManage

+ (void)checkUpdate:(UIViewController *)viewController{

    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"请到AppStore更新App" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://geo.itunes.apple.com/cn/app/id1136978764"]];
    }];
    [alertDialog addAction:okAction];
    [viewController presentViewController:alertDialog animated:YES completion:nil];
    
}

@end
