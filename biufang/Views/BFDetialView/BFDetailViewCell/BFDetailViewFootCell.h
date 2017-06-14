//
//  BFDetailViewFootCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewFootCell : UITableViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UILabel     *titleLable;
@property (nonatomic, strong) UIImageView *goImageView;
@property (nonatomic, strong) UIView      *sepLine;

@end
