//
//  BFFundCollectionViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/10/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFFundCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@property (weak, nonatomic) IBOutlet UIImageView *biuImageView;

@property (weak, nonatomic) IBOutlet UILabel *biumoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *biuTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottmLine;
@property (weak, nonatomic) IBOutlet UIImageView *bodayImageView;

- (void)setWithDiction:(NSDictionary *)dic;

@end
