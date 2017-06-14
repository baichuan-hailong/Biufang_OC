//
//  BFSelectCityView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFSelectCityView.h"

@implementation BFSelectCityView 

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{

    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectCityTableView];
}

-(UITableView *)selectCityTableView{

    if (_selectCityTableView == nil) {
        _selectCityTableView = [[UITableView alloc] init];
        _selectCityTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64);
        _selectCityTableView.backgroundColor = [UIColor whiteColor];
        _selectCityTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _selectCityTableView;
    
}

@end
