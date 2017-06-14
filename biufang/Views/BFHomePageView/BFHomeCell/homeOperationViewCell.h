//
//  homeOperationViewCell.h
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeOperationViewCell : UICollectionViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UIImageView *opImageView;
@property (nonatomic, strong) UILabel     *detailLable;

@end
