//
//  BFIssueRecordView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFIssueRecordView.h"

@implementation BFIssueRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.issueRecordTableView];
    //self.issueRecordTableView.backgroundColor = [UIColor redColor];
}

-(UITableView *)issueRecordTableView{
    
    if (_issueRecordTableView == nil) {
        _issueRecordTableView = [[UITableView alloc] init];
        _issueRecordTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH - 0, SCREEN_HEIGHT - 64);
        _issueRecordTableView.backgroundColor = [UIColor whiteColor];
        _issueRecordTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _issueRecordTableView;
    
}

@end
