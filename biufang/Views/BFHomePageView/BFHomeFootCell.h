//
//  BFHomeFootCell.h
//  biufang
//
//  Created by 娄耀文 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFHomeFootCell : UITableViewCell <ZYBannerViewDataSource>

- (void)setValueWithArray:(NSArray *)info;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexRow:(NSInteger)indexRow;

@property (nonatomic, assign) NSInteger           indexRow;
@property (nonatomic, strong) NSMutableArray      *imgArray;
@property (nonatomic, strong) NSArray             *dataArray;

@property (nonatomic, strong) UIView              *backView;
@property (nonatomic, strong) UIButton            *topBtn;
@property (nonatomic, strong) ZYBannerView        *cycleView;

@property (nonatomic, assign) BOOL                reload;



//横屏Cell属性
@property (nonatomic, strong) UIView  *cellBackView;

@end
