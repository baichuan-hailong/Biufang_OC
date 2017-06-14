//
//  UILogRegViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "UILogRegViewController.h"
#import "BFLogRegView.h"

#import "BFCheckNewTelNumViewController.h"
#import "BFServerViewController.h"

#import "WeiboSDK.h"

@interface UILogRegViewController ()<UITextFieldDelegate>
{

    BOOL isShowTip;
}
@property (nonatomic , strong) BFLogRegView *loginRegView;
@property(nonatomic,strong)UIActionSheet *camerSheet;

// NSTimer
@property(nonatomic,strong)NSTimer *valiCodeTimer;
// 秒数
@property(nonatomic)NSInteger startTime;

@property (nonatomic , strong) MBProgressHUD *HUD;

@end

@implementation UILogRegViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.loginRegView = [[BFLogRegView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.loginRegView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    //NSLog(@"%@",_entranceType);
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    [self.view addGestureRecognizer:viewTapGR];

    //coder button
    [self.loginRegView.obtainCoderButton addTarget:self action:@selector(obtainCoderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //login button
    [self.loginRegView.loginButton addTarget:self action:@selector(loginButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //wechat button
    [self.loginRegView.wechatButton addTarget:self action:@selector(wechatButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //qq button
    [self.loginRegView.qqButton addTarget:self action:@selector(qqButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //wobo button
    [self.loginRegView.weboButton addTarget:self action:@selector(weboButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Begin
    [self.loginRegView.telTextField addTarget:self action:@selector(telTextFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    self.loginRegView.telTextField.delegate = self;
    [self.loginRegView.codeTextField addTarget:self action:@selector(telTextFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    //Change
    [self.loginRegView.telTextField addTarget:self action:@selector(telTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.loginRegView.codeTextField addTarget:self action:@selector(telTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //服务条款
    [self.loginRegView.serverButton addTarget:self action:@selector(serverButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
   
    //wechat login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginUnionidAction:) name:@"wechatLoginUnionid" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatLoginUnionidFailedAc) name:@"wechatLoginUnionidFailed" object:nil];
    [self isInstallation];
    
    
    
    [WXApi registerApp:WechatAppID withDescription:@"newbiufang"];
    
    [UMSocialQQHandler setQQWithAppId:QQAppID
                               appKey:QQAppKey
                                  url:nil];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
                                              secret:SinaAppSecret
                                         RedirectURL:@"http://www.biufang.cn"];
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"loginPage"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"loginPage"];
}


#pragma mark - 判断是否安装
- (void)isInstallation{
    //0
    if (![WXApi isWXAppInstalled]&&![QQApiInterface isQQInstalled]&&![WeiboSDK isWeiboAppInstalled]) {
        
        self.loginRegView.thirdLine.alpha    = 0;
        self.loginRegView.thirdLabel.alpha   = 0;
        self.loginRegView.wechatLabel.alpha  = 0;
        self.loginRegView.wechatButton.alpha = 0;
        self.loginRegView.qqLabel.alpha      = 0;
        self.loginRegView.qqButton.alpha     = 0;
        self.loginRegView.weiboLabel.alpha   = 0;
        self.loginRegView.weboButton.alpha   = 0;
    }else {
        //1
        if (![QQApiInterface isQQInstalled]&&![WeiboSDK isWeiboAppInstalled]) {
            self.loginRegView.qqLabel.alpha      = 0;
            self.loginRegView.qqButton.alpha     = 0;
            self.loginRegView.weiboLabel.alpha   = 0;
            self.loginRegView.weboButton.alpha   = 0;
            
            
            self.loginRegView.wechatButton.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.wechatLabel.frame  = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
        }else if (![WXApi isWXAppInstalled]&&![WeiboSDK isWeiboAppInstalled]) {
            self.loginRegView.wechatLabel.alpha  = 0;
            self.loginRegView.wechatButton.alpha = 0;
            self.loginRegView.weiboLabel.alpha   = 0;
            self.loginRegView.weboButton.alpha   = 0;
            
            self.loginRegView.qqButton.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.qqLabel.frame  = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
        }else if (![WXApi isWXAppInstalled]&&![QQApiInterface isQQInstalled]) {
            self.loginRegView.wechatLabel.alpha  = 0;
            self.loginRegView.wechatButton.alpha = 0;
            self.loginRegView.qqLabel.alpha      = 0;
            self.loginRegView.qqButton.alpha     = 0;
            
            self.loginRegView.weboButton.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.weiboLabel.frame  = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
        //2
        }else if (![WXApi isWXAppInstalled]){
            self.loginRegView.wechatLabel.alpha  = 0;
            self.loginRegView.wechatButton.alpha = 0;
            
            self.loginRegView.qqButton.frame = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.qqLabel.frame  = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
            
            self.loginRegView.weboButton.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.weiboLabel.frame  = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
            
            
        }else if (![QQApiInterface isQQInstalled]) {
            self.loginRegView.qqLabel.alpha      = 0;
            self.loginRegView.qqButton.alpha     = 0;
            
            self.loginRegView.wechatButton.frame = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.wechatLabel.frame  = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
            
            self.loginRegView.weboButton.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.weiboLabel.frame  = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
            
        }else if (![WeiboSDK isWeiboAppInstalled]){
            self.loginRegView.weiboLabel.alpha   = 0;
            self.loginRegView.weboButton.alpha   = 0;
            
            self.loginRegView.wechatButton.frame = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.wechatLabel.frame  = CGRectMake(SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
            
            self.loginRegView.qqButton.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27);
            self.loginRegView.qqLabel.frame  = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*100, CGRectGetMaxY(self.loginRegView.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20);
        }
    }
}




-(void)backAction:(UIButton *)sender{

    [self.loginRegView.telTextField resignFirstResponder];
    [self.loginRegView.codeTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.loginRegView.telTextField  resignFirstResponder];
    [self.loginRegView.codeTextField resignFirstResponder];
    
    //bug
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [UIView animateWithDuration:0.38 animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

#pragma mark - 微信授权登录
//wechat login
- (void)wechatLoginUnionidAction:(NSNotification *)noti{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    
    
    NSDictionary *dic = (NSDictionary *)[noti object];
    NSString *unionid = [NSString stringWithFormat:@"%@",dic[@"unionid"]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:WechatBugKey]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:WechatBugKey];
        
        [self thirdLogin:unionid type:@"wechat"];
    }
    
}

//failed
- (void)wechatLoginUnionidFailedAc{

    [self.HUD hide:YES];
}


#pragma mark - 开始编辑
- (void)telTextFieldDidBegin:(UITextField *)sender{

    [UIView animateWithDuration:0.38 animations:^{
        self.view.frame = CGRectMake(0, -SCREEN_WIDTH/375*(64+80+15), SCREEN_WIDTH, SCREEN_HEIGHT+SCREEN_WIDTH/375*(64+80+65));
    }];
}

#pragma mark - 文本改变
- (void)telTextFieldDidChange:(UITextField *)sender{
    if (self.loginRegView.telTextField.text.length>0&&self.loginRegView.codeTextField.text.length>0) {
        
        self.loginRegView.loginButton.alpha = 1;
        self.loginRegView.loginButton.userInteractionEnabled = YES;
    }else{
        self.loginRegView.loginButton.alpha = 0.6;
        self.loginRegView.loginButton.userInteractionEnabled = NO;
    }
}


#pragma mark - 获取验证码
- (void)obtainCoderButtonDidClickedAction:(UIButton *)sender{

    if ([BFRegularManage checkMobile:self.loginRegView.telTextField.text]){
        //NSLog(@"coder");
        [self.loginRegView.codeTextField   becomeFirstResponder];
        self.loginRegView.obtainCoderButton.userInteractionEnabled = NO;
        [self startCountdown];
        //sender coder
        NSDictionary *parm = @{@"mobile":self.loginRegView.telTextField.text,
                               @"scene":@"auth"};
        NSString *urlStr = [NSString stringWithFormat:@"%@/user/send-verify-code",API];
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parm withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"%@",object);
            //NSLog(@"%@",object[@"status"][@"message"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                if (isShowTip) {
                    [self showProgress:@"验证码已发送到您的手机，请注意查收"];
                }
            }else{
                [self showProgress:object[@"status"][@"message"]];
                [self stopCount];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            [self showProgress:@"网络连接失败，请检查您的网络"];
            [self stopCount];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];

    }else{
    
        [self showProgress:@"请输入正确的手机号"];
    }
}



#pragma mark - NSTimer
-(void)startCountdown{
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    _startTime = 60;
    [self.loginRegView.obtainCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.loginRegView.obtainCoderButton setTitleColor:[UIColor colorWithHex:@"cfcecc"] forState:UIControlStateHighlighted];
    [self.loginRegView.obtainCoderButton setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)_startTime] forState:UIControlStateNormal];
}

-(void)timeGo{
    _startTime--;
    
    self.loginRegView.obtainCoderButton.userInteractionEnabled = NO;
    [self.loginRegView.obtainCoderButton setTitleColor:[UIColor colorWithHex:@"cfcecc"] forState:UIControlStateHighlighted];
    [self.loginRegView.obtainCoderButton setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)_startTime] forState:UIControlStateNormal];
    
    if (_startTime==0) {

        self.loginRegView.obtainCoderButton.userInteractionEnabled = YES;
        [self.loginRegView.obtainCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.loginRegView.obtainCoderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.loginRegView.obtainCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
        
        isShowTip = YES;
        [_valiCodeTimer invalidate];
        _valiCodeTimer = nil;
    }
}


- (void)stopCount{
    
    self.loginRegView.obtainCoderButton.userInteractionEnabled = YES;
    [self.loginRegView.obtainCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.loginRegView.obtainCoderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginRegView.obtainCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
    
    
    [_valiCodeTimer invalidate];
    _valiCodeTimer = nil;
}


#pragma mark - 登录
- (void)loginButtonDidClickedAction:(UIButton *)sender{
    
/*
 //verify moble
 NSDictionary *parDic = @{@"mobile":@"13522857012",
 @"code":@"1110"};
 NSLog(@"%@",parDic);
 NSString *urlStr = [NSString stringWithFormat:@"%@/user/verify-mobile",@"http://api.brands500.cn"];
 [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parDic withSuccessBlock:^(NSDictionary *object) {
 NSLog(@"%@",object);
 NSLog(@"%@",object[@"status"][@"message"]);
 NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
 if ([stateStr isEqualToString:@"success"]) {
 
 }else{
 [self showProgress:object[@"status"][@"message"]];
 }
 } withFailureBlock:^(NSError *error) {
 NSLog(@"%@",error);
 } progress:^(float progress) {
 NSLog(@"%f",progress);
 }];
 
 */
    
    
    
     //loading
     self.loginRegView.loginButton.alpha = 0;
     self.loginRegView.loadingView.alpha = 1;
     //旋转动画
     CABasicAnimation* rotationAnimation;
     rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
     rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
     rotationAnimation.duration = 1.5;
     rotationAnimation.cumulative = YES;
     rotationAnimation.repeatCount = 100000;
     [self.loginRegView.loadImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
     
     //NSLog(@"login");
     if ([BFRegularManage checkMobile:self.loginRegView.telTextField.text]) {
     //verify moble
     NSDictionary *parameter = @{@"mobile":self.loginRegView.telTextField.text,
     @"code":self.loginRegView.codeTextField.text,
     @"scene":@"auth"};
     NSString *urlStr = [NSString stringWithFormat:@"%@/user/verify-mobile",API];
     [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
     //NSLog(@"登录完成 --- %@",object);
     NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
     if ([stateStr isEqualToString:@"success"]) {
     
     
     //保存用户信息
     [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"id"] forKey:USER_ID];
     [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"token"] forKey:TOKEN];
     [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"verify_key"] forKey:VERIFYKEY];
     //[[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"nickname"] forKey:NICKNAME];
     
     
     
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGIN];
     if ([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
     [self getUserInfoActype:nil];
     }
     
     [self.loginRegView.telTextField resignFirstResponder];
     [self.loginRegView.codeTextField resignFirstResponder];
     
     
     //登录Next
     if ([self.entranceType isEqualToString:@"BEX"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"bexLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"BiuBEX"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"BiuBEXLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"BClassEX"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"BClassEXLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"BDetailEX"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"BDetailEXLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"FangDetailPage"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FangDetailPageLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"MySelf"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MySelfLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"MyMoney"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMoneyLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"MyBiuRecord"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"MyBiuRecordLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"FangCategaryPage"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"FangCategaryLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"DetailBiuNumbers"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailBiuNumbersLoginNextAction" object:nil];
     
     }else if ([self.entranceType isEqualToString:@"homeBuyGood"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"homeBuyGoodNextAction" object:nil];
     }
     
     
     }else{
     [self showProgress:object[@"status"][@"message"]];
     }
     
     self.loginRegView.loginButton.alpha = 1;
     self.loginRegView.loadingView.alpha = 0;
     } withFailureBlock:^(NSError *error) {
     NSLog(@"%@",error.localizedDescription);
     self.loginRegView.loginButton.alpha = 1;
     self.loginRegView.loadingView.alpha = 0;
     } progress:^(float progress) {
     
     NSLog(@"%f",progress);
     }];
     
     }else{
     [self showProgress:@"请输入正确的手机号"];
     self.loginRegView.loginButton.alpha = 1;
     self.loginRegView.loadingView.alpha = 0;
     }
     
    
    
}







#pragma mark - 获取用户信息
- (void)getUserInfoActype:(NSString *)type{

    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/info",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WechatBugKey];
        //NSLog(@"userInfo --- userInfo --- userInfo --- %@",object);
        [self.HUD hide:YES];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            /*
             记录登陆时间
             */
            //登陆成功存取CN标准时间戳
            NSDate          *unifiedDate    = [NSDate date];//获取当前时间，日期
            NSTimeInterval  currenTimeIntla = [unifiedDate timeIntervalSince1970]+28800;
            NSString *timeLoginStamp        = [NSString stringWithFormat:@"%.f", currenTimeIntla];//转为字符型
            //NSLog(@"%@",timeLoginStamp);
            [[NSUserDefaults standardUserDefaults] setObject:timeLoginStamp forKey:LoginTimeStamp];
            
            
            
            
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"nickname"] forKey:NICKNAME];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"username"] forKey:USERNAME];
            //avatar
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"avatar"] forKey:USER_AVATAR];
            //通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishlogin" object:nil];
            //UM Account statistics
            [[UMManager sharedManager] accountStatistics];
            
            
            //update Device Token
            [self uptateDeviceToken];
            
            
            //wechat BUG
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.entranceType isEqualToString:@"NewUserRed"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserRed" object:nil];
                }
            }];
            
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            
            
            //NSLog(@"%@",type);
            if ([type isEqualToString:@"wechat"]) {
                //NSLog(@"wechat");
                [self performSelector:@selector(delayMethod) withObject:nil afterDelay:2.38];
            }
        }
        
    } withFailureBlock:^(NSError *error) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WechatBugKey];
        //NSLog(@"error --- error --- error %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
        //NSLog(@"error --- error --- error %@",error);
        [self.HUD hide:YES];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}



