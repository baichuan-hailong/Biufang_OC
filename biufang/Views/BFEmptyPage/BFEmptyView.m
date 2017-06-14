
//
//  BFEmptyView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFEmptyView.h"

@interface BFEmptyView ()
@property (nonatomic , strong) UIImageView *emptyImageView;

@property (nonatomic , strong) UILabel *tipLabel;
@end

@implementation BFEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        //emptycrying
        
        self.emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*61)/2, SCREEN_HEIGHT/2-SCREEN_HEIGHT/375*100, SCREEN_WIDTH/375*61, SCREEN_WIDTH/375*61)];
        self.emptyImageView.image = [UIImage imageNamed:@"emptycrying"];
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
