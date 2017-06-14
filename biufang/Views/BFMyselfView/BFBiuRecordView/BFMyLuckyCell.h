//
//  BFMyLuckyCell.h
//  biufang
//
//  Created by 娄耀文 on 17/2/28.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFHomeModel.h"

@interface BFMyLuckyCell : UITableViewCell

- (void)setValueWithModel:(BFHomeModel *)model;

@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UIView         *topView;
@property (nonatomic, strong) UIView         *footView;

@property (nonatomic, strong) UIImageView    *houseImageView;  //商品图片
@property (nonatomic, strong) UILabel        *titleLable;      //标题
@property (nonatomic, strong) UILabel        *snLable;         //期号
@property (nonatomic, strong) UILabel        *joinLable;       //参与次数

@property (nonatomic, strong) UIButton       *sharBtn;
@property (nonatomic, strong) UIButton       *getBtn;
@property (nonatomic, strong) UIButton       *buyBtn;


@end
