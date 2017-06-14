//
//  homeBannerViewCell.m
//  biufang
//
//  Created by 娄耀文 on 17/1/4.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "homeBannerViewCell.h"

@implementation homeBannerViewCell


- (void)setValueWithArray:(NSArray *)info {

     self.dataArray = (NSArray *)info;
    [self.cycleView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.cycleView];

    }
    return self;
}

- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.125)];
        _backView.backgroundColor = [UIColor colorWithHex:@"ff2b6f"];
    }
    return _backView;
}

- (ZYBannerView *)cycleView {
    
    if (_cycleView == nil) {
        
        _cycleView = [[ZYBannerView alloc] init];
        _cycleView.tag = _indexRow;
        _cycleView.dataSource = self;
        _cycleView.showFooter = NO;
        _cycleView.shouldLoop = YES;
        _cycleView.autoScroll = YES;
        _cycleView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _cycleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.125);
        _cycleView.collectionView.pagingEnabled = YES;
        _cycleView.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/3.125);
    }
    return _cycleView;
}




#pragma mark - ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    return self.dataArray.count;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH/3.125);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArray objectAt:index][@"img"]] placeholderImage:[UIImage imageNamed:@"首页banner占位符"]];

    return imageView;
}

- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState {
    
    if (footerState == ZYBannerFooterStateIdle) {
        return @"拖动进入下一页";
    } else if (footerState == ZYBannerFooterStateTrigger) {
        return @"释放进入下一页";
    }
    return nil;
}





@end
