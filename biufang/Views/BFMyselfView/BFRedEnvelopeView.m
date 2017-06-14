//
//  BFRedEnvelopeView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFRedEnvelopeView.h"

@implementation BFRedEnvelopeView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.redEnvelopeTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.redEnvelopeTableView];
    
}

-(UITableView *)redEnvelopeTableView{
    
    if (_redEnvelopeTableView == nil) {
        //[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _redEnvelopeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        //_redEnvelopeTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT-64);
        _redEnvelopeTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _redEnvelopeTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _redEnvelopeTableView.showsVerticalScrollIndicator = NO;
    }
    return _redEnvelopeTableView;
    
}

@end
