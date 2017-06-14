//
//  BFDetailViewWinnerCell.h
//  biufang
//
//  Created by 娄耀文 on 16/11/6.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewWinnerCell : UITableViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLable;
@property (nonatomic, strong) UILabel     *luckyNumLable;
@property (nonatomic, strong) UIButton    *checkBtn;

@property (nonatomic, strong) UIView      *footView;
@property (nonatomic, strong) UILabel     *winnerLable;     //获奖者
@property (nonatomic, strong) UILabel     *ipLable;         //ip
@property (nonatomic, strong) UILabel     *timesLable;      //参与次数
@property (nonatomic, strong) UILabel     *snNumber;        //期号
@property (nonatomic, strong) UILabel     *publishTimeLable;//揭晓时间

@property (nonatomic, strong) UIImageView *avatarView;

@end
