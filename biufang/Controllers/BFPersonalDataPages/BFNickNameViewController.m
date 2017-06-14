//
//  BFNickNameViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNickNameViewController.h"

@interface BFNickNameViewController ()<UITextFieldDelegate>
@property (nonatomic , strong) UITextField *nickNameTextField;

@property (nonatomic , strong) UIButton *finishButton;

@property (nonatomic , strong) UIView *line;

@end

@implementation BFNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title                = @"修改昵称";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    [self setUIAc];
}

- (void)setUIAc{

    //self.nickNameTextField.backgroundColor = [UIColor redColor];
    self.nickNameTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.nickNameTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.nickNameTextField.textAlignment = NSTextAlignmentCenter;
    self.nickNameTextField.font = [UIFont systemFontOfSize:14];
    self.nickNameTextField.placeholder = @"输入你的昵称";
    self.nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    if (nickName.length!=0) {
        self.nickNameTextField.text = nickName;
    }else{
    
        self.nickNameTextField.text = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];;
    }
    self.nickNameTextField.delegate = self;
    [self.nickNameTextField becomeFirstResponder];
    [self.view addSubview:self.nickNameTextField];
    
    self.line.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self.view addSubview:self.line];
    
    
    [self.finishButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    self.finishButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.finishButton.alpha = 0.6;
    self.finishButton.userInteractionEnabled = NO;
    [self.view addSubview:self.finishButton];
    
    [self.nickNameTextField addTarget:self action:@selector(nickNameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.finishButton addTarget:self action:@selector(finishButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    [self.view addGestureRecognizer:viewTapGR];
}

- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{

    [self.nickNameTextField resignFirstResponder];
}

#pragma mark - 昵称
- (void)nickNameTextFieldDidChange:(UITextField *)sender{

    NSString *textCodeString = [self.nickNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textCodeString.length>0) {
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
    }else{
    
        self.finishButton.alpha = 0.6;
        self.finishButton.userInteractionEnabled = NO;
    }
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    NSString *textCodeString = [self.nickNameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textCodeString.length>0) {
        
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
    }else{
        self.finishButton.alpha = 0.6;
        self.finishButton.userInteractionEnabled = NO;
    }
    

    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length){
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 20; //411 423 1991 0210 6530
}

#pragma mark - 完成
- (void)finishButtonDidClickedAction:(UIButton *)sender{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
    NSDictionary *parameter = @{@"nickname":self.nickNameTextField.text};
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
    
    [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //NSLog(@"%@",responseObject[@"status"][@"message"]);
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userInfoVCIsShowProgress"];
            //更新用户昵称
            //nickname
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:NICKNAME];
            //username
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"username"] forKey:USERNAME];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showProgress:responseObject[@"status"][@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error type:@"login" viewController:self];
    }];
    
}


//lazy
-(UITextField *)nickNameTextField{

    if (_nickNameTextField==nil) {
        _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(80+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*20)];
    }
    return _nickNameTextField;
}

-(UIView *)line{

    if (_line==nil) {
        _line = [[UITextField alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(82+20+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*1)];
    }
    return _line;
}

-(UIButton *)finishButton{

    if (_finishButton==nil) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(38, SCREEN_WIDTH/375*(140+64), SCREEN_WIDTH-76, SCREEN_WIDTH/375*40)];
    }
    return _finishButton;
}

//MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userInfoVCIsShowProgress"];
    
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
}



@end
