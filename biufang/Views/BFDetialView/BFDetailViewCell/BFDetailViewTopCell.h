//
//  BFDetailViewTopCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/12.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BFDetailViewTopCell : UITableViewCell <ZYBannerViewDelegate,ZYBannerViewDataSource>

- (void)setValueWithDic:(NSDictionary *)info;
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)info;

@property (nonatomic, strong) ZYBannerView   *cycleView;
@property (nonatomic, strong) UIImageView    *addressImageView;
@property (nonatomic, strong) UILabel        *addressLable;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIImageView    *priceImageView;;

@property (nonatomic, strong) UIView         *footView;
@property (nonatomic, strong) UILabel        *introduceLable;

@end
