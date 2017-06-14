//
//  BFShareView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/8.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFShareView.h"

@interface BFShareView ()

@property (nonatomic , strong) UIView *shareBodyView;
//UIButton * noOneButton
@property (nonatomic , strong) UIButton * noOneButton;
@property (nonatomic , strong) UILabel  * noOneLabel;
@property (nonatomic , strong) UIButton * noTwoButton;
@property (nonatomic , strong) UILabel  * noTwoLabel;
@property (nonatomic , strong) UIButton * noThreeButton;
@property (nonatomic , strong) UILabel  * noThreeLabel;
@property (nonatomic , strong) UIButton * noFourButton;
@property (nonatomic , strong) UILabel  * noFourLabel;
@property (nonatomic , strong) UIButton * noFiveButton;
@property (nonatomic , strong) UILabel  * noFiveLabel;


@property (nonatomic , strong) UIButton * noSixButton;
@property (nonatomic , strong) UILabel  * noSixLabel;


@property (nonatomic , strong) UIButton * cancleButton;
@property (nonatomic , strong) UIView   * canclLine;

@end

@implementation BFShareView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.5;
    }
    return self;
}


//add UI
- (void)creatButtonsAc{
    
    self.noOneButton      = [self creatBtnWithFrame:CGRectMake(SCREEN_WIDTH/375*47, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                    image:[UIImage imageNamed:@"shareWechat"]
                                           animationFrame:CGRectMake(SCREEN_WIDTH/375*47, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                    delay:0];
    self.noOneButton.tag                = 701;
    //self.noOneButton.backgroundColor    = [UIColor orangeColor];
    [self.noOneButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.noOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
    self.noOneLabel.text = @"微信";
    self.noOneLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.noOneLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.noOneLabel.textAlignment = NSTextAlignmentCenter;
    [self.noOneButton addSubview:self.noOneLabel];
    
    
    self.noTwoButton      = [self creatBtnWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*64)/2, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                    image:[UIImage imageNamed:@"shareSession"]
                                           animationFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*64)/2, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                    delay:0];
    self.noTwoButton.tag                = 702;
    //self.noTwoButton.backgroundColor    = [UIColor orangeColor];
    [self.noTwoButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.noTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
    self.noTwoLabel.text = @"朋友圈";
    self.noTwoLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.noTwoLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.noTwoLabel.textAlignment = NSTextAlignmentCenter;
    [self.noTwoButton addSubview:self.noTwoLabel];
    
    
    
    
     self.noThreeButton      = [self creatBtnWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*47-SCREEN_WIDTH/375*64, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
     image:[UIImage imageNamed:@"sharewebo"]
     animationFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*47-SCREEN_WIDTH/375*64, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*2+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
     delay:0];
     self.noThreeButton.tag                = 703;
     //self.noThreeButton.backgroundColor    = [UIColor orangeColor];
     [self.noThreeButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     
     
     self.noThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
     self.noThreeLabel.text = @"微博";
     self.noThreeLabel.textColor = [UIColor colorWithHex:@"000000"];
     self.noThreeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
     self.noThreeLabel.textAlignment = NSTextAlignmentCenter;
     [self.noThreeButton addSubview:self.noThreeLabel];
    
    
    
    self.noFourButton      = [self creatBtnWithFrame:CGRectMake(SCREEN_WIDTH/375*47, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                     image:[UIImage imageNamed:@"shareQQ"]
                                            animationFrame:CGRectMake(SCREEN_WIDTH/375*47, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                     delay:0];
    self.noFourButton.tag                = 704;
    //self.noFourButton.backgroundColor    = [UIColor orangeColor];
    [self.noFourButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.noFourLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
    self.noFourLabel.text = @"QQ";
    self.noFourLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.noFourLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.noFourLabel.textAlignment = NSTextAlignmentCenter;
    [self.noFourButton addSubview:self.noFourLabel];
    
    
    
    self.noFiveButton         = [self creatBtnWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*64)/2, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                        image:[UIImage imageNamed:@"shareQQzone"]
                                               animationFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*64)/2, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                        delay:0];
    self.noFiveButton.tag                = 705;
    //self.noFiveButton.backgroundColor    = [UIColor orangeColor];
    [self.noFiveButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.noFiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
    self.noFiveLabel.text = @"QQ空间";
    self.noFiveLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.noFiveLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.noFiveLabel.textAlignment = NSTextAlignmentCenter;
    [self.noFiveButton addSubview:self.noFiveLabel];
    
    
    
    //短信
    self.noSixButton          = [self creatBtnWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*47-SCREEN_WIDTH/375*64, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                  image:[UIImage imageNamed:@"shareSms"]
                                         animationFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*47-SCREEN_WIDTH/375*64, (SCREEN_HEIGHT-SCREEN_WIDTH/375*238)+SCREEN_WIDTH/375*85+SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*54)
                                                  delay:0];
    self.noSixButton.tag                = 706;
    //self.noSixButton.backgroundColor    = [UIColor orangeColor];
    [self.noSixButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.noSixLabel = [[UILabel alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*14)];
    self.noSixLabel.text = @"短信";
    self.noSixLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.noSixLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.noSixLabel.textAlignment = NSTextAlignmentCenter;
    [self.noSixButton addSubview:self.noSixLabel];
    
    
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.canclLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/375*49, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
    self.canclLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    [keyWindow addSubview:self.canclLine];
    
    self.cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/375*48, SCREEN_WIDTH, SCREEN_WIDTH/375*48)];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancleButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [keyWindow addSubview:self.cancleButton];
    
    [self.cancleButton addTarget:self action:@selector(cancleButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)shareShow{
    
    self.shareBodyView            = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                            SCREEN_HEIGHT-SCREEN_WIDTH/375*238,
                                                                            SCREEN_WIDTH,
                                                                            SCREEN_WIDTH/375*238)];
    self.shareBodyView.backgroundColor     = [UIColor colorWithHex:@"FFFFFF"];
    self.shareBodyView.layer.masksToBounds = YES;
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.38 animations:^{
    }];
    
    [keyWindow addSubview:self];
    
    [keyWindow addSubview:self.shareBodyView];
    
    [self creatButtonsAc];
    
    
}

-(void)shareButtonClick:(UIButton*)sender{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(shareViewDidSelectButWithBtnTag:)]) {
        
        [self.delegate shareViewDidSelectButWithBtnTag:sender.tag];
        
        
        if (sender.tag==706) {
            [UIView animateWithDuration:10.38 animations:^{
                [self removeFromSuperview];
                [self.shareBodyView removeFromSuperview];
                [self.noOneButton removeFromSuperview];
                [self.noTwoButton removeFromSuperview];
                [self.noThreeButton removeFromSuperview];
                [self.noFourButton removeFromSuperview];
                [self.noFiveButton removeFromSuperview];
                [self.noSixButton removeFromSuperview];
                
                [self.canclLine removeFromSuperview];
                [self.cancleButton removeFromSuperview];
                
            }];
        }
    }
    
}


//touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch            = [touches anyObject];
    CGPoint currentPosition   = [touch locationInView:self];
    CGFloat currentY          = currentPosition.y;
    if (currentY<(SCREEN_HEIGHT-SCREEN_WIDTH/375*238)){
        [UIView animateWithDuration:10.38 animations:^{
            [self removeFromSuperview];
            [self.shareBodyView removeFromSuperview];
            
            [self.noOneButton removeFromSuperview];
            [self.noTwoButton removeFromSuperview];
            [self.noThreeButton removeFromSuperview];
            [self.noFourButton removeFromSuperview];
            [self.noFiveButton removeFromSuperview];
            [self.noSixButton removeFromSuperview];
            
            [self.canclLine removeFromSuperview];
            [self.cancleButton removeFromSuperview];
        }];
    }
}

-(void)shareHide{

    [UIView animateWithDuration:10.38 animations:^{
        
        [self removeFromSuperview];
        
        [self.shareBodyView removeFromSuperview];
        
        [self.noOneButton removeFromSuperview];
        [self.noTwoButton removeFromSuperview];
        [self.noThreeButton removeFromSuperview];
        [self.noFourButton removeFromSuperview];
        [self.noFiveButton removeFromSuperview];
        [self.noSixButton removeFromSuperview];
        
        [self.canclLine removeFromSuperview];
        [self.cancleButton removeFromSuperview];
        
    }];
}

//cancle
- (void)cancleButtonDidClickedAction:(UIButton *)sender{

    [UIView animateWithDuration:10.38 animations:^{
        
        [self removeFromSuperview];
        
        [self.shareBodyView removeFromSuperview];
        
        [self.noOneButton removeFromSuperview];
        [self.noTwoButton removeFromSuperview];
        [self.noThreeButton removeFromSuperview];
        [self.noFourButton removeFromSuperview];
        [self.noFiveButton removeFromSuperview];
        [self.noSixButton removeFromSuperview];
        
        [self.canclLine removeFromSuperview];
        [self.cancleButton removeFromSuperview];
        
    }];
}



//creat share btn
-(UIButton *)creatBtnWithFrame:(CGRect)frame
                         image:(UIImage *)image
                animationFrame:(CGRect)animationFrame
                         delay:(CGFloat)afterDelay{
    
    UIButton *shareButton      = [[UIButton alloc]init];
    shareButton.frame          = frame;
    //[shareButton setBackgroundImage:image forState:UIControlStateNormal];
    [shareButton setImage:image forState:UIControlStateNormal];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow  addSubview:shareButton];
    
    
    
    [UIView animateWithDuration:1.0 delay:afterDelay usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        shareButton.frame      = animationFrame;
    } completion:^(BOOL finished) {
        
    }];
    return shareButton;
    
    //usingSpringWithDamping :弹簧动画的阻尼值，也就是相当于摩擦力的大小，该属性的值从0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大道一定程度，会出现弹不动的情况。
    //initialSpringVelocity  :弹簧动画的速率，或者说是动力。值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里需要注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
}


@end
