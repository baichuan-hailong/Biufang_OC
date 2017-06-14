//
//  BFHouseViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHouseViewController.h"

@interface BFHouseViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BFHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"房屋详情";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"开始加载");
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.removeFromSuperViewOnHide = YES;
    
}
//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"结束");
    [_hud hide:YES];
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

}


@end
