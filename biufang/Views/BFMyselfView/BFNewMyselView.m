//
//  BFNewMyselView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewMyselView.h"

@implementation BFNewMyselView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.newMyselTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.newMyselTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.newMyselTableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.newMyselTableView];
    
}

-(UITableView *)newMyselTableView{
    
    if (_newMyselTableView==nil) {
        _newMyselTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _newMyselTableView;
}

@end
