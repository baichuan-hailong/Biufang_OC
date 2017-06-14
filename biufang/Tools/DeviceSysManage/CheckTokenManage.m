//
//  CheckTokenManage.m
//  biufang
//
//  Created by 杜海龙 on 16/10/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "CheckTokenManage.h"

@implementation CheckTokenManage



+ (void)chekcToken:(NSError *)error{
    
    //NSLog(@"error --- %@",error);
    
    if ([[NSString stringWithFormat:@"%@",error.localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO    forKey:IS_LOGIN];
        
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_ID];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:TOKEN];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_AVATAR];
        //[[NSUserDefaults standardUserDefaults] setBool:NO    forKey:IS_LOGIN];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:NICKNAME];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERNAME];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:CARD_ID];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:REAL_NAME];
        //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:VERIFYKEY];
        
        
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
        
        //first page
        //[self.tabBarController setSelectedIndex:0];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenFailureAction" object:nil];
        
        
        
        //UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //只显示文字
        //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        //hud.mode = MBProgressHUDModeText;
        //hud.labelText = @"您的账户在其他设备登录，请重新登录";
        //hud.margin = 20.f;
        //hud.yOffset = 150.f;
        //hud.removeFromSuperViewOnHide = YES;
        //[hud hide:YES afterDelay:1];
    }
}


+ (void)chekcToken:(NSError *)error type:(NSString *)type viewController:(UIViewController *)viewController{

    if ([[NSString stringWithFormat:@"%@",error.localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_ID];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_AVATAR];
        [[NSUserDefaults standardUserDefaults] setBool:NO    forKey:IS_LOGIN];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:NICKNAME];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CARD_ID];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:REAL_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:VERIFYKEY];
        
        
        
        [viewController.navigationController popToRootViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenFailureLoginAction" object:nil];
        
        
    }
}



@end
