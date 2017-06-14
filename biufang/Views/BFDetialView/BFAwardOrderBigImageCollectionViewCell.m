//
//  BFAwardOrderBigImageCollectionViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFAwardOrderBigImageCollectionViewCell.h"

@implementation BFAwardOrderBigImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.awardBiuImageView.image = [UIImage imageNamed:@"awardTypeEmail"];
}

@end
