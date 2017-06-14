//
//  BFMiddleViewCell.h
//  biufang
//
//  Created by 娄耀文 on 17/2/24.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"

@interface BFMiddleViewCell : UICollectionViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView    *detialImageView;
@property (nonatomic, strong) UIImageView    *priceImageView;;
@property (nonatomic, strong) UILabel        *titleLable;

//倒计时
@property (nonatomic, strong) UIView         *timeView;
@property (nonatomic, strong) UIView         *tipsView;
@property (nonatomic, strong) UIImageView    *tipsImg;
@property (nonatomic, strong) UILabel        *tipsLable;
@property (nonatomic, strong) UILabel        *timeLessLable;;

//获奖者信息
@property (nonatomic, strong) UIView         *winnerView;
@property (nonatomic, strong) UILabel        *nickName;
@property (nonatomic, strong) UILabel        *joinTimes;
@property (nonatomic, strong) UILabel        *snLable;
@property (nonatomic, strong) UILabel        *timeLable;



@end
