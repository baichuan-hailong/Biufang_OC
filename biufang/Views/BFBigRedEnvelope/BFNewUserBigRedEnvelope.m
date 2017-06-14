//
//  BFNewUserBigRedEnvelope.m
//  biufang
//
//  Created by 杜海龙 on 17/2/20.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFNewUserBigRedEnvelope.h"

@interface BFNewUserBigRedEnvelope ()
@property (nonatomic , strong) UIImageView *popImageView;
@property (nonatomic , strong) UIImageView *bigCockImageView;
@property (nonatomic , strong) UIImageView *leftTopImageView;
@property (nonatomic , strong) UIImageView *leftMiddleImageView;
@property (nonatomic , strong) UIImageView *rightTopImageView;
@property (nonatomic , strong) UIImageView *rightMiddleImageView;
@property (nonatomic , strong) UIButton    *receiveButton;
@property (nonatomic , strong) UIButton    *closeButton;
@end


@implementation BFNewUserBigRedEnvelope
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.5;
    }
    return self;
}

- (void)showPopupView{
    //1
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    //popwiningimage
    self.popImageView.image = [UIImage imageNamed:@"popBigRedEnvelope"];
    self.popImageView.userInteractionEnabled = YES;
    [keyWindow addSubview:self.popImageView];
    
    //close
    //self.closeButton.backgroundColor = [UIColor yellowColor];
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"bigRedEnvelopeClose"] forState:UIControlStateNormal];
    //[self.closeButton setImage:[UIImage imageNamed:@"bigRedEnvelopeClose"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(closeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];

    
    //big cock
    self.bigCockImageView.image = [UIImage imageNamed:@"bigRedCockEnvelope"];
    [self.popImageView addSubview:self.bigCockImageView];
    
    //receive
    [self.receiveButton setBackgroundImage:[UIImage imageNamed:@"receiveButtonBigRed"] forState:UIControlStateNormal];
    [self.receiveButton setTitle:@"点击领取" forState:UIControlStateNormal];
    [self.receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.receiveButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    [self.popImageView addSubview:self.receiveButton];
    [self.receiveButton addTarget:self action:@selector(receiveButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];

    //left top
    self.leftTopImageView.image = [UIImage imageNamed:@"leftTopRedCloud"];
    [self.popImageView addSubview:self.leftTopImageView];
    
    //right top
    self.rightTopImageView.image = [UIImage imageNamed:@"rightTopRedCloud"];
    [self.popImageView addSubview:self.rightTopImageView];
    
    //left middle
    self.leftMiddleImageView.image = [UIImage imageNamed:@"bigRedMiddleEnvelope"];
    [self.popImageView addSubview:self.leftMiddleImageView];
    
    //right middle
    self.rightMiddleImageView.image= [UIImage imageNamed:@"bigRedMiddleEnvelope"];
    [self.popImageView addSubview:self.rightMiddleImageView];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.popImageView.frame      = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2,
                                                  SCREEN_WIDTH/375*200+SCREEN_WIDTH/375*20,
                                                  SCREEN_WIDTH/375*296,
                                                  SCREEN_WIDTH/375*301);
        self.closeButton.frame       = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2-SCREEN_WIDTH/375*29,
                                                  SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*44+SCREEN_WIDTH/375*20,
                                                  SCREEN_WIDTH/375*29,
                                                  SCREEN_WIDTH/375*44);
    } completion:nil];
    
}

- (void)closeButtonDidClickedAction:(UIButton *)sener{
 
    [UIView animateWithDuration:0.38 animations:^{
        [self removeFromSuperview];
        [self.popImageView removeFromSuperview];
    }];
}

- (void)receiveButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"receive");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(newUeserBigRedEnvelopeHaveClickedReceiveBtn:)]) {
        [self.delegate newUeserBigRedEnvelopeHaveClickedReceiveBtn:sender];
    }
}

//lazy
-(UIImageView *)popImageView{
    if (_popImageView==nil) {
        _popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*296, SCREEN_WIDTH/375*301)];
    }
    return _popImageView;
}

-(UIImageView *)bigCockImageView{
    if (_bigCockImageView==nil) {
        _bigCockImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*223)/2, -SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*223, SCREEN_WIDTH/375*318)];
    }
    return _bigCockImageView;
}

-(UIButton *)closeButton{
    if (_closeButton==nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2-SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*44, SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*44)];
    }
    return _closeButton;
}

-(UIButton *)receiveButton{
    if (_receiveButton==nil) {
        _receiveButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*252)/2, SCREEN_WIDTH/375*301-SCREEN_WIDTH/375*22-SCREEN_WIDTH/375*58, SCREEN_WIDTH/375*252, SCREEN_WIDTH/375*58)];
    }
    return _receiveButton;
}

-(UIImageView *)leftTopImageView{
    if (_leftTopImageView==nil) {
        _leftTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*22, -SCREEN_WIDTH/375*19, SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*66)];
    }
    return _leftTopImageView;
}


-(UIImageView *)rightTopImageView{
    if (_rightTopImageView==nil) {
        _rightTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*91+SCREEN_WIDTH/375*22, -SCREEN_WIDTH/375*19, SCREEN_WIDTH/375*91, SCREEN_WIDTH/375*60)];
    }
    return _rightTopImageView;
}

-(UIImageView *)leftMiddleImageView{
    if (_leftMiddleImageView==nil) {
        _leftMiddleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*31, SCREEN_WIDTH/375*84.3, SCREEN_WIDTH/375*61, SCREEN_WIDTH/375*121)];
    }
    return _leftMiddleImageView;
}

-(UIImageView *)rightMiddleImageView{
    if (_rightMiddleImageView==nil) {
        _rightMiddleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*31, SCREEN_WIDTH/375*84.3, SCREEN_WIDTH/375*61, SCREEN_WIDTH/375*121)];
    }
    return _rightMiddleImageView;
}

@end
