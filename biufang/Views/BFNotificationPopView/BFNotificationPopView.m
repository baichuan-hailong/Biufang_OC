//
//  BFNotificationPopView.m
//  biufang
//
//  Created by 杜海龙 on 17/2/21.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFNotificationPopView.h"

@interface BFNotificationPopView ()
@property (nonatomic,strong)UIView      *popView;
@property (nonatomic,strong)UIImageView *topImageView;
@property (nonatomic,strong)UILabel     *bottomLabel;
@property (nonatomic,strong)UIButton    *openButton;
@property (nonatomic,strong)UIView      *middleLine;
@property (nonatomic,strong)UIButton    *closeButton;
@end

@implementation BFNotificationPopView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"000000"];
        self.alpha = 0.8;
    }
    return self;
}


-(void)showPopView{
    //1
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    //2
    self.popView.backgroundColor    = [UIColor colorWithHex:@"FFFFFF"];
    self.popView.layer.cornerRadius = SCREEN_WIDTH/375*5;
    self.popView.layer.masksToBounds= YES;
    [keyWindow addSubview:self.popView];
    
    //close
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"bigRedEnvelopeClose"] forState:UIControlStateNormal];
    [self addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(closeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //top
    self.topImageView.image = [UIImage imageNamed:@"notificationPopImage"];
    [self.popView addSubview:self.topImageView];
    
    //bottom
    self.bottomLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.bottomLabel.textColor     = [UIColor colorWithHex:@"8B8B8B"];
    self.bottomLabel.textAlignment = NSTextAlignmentLeft;
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.text = @"为了保证您能第一时间收到中奖消息，请在下个页面选择“好”开启推动通知～";
    [self.popView addSubview:self.bottomLabel];
    
    //open
    [self.openButton setTitle:@"立即开启" forState:UIControlStateNormal];
    [self.openButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    self.openButton.titleLabel.font    = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.openButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
    self.openButton.layer.masksToBounds= YES;
    [self.openButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"FF4668"] size:self.openButton.frame.size] forState:UIControlStateNormal];
    [self.popView addSubview:self.openButton];
    [self.openButton addTarget:self action:@selector(openButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.popView.frame           = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2,
                                                  SCREEN_WIDTH/375*200+SCREEN_WIDTH/375*20,
                                                  SCREEN_WIDTH/375*296,
                                                  SCREEN_WIDTH/375*301);
        self.closeButton.frame       = CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2-SCREEN_WIDTH/375*29,
                                                  SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*44+SCREEN_WIDTH/375*20,
                                                  SCREEN_WIDTH/375*29,
                                                  SCREEN_WIDTH/375*44);
    } completion:^(BOOL finished) {
        /*
         记录弹起时间
         */
        NSDate          *unifiedDate    = [NSDate date];//获取当前时间，日期
        NSTimeInterval  currenTimeIntla = [unifiedDate timeIntervalSince1970]+28800;
        NSString *timeNotificationStamp        = [NSString stringWithFormat:@"%.f", currenTimeIntla];
        //转为字符型
        //NSLog(@"%@",timeLoginStamp);
        [[NSUserDefaults standardUserDefaults] setObject:timeNotificationStamp forKey:notificationPopTimeStamp];
    }];
}

-(void)openButtonDidClickedAction:(UIButton *)sender{

    //NSLog(@"open");
    
    [UIView animateWithDuration:0.38 animations:^{
        [self removeFromSuperview];
        [self.popView removeFromSuperview];
        [self.closeButton removeFromSuperview];
    }];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

-(void)closeButtonDidClickedAction:(UIButton *)sender{
    
    //NSLog(@"close");
    [UIView animateWithDuration:0.38 animations:^{
        [self removeFromSuperview];
        [self.popView removeFromSuperview];
        [self.closeButton removeFromSuperview];
    }];
}

//lazy
-(UIView *)popView{
    if (_popView==nil) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*296, SCREEN_WIDTH/375*301)];
    }
    return _popView;
}

-(UIButton *)closeButton{
    if (_closeButton==nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-(SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2-SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*44, SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*44)];
    }
    return _closeButton;
}

-(UIImageView *)topImageView{
    if (_topImageView==nil) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/375*296, SCREEN_WIDTH/375*141)];
    }
    return _topImageView;
}

-(UILabel *)bottomLabel{
    if (_bottomLabel==nil) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*31, SCREEN_WIDTH/375*160, SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*62, SCREEN_WIDTH/375*63)];
    }
    return _bottomLabel;
}

-(UIButton *)openButton{
    if (_openButton==nil) {
        _openButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*31, SCREEN_WIDTH/375*251, SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*62, SCREEN_WIDTH/375*40)];
    }
    return _openButton;
}


@end
