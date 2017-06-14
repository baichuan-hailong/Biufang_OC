//
//  BFLuckyNumViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/11/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFLuckyNumViewController.h"
#import "BFLuckyNumView.h"

@interface BFLuckyNumViewController () <UIWebViewDelegate>

@property (nonatomic, strong) BFLuckyNumView *currentView;
@property (nonatomic, strong) MBProgressHUD  *hud;


@end

@implementation BFLuckyNumViewController

#pragma mark - LifeCycle
- (void)loadView {

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentView = [[BFLuckyNumView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view = self.currentView;
    
    self.currentView.webView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"幸运号码";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self.currentView setValueWithDic:_dataSource];
    
    NSString *url = [NSString stringWithFormat:@"%@?sn=%@&shangz=%@&shenz=%@&quota=%@",luckNumberUrl,_dataSource[@"sn"],
                                                                                                     _dataSource[@"index_sh"],
                                                                                                     _dataSource[@"index_sz"],
                                                                                                     _dataSource[@"quota"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.currentView.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"MyLuckyRecordPage"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"MyLuckyRecordPage"];
}



#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

    _hud = [MBProgressHUD showHUDAddedTo:self.currentView.webView animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    
}
//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [_hud hide:YES];
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
