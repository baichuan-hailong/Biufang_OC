//
//  BFMiddleViewCell.m
//  biufang
//
//  Created by 娄耀文 on 17/2/24.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFMiddleViewCell.h"

@implementation BFMiddleViewCell

- (void)setValueWithModel:(BFHomeModel *)model {
    
    //setValue...
    
    [self.detialImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.cover]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    
    float biuPrice = [model.biu_price floatValue];
    if (biuPrice == 10) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"十元商品"];
    } else if (biuPrice == 100) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"百元商品"];
    } else if (biuPrice == 1000) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"千元商品"];
    } else {
        self.priceImageView.hidden = YES;
    }
    self.titleLable.text = [NSString stringWithFormat:@"%@",model.title];
    
    if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"3"]) {
        
        //*** 显示获奖者信息 ***//
        self.winnerView.alpha = 1;
        self.timeView.alpha   = 0;
        
        self.nickName.text  = [NSString stringWithFormat:@"获奖者：%@",model.winner[@"nickname"]];
        self.joinTimes.text = [NSString stringWithFormat:@"参与人次：%@",model.winner[@"quantity"]];
        self.snLable.text   = [NSString stringWithFormat:@"期号%@",model.sn];
        self.timeLable.text = [NSString stringWithFormat:@"揭晓时间：%@",@"xxx"];
    } else {
        
        //*** 显示倒计时 ***//
        self.winnerView.alpha = 0;
        self.timeView.alpha   = 1;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 0.5, 0, 0.5, self.frame.size.height - 0.5)];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5 - 0.5, self.frame.size.width, 0.5)];
        line1.backgroundColor = [UIColor colorWithHex:@"e5e5e5"];
        line2.backgroundColor = [UIColor colorWithHex:@"e5e5e5"];
        
        [self addSubview:self.backView];
        [self.backView addSubview:line1];
        [self.backView addSubview:line2];
        [self.backView addSubview:self.detialImageView];
        [self.backView addSubview:self.priceImageView];
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.winnerView];
        [self.backView addSubview:self.timeView];
        
        [self.winnerView addSubview:self.nickName];
        [self.winnerView addSubview:self.joinTimes];
        [self.winnerView addSubview:self.snLable];
        [self.winnerView addSubview:self.timeLable];
        
        [self.timeView addSubview:self.tipsView];
        [self.tipsView addSubview:self.tipsImg];
        [self.tipsView addSubview:self.tipsLable];
        [self.timeView addSubview:self.timeLessLable];
        
    }
    return self;
}

#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)detialImageView {
    
    if (_detialImageView == nil) {
        _detialImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - SCREEN_WIDTH/3.125)/2,
                                                                         7,
                                                                         SCREEN_WIDTH/3.125,
                                                                         SCREEN_WIDTH/3.125)];
        _detialImageView.contentMode = UIViewContentModeScaleAspectFill;
        _detialImageView.clipsToBounds = YES;
    }
    return _detialImageView;
}


- (UIImageView *)priceImageView {
    
    if (_priceImageView == nil) {
        _priceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7,
                                                                        -0.5,
                                                                        SCREEN_WIDTH/9.62,
                                                                        SCREEN_WIDTH/10.14)];
        
    }
    return _priceImageView;
}


- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(10, CGRectGetMaxY(self.detialImageView.frame) + 7, self.frame.size.width - 20, (SCREEN_WIDTH/26.78)*2.5);
        _titleLable.numberOfLines = 2;
        _titleLable.textColor = [UIColor colorWithHex:@"353846"];
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
    }
    return _titleLable;
}


//*** 倒计时 ***//
- (UIView *)timeView {
    
    if (_timeView == nil) {
        _timeView = [[UIView alloc] init];
        _timeView.frame = CGRectMake(10,
                                     CGRectGetMaxY(self.titleLable.frame) + 5,
                                     self.frame.size.width - 20,
                                     self.frame.size.height - self.detialImageView.frame.size.height - self.titleLable.frame.size.height - 24);
        _timeView.alpha = 0;
    }
    return _timeView;
}

