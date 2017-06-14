//
//  BFAwardOrderTelEmailCollectionViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFAwardOrderTelEmailCollectionViewCell.h"

@implementation BFAwardOrderTelEmailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.telImageView.image = [UIImage imageNamed:@"awardTypeTel"];
    

    self.tipLabel.text          = @"请在工作日拨打电话完成领奖";
    self.tipLabel.textColor     = [UIColor colorWithHex:@"000000"];
    self.tipLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.callButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.callButton.frame.size] forState:UIControlStateNormal];
    [self.callButton setTitle:@"--- ----" forState:UIControlStateNormal];
    [self.callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.callButton.titleLabel.font        = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    self.callButton.layer.cornerRadius     = SCREEN_WIDTH/375*4;
    self.callButton.userInteractionEnabled = NO;
    self.callButton.layer.masksToBounds    = YES;
   
}

-(void)prepareForReuse{

    
}

- (void)setValueWithBiuNumberModle:(NSString *)telStr{

    [self.callButton setTitle:telStr forState:UIControlStateNormal];
}

@end
