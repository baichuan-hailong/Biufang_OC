//
//  BFDetailRuleViewController.h
//  biufang
//
//  Created by 娄耀文 on 16/11/4.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailRuleViewController : BFBaseViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, copy  ) NSString      *webUrl;
@property (nonatomic, strong) MBProgressHUD *hud;

@end
