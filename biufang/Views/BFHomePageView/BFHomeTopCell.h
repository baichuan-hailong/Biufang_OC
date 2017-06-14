//
//  BFHomeTopCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFHomeTopCell : UITableViewCell <ZYBannerViewDelegate,ZYBannerViewDataSource>

- (void)setValueWithArray:(NSArray *)info;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexRow:(NSInteger)indexRow;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, strong) NSArray   *dataArray;

@property (nonatomic, strong) NSMutableArray      *imgArray;
@property (nonatomic, strong) UIView              *backView;
@property (nonatomic, strong) ZYBannerView        *cycleView;

@property (nonatomic, strong) UIView              *btnView;
@property (nonatomic, strong) UIButton            *sellBtn;
@property (nonatomic, strong) UIButton            *rentBtn;
@property (nonatomic, strong) UIButton            *hotelBtn;
@property (nonatomic, strong) UIButton            *guideBtn;

@end
