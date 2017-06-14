//
//  BFPayFailedView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPayFailedView.h"


@interface BFPayFailedView ()
//pay result view
@property (nonatomic , strong) UIView *payPopupView;
@property (nonatomic , strong) UIView *topLine;
@property (nonatomic , strong) UIView *middleLine;

@property (nonatomic , strong) UIImageView *failedImageView;
@property (nonatomic , strong) UILabel *topLabel;
@property (nonatomic , strong) UILabel *dowmLabel;

@property (nonatomic , strong) UIButton *leftButton;
@property (nonatomic , strong) UIButton *rightButton;

@end

@implementation BFPayFailedView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
    }
    return self;
}


-(void)showPayFailed{

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    
    [keyWindow addSubview:self];
    
    self.payPopupView.backgroundColor = [UIColor colorWithHex:@"FCFCFC"];
    self.payPopupView.layer.cornerRadius = 12;
    self.payPopupView.layer.masksToBounds= YES;
    [keyWindow addSubview:self.payPopupView];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.payPopupView.frame      = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*270)/2,
                                                  SCREEN_HEIGHT/667*211+SCREEN_WIDTH/375*20,
                                                  SCREEN_WIDTH/375*270,
                                                  SCREEN_WIDTH/375*180);
    } completion:^(BOOL finished) {
    }];
    
    self.failedImageView.image = [UIImage imageNamed:@"paynewFailedimage"];
    [self.payPopupView addSubview:self.failedImageView];
    
    self.topLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.topLabel.textColor = [UIColor colorWithHex:@"030303"];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.text = @"支付失败";
    [self.payPopupView addSubview:self.topLabel];
    
    self.dowmLabel.font = [UIFont systemFontOfSize:13];
    self.dowmLabel.textColor = [UIColor colorWithHex:@"030303"];
    self.dowmLabel.textAlignment = NSTextAlignmentCenter;
    self.dowmLabel.text = @"如未完成支付请重新支付";
    [self.payPopupView addSubview:self.dowmLabel];
    
    self.topLine.backgroundColor = [UIColor colorWithHex:@"4D4D4D"];
    self.topLine.alpha = 0.3;
    [self.payPopupView addSubview:self.topLine];
    
    self.middleLine.backgroundColor = [UIColor colorWithHex:@"4D4D4D"];
    self.middleLine.alpha = 0.3;
    [self.payPopupView addSubview:self.middleLine];
    
    [self.leftButton setTitle:@"知道了" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [self.payPopupView addSubview:self.leftButton];
    
    [self.rightButton setTitle:@"继续支付" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHex:@"0076FF"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [self.payPopupView addSubview:self.rightButton];
    
    [self.leftButton addTarget:self action:@selector(leftButtonPopDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self action:@selector(rightButtonPopDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)leftButtonPopDidClickedAction:(UIButton *)sender{

    if (self.delegate&&[self.delegate respondsToSelector:@selector(canclePay:)]) {
        
        [self.delegate canclePay:sender];
        
        [UIView animateWithDuration:1.0 animations:^{
            [self removeFromSuperview];
            [self.payPopupView removeFromSuperview];
            [self.topLine removeFromSuperview];
            [self.middleLine removeFromSuperview];
            [self.failedImageView removeFromSuperview];
            [self.topLabel removeFromSuperview];
            [self.dowmLabel removeFromSuperview];
            [self.leftButton removeFromSuperview];
            [self.rightButton removeFromSuperview];
        }];
    }
}

- (void)hiddenPayFailed{

    [self removeFromSuperview];
    [self.payPopupView removeFromSuperview];
    [self.topLine removeFromSuperview];
    [self.middleLine removeFromSuperview];
    [self.failedImageView removeFromSuperview];
    [self.topLabel removeFromSuperview];
    [self.dowmLabel removeFromSuperview];
    [self.leftButton removeFromSuperview];
    [self.rightButton removeFromSuperview];
}


- (void)rightButtonPopDidClickedAction:(UIButton *)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(continuePay:)]) {
        [self.delegate continuePay:sender];
        
        [UIView animateWithDuration:1.0 animations:^{
            [self removeFromSuperview];
            [self.payPopupView removeFromSuperview];
            [self.topLine removeFromSuperview];
            [self.middleLine removeFromSuperview];
            [self.failedImageView removeFromSuperview];
            [self.topLabel removeFromSuperview];
            [self.dowmLabel removeFromSuperview];
            [self.leftButton removeFromSuperview];
            [self.rightButton removeFromSuperview];
        }];
    }
}


//lazy
//pay result view
//@property (nonatomic , strong) UIView *payReultBackView;

//@property (nonatomic , strong) UIView *payPopupView;
-(UIView *)payPopupView{
    
    if (_payPopupView==nil) {
        _payPopupView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*270)/2, SCREEN_HEIGHT/667*211, SCREEN_WIDTH/375*270, SCREEN_WIDTH/375*180)];
    }
    return _payPopupView;
}
//@property (nonatomic , strong) UIView *topLine;
-(UIView *)topLine{
    
    if (_topLine==nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/667*136, SCREEN_WIDTH/375*270, SCREEN_WIDTH/375*1)];
    }
    return _topLine;
}
//@property (nonatomic , strong) UIView *middleLine;
-(UIView *)middleLine{
    
    if (_middleLine==nil) {
        _middleLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*270/2-0.5, SCREEN_HEIGHT/667*137, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*44)];
    }
    return _middleLine;
}
//@property (nonatomic , strong) UIImageView *failedImageView;
-(UIImageView *)failedImageView{
    
    if (_failedImageView==nil) {
        _failedImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*270-SCREEN_WIDTH/375*45)/2, SCREEN_HEIGHT/667*20, SCREEN_WIDTH/375*45, SCREEN_WIDTH/375*45)];
    }
    return _failedImageView;
}
//@property (nonatomic , strong) UILabel *topLabel;
-(UILabel *)topLabel{
    
    if (_topLabel==nil) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/667*77, SCREEN_WIDTH/375*270, SCREEN_WIDTH/375*18)];
    }
    return _topLabel;
}
//@property (nonatomic , strong) UILabel *dowmLabel;
-(UILabel *)dowmLabel{
    
    if (_dowmLabel==nil) {
        _dowmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/667*100, SCREEN_WIDTH/375*270, SCREEN_WIDTH/375*16)];
    }
    return _dowmLabel;
}
//@property (nonatomic , strong) UIButton *leftButton;
-(UIButton *)leftButton{
    
    if (_leftButton==nil) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/667*137, SCREEN_WIDTH/375*270/2, SCREEN_WIDTH/375*42)];
    }
    return _leftButton;
}
//@property (nonatomic , strong) UIButton *rightButton;
-(UIButton *)rightButton{
    
    if (_rightButton==nil) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*270/2, SCREEN_HEIGHT/667*137, SCREEN_WIDTH/375*270/2, SCREEN_WIDTH/375*42)];
    }
    return _rightButton;
}


@end
