//
//  BFDetailViewProgressCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewProgressCell : UITableViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView         *backView;

@property (nonatomic, strong) UILabel        *percentLable;
@property (nonatomic, strong) AMProgressView *progressView;
@property (nonatomic, strong) UILabel        *totalLable;
@property (nonatomic, strong) UILabel        *leftLable;


@end
