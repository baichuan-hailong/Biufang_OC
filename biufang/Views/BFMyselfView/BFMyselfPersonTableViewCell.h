//
//  BFMyselfPersonTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/11/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMyselfPersonTableViewCell : UITableViewCell
//headerImage
@property (nonatomic , strong) UIImageView *headerImageViwe;
//nameLabel
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *lookPersonInfoLabel;
@property (nonatomic , strong) UIImageView *arrowImageView;

- (void)setPersonCell;
@end
