//
//  BFBiuDetailsViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBiuDetailsViewController.h"
#import "BFExchangeSuccessfulView.h"

@interface BFBiuDetailsViewController ()<BFExchangeSuccessfulDelegate,UIWebViewDelegate>
@property (nonatomic , strong) UIView *bottomView;
@property (nonatomic , strong) UIButton *exchangeButton;
@property (nonatomic , strong) UILabel *biubLabel;
@property (nonatomic , strong) UIImageView *biubImageView;

@property (nonatomic , strong) UIWebView *detailWebView;;
@property (nonatomic, strong) MBProgressHUD *hud;
//pop
@property (nonatomic , strong) BFExchangeSuccessfulView *exchangeSuccessfulView;
@end

@implementation BFBiuDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    [self setWeb];
    
    self.bottomView.backgroundColor     = [UIColor colorWithHex:@"FFFFFF"];
    self.bottomView.layer.shadowColor   = [UIColor colorWithHex:@"828282"].CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0,0);
    self.bottomView.layer.shadowRadius  = 1;
    self.bottomView.layer.shadowOpacity = 0.6;
    [self.view addSubview:self.bottomView];
    
    
    [self.exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [self.exchangeButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    self.exchangeButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.exchangeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.exchangeButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"FF3F56"] size:self.exchangeButton.frame.size] forState:UIControlStateNormal];
    self.exchangeButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
    self.exchangeButton.layer.masksToBounds= YES;
    [self.bottomView addSubview:self.exchangeButton];
    
    [self.exchangeButton addTarget:self action:@selector(exchangeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.biubLabel.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/375*24];//[UIFont systemFontOfSize:SCREEN_WIDTH/375*24];
    self.biubLabel.textAlignment = NSTextAlignmentRight;
    self.biubLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.biubLabel.text = self.detailBiuB;//detailBiuB
    [self.biubLabel sizeToFit];
    [self.bottomView addSubview:self.biubLabel];

    self.biubImageView.image = [UIImage imageNamed:@"biubibagimage"];
    [self.bottomView addSubview:self.biubImageView];
    
    
    
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BDetailEXLoginNextAc) name:@"BDetailEXLoginNextAction" object:nil];
    
    if (_detailWebUrl == nil && _detailBiuB == nil) {
        [self loadDataSource];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"MoneyBiuGoodsDetailDisplayPage"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"MoneyBiuGoodsDetailDisplayPage"];
}

#pragma mark - web
- (void)setWeb{
    
    NSLog(@"url --- %@",self.detailWebUrl);
    
    self.detailWebView = [[UIWebView alloc] init];
    self.detailWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*60);
    self.detailWebView.delegate = self;
    self.detailWebView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.detailWebUrl]];
    [self.detailWebView loadRequest:request];
    [self.view addSubview:self.detailWebView];
    
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    //NSLog(@"开始加载");
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
   // NSLog(@"结束");
    [_hud hide:YES];
}

#pragma mark - 登录Next
- (void)BDetailEXLoginNextAc{

    [self exchangeButtonDidClickedAction:nil];
}

- (void)exchangeButtonDidClickedAction:(UIButton *)sender{
    
    //MoneyBiuGoodsDetailPagePurchase
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MoneyBiuGoodsDetailPagePurchase"];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/biub/redeem",API];
        NSDictionary *parame = @{@"pid":self.detailID};
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"%@",object);
            [_hud hide:YES];
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                self.exchangeSuccessfulView = [[BFExchangeSuccessfulView alloc] initWithFrame:SCREEN_BOUNDS];
                self.exchangeSuccessfulView.delegate = self;
                [self.exchangeSuccessfulView showSuccessful];
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [_hud hide:YES];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
        
    }else{
        [_hud hide:YES];
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        loginRegVC.entranceType = @"BDetailEX";
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}


- (void)loadDataSource {

    //请求参数
    NSString *urlStr = [NSString stringWithFormat:@"%@/biub/product-info?id=%@",API,_detailID];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"good - %@",object);
        
        self.detailBiuB   = [NSString stringWithFormat:@"%@",object[@"data"][@"biub"]];
        self.detailWebUrl = [NSString stringWithFormat:@"%@",object[@"data"][@"detail"]];
        
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_detailWebUrl]];
        [self.detailWebView loadRequest:request];
        
        self.biubLabel.text = self.detailBiuB;
        [self.biubLabel sizeToFit];
        _biubImageView.frame = CGRectMake(CGRectGetMaxX(self.biubLabel.frame)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*18);
        
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}



#pragma mark - 兑换成功代理
-(void)exchangeSuccessful:(UIButton *)sender{
    
    NSLog(@"finish");
}

//MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tipStr;
    hud.margin = 20.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//lazy
-(UIView *)bottomView{

    if (_bottomView==nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/375*60, SCREEN_WIDTH, SCREEN_WIDTH/375*60)];
    }
    return _bottomView;
}

-(UIButton *)exchangeButton{

    if (_exchangeButton==nil) {
        _exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*13-SCREEN_WIDTH/375*110, SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*110, SCREEN_WIDTH/375*35)];
    }
    return _exchangeButton;
}

-(UILabel *)biubLabel{

    if (_biubLabel==nil) {
        _biubLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*75, SCREEN_WIDTH/375*35)];
    }
    return _biubLabel;
}

-(UIImageView *)biubImageView{

    if (_biubImageView==nil) {
        _biubImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.biubLabel.frame)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*18)];
    }
    return _biubImageView;
}

@end
