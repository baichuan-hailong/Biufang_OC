//
//  BFBiuRecordView.m
//  biufang
//
//  Created by 娄耀文 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBiuRecordView.h"

@implementation BFBiuRecordView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSInteger)tags {

    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {
    
    // SETUP...
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self addSubview:self.titleView];


}

- (UIView *)titleView {

    if (_titleView == nil) {
        
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 50);
        _titleView.backgroundColor = [UIColor lightGrayColor];
    }
    return _titleView;
}


@end
