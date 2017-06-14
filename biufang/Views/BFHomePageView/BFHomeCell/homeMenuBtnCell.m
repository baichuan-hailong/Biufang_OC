//
//  homeMenuBtnCell.m
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "homeMenuBtnCell.h"

@implementation homeMenuBtnCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.hotBtn];
        [self.backView addSubview:self.lastBtn];
        [self.backView addSubview:self.progressBtn];
        [self.backView addSubview:self.houseBtn];
        [self.backView addSubview:self.segmentView];
        
    }
    return self;
}

- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/10)];
        _backView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"e5e5e5"];
        [_backView addSubview:line];
    }
    return _backView;
}

- (UIView *)segmentView {

    if (_segmentView == nil) {
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/4 - SCREEN_WIDTH/6.82)/2 + (SCREEN_WIDTH/4)*0,
                                                                self.backView.frame.size.height - 0.5 - 3,
                                                                SCREEN_WIDTH/6.82,
                                                                3)];
        _segmentView.backgroundColor = [UIColor colorWithHex:@"ff2b6f"];
    }
    return _segmentView;
}

- (UIButton *)hotBtn {
    
    if (_hotBtn == nil) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotBtn.tag = 1;
        _hotBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/10 - 0.5);
        _hotBtn.backgroundColor = [UIColor whiteColor];
        
        [_hotBtn setTitle:@"最热" forState:UIControlStateNormal];
        [_hotBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]];
        
        [_hotBtn setTitleColor:[UIColor colorWithHex:@"ff2b6f"] forState:UIControlStateNormal];
    }
    return _hotBtn;
}

- (UIButton *)lastBtn {
    
    if (_lastBtn == nil) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastBtn.tag = 2;
        _lastBtn.frame = CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/10 - 0.5);
        _lastBtn.backgroundColor = [UIColor whiteColor];
        
        [_lastBtn setTitle:@"最新" forState:UIControlStateNormal];
        [_lastBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]];
        [_lastBtn setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];

    }
    return _lastBtn;
}

- (UIButton *)progressBtn {
    
    if (_progressBtn == nil) {
        _progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _progressBtn.tag = 3;
        _progressBtn.frame = CGRectMake((SCREEN_WIDTH/4)*2, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/10 - 0.5);
        _progressBtn.backgroundColor = [UIColor whiteColor];
        
        [_progressBtn setTitle:@"进度" forState:UIControlStateNormal];
        [_progressBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]];
        [_progressBtn setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    }
    return _progressBtn;
}

- (UIButton *)houseBtn {
    
    if (_houseBtn == nil) {
        _houseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _houseBtn.tag = 4;
        _houseBtn.frame = CGRectMake((SCREEN_WIDTH/4)*3, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/10 - 0.5);
        _houseBtn.backgroundColor = [UIColor whiteColor];
        
        [_houseBtn setTitle:@"总需人次   " forState:UIControlStateNormal];
        [_houseBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]];
        [_houseBtn setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
        
        
        [_houseBtn addSubview:self.upDownImg];
    }
    return _houseBtn;
}

- (UIImageView *)upDownImg {

    if (_upDownImg == nil) {
        
        UIImage *img = [UIImage imageNamed:@"home_up"];
        _upDownImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.houseBtn.frame.size.width - img.size.width - 12,
                                                                  (self.houseBtn.frame.size.height - img.size.height)/2,
                                                                   img.size.width,
                                                                   img.size.height)];
        _upDownImg.image = img;
    }
    return _upDownImg;
}




@end
