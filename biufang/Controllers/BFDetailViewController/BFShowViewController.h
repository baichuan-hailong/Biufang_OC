//
//  BFShowViewController.h
//  biufang
//
//  Created by 娄耀文 on 16/12/16.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFShowViewController : BFBaseViewController

@property (nonatomic, copy  ) NSString     *webUrl;
@property (nonatomic, strong) NSDictionary *dataSource;

//headView
@property (nonatomic , strong) UIView        *issueHeaderView;
@property (nonatomic , strong) UIImageView   *fangImagaView;
@property (nonatomic , strong) UILabel       *communityNameLabel;
@property (nonatomic , strong) UILabel       *issueNumberLabel;

@end
