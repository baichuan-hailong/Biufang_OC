//
//  BFUserInfView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFUserInfView.h"

@implementation BFUserInfView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        
        [self addUI];
    }
    return self;
}

- (void)addUI{

    [self addSubview:self.userInfoTableView];
}

-(UITableView *)userInfoTableView{

    if (_userInfoTableView==nil) {
        _userInfoTableView = [[UITableView alloc] init];
        _userInfoTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64);
        _userInfoTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _userInfoTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _userInfoTableView;
}

@end
