//
//  BFEvaluationView.m
//  biufang
//
//  Created by 杜海龙 on 17/1/13.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFEvaluationView.h"

@interface BFEvaluationView ()

@property(nonatomic, strong)UIView       *evalutationPopupView;

@property(nonatomic, strong)UIImageView  *topLoginImageView;

@property(nonatomic, strong)UIImageView  *leftTipImageView;

@property(nonatomic, strong)UIImageView  *detailTipImageView;

@property(nonatomic, strong)UIImageView  *startTipImageView;

@property(nonatomic, strong)UIButton     *startButton;

@property(nonatomic, strong)UIButton     *refuseButton;

@property(nonatomic, strong)UIButton     *afterButton;

@property(nonatomic, strong)UIView       *topLine;

@property(nonatomic, strong)UIView       *middleLine;

@property(nonatomic, strong)UIView       *downLine;



@end

@implementation BFEvaluationView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"000000"];
        self.alpha = 0.8;
    }
    return self;
}

-(void)showEvaluation{
    
    //1
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.evalutationPopupView.backgroundColor     = [UIColor whiteColor];
    self.evalutationPopupView.layer.cornerRadius  = SCREEN_WIDTH/375*10;
    //self.evalutationPopupView.layer.masksToBounds = YES;
    [keyWindow addSubview:self.evalutationPopupView];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.evalutationPopupView.frame      = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2,
                                                          SCREEN_HEIGHT/667*150+SCREEN_HEIGHT/667*30,
                                                          SCREEN_WIDTH/375*296,
                                                          SCREEN_WIDTH/375*301);
    } completion:^(BOOL finished) {
    }];
    
    self.topLoginImageView.image = [UIImage imageNamed:@"evaluationLogionName"];
    [self.evalutationPopupView addSubview:self.topLoginImageView];
    
    
    self.leftTipImageView.image = [UIImage imageNamed:@"evaluationLeftName"];
    [self.evalutationPopupView addSubview:self.leftTipImageView];
    
    self.detailTipImageView.image = [UIImage imageNamed:@"evaluationTextName"];
    [self.evalutationPopupView addSubview:self.detailTipImageView];
    
    //line
    self.topLine.backgroundColor    = [UIColor colorWithHex:@"EEEEEE"];
    self.middleLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    self.downLine.backgroundColor   = [UIColor colorWithHex:@"EEEEEE"];
    [self.evalutationPopupView addSubview:self.topLine];
    [self.evalutationPopupView addSubview:self.middleLine];
    [self.evalutationPopupView addSubview:self.downLine];
    
    self.startTipImageView.image = [UIImage imageNamed:@"evaluationStarName"];
    [self.evalutationPopupView addSubview:self.startTipImageView];
    
    
    //self.startButton.backgroundColor = [UIColor redColor];
    [self.startButton setTitle:@"去五星好评！" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor colorWithHex:@"1580FD"] forState:UIControlStateNormal];
    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    
    
    //self.refuseButton.backgroundColor= [UIColor redColor];
    [self.refuseButton setTitle:@"无情的拒绝" forState:UIControlStateNormal];
    [self.refuseButton setTitleColor:[UIColor colorWithHex:@"8B8B8B"] forState:UIControlStateNormal];
    self.refuseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.refuseButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    
    //self.afterButton.backgroundColor = [UIColor redColor];
    [self.afterButton setTitle:@"稍后提醒我" forState:UIControlStateNormal];
    [self.afterButton setTitleColor:[UIColor colorWithHex:@"8B8B8B"] forState:UIControlStateNormal];
    self.afterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.afterButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    
    
    
    [self.evalutationPopupView addSubview:self.startButton];
    [self.evalutationPopupView addSubview:self.refuseButton];
    [self.evalutationPopupView addSubview:self.afterButton];
    
    [self.startButton addTarget:self action:@selector(startButtonDidClickedAc:) forControlEvents:UIControlEventTouchUpInside];
    [self.refuseButton addTarget:self action:@selector(refuseButtonDidClickedAc:) forControlEvents:UIControlEventTouchUpInside];
    [self.afterButton addTarget:self action:@selector(afterButtonDidClickedAc:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - click
- (void)startButtonDidClickedAc:(UIButton *)sender{

    //NSLog(@"0");
    [UIView animateWithDuration:1.0 animations:^{
        [self removeFromSuperview];
        [self.evalutationPopupView removeFromSuperview];
        [self.topLoginImageView removeFromSuperview];
        [self.leftTipImageView removeFromSuperview];
        [self.detailTipImageView removeFromSuperview];
        [self.startTipImageView removeFromSuperview];
        [self.topLine removeFromSuperview];
        [self.middleLine removeFromSuperview];
        [self.downLine removeFromSuperview];
        [self.startButton removeFromSuperview];
        [self.refuseButton removeFromSuperview];
        [self.afterButton removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(evaluationClick:)]) {
        [self.delegate evaluationClick:0];
    }
}

- (void)refuseButtonDidClickedAc:(UIButton *)sender{

    //NSLog(@"1");
    [UIView animateWithDuration:1.0 animations:^{
        [self removeFromSuperview];
        [self.evalutationPopupView removeFromSuperview];
        [self.topLoginImageView removeFromSuperview];
        [self.leftTipImageView removeFromSuperview];
        [self.detailTipImageView removeFromSuperview];
        [self.startTipImageView removeFromSuperview];
        [self.topLine removeFromSuperview];
        [self.middleLine removeFromSuperview];
        [self.downLine removeFromSuperview];
        [self.startButton removeFromSuperview];
        [self.refuseButton removeFromSuperview];
        [self.afterButton removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(evaluationClick:)]) {
        [self.delegate evaluationClick:1];
    }
}

- (void)afterButtonDidClickedAc:(UIButton *)sender{

    //NSLog(@"2");
    [UIView animateWithDuration:1.0 animations:^{
        [self removeFromSuperview];
        [self.evalutationPopupView removeFromSuperview];
        [self.topLoginImageView removeFromSuperview];
        [self.leftTipImageView removeFromSuperview];
        [self.detailTipImageView removeFromSuperview];
        [self.startTipImageView removeFromSuperview];
        [self.topLine removeFromSuperview];
        [self.middleLine removeFromSuperview];
        [self.downLine removeFromSuperview];
        [self.startButton removeFromSuperview];
        [self.refuseButton removeFromSuperview];
        [self.afterButton removeFromSuperview];
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(evaluationClick:)]) {
        [self.delegate evaluationClick:2];
    }
}


//lazy
-(UIView *)evalutationPopupView{

    if (_evalutationPopupView==nil) {
        _evalutationPopupView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*296)/2, SCREEN_HEIGHT/667*150, SCREEN_WIDTH/375*296, SCREEN_WIDTH/375*301)];
    }
    return _evalutationPopupView;
}


 
 -(UIImageView *)topLoginImageView{
     if (_topLoginImageView==nil) {
         _topLoginImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/375*296-SCREEN_WIDTH/375*68)/2, -SCREEN_WIDTH/375*32, SCREEN_WIDTH/375*68, SCREEN_WIDTH/375*68)];
     }
     return _topLoginImageView;
 }

