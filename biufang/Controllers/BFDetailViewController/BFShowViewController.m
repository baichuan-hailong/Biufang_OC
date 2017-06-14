//
//  BFShowViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/12/16.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFShowViewController.h"

@interface BFShowViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BFShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单分享";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.issueHeaderView];
    [self.issueHeaderView addSubview:self.fangImagaView];
    [self.issueHeaderView addSubview:self.communityNameLabel];
    [self.issueHeaderView addSubview:self.issueNumberLabel];
    
    [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataSource[@"cover"]]] placeholderImage:nil];
    self.communityNameLabel.text = [NSString stringWithFormat:@"%@",_dataSource[@"title"]];
    self.issueNumberLabel.text   = [NSString stringWithFormat:@"期号：%@",_dataSource[@"sn"]];
    
    CGSize size = CGSizeMake(SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), 0);
    CGSize autoSize = [self.communityNameLabel actualSizeOfLable:[NSString stringWithFormat:@"%@",_dataSource[@"title"]]
                                                andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/375*14]
                                                andSize:size];
    self.communityNameLabel.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                                                    SCREEN_WIDTH/375*11,
                                                                    SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                                                    autoSize.height);
    
    [self.view addSubview:self.webView];
    
    NSLog(@"webUrl : %@",_webUrl);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - webViewDelegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.removeFromSuperViewOnHide = YES;
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
}



#pragma mark - getter
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, CGRectGetMaxY(self.issueHeaderView.frame) + 7, SCREEN_WIDTH, SCREEN_HEIGHT - self.issueHeaderView.frame.size.height - 64 - 14);
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        
        _webUrl = [_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
        [_webView loadRequest:request];
    }
    return _webView;
}


//hearView
- (UIView *)issueHeaderView{
    
    if (_issueHeaderView==nil) {
        _issueHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 7, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
        _issueHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _issueHeaderView;
}

- (UIImageView *)fangImagaView {
    
    if (_fangImagaView == nil) {
        
        _fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12,
                                                                       SCREEN_WIDTH/375*11,
                                                                       SCREEN_WIDTH/375*70,
                                                                       SCREEN_WIDTH/375*70)];
        _fangImagaView.backgroundColor = [UIColor lightGrayColor];
        _fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
        _fangImagaView.layer.masksToBounds= YES;
        _fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _fangImagaView;
}

- (UILabel *)communityNameLabel {
    
    if (_communityNameLabel == nil) {
        
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                                                        SCREEN_WIDTH/375*11,
                                                                        SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                                                        0)];
        _communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        _communityNameLabel.textColor = [UIColor blackColor];
        _communityNameLabel.numberOfLines = 0;
        _communityNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _communityNameLabel;
}

- (UILabel *)issueNumberLabel {
    
    if (_issueNumberLabel == nil) {
        
        _issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                                                      CGRectGetMaxY(self.fangImagaView.frame) - SCREEN_WIDTH/375*14,
                                                                      SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                                                      SCREEN_WIDTH/375*14)];
        _issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        _issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
        _issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _issueNumberLabel;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
