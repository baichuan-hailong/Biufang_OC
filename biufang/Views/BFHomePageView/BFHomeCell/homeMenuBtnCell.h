//
//  homeMenuBtnCell.h
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeMenuBtnCell : UICollectionViewCell

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView    *segmentView;   //移动条
@property (nonatomic, strong) UIButton  *hotBtn;        //最热
@property (nonatomic, strong) UIButton  *lastBtn;       //最新
@property (nonatomic, strong) UIButton  *progressBtn;   //进度
@property (nonatomic, strong) UIButton  *houseBtn;      //总需人次

@property (nonatomic, strong) UIImageView *upDownImg;

@end
