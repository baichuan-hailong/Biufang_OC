//
//  BFSelectCityCell.h
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFCityModle;
@interface BFSelectCityCell : UITableViewCell

- (void)setValueWithCity:(BFCityModle *)cityModel;
@property (nonatomic , strong) UILabel     *cityNameLabel;

@end
