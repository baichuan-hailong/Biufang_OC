//
//  BFBiuNumbersHeaderView.m
//  BFCollectionViewDemo
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 anju. All rights reserved.
//

#import "BFBiuNumbersHeaderView.h"

@implementation BFBiuNumbersHeaderView
- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return self;
}
@end
