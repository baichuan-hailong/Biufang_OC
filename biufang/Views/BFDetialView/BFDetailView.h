//
//  BFDetailView.h
//  biufang
//
//  Created by 娄耀文 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFDetailView : UIView

@property (nonatomic, strong) UITableView  *detailTableView;
@property (nonatomic, strong) UIView       *navBarView;
@property (nonatomic, strong) UIButton     *backBtn;
@property (nonatomic, strong) UIButton     *shareBtn;
@property (nonatomic, strong) UIView       *footView;
@property (nonatomic, strong) UIButton     *footBtn;
@property (nonatomic, strong) UIImageView  *publishingImageView;

@end
