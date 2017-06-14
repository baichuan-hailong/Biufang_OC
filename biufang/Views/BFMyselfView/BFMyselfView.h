//
//  BFMyselfView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFMyselfView : UIScrollView

//个人资料
@property (nonatomic , strong) UIView *personViwe;

//Biu
@property (nonatomic , strong) UIView *biufangRecordViwe;
//red
@property (nonatomic , strong) UIView *redMoneyViwe;
//star
@property (nonatomic , strong) UIView *starViwe;


//question
@property (nonatomic , strong) UIView *questionView;
//feedBack
@property (nonatomic , strong) UIView *feedbackViwe;

//注销
@property (nonatomic , strong) UIView *cancleViwe;



//headerImage
@property (nonatomic , strong) UIImageView *headerImageViwe;
//nameLabel
@property (nonatomic , strong) UILabel *nameLabel;
//winningLabel
@property (nonatomic , strong) UIImageView *winningLabel;



@end
