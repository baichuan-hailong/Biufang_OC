//
//  BFPerfectAwardInfoViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPerfectAwardInfoViewController.h"
#import "WTReTextField.h"

@interface BFPerfectAwardInfoViewController ()<UITextFieldDelegate>
@property (nonatomic , strong) UILabel *topLabel;

@property (nonatomic , strong) UILabel *nickLabel;
@property (nonatomic , strong) UITextField *nickNameTextField;
@property (nonatomic , strong) UIView *nickline;

@property (nonatomic , strong) UILabel *cardIDLabel;
@property (nonatomic , strong) WTReTextField *cardIDTextField;
@property (nonatomic , strong) UIView *cardIDline;

@property (nonatomic , strong) UIButton *finishButton;

@property (nonatomic , strong) UILabel *downLabel;

//successful
@property (nonatomic , strong) UIView *finishView;
@property (nonatomic , strong) UILabel *finishTopLabel;
@property (nonatomic , strong) UILabel *finishNameLabel;
@property (nonatomic , strong) UILabel *finishCardIDLabel;

//loading
@property(nonatomic,strong)UIView *loadingView;
//loading-Image
@property(nonatomic,strong)UIImageView *loadImageView;

@end

@implementation BFPerfectAwardInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
    //NSLog(@"%@---%ld",realName,realName.length);
    if (realName.length>0) {
        self.title                = @"领奖信息";
        [self showFinishView];
    }else{
        self.title                = @"完善领奖信息";
        [self creatUIAc];
    }
    
    //[self creatUIAc];
    if (_isLuckyBool) {
        [self leftButton];
    }
}


- (void)leftButton {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"close icon"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 15, 64, 40);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)backAction:(UIButton *)sender{
    
    [self.nickNameTextField resignFirstResponder];
    [self.cardIDTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)creatUIAc{
    self.topLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.topLabel.textAlignment = NSTextAlignmentLeft;
    
    //self.topLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    //self.topLabel.text = @"我们需要您提供更详细的身份信息,以便于领取您的奖品";
    //[self.view addSubview:self.topLabel];
    
    self.nickLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.nickLabel.textAlignment = NSTextAlignmentLeft;
    self.nickLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.nickLabel.text = @"姓名";
    [self.view addSubview:self.nickLabel];
    
    self.nickNameTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.nickNameTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.nickNameTextField.textAlignment = NSTextAlignmentLeft;
    self.nickNameTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    [self.nickNameTextField becomeFirstResponder];
    self.nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.nickNameTextField];
    
    self.nickline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.view addSubview:self.nickline];
    
    self.cardIDLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.cardIDLabel.textAlignment = NSTextAlignmentLeft;
    self.cardIDLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.cardIDLabel.text = @"身份证号";
    [self.view addSubview:self.cardIDLabel];
    
    self.cardIDTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.cardIDTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.cardIDTextField.textAlignment = NSTextAlignmentLeft;
    self.cardIDTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.cardIDTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.cardIDTextField.delegate = self;
    self.cardIDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //self.cardIDTextField.pattern = @"^([0-9a-zA-Z]{4}(?: )){3}[0-9a-zA-Z]{4}$";
    //[self.cardIDTextField setPattern:@"^([0-9a-zA-Z]{4}(?: )){4}[0-9a-zA-Z]{4}$"];
    [self.view addSubview:self.cardIDTextField];
    
    
    
    
    
    self.cardIDline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.view addSubview:self.cardIDline];
    
    
    
    [self.finishButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    self.finishButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.finishButton.alpha = 0.6;
    self.finishButton.userInteractionEnabled = NO;
    [self.view addSubview:self.finishButton];
    
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(149+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*40)];
    self.loadingView.alpha = 0;
    self.loadingView.layer.cornerRadius = SCREEN_WIDTH/375*5;
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.backgroundColor = [UIColor colorWithHex:RED_COLOR];
    [self.view addSubview:self.loadingView];
    
    self.loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-76-SCREEN_WIDTH/375*21)/2, SCREEN_WIDTH/375*(40-21)/2, SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*21)];
    self.loadImageView.image = [UIImage imageNamed:@"loadingImage"];
    [self.loadingView addSubview:self.loadImageView];
    
    
    
    [self.nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cardIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.finishButton addTarget:self action:@selector(finishButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    [self.view addGestureRecognizer:viewTapGR];
    
    self.downLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.downLabel.textAlignment = NSTextAlignmentLeft;
    
    if (iPhone5) {
        self.downLabel.font = [UIFont systemFontOfSize:10];
    }else{
        
        self.downLabel.font = [UIFont systemFontOfSize:12];
    }
    self.downLabel.numberOfLines = 0;
    //self.downLabel.text = @"我们将严格保密您的身份信息，身份信息无法修改，且具有唯一性，不能再用于其他账户认证。您在成为幸运儿后，需要凭借此身份信息领取";
    
    NSString *testString = @"我们将严格保密您的身份信息，身份信息无法修改，且具有唯一性，不能再用于其他账户认证。您在成为幸运儿后，需要凭借此身份信息领取";
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:testString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:SCREEN_WIDTH/375*1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [testString length])];
    [self.downLabel setAttributedText:attributedString1];
    [self.view addSubview:self.downLabel];
}


- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.nickNameTextField resignFirstResponder];
    [self.cardIDTextField resignFirstResponder];
}

#pragma mark - changed
- (void)textFieldDidChange:(UITextField *)sender{
    
    NSString *textCodeString = [self.cardIDTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.cardIDTextField.text = [self changCircleCardID:textCodeString];
    
    if (self.nickNameTextField.text.length>0&&textCodeString.length>14) {
        //NSLog(@"%@",textCodeString);
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
        
    }else{
        self.finishButton.alpha = 0.6;
        self.finishButton.userInteractionEnabled = NO;
    }
}


#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 21; //411 423 1991 0210 6530
}

#pragma mark - 完成
- (void)finishButtonDidClickedAction:(UIButton *)sender{
    
    
    //loading
    self.finishButton.alpha = 0;
    self.loadingView.alpha = 1;
    //旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.loadImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    
    
    NSString *textCodeString = [self.cardIDTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    NSLog(@"%@",textCodeString);
    NSString *uptextCodeString = [textCodeString uppercaseString];
    NSLog(@"%@",uptextCodeString);
    
    
    NSLog(@"%ld",(unsigned long)textCodeString.length);
    NSLog(@"生日 -- %@",[textCodeString substringWithRange:NSMakeRange(6, 4)]);
    
    
    
    
    NSString *birthday = [textCodeString substringWithRange:NSMakeRange(6, 4)];
    NSInteger birthdarInt = [birthday integerValue];
    
    
    if ([BFRegularManage checkUserIdCard:uptextCodeString]) {
        if (textCodeString.length==18) {
            if (birthdarInt>1900&&birthdarInt<2017) {
                [self finshRequestAc:uptextCodeString];
            }else{
                [self showProgress:@"身份证号码错误,请重新输入"];
                self.finishButton.alpha = 1;
                self.loadingView.alpha = 0;
            }
        }else{
            [self finshRequestAc:textCodeString];
        }
    }else{
        self.finishButton.alpha = 1;
        self.loadingView.alpha = 0;
        [self showProgress:@"身份证号码错误,请重新输入"];
    }
    
}

- (void)finshRequestAc:(NSString *)textCodeString{
    //NSLog(@"fnish");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
    
    
    
    NSDictionary *parameter = @{@"realname":self.nickNameTextField.text,
                                @"id_num":textCodeString};
    //NSLog(@"%@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
    [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //NSLog(@"%@",responseObject[@"status"][@"message"]);
        self.finishButton.alpha = 1;
        self.loadingView.alpha = 0;
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
        
        if ([stateStr isEqualToString:@"success"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userInfoVCIsShowProgress"];
            //real name
            [[NSUserDefaults standardUserDefaults] setObject:self.nickNameTextField.text forKey:REAL_NAME];
            //card ID
            [[NSUserDefaults standardUserDefaults] setObject:textCodeString forKey:CARD_ID];
            //self.title                = @"领奖信息";
            //[self showFinishView];
            
            if (_isLuckyBool) {
                
                [self.nickNameTextField resignFirstResponder];
                [self.cardIDTextField resignFirstResponder];
                //Notification
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAwardOrderOpreation" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
            
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }else{
            [self showProgress:responseObject[@"status"][@"message"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error type:@"login" viewController:self];
        self.finishButton.alpha = 1;
        self.loadingView.alpha = 0;
    }];
    
    
}



- (void)showFinishView{
    
    self.finishView.backgroundColor = [UIColor whiteColor];
    self.view = self.finishView;
    
    //self.finishTopLabel.textColor = [UIColor colorWithHex:@"000000"];
    //self.finishTopLabel.textAlignment = NSTextAlignmentCenter;
    //self.finishTopLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    //self.finishTopLabel.text = @"在中奖后需凭以下身份信息领取奖品";
    //[self.finishView addSubview:self.finishTopLabel];
    
    self.nickLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.nickLabel.textAlignment = NSTextAlignmentLeft;
    self.nickLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.nickLabel.text = @"姓名";
    [self.finishView addSubview:self.nickLabel];
    
    self.finishNameLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.finishNameLabel.textAlignment = NSTextAlignmentLeft;
    self.finishNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.finishNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
    [self.finishView addSubview:self.finishNameLabel];
    
    self.nickline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.finishView addSubview:self.nickline];
    
    self.cardIDLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.cardIDLabel.textAlignment = NSTextAlignmentLeft;
    self.cardIDLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.cardIDLabel.text = @"身份证号";
    [self.finishView addSubview:self.cardIDLabel];
    
    
    
    self.finishCardIDLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.finishCardIDLabel.textAlignment = NSTextAlignmentLeft;
    self.finishCardIDLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    NSString *cardID = [[NSUserDefaults standardUserDefaults] objectForKey:CARD_ID];
    if (cardID.length>0) {
       self.finishCardIDLabel.text = [self changCardID:cardID];
    }
    
    
    
    
    [self.finishView addSubview:self.finishCardIDLabel];
    
    self.cardIDline.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.finishView addSubview:self.cardIDline];
    
    self.downLabel.frame = CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(155+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*50);
    self.downLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.downLabel.textAlignment = NSTextAlignmentLeft;
    self.downLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.downLabel.numberOfLines = 0;
    NSString *testString = @"我们将严格保密您的身份信息，身份信息无法修改，且具有唯一性，不能再用于其他账户认证。您在成为幸运儿后，需要凭借此身份信息领取";
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:testString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:SCREEN_WIDTH/375*1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [testString length])];
    [self.downLabel setAttributedText:attributedString1];
    [self.finishView addSubview:self.downLabel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userInfoVCIsShowProgress"];
    
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tipStr;
    hud.margin = SCREEN_WIDTH/375*10.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

//lazy
-(UILabel *)topLabel{
    
    if (_topLabel==nil) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(19+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*20)];
    }
    return _topLabel;
}