//bug
- (void)delayMethod{

    [self backAction:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - wechat
- (void)wechatButtonDidClickedAction:(UIButton *)sender{
    
    if ([WXApi isWXAppInstalled]) {
        [WXApi registerApp:WechatAppID withDescription:@"newbiufang"];
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    }else {
        [self setupAlertController];
    }
}



#pragma mark - qq
- (void)qqButtonDidClickedAction:(UIButton *)sender{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
    
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            //NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            //NSDictionary *thirdPla = response.thirdPlatformUserProfile;
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.userName forKey:@"bindUserName"];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.iconURL forKey:@"bindUserIconURL"];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.usid forKey:@"bindUserOpenid"];
            
            
            
            [self thirdLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserOpenid"] type:@"qq"];
            
        }});
}


#pragma mark - webo
- (void)weboButtonDidClickedAction:(UIButton *)sender{

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            //NSLog(@"dict --- %@",dict);
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            //NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.userName forKey:@"bindUserName"];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.iconURL forKey:@"bindUserIconURL"];
            [[NSUserDefaults standardUserDefaults] setObject:snsAccount.usid forKey:@"bindUserOpenid"];
            
            [self thirdLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserOpenid"] type:@"weibo"];
            
            
            
        }});
}


- (void)thirdLogin:(NSString *)thirdToken type:(NSString *)type{

    NSDictionary *parameter = @{@"social_token":thirdToken,
                                @"social_source":type};
    //NSLog(@"%@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/social-auth",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"登录信息 --- %@",object);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"token"] forKey:TOKEN];
            //保存用户信息
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"id"] forKey:USER_ID];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGIN];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
                [self getUserInfoActype:type];
            }
            
            //登录Next
            if ([self.entranceType isEqualToString:@"BEX"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"bexLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"BiuBEX"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BiuBEXLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"BClassEX"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BClassEXLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"BDetailEX"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BDetailEXLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"FangDetailPage"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FangDetailPageLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"MySelf"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MySelfLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"FangCategaryPage"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FangCategaryLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"MyMoney"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMoneyLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"MyBiuRecord"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyBiuRecordLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"DetailBiuNumbers"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailBiuNumbersLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"homeBuyGood"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeBuyGoodNextAction" object:nil];
            }
            
            
        }else{
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WechatBugKey];
            [self.HUD hide:YES];
            NSString *messageStr = [NSString stringWithFormat:@"%@",object[@"status"][@"message"]];
            //绑定手机号
            if ([messageStr isEqualToString:@"PENDING|WAITING_FOR_BIND"]) {
                BFCheckNewTelNumViewController *checkNewTelVC = [[BFCheckNewTelNumViewController alloc] init];
                checkNewTelVC.isLogin = YES;
                checkNewTelVC.typeStr = type;
                checkNewTelVC.entranceType = self.entranceType;
                [self.navigationController pushViewController:checkNewTelVC animated:YES];
            }
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindUserIconURL"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindUserUnionid"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"bindUserOpenid"];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:WechatBugKey];
        [self.HUD hide:YES];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}

- (void)uptateDeviceToken{
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN];

    //*** 上传DEVICE_TOKEN ***/
    if (deviceToken.length>10) {
        
        //*** 上传DEVICE_TOKEN ***//
        NSLog(@"  DEVICE_TOKEN : %@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN]]);
        
        NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]&&userToken.length>3) {
            NSString     *urlStr = [NSString stringWithFormat:@"%@/user/push",API];
            NSDictionary *param  = @{@"device_token":deviceToken,
                                     @"device_os":@"ios",
                                     @"badge":@(0)};
            [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
                //NSLog(@"  userPush : %@",object);
            } withFailureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            } progress:^(float progress) {}];
            
        }
        
    }
    
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 11) {
        [self.loginRegView.codeTextField becomeFirstResponder];
    }
    return newLength <= 11;
}

#pragma mark - 服务条款
- (void)serverButtonDidClickedAction:(UIButton *)sender{

    NSLog(@"server");
    BFServerViewController *serverVC = [[BFServerViewController alloc] init];
    UINavigationController *serverNC = [[UINavigationController alloc] initWithRootViewController:serverVC];
    [self presentViewController:serverNC animated:YES completion:nil];
    
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

#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