-(UIImageView *)leftTipImageView{

    if (_leftTipImageView==nil) {
        _leftTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*54, SCREEN_WIDTH/375*60, SCREEN_WIDTH/375*83)];
    }
    return _leftTipImageView;
}

-(UIImageView *)detailTipImageView{

    if (_detailTipImageView==nil) {
        _detailTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*98, SCREEN_WIDTH/375*60, SCREEN_WIDTH/375*163, SCREEN_WIDTH/375*63)];
    }
    return _detailTipImageView;
}


//line
-(UIView *)topLine{
    if (_topLine==nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*19, SCREEN_HEIGHT/667*160, SCREEN_WIDTH/375*259, SCREEN_WIDTH/375*0.6)];
    }
    return _topLine;
}

-(UIView *)middleLine{
    if (_middleLine==nil) {
        _middleLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*19, SCREEN_HEIGHT/667*206, SCREEN_WIDTH/375*259, SCREEN_WIDTH/375*0.6)];
    }
    return _middleLine;
}

-(UIView *)downLine{
    if (_downLine==nil) {
        _downLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*19, SCREEN_HEIGHT/667*252, SCREEN_WIDTH/375*259, SCREEN_WIDTH/375*0.6)];
    }
    return _downLine;
    
}


-(UIImageView *)startTipImageView{

    if (_startTipImageView==nil) {
        _startTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*172, SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*24)];
    }
    return _startTipImageView;
}


//button
-(UIButton *)startButton{

    if (_startButton==nil) {
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*113, SCREEN_WIDTH/375*172, SCREEN_WIDTH/375*259-SCREEN_WIDTH/375*120, SCREEN_WIDTH/375*24)];
    }
    return _startButton;
}

-(UIButton *)refuseButton{

    if (_refuseButton==nil) {
        _refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*113, SCREEN_WIDTH/375*220, SCREEN_WIDTH/375*259-SCREEN_WIDTH/375*120, SCREEN_WIDTH/375*24)];
    }
    return _refuseButton;
}

-(UIButton *)afterButton{

    if (_afterButton==nil) {
        _afterButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*113, SCREEN_WIDTH/375*266, SCREEN_WIDTH/375*259-SCREEN_WIDTH/375*120, SCREEN_WIDTH/375*24)];
    }
    return _afterButton;
}


@end
