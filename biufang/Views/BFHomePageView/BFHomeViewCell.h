//
//  BFHomeViewCell.h
//  biufang
//
//  Created by 娄耀文 on 16/9/30.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"

@interface BFHomeViewCell : UITableViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UIImageView    *houseImageView;
@property (nonatomic, strong) UIImageView    *priceImageView;

@property (nonatomic, strong) UIView         *midView;
@property (nonatomic, strong) UILabel        *introduceLable;

@property (nonatomic, strong) UIView         *footView;
@property (nonatomic, strong) AMProgressView *progressView;
@property (nonatomic, strong) UILabel        *totalLable;
@property (nonatomic, strong) UILabel        *leftLable;
@property (nonatomic, strong) UIButton       *biuButton;

@end
