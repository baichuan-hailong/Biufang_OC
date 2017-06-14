//
//  homeBannerViewCell.h
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface homeBannerViewCell : UICollectionViewCell <ZYBannerViewDelegate,ZYBannerViewDataSource>


- (void)setValueWithArray:(NSArray *)info;

@property (nonatomic, assign) NSInteger           indexRow;
@property (nonatomic, strong) NSArray             *dataArray;
@property (nonatomic, strong) NSMutableArray      *imgArray;
@property (nonatomic, strong) ZYBannerView        *cycleView;
@property (nonatomic, strong) UIView              *backView;

@end