-(UILabel *)nickLabel{
    
    if (_nickLabel==nil) {
        _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*41, SCREEN_WIDTH/375*(40+64), SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*20)];
    }
    return _nickLabel;
}
-(UITextField *)nickNameTextField{
    
    if (_nickNameTextField==nil) {
        _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*113, SCREEN_WIDTH/375*(40+64), SCREEN_WIDTH-SCREEN_WIDTH/375*123-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*20)];
    }
    return _nickNameTextField;
}

-(UIView *)nickline{
    
    if (_nickline==nil) {
        _nickline = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(71+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*1)];
    }
    return _nickline;
}


-(UILabel *)cardIDLabel{
    
    if (_cardIDLabel==nil) {
        _cardIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*41, SCREEN_WIDTH/375*(90+64), SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*20)];
    }
    return _cardIDLabel;
}

-(WTReTextField *)cardIDTextField{
    
    if (_cardIDTextField==nil) {
        _cardIDTextField = [[WTReTextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*113, SCREEN_WIDTH/375*(90+64), SCREEN_WIDTH-SCREEN_WIDTH/375*123-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*20)];
    }
    return _cardIDTextField;
}

-(UIView *)cardIDline{
    
    if (_cardIDline==nil) {
        _cardIDline = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(121+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*1)];
    }
    return _cardIDline;
}

