
//
//  BFMyselfLuckyView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfLuckyView.h"

@implementation BFMyselfLuckyView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}


- (void)addUI{
    
    [self addSubview:self.luckeRecordTableView];
    
    //加快按钮点按效果，提高touch层级
    self.luckeRecordTableView.delaysContentTouches = NO;
    for (UIView *currentView in self.luckeRecordTableView.subviews) {
        
        if([currentView isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
}


-(UITableView *)luckeRecordTableView{
    
    if (_luckeRecordTableView == nil) {
        _luckeRecordTableView = [[UITableView alloc] init];
        _luckeRecordTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _luckeRecordTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _luckeRecordTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _luckeRecordTableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    }
    return _luckeRecordTableView;
    
}


@end
