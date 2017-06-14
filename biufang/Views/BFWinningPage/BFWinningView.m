//
//  BFWinningView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFWinningView.h"

@interface BFWinningView ()
@property (nonatomic , strong) UIImageView *popImageView;
@property (nonatomic , strong) UIImageView *topImageView;
@property (nonatomic , strong) UIImageView *dowmImageView;
@property (nonatomic , strong) UIButton    *rightButton;

@end


@implementation BFWinningView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"000000"];
        self.alpha = 0.8;
    }
    return self;
}

- (void)showWinPop{
    //1
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    //popwiningimage
    self.popImageView.image = [UIImage imageNamed:@"popwiningimage"];
    [keyWindow addSubview:self.popImageView];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.popImageView.frame      = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*242)/2,
                                                   SCREEN_HEIGHT/667*184+SCREEN_WIDTH/375*30,
                                                   SCREEN_WIDTH/375*242,
                                                   SCREEN_WIDTH/375*237);
    } completion:^(BOOL finished) {
    }];
    
    //topwiningimage
    self.topImageView.image = [UIImage imageNamed:@"topwiningimage"];
    [self.popImageView addSubview:self.topImageView];
    
    //downwiningimage
    self.dowmImageView.image = [UIImage imageNamed:@"downwiningimage"];
    [self.popImageView addSubview:self.dowmImageView];
    
    [self.rightButton setTitle:@"领取幸运商品" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHex:@"FF3F56"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:SCREEN_WIDTH/375*16];
    self.rightButton.layer.cornerRadius = SCREEN_WIDTH/375*8;
    self.rightButton.layer.masksToBounds= YES;
    [self.rightButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"FFFFFF"] size:self.rightButton.frame.size] forState:UIControlStateNormal];
    [self.popImageView addSubview:self.rightButton];
    
    self.popImageView.userInteractionEnabled = YES;
    [self.rightButton addTarget:self action:@selector(rightButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)rightButtonDidClicked:(UIButton *)sender{
    
    [UIView animateWithDuration:1.0 animations:^{
        [self removeFromSuperview];
        [self.popImageView removeFromSuperview];
        [self.topImageView removeFromSuperview];
        [self.dowmImageView removeFromSuperview];
        [self.rightButton removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(lookDetail:)]) {
        [self.delegate lookDetail:sender];
    }
}

//touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch            = [touches anyObject];
    CGPoint currentPosition   = [touch locationInView:self];
    CGFloat currentY          = currentPosition.y;
    if (currentY<SCREEN_HEIGHT/667*184||currentY>SCREEN_HEIGHT/667*(184+237)){
        
        [UIView animateWithDuration:1.0 animations:^{
            [self removeFromSuperview];
            [self.popImageView removeFromSuperview];
            [self.topImageView removeFromSuperview];
            [self.dowmImageView removeFromSuperview];
            [self.rightButton removeFromSuperview];
        }];
        
    }
}




//lazy 242 237
-(UIImageView *)popImageView{
    
    if (_popImageView==nil) {
        _popImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*242)/2, SCREEN_HEIGHT/667*184, SCREEN_WIDTH/375*242, SCREEN_WIDTH/375*237)];
    }
    return _popImageView;
}

-(UIImageView *)topImageView{
    
    if (_topImageView==nil) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*242-SCREEN_WIDTH/375*80)/2, SCREEN_HEIGHT/667*57, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*39)];
    }
    return _topImageView;
}

-(UIImageView *)dowmImageView{
    
    if (_dowmImageView==nil) {
        _dowmImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*242-SCREEN_WIDTH/375*153)/2, SCREEN_HEIGHT/667*109, SCREEN_WIDTH/375*153, SCREEN_WIDTH/375*33)];
    }
    return _dowmImageView;
}



-(UIButton *)rightButton{
    
    if (_rightButton==nil) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*242-SCREEN_WIDTH/375*147)/2, SCREEN_HEIGHT/667*167, SCREEN_WIDTH/375*147, SCREEN_WIDTH/375*38)];
    }
    return _rightButton;
}


@end
