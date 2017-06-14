//
//  homeGoodsViewCell.h
//  biufang
//
//  Created by 娄耀文 on 17/1/3.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"


@interface homeGoodsViewCell : UICollectionViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView    *detialImageView;
@property (nonatomic, strong) UIImageView    *priceImageView;;
@property (nonatomic, strong) UILabel        *titleLable;

//进度View
@property (nonatomic, strong) UIView         *progressView;
@property (nonatomic, strong) UILabel        *progressLable;
@property (nonatomic, strong) AMProgressView *progress;

@property (nonatomic, strong) UIButton       *buyBtn;

@end
