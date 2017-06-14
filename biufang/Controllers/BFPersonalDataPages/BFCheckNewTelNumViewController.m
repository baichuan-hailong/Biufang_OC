//
//  BFCheckNewTelNumViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFCheckNewTelNumViewController.h"
#import "BFServerViewController.h"

@interface BFCheckNewTelNumViewController ()<UITextFieldDelegate>
{

    BOOL isResetSmsCode;
}
@property (nonatomic , strong) UITextField *telTextField;
@property (nonatomic , strong) UIView *telline;

@property (nonatomic , strong) UITextField *coderTextField;
@property (nonatomic , strong) UIView *coderline;

@property (nonatomic , strong) UIButton *loginButton;

@property (nonatomic , strong) UIButton *requestCoderButton;

// NSTimer
@property(nonatomic,strong)NSTimer *valiCodeTimer;
// 秒数
@property(nonatomic)NSInteger startTime;

//服务条款
@property (nonatomic , strong) UIButton *serverButton;
@property (nonatomic , strong) UILabel *tipLabel;

//loading
@property(nonatomic,strong)UIView *loadingView;
//loading-Image
@property(nonatomic,strong)UIImageView *loadImageView;
@end

@implementation BFCheckNewTelNumViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (_isLogin) {
        self.title                = @"验证手机号码";
        self.tipLabel.alpha       = 1;
        self.serverButton.alpha   = 1;
    }else{
        self.title                = @"验证新手机号码";
        self.tipLabel.alpha       = 0;
        self.serverButton.alpha   = 0;
    }
    //self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self setUIAc];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(crearUserSuccessful) name:@"crearUserSuccessful" object:nil];
}



- (void)setUIAc{
    
    self.telTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.telTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.telTextField.textAlignment = NSTextAlignmentLeft;
    self.telTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextField.font = [UIFont systemFontOfSize:14];
    self.telTextField.placeholder = @"手机号";
    self.telTextField.delegate = self;
    self.telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.telTextField becomeFirstResponder];
    [self.view addSubview:self.telTextField];
    
    self.telline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.view addSubview:self.telline];
    
    
    //self.coderTextField.backgroundColor = [UIColor redColor];
    self.coderTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.coderTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.coderTextField.textAlignment = NSTextAlignmentLeft;
    self.coderTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.coderTextField.font = [UIFont systemFontOfSize:14];
    self.coderTextField.placeholder = @"验证码";
    self.coderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.coderTextField];
    
    //self.requestCoderButton.backgroundColor = [UIColor redColor];
    [self.requestCoderButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    [self.requestCoderButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.requestCoderButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.requestCoderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.requestCoderButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.requestCoderButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.requestCoderButton];
    
    self.coderline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.view addSubview:self.coderline];


    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"完成" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.loginButton.alpha = 0.6;
    self.loginButton.userInteractionEnabled = NO;
    [self.view addSubview:self.loginButton];
    
    
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(192+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*40)];
    self.loadingView.alpha = 0;
    self.loadingView.layer.cornerRadius = SCREEN_WIDTH/375*5;
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.backgroundColor = [UIColor colorWithHex:RED_COLOR];
    [self.view addSubview:self.loadingView];
    
    self.loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-76-SCREEN_WIDTH/375*21)/2, SCREEN_WIDTH/375*(40-21)/2, SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*21)];
    self.loadImageView.image = [UIImage imageNamed:@"loadingImage"];
    [self.loadingView addSubview:self.loadImageView];
    
    
    self.tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.tipLabel.text = @"轻点登录，即表示你已阅读并同意《                                 》";
    [self.view addSubview:self.tipLabel];
    
    
    [self.serverButton setTitle:@"支持者平台服务协议" forState:UIControlStateNormal];
    [self.serverButton setTitleColor:[UIColor colorWithHex:@"4A90E2"] forState:UIControlStateNormal];
    self.serverButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.serverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:self.serverButton];
    
    //服务条款
    [self.serverButton addTarget:self action:@selector(serverButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.telTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.coderTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    [self.view addGestureRecognizer:viewTapGR];
    
    [self.loginButton addTarget:self action:@selector(loginButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.requestCoderButton addTarget:self action:@selector(requestCoderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.telTextField resignFirstResponder];
    [self.coderTextField resignFirstResponder];
}


#pragma mark - 服务条款
- (void)serverButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"server");
    BFServerViewController *serverVC = [[BFServerViewController alloc] init];
    UINavigationController *serverNC = [[UINavigationController alloc] initWithRootViewController:serverVC];
    [self presentViewController:serverNC animated:YES completion:nil];
    
}

#pragma mark - 获取验证码
- (void)requestCoderButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"request coder");
    if ([BFRegularManage checkMobile:self.telTextField.text]){
        
        
        //NSString *oldTel = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
        [self.coderTextField becomeFirstResponder];
        self.requestCoderButton.userInteractionEnabled = NO;
        [self startCountdown];
        //sender coder
        NSDictionary *parm;
        if (_isLogin) {
            parm = @{@"mobile":self.telTextField.text};
        }else{
            parm = @{@"mobile":self.telTextField.text,
                     @"scene":@"update_mobile"};
        }
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:[NSString stringWithFormat:@"%@/user/send-verify-code",API] withParaments:parm withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"%@",object);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                
                if (isResetSmsCode) {
                   [self showProgress:@"验证码已发送到您的手机,请注意查收"];
                }
                
            }else{
                [self showProgress:object[@"status"][@"message"]];
                [self stopCount];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [CheckTokenManage chekcToken:error type:@"login" viewController:self];
            [self stopCount];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }else{
        [self showProgress:@"请输入正确的手机号"];
    }
}


