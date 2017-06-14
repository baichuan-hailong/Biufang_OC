//
//  BFNewUserViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/11/16.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewUserViewController.h"
#import "UILogRegViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "BFDetailViewController.h"
#import "BFBannerWebViewController.h"
#import "BFBiuDetailsViewController.h"
#import "BFNewClassViewController.h" //biu币类目页
#import "BFRedEnvelopeViewController.h"
#import "BFBiuRecordViewController.h"
#import "BFHomeCategoryViewController.h"


@interface BFNewUserViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

//JS传递参数
@property (nonatomic, copy  ) NSString      *requestUrl;
@property (nonatomic, strong) NSDictionary  *paramDic;

@end

@implementation BFNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAndRequest) name:@"NewUserRed" object:nil];
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cleanCache];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - webViewDelegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self hud];
}

- (MBProgressHUD *)hud {

    if (_hud == nil) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.userInteractionEnabled = NO;
        _hud.removeFromSuperViewOnHide = YES;
    }
    return _hud;
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
    
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    //JavaScript Call Objc
    
    //通用方法
    context[@"useInterface"] = ^() {
        
        NSArray *args = [JSContext currentArguments];
        for (int i = 0; i < args.count; i++) {
            
            JSValue *jsVal = [args objectAt:i];
            
            if (i == 0) {
                self.requestUrl = [NSString stringWithFormat:@"%@",jsVal];
            } else if (i == 1) {
                self.paramDic   = [myToolsClass nsstringToJson:[NSString stringWithFormat:@"%@",jsVal]];
                NSLog(@"32323232  %@",self.paramDic);
            }
            NSLog(@"参数 %d : %@",i ,[NSString stringWithFormat:@"%@",jsVal]);
            
            
            
        }
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {

            [self refreshAndRequest];
            
        } else {
            
            UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
            loginView.entranceType = @"NewUserRed";
            UINavigationController *loginNv = [[UINavigationController alloc] initWithRootViewController:loginView];
            [self presentViewController:loginNv animated:YES completion:nil];
        }
    };



    context[@"jumpNative"] = ^() {
        
        NSString *type  = nil;  //跳转目标
        NSString *param = nil;  //跳转参数
        
        NSArray *args = [JSContext currentArguments];
        for (int i = 0; i < args.count; i++) {
            
            JSValue *jsVal = [args objectAt:i];
            
            if (i == 0) {
                type  = [NSString stringWithFormat:@"%@",jsVal];
            } else if (i == 1) {
                param = [NSString stringWithFormat:@"%@",jsVal];
            }
            NSLog(@"参数 %d : %@",i ,[NSString stringWithFormat:@"%@",jsVal]);
        }
        
        //****** 跳转约定 ******//
        if ([type isEqualToString:@"home"]) {
            
            //*** 返回首页 ***//
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserRed" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else if ([type isEqualToString:@"web"]) {
            
            //*** WEB ***//
            BFBannerWebViewController *bannerWebView = [[BFBannerWebViewController alloc] init];
            bannerWebView.webUrl = param;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:bannerWebView animated:YES];
            });
            
        } else if ([type isEqualToString:@"goods_detail"]) {
            
            //*** 普通商品详情页 ***//
            BFDetailViewController *detailView = [[BFDetailViewController alloc] init];
            detailView.detailId = param;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:detailView animated:YES];
            });
            
            
        } else if ([type isEqualToString:@"biu_detail"]) {
            
            //*** Biu币商品详情页 ***//
            BFBiuDetailsViewController *detailBiu = [[BFBiuDetailsViewController alloc] init];
            detailBiu.title = @"商品详情";
            detailBiu.detailID = param;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:detailBiu animated:YES];
            });
            
        } else if ([type isEqualToString:@"goods_classify"]) {
            
            //*** 商品类目页 ***//

            
        } else if ([type isEqualToString:@"biu_classify"]) {
            //*** Biu币类目页 ***//

            
        } else if ([type isEqualToString:@"lucky"]) {
            //*** 红包页 ***//

            
        } else if ([type isEqualToString:@"mybiu_record"]) {
            //*** 我的biu房记录 ***//

        }
        //************//
        
    };
}


//改变参数刷新webView && 通用接口请求
- (void)refreshAndRequest {
    
    //刷新页面
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?isLogin=1",_webUrl]]];
//    [self.webView loadRequest:request];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.backgroundColor = [UIColor blackColor];
    indicator.alpha = 0.5;
    indicator.layer.cornerRadius = 6;
    indicator.layer.masksToBounds = YES;
    [indicator setCenter:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)];
    
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    //通用接口请求
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",API,self.requestUrl];

    
    NSLog(@"url : %@   param : %@",urlStr,self.paramDic);
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:self.paramDic withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"%@",object);
        [indicator stopAnimating];
        NSString *status;
        NSString *msg;
        if ([[NSString stringWithFormat:@"%@",object[@"status"][@"state"]] isEqualToString:@"success"]) {
            
            status = @"success";
            msg    = @"";
        } else {
            
            status = @"error";
            msg    = [NSString stringWithFormat:@"%@",object[@"status"][@"message"]];
        }
        
        //Objc Call JavaScript
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"callbackJs('%@','%@')",status,msg]];
        
    } withFailureBlock:^(NSError *error) {
        [indicator stopAnimating];
    } progress:^(float progress) {}];

}





#pragma mark - getter
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        
        NSString *isLogin;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
            isLogin = @"1";
        } else {
            isLogin = @"0";
        }
        _webUrl = [_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString  stringWithFormat:@"%@?isLogin=%@",_webUrl,isLogin]]];
        [_webView loadRequest:request];
    }
    return _webView;
}



#pragma mark - customMethod
- (void)backButton {
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 64, 64);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-50, 0, 10);
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=item;
}

/** 清除缓存 **/
- (void)cleanCache{
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


- (void)backAction {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewUserRed" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}



@end