-(UIButton *)finishButton{
    
    if (_finishButton==nil) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(149+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*40)];
    }
    return _finishButton;
}


-(UILabel *)downLabel{
    
    if (_downLabel==nil) {
        _downLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*(204+64), SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*50)];
    }
    return _downLabel;
}



//@property (nonatomic , strong) UIView *finishView;
-(UIView *)finishView{
    
    if (_finishView==nil) {
        _finishView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _finishView;
}
//@property (nonatomic , strong) UILabel *finishTopLabel;
-(UILabel *)finishTopLabel{
    
    if (_finishTopLabel==nil) {
        _finishTopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(21+64), SCREEN_WIDTH, SCREEN_WIDTH/375*14)];
    }
    return _finishTopLabel;
}
//@property (nonatomic , strong) UILabel *finishNameLabel;
-(UILabel *)finishNameLabel{
    
    if (_finishNameLabel==nil) {
        _finishNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*122, SCREEN_WIDTH/375*(35+64), SCREEN_WIDTH, SCREEN_WIDTH/375*36)];
    }
    return _finishNameLabel;
}
//@property (nonatomic , strong) UILabel *finishCardIDLabel;
-(UILabel *)finishCardIDLabel{
    
    if (_finishCardIDLabel==nil) {
        _finishCardIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*122, SCREEN_WIDTH/375*(81+64), SCREEN_WIDTH, SCREEN_WIDTH/375*36)];
    }
    return _finishCardIDLabel;
}



//chang CARDID
- (NSString *)changCardID:(NSString *)cardStr{

    //NSLog(@"card ID --- %@",cardStr);//000 000 0000 0000 0000
    NSString *tempStr = [cardStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString * tempID =  [[NSMutableString alloc]initWithString:tempStr];
    //3 7 12 17
    [tempID insertString:@" " atIndex:6];
    [tempID insertString:@" " atIndex:11];
    [tempID insertString:@" " atIndex:16];
    //[tempID insertString:@" " atIndex:17];
    NSLog(@"%@",tempID);
    return tempID;
}

- (NSString *)changCircleCardID:(NSString *)cardStr{
    
    NSInteger length = cardStr.length;
    
    //NSLog(@"card ID --- %@",cardStr);//000 000 0000 0000 0000
    NSMutableString * tempID =  [[NSMutableString alloc]initWithString:cardStr];
    if(length>14){
        //3 7 12 17
        [tempID insertString:@" " atIndex:6];
        [tempID insertString:@" " atIndex:11];
        [tempID insertString:@" " atIndex:16];
        //[tempID insertString:@" " atIndex:17];
    }else if (length>10){
        [tempID insertString:@" " atIndex:6];
        [tempID insertString:@" " atIndex:11];
        //[tempID insertString:@" " atIndex:12];
    }else if (length>6){
        [tempID insertString:@" " atIndex:6];
        //[tempID insertString:@" " atIndex:7];
    }else if (length>3) {
        //[tempID insertString:@" " atIndex:3];
    }
    
    
    NSLog(@"%@",tempID);
    
    
    return tempID;
}
@end
