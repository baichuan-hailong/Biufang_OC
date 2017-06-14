//
//  BFMyselfDetailTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/11/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMyselfDetailTableViewCell : UITableViewCell
@property (nonatomic , strong) UIImageView *detailImageView;
@property (nonatomic , strong) UILabel *detailLabel;
@property (nonatomic , strong) UIImageView *arrowImageView;
@property (nonatomic , strong) UIView *biuLine;
- (void)setDetaillCell:(NSDictionary *)dic;
@end
