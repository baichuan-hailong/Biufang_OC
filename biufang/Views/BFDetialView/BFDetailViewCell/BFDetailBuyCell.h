//
//  BFDetailBuyCell.h
//  biufang
//
//  Created by 娄耀文 on 16/11/4.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailBuyCell : UITableViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIImageView *avatarImg;

@property (nonatomic, strong) UIView      *mainView;
@property (nonatomic, strong) UILabel     *nickName;
@property (nonatomic, strong) UILabel     *ipLable;
@property (nonatomic, strong) UILabel     *joinLable;
@property (nonatomic, strong) UILabel     *timeLable;

@end
