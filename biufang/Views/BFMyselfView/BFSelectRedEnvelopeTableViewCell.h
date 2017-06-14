//
//  BFSelectRedEnvelopeTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/11/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFSelectRedEnvelopeTableViewCell : UITableViewCell

@property (nonatomic , strong) UIImageView *ableImageView;
@property (nonatomic , strong) UIImageView *bodyImageView;
@property (nonatomic , strong) UILabel *tipMonLabel;
@property (nonatomic , strong) UILabel *moneyLabel;
- (void)setValueWithRedEnavle:(NSDictionary *)redEnavleModelDic;

@end
