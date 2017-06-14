//
//  BFFeedBackViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFFeedBackViewController.h"

@interface BFFeedBackViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UIView *suggestView;
//反馈
@property(nonatomic,strong)UITextView *suggestTextView;
//反馈占位Label
@property(nonatomic,strong)UILabel *suggestPlaceHolderLabel;
//0/25
@property(nonatomic,strong)UILabel *worldCountLabel;

@property (nonatomic , strong) UIButton *sendButton;

@property (nonatomic , strong) MBProgressHUD *HUD;
@end

@implementation BFFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                = @"帮助反馈";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.suggestView.layer.cornerRadius = 4;
    self.suggestView.layer.borderColor = [UIColor colorWithHex:@"DDDDDD"].CGColor;
    self.suggestView.layer.borderWidth = 1;
    self.suggestView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.suggestView];
    
    //self.suggestTextView.layer.cornerRadius = 4;
    //self.suggestTextView.layer.borderColor = [UIColor colorWithHex:@"DDDDDD"].CGColor;
    //self.suggestTextView.layer.borderWidth = 1;
    self.suggestTextView.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.suggestTextView.delegate = self;
    self.suggestTextView.backgroundColor = [UIColor whiteColor];
    [self.suggestView addSubview:self.suggestTextView];
    
    
    self.suggestPlaceHolderLabel.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.suggestPlaceHolderLabel.text=@"告诉我们遇到了什么问题？";
    self.suggestPlaceHolderLabel.textColor=[UIColor colorWithHex:@"B2B2B2"];
    //self.suggestPlaceHolderLabel.backgroundColor = [UIColor orangeColor];
    [self.suggestTextView addSubview:self.suggestPlaceHolderLabel];
    
    [self.suggestTextView becomeFirstResponder];
    
    self.worldCountLabel.textAlignment = NSTextAlignmentRight;
    self.worldCountLabel.text = @"0/255";
    self.worldCountLabel.font = [UIFont systemFontOfSize:14];
    self.worldCountLabel.textColor = [UIColor colorWithHex:@"B2B2B2"];
    //self.worldCountLabel.backgroundColor = [UIColor orangeColor];
    [self.suggestView addSubview:self.worldCountLabel];
    
    
    
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.sendButton.alpha = 0.6;
    self.sendButton.userInteractionEnabled = NO;
    [self.view addSubview:self.sendButton];
    
    
    [self.sendButton addTarget:self action:@selector(sendButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    [self.view addGestureRecognizer:viewTapGR];
    
}


#pragma mark - 发送
- (void)sendButtonDidClickedAction:(UIButton *)snder{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    
    //NSLog(@"%@",self.suggestTextView.text);
    NSDictionary *parameter = @{@"content":self.suggestTextView.text};
    NSString *urlStr = [NSString stringWithFormat:@"%@/common/feedback",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"%@",object);
        [self.HUD hide:YES];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //[self showProgress:@"反馈成功"];
            [self showProgress:@"发送成功,感谢您的反馈"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showProgress:object[@"status"][@"message"]];
        }
    } withFailureBlock:^(NSError *error) {
        if (![[NSString stringWithFormat:@"%@",error.localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"]) {
            [self showProgress:@"系统繁忙,请稍后再试"];
        }
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error type:@"login" viewController:self];
    } progress:^(float progress) {
        
        NSLog(@"%f",progress);
    }];
}

- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.suggestTextView resignFirstResponder];
}

#pragma mark - TextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    //[self.suggestPlaceHolderLabel removeFromSuperview];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.suggestTextView.text.length==0) {
        [self.suggestTextView addSubview:self.suggestPlaceHolderLabel];
    }else{
        [self.suggestPlaceHolderLabel removeFromSuperview];
    }
    
    //TextView字符
    self.worldCountLabel.text = [NSString stringWithFormat:@"%lu/255",(unsigned long)textView.text.length];
    NSString *textCodeString = [self.suggestTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textCodeString.length>0) {
        self.sendButton.alpha = 1;
        self.sendButton.userInteractionEnabled = YES;
    }else{
        self.sendButton.alpha = 0.6;
        self.sendButton.userInteractionEnabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 255) {
            
            return NO;
        }
        else {
            return YES;
        }
    }
}


//lazy
-(UIView *)suggestView{
    
    if (_suggestView==nil) {
        _suggestView=[[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*(11+64), SCREEN_WIDTH-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*200)];
    }
    return _suggestView;
}

-(UITextView *)suggestTextView{
    
    if (_suggestTextView==nil) {
        _suggestTextView=[[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*0, SCREEN_WIDTH-SCREEN_WIDTH/375*20-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*200)];
    }
    return _suggestTextView;
}

-(UILabel *)suggestPlaceHolderLabel{
    
    if (_suggestPlaceHolderLabel==nil) {
        _suggestPlaceHolderLabel =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*4, SCREEN_WIDTH/375*7, self.suggestTextView.frame.size.width, SCREEN_WIDTH/375*17)];
    }
    return _suggestPlaceHolderLabel;
}

-(UILabel *)worldCountLabel{
    
    if (_worldCountLabel==nil) {
        _worldCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*12-100-15, SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*25, 100, SCREEN_WIDTH/375*20)];
    }
    return _worldCountLabel;
}

-(UIButton *)sendButton{
    
    if (_sendButton==nil) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*(231+64), SCREEN_WIDTH-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*40)];
    }
    return _sendButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@end
