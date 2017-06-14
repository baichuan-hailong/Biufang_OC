//
//  BFBannerWebViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/11/12.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBannerWebViewController.h"

@interface BFBannerWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BFBannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"banner广告web页面";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (MBProgressHUD *)hud {
    
    if (_hud == nil) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.userInteractionEnabled = NO;
        _hud.removeFromSuperViewOnHide = YES;
    }
    return _hud;
}

#pragma mark - webViewDelegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {

    [self hud];
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}



#pragma mark - getter
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
     
        _webUrl = [_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
        [_webView loadRequest:request];
    }
    return _webView;
}

























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
