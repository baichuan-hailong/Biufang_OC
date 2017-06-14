//
//  BFMyLuckyViewCell.h
//  biufang
//
//  Created by 娄耀文 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"
#import "AMProgressView.h"

@interface BFMyLuckyViewCell : UITableViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UIView         *topView;
@property (nonatomic, strong) UIView         *footView;

@property (nonatomic, strong) UIImageView    *houseImageView;  //商品图片
@property (nonatomic, strong) UILabel        *titleLable;      //标题
@property (nonatomic, strong) UILabel        *snLable;         //期号
@property (nonatomic, strong) UILabel        *joinLable;       //参与次数

//进度View
@property (nonatomic, strong) UIView         *progressView;
@property (nonatomic, strong) AMProgressView *progress;
@property (nonatomic, strong) UILabel        *totalLable;
@property (nonatomic, strong) UILabel        *leftLable;

@property (nonatomic, strong) UIButton       *biuBtn;
@property (nonatomic, strong) UIButton       *biuAgainBtn;

//获奖者
@property (nonatomic, strong) UILabel        *winnerLable;
@property (nonatomic, strong) UILabel        *winnerJoinLable;

//倒计时View
@property (nonatomic, strong) UIView         *timeView;
@property (nonatomic, strong) UILabel        *timeLable;
@property (nonatomic, strong) UIImageView    *timeImage;
@property (nonatomic, strong) UILabel        *tiplable;

//揭晓中图片
@property (nonatomic, strong) UIImageView    *openingImageView;




@end