//login
- (void)loginButtonDidClickedAction:(UIButton *)sender{
    
    //loading
    self.loginButton.alpha = 0;
    self.loadingView.alpha = 1;
    //旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.loadImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    if (_isLogin) {
        //verify moble
        NSDictionary *parameter = @{@"mobile":self.telTextField.text,
                                    @"code":self.coderTextField.text,
                                    @"scene":@"auth"};
        NSString *urlStr = [NSString stringWithFormat:@"%@/user/verify-mobile",API];
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
            self.loginButton.alpha = 1;
            self.loadingView.alpha = 0;
            //NSLog(@"verify moble --- %@",object);
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
                
                
                
                
                //保存用户信息
                [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"id"] forKey:USER_ID];
                [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"token"] forKey:TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"verify_key"] forKey:VERIFYKEY];
                
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_LOGIN];
                
                
                NSString *first_login = [NSString stringWithFormat:@"%@",object[@"data"][@"first_login"]];
                if ([first_login isEqualToString:@"1"]) {
                    //新创建用户
                    //[self updateUserInfoThirdLogin:YES];
                    
                    NSString *userIconURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserIconURL"];
                    NSLog(@"第三方url --- %@",userIconURL);
                    UIImage *headerImage = [UIImage imageWithData:[NSData
                                                                   dataWithContentsOfURL:[NSURL URLWithString:userIconURL]]];
                    AliyunOSSManager *ossManager = [AliyunOSSManager new];
                    [ossManager initOSSClient];
                    
                    NSData *imageData = UIImageJPEGRepresentation(headerImage, 0.5);
                    //uploading
                    [ossManager uploadThirdHeaderImage:imageData type:self.typeStr];
                    
                }else{
                    [self updateUserInfoThirdLogin:NO];
                }
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            self.loginButton.alpha = 1;
            self.loadingView.alpha = 0;
            [CheckTokenManage chekcToken:error];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
        
    }else{
        
        //verify moble
        NSDictionary *parameter = @{@"mobile":self.telTextField.text,
                                    @"code":self.coderTextField.text,
                                    @"scene":@"update_mobile"};
        NSString *urlStr = [NSString stringWithFormat:@"%@/user/verify-mobile",API];
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"%@",object);
            self.loginButton.alpha = 1;
            self.loadingView.alpha = 0;
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"verify_key"] forKey:VERIFYKEY];//update
                //更新手机号
                [self updateUserTelAc];
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            self.loginButton.alpha = 1;
            self.loadingView.alpha = 0;
            [CheckTokenManage chekcToken:error type:@"login" viewController:self];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }
}


