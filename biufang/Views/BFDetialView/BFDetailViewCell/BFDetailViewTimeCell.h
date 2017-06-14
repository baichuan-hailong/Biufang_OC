//
//  BFDetailViewTimeCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewTimeCell : UITableViewCell

@property (nonatomic, strong) UIView  *backView;
@property (nonatomic, strong) UIView  *titleView;
@property (nonatomic, strong) UIView  *footView;

@property (nonatomic, strong) UILabel *snLable;     //期号
@property (nonatomic, strong) UILabel *tipsLable;   //tips
@property (nonatomic, strong) UILabel *timeLable;   //倒计时

@end
