//
//  BFLogRegView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFLogRegView.h"

@interface BFLogRegView ()

@property (nonatomic , strong) UIView *telLine;
@property (nonatomic , strong) UIView *codeLine;

@property (nonatomic , strong) UILabel *tipLabel;



@end

@implementation BFLogRegView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    self.backgroundColor = [UIColor whiteColor];
    
    //loginLogoImage
    self.headerImageView.image = [UIImage imageNamed:@"loginLogoImage"];
    [self addSubview:self.headerImageView];
    
    //tel
    //self.telTextField.backgroundColor = [UIColor redColor];
    self.telTextField.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.telTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.telTextField.textAlignment = NSTextAlignmentLeft;
    self.telTextField.placeholder = @"手机号";
    self.telTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.telTextField.textColor = [UIColor blackColor];
    self.telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.telTextField];
    
    self.telLine.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self addSubview:self.telLine];
    
    //code
    //self.codeTextField.backgroundColor = [UIColor redColor];
    self.codeTextField.textColor = [UIColor colorWithHex:@"B2B2B2"];
    self.codeTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.codeTextField.textAlignment = NSTextAlignmentLeft;
    self.codeTextField.placeholder = @"验证码";
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.codeTextField.textColor = [UIColor blackColor];
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.codeTextField];
    
    self.codeLine.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self addSubview:self.codeLine];
    
    
    //self.obtainCoderButton.backgroundColor = [UIColor redColor];
    [self.obtainCoderButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    [self.obtainCoderButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.obtainCoderButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.obtainCoderButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.obtainCoderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.obtainCoderButton];
    
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.loginButton.alpha = 0.6;
    self.loginButton.userInteractionEnabled = NO;
    [self addSubview:self.loginButton];
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.codeLine.frame)+SCREEN_WIDTH/375*45, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*40)];
    self.loadingView.alpha = 0;
    self.loadingView.layer.cornerRadius = SCREEN_WIDTH/375*5;
    self.loadingView.layer.masksToBounds = YES;
    self.loadingView.backgroundColor = [UIColor colorWithHex:RED_COLOR];
    [self addSubview:self.loadingView];
    
    self.loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*76-SCREEN_WIDTH/375*21)/2, SCREEN_WIDTH/375*(40-21)/2, SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*21)];
    self.loadImageView.image = [UIImage imageNamed:@"loadingImage"];
    [self.loadingView addSubview:self.loadImageView];
    
    
    self.tipLabel.backgroundColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.tipLabel.text = @"轻点登录，即表示你已阅读并同意《                                 》";
    [self addSubview:self.tipLabel];
    
    
    //self.serverButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*250, 0, 200, SCREEN_WIDTH/375*14)];
    //self.serverButton.backgroundColor = [UIColor redColor];
    [self.serverButton setTitle:@"支持者平台服务协议" forState:UIControlStateNormal];
    [self.serverButton setTitleColor:[UIColor colorWithHex:@"4A90E2"] forState:UIControlStateNormal];
    self.serverButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.serverButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self addSubview:self.serverButton];
    
    
    //thitd
    self.thirdLine.backgroundColor = [UIColor colorWithHex:@"DFDFDF"];
    [self addSubview:self.thirdLine];
    
    self.thirdLabel.backgroundColor = [UIColor whiteColor];
    self.thirdLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.thirdLabel.textAlignment = NSTextAlignmentCenter;
    self.thirdLabel.textColor = [UIColor colorWithHex:@"7D7D7D"];
    self.thirdLabel.text = @"合作账号登录";
    [self addSubview:self.thirdLabel];
    
    //wechat
    [self.wechatButton setImage:[UIImage imageNamed:@"wechatlogin"] forState:UIControlStateNormal];
    //self.wechatButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.wechatButton];
    
    self.wechatLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.wechatLabel.textAlignment = NSTextAlignmentCenter;
    self.wechatLabel.text = @"微信登录";
    self.wechatLabel.textColor = [UIColor colorWithHex:@"7D7D7D"];
    //self.wechatLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.wechatLabel];
    
    
    
    //qq
    //[self.qqButton setBackgroundImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];//44x54
    [self.qqButton setImage:[UIImage imageNamed:@"qqlogin"] forState:UIControlStateNormal];//44x54
    //self.qqButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.qqButton];
    
    
    self.qqLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.qqLabel.textAlignment = NSTextAlignmentCenter;
    self.qqLabel.textColor = [UIColor colorWithHex:@"7D7D7D"];
    self.qqLabel.text = @"QQ登录";
    //self.qqLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.qqLabel];
    
    
    //webo
    //[self.weboButton setBackgroundImage:[UIImage imageNamed:@"webologin"] forState:UIControlStateNormal];//58x52
    [self.weboButton setImage:[UIImage imageNamed:@"webologin"] forState:UIControlStateNormal];//58x52
    //self.weboButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.weboButton];
    
    
    self.weiboLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textColor = [UIColor colorWithHex:@"7D7D7D"];
    self.weiboLabel.text = @"微博登录";
    //self.weiboLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.weiboLabel];
    
    
}