#pragma mark - 三方创建用户成功
- (void)crearUserSuccessful{

    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]&&[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
    
        //*** 上传DEVICE_TOKEN ***//
        NSString     *urlStr = [NSString stringWithFormat:@"%@/user/push",API];
        NSDictionary *param  = @{@"device_token":[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN],
                                 @"device_os":@"ios",
                                 @"badge":@(0)};
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
            //NSLog(@"  userPush : %@",object);
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
        } progress:^(float progress) {}];
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
    }
    
    else if ([self.entranceType isEqualToString:@"MyMoney"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMoneyLoginNextAction" object:nil];
    }else if ([self.entranceType isEqualToString:@"MyBiuRecord"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyBiuRecordLoginNextAction" object:nil];
    }
    else if ([self.entranceType isEqualToString:@"DetailBiuNumbers"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailBiuNumbersLoginNextAction" object:nil];
        
    }else if ([self.entranceType isEqualToString:@"homeBuyGood"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"homeBuyGoodNextAction" object:nil];
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.entranceType isEqualToString:@"NewUserRed"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserRed" object:nil];
            
        }
    }];
}

#pragma mark - 三方登录 tel新用户 更新用户信息
- (void)updateUserInfoThirdLogin:(BOOL)isCreatUser{
    
    NSString *nickName       = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserName"];
    NSString *bindUserToken  = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserOpenid"];
    NSString *bindUnionToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserUnionid"];
    NSString *userHeaderFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindThirdUserHeaderImage"];
    
    
    NSLog(@"%@---%@---%@",nickName,bindUserToken,userHeaderFileName);
    
    NSDictionary *parameter = nil;
    if ([self.typeStr isEqualToString:@"qq"]) {
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"qq",
                          @"social_token":bindUserToken};
        }else{
            parameter = @{
                          @"social_source":@"qq",
                          @"social_token":bindUserToken};
        }
    }else if ([self.typeStr isEqualToString:@"weibo"]){
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"weibo",
                          @"social_token":bindUserToken};
        }else{
            parameter = @{@"social_source":@"weibo",
                          @"social_token":bindUserToken};
        }
        
    }else{
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"wechat",
                          @"social_token":bindUserToken,
                          @"union_token":bindUnionToken};
        }else{
            parameter = @{
                          @"social_source":@"wechat",
                          @"social_token":bindUserToken,
                          @"union_token":bindUnionToken};
        }
    }
    
    NSLog(@"%@",parameter);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
    [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]){
            
            
            
            
            //nickname
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:NICKNAME];
            //avatar
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"avatar"] forKey:USER_AVATAR];
            //username
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"username"] forKey:USERNAME];
            //id
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id"] forKey:USER_ID];
            
            
            //*** 上传DEVICE_TOKEN ***//
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]&&[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
                
                NSString     *urlStr = [NSString stringWithFormat:@"%@/user/push",API];
                NSDictionary *param  = @{@"device_token":[[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN],
                                         @"device_os":@"ios",
                                         @"badge":@(0)};
                [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
                    //NSLog(@"  userPush : %@",object);
                } withFailureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                } progress:^(float progress) {}];
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
            }
            else if ([self.entranceType isEqualToString:@"MyMoney"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyMoneyLoginNextAction" object:nil];
            }else if ([self.entranceType isEqualToString:@"MyBiuRecord"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MyBiuRecordLoginNextAction" object:nil];
            }
            else if ([self.entranceType isEqualToString:@"DetailBiuNumbers"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailBiuNumbersLoginNextAction" object:nil];
                
            }else if ([self.entranceType isEqualToString:@"homeBuyGood"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homeBuyGoodNextAction" object:nil];
            }
            
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self.entranceType isEqualToString:@"NewUserRed"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewUserRed" object:nil];
                    
                }
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error];
    }];
}




