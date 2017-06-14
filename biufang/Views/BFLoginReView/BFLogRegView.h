//
//  BFLogRegView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFLogRegView : UIView

@property (nonatomic , strong) UIImageView *headerImageView;

//tel
@property (nonatomic , strong) UITextField *telTextField;
//code
@property (nonatomic , strong) UITextField *codeTextField;

@property (nonatomic , strong) UIButton *obtainCoderButton;
@property (nonatomic , strong) UIButton *loginButton;


//loading
@property(nonatomic,strong)UIView *loadingView;
//loading-Image
@property(nonatomic,strong)UIImageView *loadImageView;

@property (nonatomic , strong) UIButton *serverButton;

@property (nonatomic , strong) UIView *thirdLine;
@property (nonatomic , strong) UILabel *thirdLabel;

//wechat
@property (nonatomic,strong)UIButton *wechatButton;
@property (nonatomic,strong)UILabel  *wechatLabel;
//qq
@property (nonatomic,strong)UIButton *qqButton;
@property (nonatomic,strong)UILabel  *qqLabel;
//webo
@property (nonatomic,strong)UIButton *weboButton;
@property (nonatomic,strong)UILabel  *weiboLabel;

@end
