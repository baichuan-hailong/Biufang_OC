//
//  BFNewFundTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFNewFundTableViewCell : UITableViewCell

@property (nonatomic , strong) UIButton *exchangeButton;
- (void)setNewFund:(NSDictionary *)dic;

@end
