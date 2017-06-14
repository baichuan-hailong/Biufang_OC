//
//  BFShareOrderCell.h
//  biufang
//
//  Created by 娄耀文 on 17/3/8.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFShareOrderCell : UITableViewCell

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIView         *backView;

@end
