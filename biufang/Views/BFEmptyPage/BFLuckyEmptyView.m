//
//  BFLuckyEmptyView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/23.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFLuckyEmptyView.h"
@interface BFLuckyEmptyView ()
@property (nonatomic , strong) UIImageView *emptyImageView;

@property (nonatomic , strong) UILabel *tipLabel;
@end

@implementation BFLuckyEmptyView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        //emptycrying 150 134
        
        self.emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*150/2)/2, SCREEN_HEIGHT/2-SCREEN_HEIGHT/375*100, SCREEN_WIDTH/375*150/2, SCREEN_WIDTH/375*134/2)];
        self.emptyImageView.image = [UIImage imageNamed:@"luckyemptyimage"];
        [self addSubview:self.emptyImageView];
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emptyImageView.frame)+10, SCREEN_WIDTH, SCREEN_WIDTH/375*17)];
        self.tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.tipLabel.textColor = [UIColor colorWithHex:@"9A9A9A"];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.tipLabel];
        
    }
    return self;
}

- (void)tipStr:(NSString *)tipStr{
    
    self.tipLabel.text = tipStr;
}


@end
