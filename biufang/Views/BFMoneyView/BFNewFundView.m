//
//  BFNewFundView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewFundView.h"

@implementation BFNewFundView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.fundTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.fundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.fundTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.fundTableView];
    
}

-(UITableView *)fundTableView{

    if (_fundTableView==nil) {
        _fundTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-SCREEN_WIDTH/375*49) style:UITableViewStyleGrouped];
    }
    return _fundTableView;
}

@end
