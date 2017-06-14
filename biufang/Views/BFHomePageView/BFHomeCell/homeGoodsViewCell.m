//
//  homeGoodsViewCell.m
//  biufang
//
//  Created by 娄耀文 on 17/1/3.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "homeGoodsViewCell.h"

@implementation homeGoodsViewCell

- (void)setValueWithModel:(BFHomeModel *)model {

    //......
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
    
    CGSize size = CGSizeMake(self.frame.size.width - 24, (SCREEN_WIDTH/26.78)*2.5);
    CGSize autoSize = [self.titleLable actualSizeOfLable:[NSString stringWithFormat:@"%@",model.title]
                                                andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]
                                                andSize:size];
    self.titleLable.frame = CGRectMake(12, CGRectGetMaxY(self.detialImageView.frame) + 12, self.frame.size.width - 24, autoSize.height);
    
    
    CGFloat  percent = (([model.quota floatValue] - [model.stock floatValue]) / [model.quota floatValue]) * 100.0;
    
    NSString *finalStr = @"0.000000";
    if (model.quota || model.stock) {
        
        if (percent >= 10) {
            
            if (percent >= 100) {
                finalStr = [[NSString stringWithFormat:@"%.6f",percent] substringWithRange:NSMakeRange(0,6)];
            }else {
                finalStr = [[NSString stringWithFormat:@"%.6f",percent] substringWithRange:NSMakeRange(0,5)];
            }
            
        }else {
            finalStr = [[NSString stringWithFormat:@"%.6f",percent] substringWithRange:NSMakeRange(0,4)];
        }
    }
    self.progressLable.text = [NSString stringWithFormat:@"揭晓进度：%@%%",finalStr];
    
    float leftNum = model.stock ? [model.stock floatValue] : 1;
    float totalNum = model.quota ? [model.quota floatValue] : 1;
    self.progress.minimumValue = 0;
    self.progress.maximumValue = totalNum;
    self.progress.progress     = totalNum - leftNum;
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
        
        [self.backView addSubview:self.progressView];
        [self.progressView addSubview:self.progressLable];
        [self.progressView addSubview:self.progress];
        [self.backView addSubview:self.buyBtn];
        
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
        _detialImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - SCREEN_WIDTH/2.68)/2,
                                                                          12,
                                                                          SCREEN_WIDTH/2.68,
                                                                          SCREEN_WIDTH/2.68)];
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
        _titleLable.frame = CGRectMake(12, CGRectGetMaxY(self.detialImageView.frame) + 12, self.frame.size.width - 24, 0);
        _titleLable.numberOfLines = 2;
        _titleLable.textColor = [UIColor colorWithHex:@"353846"];
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
    }
    return _titleLable;
}


//进度View
- (UIView *)progressView {

    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 self.frame.size.height - SCREEN_WIDTH/10,
                                                                 SCREEN_WIDTH/3.125,
                                                                 SCREEN_WIDTH/10)];
    }
    return _progressView;
}

- (UILabel *)progressLable {

    if (_progressLable == nil) {
        _progressLable = [[UILabel alloc] init];
        _progressLable.frame = CGRectMake(12, 3, self.progressView.frame.size.width - 12, SCREEN_WIDTH/31.25);
        _progressLable.textColor = [UIColor colorWithHex:@"353846"];
        _progressLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
    }
    return _progressLable;
}

- (AMProgressView *)progress {
    
    if (_progress == nil) {
        _progress = [[AMProgressView alloc] initWithFrame:CGRectMake(12,
                                                                     CGRectGetMaxY(self.progressLable.frame) + 7,
                                                                     SCREEN_WIDTH/3.83,
                                                                     (SCREEN_WIDTH/3.83)/19.6)
                                            andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:@"ff6f5c"],[UIColor colorWithHex:@"ff2b6f"],nil]
                                             andOutsideBorder:NO
                                                  andVertical:NO];
        _progress.isHidePercent = YES;
        _progress.layer.masksToBounds = YES;
        _progress.layer.cornerRadius = (SCREEN_WIDTH/3.83)/39.2;
    }
    return _progress;
}

- (UIButton *)buyBtn {

    if (_buyBtn == nil) {
        _buyBtn = [[UIButton alloc] init];
        _buyBtn.frame = CGRectMake(self.frame.size.width - SCREEN_WIDTH/6.5 - 9,
                                   self.frame.size.height - (SCREEN_WIDTH/6.5)/2.23 - SCREEN_WIDTH/37.5,
                                   SCREEN_WIDTH/6.5,
                                   (SCREEN_WIDTH/6.5)/2.23);
        _buyBtn.backgroundColor = [UIColor whiteColor];
        _buyBtn.layer.borderColor = [UIColor colorWithHex:@"fc334c"].CGColor;
        _buyBtn.layer.borderWidth = 0.5;
        _buyBtn.layer.cornerRadius = 4;
        
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/35]];
        [_buyBtn setTitleColor:[UIColor colorWithHex:@"fc334c"] forState:UIControlStateNormal];
    }
    return _buyBtn;
}











@end