#pragma mark - 更新手机号
- (void)updateUserTelAc{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
    
    
    NSString *verifyKey = [[NSUserDefaults standardUserDefaults] objectForKey:VERIFYKEY];
    NSLog(@"%@",verifyKey);
    NSDictionary *parameter = @{@"username":self.telTextField.text,
                                @"scene":@"update_mobile",
                                @"verify_key":verifyKey};
    NSLog(@"%@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
    
    
    [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
        
        if ([stateStr isEqualToString:@"success"]){
            //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userInfoVCIsShowProgress"];
            
            //更新用户昵称
            //username
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"username"] forKey:USERNAME];
            [self showProgress:@"手机号修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUsernameAc" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showProgress:responseObject[@"status"][@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error];
    }];
}


#pragma mark - 输入
- (void)textFieldDidChange:(UITextField *)sender{

    if (self.telTextField.text.length>0&&self.coderTextField.text.length>0) {
        
        self.loginButton.alpha = 1;
        self.loginButton.userInteractionEnabled = YES;
    }else{
    
        self.loginButton.alpha = 0.6;
        self.loginButton.userInteractionEnabled = NO;
    }
}


#pragma mark - NSTimer
-(void)startCountdown{
    
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    _startTime = 60;
    
    
    [self.requestCoderButton setTitleColor:[UIColor colorWithHex:@"cfcecc"] forState:UIControlStateHighlighted];
    [self.requestCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.requestCoderButton setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)_startTime] forState:UIControlStateNormal];
}

-(void)timeGo{
    
    _startTime--;
    
    self.requestCoderButton.userInteractionEnabled = NO;
    [self.requestCoderButton setTitleColor:[UIColor colorWithHex:@"cfcecc"] forState:UIControlStateHighlighted];
    [self.requestCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.requestCoderButton setTitle:[NSString stringWithFormat:@"重新发送(%lds)",(long)_startTime] forState:UIControlStateNormal];
    
    if (_startTime==0) {
        
        self.requestCoderButton.userInteractionEnabled = YES;
        [self.requestCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.requestCoderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.requestCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
        
        isResetSmsCode = YES;
        [_valiCodeTimer invalidate];
        _valiCodeTimer = nil;
    }
}


- (void)stopCount{
    
    self.requestCoderButton.userInteractionEnabled = YES;
    [self.requestCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.requestCoderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.requestCoderButton setTitle:@"重新发送" forState:UIControlStateNormal];
    
    [_valiCodeTimer invalidate];
    _valiCodeTimer = nil;
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 11) {
        [self.coderTextField becomeFirstResponder];
    }
    return newLength <= 11;
}


//MBProgress
- (void)showProgress:(NSString *)tipStr{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
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
-(UITextField *)telTextField{
    
    if (_telTextField==nil) {
        _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(41, SCREEN_WIDTH/375*(88+64), SCREEN_WIDTH-82, SCREEN_WIDTH/375*20)];
    }
    return _telTextField;
}

-(UIView *)telline{
    
    if (_telline==nil) {
        _telline = [[UITextField alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(88+20+2+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*1)];
    }
    return _telline;
}


-(UITextField *)coderTextField{
    
    if (_coderTextField==nil) {
        _coderTextField = [[UITextField alloc] initWithFrame:CGRectMake(41, SCREEN_WIDTH/375*(138+64), SCREEN_WIDTH/2-41, SCREEN_WIDTH/375*20)];
    }
    return _coderTextField;
}

-(UIView *)coderline{
    
    if (_coderline==nil) {
        _coderline = [[UITextField alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(138+20+2+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*1)];
    }
    return _coderline;
}

-(UIButton *)loginButton{
    
    if (_loginButton==nil) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(192+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*40)];
    }
    return _loginButton;
}

-(UIButton *)requestCoderButton{
    
    if (_requestCoderButton==nil) {
        _requestCoderButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-41-120, SCREEN_WIDTH/375*(138+64), 120, SCREEN_WIDTH/375*20)];
    }
    return _requestCoderButton;
}

-(UILabel *)tipLabel{
    
    if (_tipLabel==nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*18, SCREEN_WIDTH, SCREEN_WIDTH/375*14)];
    }
    return _tipLabel;
}

-(UIButton *)serverButton{
    
    if (_serverButton==nil) {
        _serverButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*224, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*18, 200, SCREEN_WIDTH/375*14)];
    }
    return _serverButton;
}

@end
