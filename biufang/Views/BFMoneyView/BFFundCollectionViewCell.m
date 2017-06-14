//
//  BFFundCollectionViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFFundCollectionViewCell.h"

@implementation BFFundCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.exchangeButton.layer.cornerRadius = 4;
    self.exchangeButton.layer.masksToBounds = YES;
    
    
    self.biuImageView.image = [UIImage imageNamed:@"biubilittleimage"];
    self.biumoneyLabel.textColor = [UIColor colorWithHex:@"FF3F56"];
    self.biuTitleLabel.textColor = [UIColor colorWithHex:@"333333"];
    
    self.backgroundColor = [UIColor whiteColor];
    self.rightLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    self.bottmLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    
    self.bodayImageView.contentMode = UIViewContentModeScaleAspectFit;
    //self.bodayImageView.backgroundColor = [UIColor redColor];
}


- (void)setWithDiction:(NSDictionary *)dic{
    
    //NSLog(@"cell dic --- %@",dic);
    self.biuTitleLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    self.biumoneyLabel.text = [NSString stringWithFormat:@"%@",dic[@"biub"]];
    [self.bodayImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]]];
}

@end
