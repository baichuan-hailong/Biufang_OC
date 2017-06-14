//
//  BFExchangeRecordView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/27.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFExchangeRecordView.h"

@implementation BFExchangeRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}


- (void)addUI{
    
    [self addSubview:self.exchangeRecordTableView];
}


-(UITableView *)exchangeRecordTableView{
    
    if (_exchangeRecordTableView == nil) {
        _exchangeRecordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        //_exchangeRecordTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _exchangeRecordTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _exchangeRecordTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _exchangeRecordTableView;
    
}

@end
