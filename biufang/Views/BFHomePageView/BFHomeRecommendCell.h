//
//  BFHomeRecommendCell.h
//  biufang
//
//  Created by 娄耀文 on 16/12/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"
#import "AMProgressView.h"

@interface BFHomeRecommendCell : UITableViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UIImageView    *houseImageView;
@property (nonatomic, strong) UILabel        *titleLable;
@property (nonatomic, strong) UILabel        *priceLable;
@property (nonatomic, strong) UILabel        *tipsLable;
@property (nonatomic, strong) AMProgressView *progressView;


@end
