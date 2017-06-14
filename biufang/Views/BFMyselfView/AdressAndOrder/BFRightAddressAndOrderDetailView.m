//
//  BFRightAddressAndOrderDetailView.m
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFRightAddressAndOrderDetailView.h"

@implementation BFRightAddressAndOrderDetailView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    //self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.writeAddressOrderDetailTableView];
}
-(UITableView *)writeAddressOrderDetailTableView{

    if (_writeAddressOrderDetailTableView==nil) {
        _writeAddressOrderDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        //_writeAddressOrderDetailTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _writeAddressOrderDetailTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _writeAddressOrderDetailTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _writeAddressOrderDetailTableView;
}



@end
