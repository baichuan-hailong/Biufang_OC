//
//  BFNoNetView.m
//  biufang
//
//  Created by 杜海龙 on 16/11/16.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNoNetView.h"

@interface BFNoNetView ()
@property (nonatomic , strong) UIImageView *noNetImageView;
@end

@implementation BFNoNetView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        
        //emptycrying
        
        self.noNetImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*69)/2, SCREEN_WIDTH/375*150, SCREEN_WIDTH/375*69, SCREEN_WIDTH/375*104)];
        self.noNetImageView.image = [UIImage imageNamed:@"noNetPlaceImage"];
        [self addSubview:self.noNetImageView];
        
        
        self.updateButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*145)/2, CGRectGetMaxY(self.noNetImageView.frame)+10, SCREEN_WIDTH/375*145, SCREEN_WIDTH/375*33)];
        [self.updateButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.updateButton.frame.size] forState:UIControlStateNormal];
        [self.updateButton setTitle:@"点我重新刷新网络" forState:UIControlStateNormal];
        [self.updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.updateButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.updateButton.layer.cornerRadius = SCREEN_WIDTH/375*3;
        self.updateButton.layer.masksToBounds= YES;
        [self addSubview:self.updateButton];
        
    }
    return self;
}

@end