- (UIView *)tipsView {
    
    if (_tipsView == nil) {
        _tipsView = [[UIView alloc] init];
        _tipsView.frame = CGRectMake(0,
                                     0,
                                     self.timeView.frame.size.width,
                                     20);
    }
    return _tipsView;
}

- (UIImageView *)tipsImg {

    if (_tipsImg == nil) {
        _tipsImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 12, 12)];
        _tipsImg.image = [UIImage imageNamed:@"detailView_time"];
    }
    return _tipsImg;
}

- (UILabel *)tipsLable {
    
    if (_tipsLable == nil) {
        _tipsLable = [[UILabel alloc] init];
        _tipsLable.frame = CGRectMake(CGRectGetMaxX(self.tipsImg.frame) + 5,
                                      0,
                                      self.tipsView.frame.size.width - self.tipsImg.frame.size.width - 5,
                                      self.tipsView.frame.size.height);
        _tipsLable.textColor = [UIColor colorWithHex:@"494949"];
        _tipsLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/37.5];
        _tipsLable.text = @"揭晓倒计时";
    }
    return _tipsLable;
}

- (UILabel *)timeLessLable {
    
    if (_timeLessLable == nil) {
        _timeLessLable = [[UILabel alloc] init];
        _timeLessLable.frame = CGRectMake(0,
                                          CGRectGetMaxY(self.tipsView.frame) - 5,
                                          self.timeView.frame.size.width,
                                          self.timeView.frame.size.height - self.tipsView.frame.size.height);
        _timeLessLable.textColor = [UIColor colorWithHex:RED_COLOR];
        _timeLessLable.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/13.39];
    }
    return _timeLessLable;
}




//*** 获奖者信息 ***//
- (UIView *)winnerView {

    if (_winnerView == nil) {
        _winnerView = [[UIView alloc] init];
        _winnerView.frame = CGRectMake(10,
                                       CGRectGetMaxY(self.titleLable.frame) + 5,
                                       self.frame.size.width - 20,
                                       self.frame.size.height - self.detialImageView.frame.size.height - self.titleLable.frame.size.height - 24);
        _winnerView.alpha = 0;
    }
    return _winnerView;
}

//获奖者
- (UILabel *)nickName {
    
    if (_nickName == nil) {
        _nickName = [[UILabel alloc] init];
        _nickName.frame = CGRectMake(0,
                                     0,
                                     self.winnerView.frame.size.width,
                                     self.winnerView.frame.size.height/4);
        _nickName.textColor = [UIColor colorWithHex:@"999999"];
        _nickName.font = [UIFont systemFontOfSize:SCREEN_WIDTH/34.1];
    }
    return _nickName;
}

//参与人次
- (UILabel *)joinTimes {
    
    if (_joinTimes == nil) {
        _joinTimes = [[UILabel alloc] init];
        _joinTimes.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.nickName.frame),
                                      self.winnerView.frame.size.width,
                                      self.winnerView.frame.size.height/4);
        _joinTimes.textColor = [UIColor colorWithHex:@"999999"];
        _joinTimes.font = [UIFont systemFontOfSize:SCREEN_WIDTH/34.1];
    }
    return _joinTimes;
}

//期号
- (UILabel *)snLable {
    
    if (_snLable == nil) {
        _snLable = [[UILabel alloc] init];
        _snLable.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.joinTimes.frame),
                                    self.winnerView.frame.size.width,
                                    self.winnerView.frame.size.height/4);
        _snLable.textColor = [UIColor colorWithHex:@"999999"];
        _snLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/34.1];
    }
    return _snLable;
}

//揭晓时间
- (UILabel *)timeLable {
    
    if (_timeLable == nil) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.snLable.frame),
                                      self.winnerView.frame.size.width,
                                      self.winnerView.frame.size.height/4);
        _timeLable.textColor = [UIColor colorWithHex:@"999999"];
        _timeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/34.1];
    }
    return _timeLable;
}




@end
