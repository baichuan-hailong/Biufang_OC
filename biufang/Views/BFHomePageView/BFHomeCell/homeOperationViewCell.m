//
//  homeOperationViewCell.m
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "homeOperationViewCell.h"

@implementation homeOperationViewCell


- (void)setValueWithDic:(NSDictionary *)info {

    //...
    [self.opImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"img"]]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self addSubview:self.backView];
        
        //[self.backView addSubview:self.opImageView];
        [self.backView addSubview:self.detailLable];

    }
    return self;
}

#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/10)];
        _backView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"e9e9e9"];
        [_backView addSubview:line];
    }
    return _backView;
}

- (UIImageView *)opImageView {

    if (_opImageView == nil) {
        _opImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height)];
        _opImageView.contentMode = UIViewContentModeScaleAspectFill;
        _opImageView.clipsToBounds = YES;
        _opImageView.backgroundColor = [UIColor whiteColor];
    }
    return _opImageView;
}


- (UILabel *)detailLable {

    if (_detailLable == nil) {
        
        _detailLable = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                (_backView.frame.size.height - SCREEN_WIDTH/31.25)/2,
                                                                 _backView.frame.size.width - 30,
                                                                 SCREEN_WIDTH/31.25)];
        _detailLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _detailLable.textAlignment = NSTextAlignmentLeft;
        _detailLable.textColor = [UIColor colorWithHex:@"757575"];
        _detailLable.text = @"恭喜xxxxxx";
    }
    return _detailLable;
}











@end
