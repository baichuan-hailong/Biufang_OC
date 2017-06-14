//
//  BFBiuNumbersCollectionCell.m
//  BFCollectionViewDemo
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 anju. All rights reserved.
//

#import "BFBiuNumbersCollectionCell.h"
#import "BFBiuNumberModle.h"

@implementation BFBiuNumbersCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.biuNumberBodyView.backgroundColor = [UIColor whiteColor];
    //self.biuNumberBodyView.layer.cornerRadius = ((SCREEN_WIDTH-80)/2)/119*26/2;
    //self.biuNumberBodyView.layer.borderColor = [UIColor colorWithHex:@"9B9B9B"].CGColor;
    //self.biuNumberBodyView.layer.borderWidth = SCREEN_WIDTH/375*1;
    //self.biuNumberBodyView.layer.masksToBounds= YES;
    //self.biuNumberBodyView.backgroundColor = [UIColor redColor];
    
    self.backgroundColor = [UIColor whiteColor];
    self.biuNumberLabel.textColor = [UIColor colorWithHex:@"5C5C5C"];
    self.biuNumberLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:SCREEN_WIDTH/375*14];
}

- (void)setValueWithBiuNumberModle:(NSString *)biuNumberModle{
    
    self.biuNumberLabel.text = biuNumberModle;
}

@end