//lazy 288 244
-(UIImageView *)headerImageView{

    if (_headerImageView==nil) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*144)/2, SCREEN_WIDTH/375*(64+35), SCREEN_WIDTH/375*144, SCREEN_WIDTH/375*122)];
    }
    return _headerImageView;
}

-(UITextField *)telTextField{

    if (_telTextField==nil) {
        _telTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*41, SCREEN_WIDTH/375*(64+210), SCREEN_WIDTH-SCREEN_WIDTH/375*82, SCREEN_WIDTH/375*40)];
    }
    return _telTextField;
}

-(UIView *)telLine{
    
    if (_telLine==nil) {
        _telLine = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.telTextField.frame)-SCREEN_WIDTH/375*5, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*1)];
    }
    return _telLine;
}


-(UITextField *)codeTextField{
    
    if (_codeTextField==nil) {
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*41, SCREEN_WIDTH/375*(64+260), SCREEN_WIDTH/5*2, SCREEN_WIDTH/375*40)];
    }
    return _codeTextField;
}

-(UIView *)codeLine{
    
    if (_codeLine==nil) {
        _codeLine = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.codeTextField.frame)-SCREEN_WIDTH/375*5, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*1)];
    }
    return _codeLine;
}

//request
-(UIButton *)obtainCoderButton{
    
    if (_obtainCoderButton==nil) {
        _obtainCoderButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*45-SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*(64+260+10), SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*20)];
    }
    return _obtainCoderButton;
}



//login
-(UIButton *)loginButton{

    if (_loginButton==nil) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.codeLine.frame)+SCREEN_WIDTH/375*45, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*40)];
    }
    return _loginButton;
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

//third Line
- (UIView *)thirdLine{

    if (_thirdLine==nil) {
        _thirdLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*75, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*1)];
    }
    return _thirdLine;
}

-(UILabel *)thirdLabel{

    if (_thirdLabel==nil) {
        _thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*86)/2, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*69, SCREEN_WIDTH/375*88, SCREEN_WIDTH/375*12)];
    }
    return _thirdLabel;
}

//wechat
-(UIButton *)wechatButton{
    
    if (_wechatButton==nil) {
        _wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*48, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27)];
    }
    return _wechatButton;
}

-(UILabel *)wechatLabel{

    if (_wechatLabel==nil) {
       
        _wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*72, SCREEN_WIDTH/375*20)];
    }
    return _wechatLabel;
}

//qq
-(UIButton *)qqButton{

    if (_qqButton==nil) {
        _qqButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*50)/2, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*101, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*27)];
    }
    return _qqButton;
}
-(UILabel *)qqLabel{

    if (_qqLabel==nil) {
       
        _qqLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*69)/2, CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*69, SCREEN_WIDTH/375*20)];
        
    }
    return _qqLabel;
}
//webo
-(UIButton *)weboButton{

    if (_weboButton==nil) {
       _weboButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*38-SCREEN_WIDTH/375*50), CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*99, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*26)];
    }
    return _weboButton;
}

-(UILabel *)weiboLabel{

    if (_weiboLabel==nil) {
        _weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*38-SCREEN_WIDTH/375*50), CGRectGetMaxY(self.loginButton.frame)+SCREEN_WIDTH/375*133, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*20)];
    }
    return _weiboLabel;
}
@end
