//
//  homeTopBtnViewCell.m
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "homeTopBtnViewCell.h"

@implementation homeTopBtnViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.sellBtn];
        [self.backView addSubview:self.rentBtn];
        [self.backView addSubview:self.hotelBtn];
        [self.backView addSubview:self.guideBtn];
    }
    return self;
}

- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4.17)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)sellBtn {
    
    if (_sellBtn == nil) {
        _sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sellBtn.tag = 1;
        _sellBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _sellBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *img = [UIImage imageNamed:@"home_sell"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((_sellBtn.frame.size.width - img.size.width)/2,
                                                                              10,
                                                                              img.size.width,
                                                                              img.size.height)];
        imgView.image = img;

        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        self.backView.frame.size.height - SCREEN_WIDTH/31.25 - SCREEN_HEIGHT/45,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/31.25)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        titleLable.textColor = [UIColor colorWithHex:@"353846"];
        titleLable.text = @"热门新房";
        
        [_sellBtn addSubview:imgView];
        [_sellBtn addSubview:titleLable];
    }
    return _sellBtn;
}

- (UIButton *)hotelBtn {
    
    if (_hotelBtn == nil) {
        _hotelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotelBtn.tag = 2;
        _hotelBtn.frame = CGRectMake(CGRectGetMaxX(self.sellBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _hotelBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *img = [UIImage imageNamed:@"home_hotel"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((_hotelBtn.frame.size.width - img.size.width)/2,
                                                                             10,
                                                                             img.size.width,
                                                                             img.size.height)];
        imgView.image = img;
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        self.backView.frame.size.height - SCREEN_WIDTH/31.25 - SCREEN_HEIGHT/45,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/31.25)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        titleLable.textColor = [UIColor colorWithHex:@"353846"];
        titleLable.text = @"酒店客栈";
        
        [_hotelBtn addSubview:imgView];
        [_hotelBtn addSubview:titleLable];
    }
    return _hotelBtn;
}

- (UIButton *)rentBtn {
    
    if (_rentBtn == nil) {
        _rentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rentBtn.tag = 3;
        _rentBtn.frame = CGRectMake(CGRectGetMaxX(self.hotelBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _rentBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *img = [UIImage imageNamed:@"home_rent"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((_hotelBtn.frame.size.width - img.size.width)/2,
                                                                             10,
                                                                             img.size.width,
                                                                             img.size.height)];
        imgView.image = img;
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        self.backView.frame.size.height - SCREEN_WIDTH/31.25 - SCREEN_HEIGHT/45,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/31.25)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        titleLable.textColor = [UIColor colorWithHex:@"353846"];
        titleLable.text = @"热门精品";
        
        [_rentBtn addSubview:imgView];
        [_rentBtn addSubview:titleLable];
    }
    return _rentBtn;
}


- (UIButton *)guideBtn {
    
    if (_guideBtn == nil) {
        _guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _guideBtn.tag = 4;
        _guideBtn.frame = CGRectMake(CGRectGetMaxX(self.rentBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _guideBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *img = [UIImage imageNamed:@"home_guide"];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((_hotelBtn.frame.size.width - img.size.width)/2,
                                                                             10,
                                                                             img.size.width,
                                                                             img.size.height)];
        imgView.image = img;
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        self.backView.frame.size.height - SCREEN_WIDTH/31.25 - SCREEN_HEIGHT/45,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/31.25)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        titleLable.textColor = [UIColor colorWithHex:@"353846"];
        titleLable.text = @"新手指南";
        
        [_guideBtn addSubview:imgView];
        [_guideBtn addSubview:titleLable];
    }
    return _guideBtn;
}

@end
