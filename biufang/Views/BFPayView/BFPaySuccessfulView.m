//
//  BFPaySuccessfulView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPaySuccessfulView.h"

@implementation BFPaySuccessfulView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{

    [self addSubview:self.paySuccessfulTableView];
    
    [self.redmoneyButton setImage:[UIImage imageNamed:@"redmoneybuttonimage"] forState:UIControlStateNormal];
    [self addSubview:self.redmoneyButton];
    
    self.redmoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.redmoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.redmoneyLabel.textColor = [UIColor colorWithHex:@"FB344C"];
    self.redmoneyLabel.text = @"发红包";
    [self addSubview:self.redmoneyLabel];
}


-(UITableView *)paySuccessfulTableView{
    
    if (_paySuccessfulTableView==nil) {
        _paySuccessfulTableView = [[UITableView alloc] init];
        _paySuccessfulTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64);
        _paySuccessfulTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _paySuccessfulTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _paySuccessfulTableView;
}

-(UIButton *)redmoneyButton{

    if (_redmoneyButton==nil) {
        _redmoneyButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*26-SCREEN_WIDTH/375*50, SCREEN_HEIGHT-SCREEN_WIDTH/375*52-SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
    }
    return _redmoneyButton;
}

-(UILabel *)redmoneyLabel{

    if (_redmoneyLabel==nil) {
        _redmoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*26-SCREEN_WIDTH/375*50, SCREEN_HEIGHT-SCREEN_WIDTH/375*36-SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*14)];
    }
    return _redmoneyLabel;
}

@end
