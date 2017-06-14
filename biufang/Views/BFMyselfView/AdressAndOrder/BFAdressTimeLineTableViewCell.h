//
//  BFAdressTimeLineTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFAdressTimeLineTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *coView;
@property(nonatomic,strong)UIImageView *tipImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIView  *maskView;

@property(nonatomic,strong)UIView *Line;

- (void)setCellInfo:(NSDictionary *)dic;
@end
