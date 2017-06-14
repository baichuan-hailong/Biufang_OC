//
//  BFDetailViewInfoCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailViewJoinCell : UITableViewCell

- (void)setValueWithArray:(NSArray *)info;

@property (nonatomic, strong) UIView    *backView;
@property (nonatomic, strong) UIView    *mainView;
@property (nonatomic, strong) UILabel   *biuNumLable;

@property (nonatomic, strong) UIView    *biuNumView;
@property (nonatomic, strong) UILabel   *joinLable;  //参与次数
@property (nonatomic, strong) UILabel   *numLable;
@property (nonatomic, strong) UIButton  *moreBtn;


@end
