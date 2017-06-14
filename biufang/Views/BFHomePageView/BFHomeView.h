//
//  BFHomeView.h
//  biufang
//
//  Created by 娄耀文 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFHomeView : UIView

@property (nonatomic, strong) UIView           *navBarView;
@property (nonatomic, strong) UIView           *navBarWhiteView;
@property (nonatomic, strong) UILabel          *titleLable;
@property (nonatomic, strong) UITableView      *homeTableView;
@property (nonatomic, strong) UICollectionView *homeCollectionView;

@property (nonatomic, strong) UIButton    *leftBtn;
@property (nonatomic, strong) UIImageView *rightImage;

@end
