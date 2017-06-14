//
//  BFLuckyNumView.h
//  biufang
//
//  Created by 娄耀文 on 16/11/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFLuckyNumView : UIView

- (void)setValueWithDic:(NSDictionary *)info;

@property (nonatomic, strong) UIScrollView   *scrollView;

//headView
@property (nonatomic , strong) UIView        *issueHeaderView;
@property (nonatomic , strong) UIImageView   *fangImagaView;
@property (nonatomic , strong) UILabel       *communityNameLabel;
@property (nonatomic , strong) UILabel       *issueNumberLabel;

//winnerView
@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UILabel        *titleLable;
@property (nonatomic, strong) UILabel        *luckyNumLable;;
@property (nonatomic, strong) UIView         *footView;
@property (nonatomic, strong) UILabel        *winnerLable;
@property (nonatomic, strong) UILabel        *timesLable;
@property (nonatomic, strong) UILabel        *ipLable;
@property (nonatomic, strong) UILabel        *publishTimeLable;
@property (nonatomic, strong) UIImageView    *avatarView;

//webView
@property (nonatomic, strong) UIWebView      *webView;

@end
