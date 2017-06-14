//
//  BFGivingBiuNumbersView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFGivingBiuNumbersView.h"

@implementation BFGivingBiuNumbersView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}


- (void)addUI{
    
    [self addSubview:self.givingBiuNumbersTableView];
    
}

-(UITableView *)givingBiuNumbersTableView{
    
    if (_givingBiuNumbersTableView == nil) {
        _givingBiuNumbersTableView = [[UITableView alloc] init];
        _givingBiuNumbersTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64);
        _givingBiuNumbersTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _givingBiuNumbersTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _givingBiuNumbersTableView;
    
}


@end
