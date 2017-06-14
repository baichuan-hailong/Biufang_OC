//
//  BFOrderUserAddressTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFOrderUserAddressTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *coView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *telLabel;
@property(nonatomic,strong)UILabel *addressLabel;

- (void)setCell:(NSDictionary *)dic time:(NSString *)time;
@end
