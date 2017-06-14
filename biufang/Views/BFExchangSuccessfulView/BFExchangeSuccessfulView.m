//
//  BFExchangeSuccessfulView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/27.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFExchangeSuccessfulView.h"

@interface BFExchangeSuccessfulView ()
@property (nonatomic , strong) UIView *bodyView;
@property (nonatomic , strong) UIImageView *exchangeImageView;
@property (nonatomic , strong) UILabel *tipLabel;
@property (nonatomic , strong) UILabel *firstLabel;
@property (nonatomic , strong) UILabel *secondLabel;
@property (nonatomic , strong) UIButton *finishButton;
@end


@implementation BFExchangeSuccessfulView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
    }
    return self;
}



- (void)showSuccessful{

    self.bodyView            = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*280)/2,
                                                                            SCREEN_WIDTH/375*128,
                                                                            SCREEN_WIDTH/375*280,
                                                                            SCREEN_WIDTH/375*240)];
    self.bodyView.backgroundColor     = [UIColor colorWithHex:@"FFFFFF"];
    self.bodyView.layer.cornerRadius  = SCREEN_WIDTH/375*8;
    self.bodyView.layer.masksToBounds = YES;
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [keyWindow addSubview:self.bodyView];
    
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.bodyView.frame      = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*280)/2,
                                              SCREEN_WIDTH/375*128+SCREEN_WIDTH/375*20,
                                              SCREEN_WIDTH/375*280,
                                              SCREEN_WIDTH/375*240);
    } completion:^(BOOL finished) {
        
    }];
    
    //add subs
    self.exchangeImageView.image = [UIImage imageNamed:@"exchangesuccessfulimage"];
    [self.bodyView addSubview:self.exchangeImageView];
    
    self.tipLabel.text = @"兑换成功";
    self.tipLabel.textColor = [UIColor colorWithHex:@"030303"];
    self.tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*17];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.bodyView addSubview:self.tipLabel];
    
    self.firstLabel.text = @"我们会在1个工作日内联系您,";
    self.firstLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.firstLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    [self.bodyView addSubview:self.firstLabel];
    //
    self.secondLabel.text = @"与您核实兑奖信息";
    self.secondLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.secondLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.bodyView addSubview:self.secondLabel];
    
    
    [self.finishButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"5599F5"] size:self.finishButton.frame.size] forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    self.finishButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.finishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.finishButton.layer.cornerRadius = SCREEN_WIDTH/375*3;
    self.finishButton.layer.masksToBounds= YES;
    [self.bodyView addSubview:self.finishButton];
    
    [self.finishButton addTarget:self action:@selector(finishButtonDidClickAction:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 完成
- (void)finishButtonDidClickAction:(UIButton *)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(exchangeSuccessful:)]) {
        [self.delegate exchangeSuccessful:sender];
        [UIView animateWithDuration:1.0 animations:^{
            [self removeFromSuperview];
            [self.bodyView removeFromSuperview];
            [self.exchangeImageView removeFromSuperview];
            [self.tipLabel removeFromSuperview];
            [self.firstLabel removeFromSuperview];
            [self.secondLabel removeFromSuperview];
            [self.finishButton removeFromSuperview];
        }];
    }
}




//touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch            = [touches anyObject];
    CGPoint currentPosition   = [touch locationInView:self];
    CGFloat currentY          = currentPosition.y;
    if (currentY<SCREEN_WIDTH/375*128||currentY>SCREEN_WIDTH/375*368){
        [UIView animateWithDuration:1.0 animations:^{
            [self removeFromSuperview];
            [self.bodyView removeFromSuperview];
            [self.exchangeImageView removeFromSuperview];
            [self.tipLabel removeFromSuperview];
            [self.firstLabel removeFromSuperview];
            [self.secondLabel removeFromSuperview];
            [self.finishButton removeFromSuperview];
        }];
    }
}

//lazy
-(UIImageView *)exchangeImageView{

    if (_exchangeImageView==nil) {//110x96
        _exchangeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(280-55)/2, SCREEN_WIDTH/375*30, SCREEN_WIDTH/375*55, SCREEN_WIDTH/375*48)];
    }
    return _exchangeImageView;
}

-(UILabel *)tipLabel{

    if (_tipLabel==nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*90, SCREEN_WIDTH/375*280, SCREEN_WIDTH/375*20)];
    }
    return _tipLabel;
}

-(UILabel *)firstLabel{

    if (_firstLabel==nil) {
        _firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*119, SCREEN_WIDTH/375*280, SCREEN_WIDTH/375*14)];
    }
    return _firstLabel;
}

-(UILabel *)secondLabel{

    if (_secondLabel==nil) {
        _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*138, SCREEN_WIDTH/375*280, SCREEN_WIDTH/375*14)];
    }
    return _secondLabel;
}

-(UIButton *)finishButton{

    if (_finishButton==nil) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*181, SCREEN_WIDTH/375*250, SCREEN_WIDTH/375*40)];
    }
    return _finishButton;
}

@end
