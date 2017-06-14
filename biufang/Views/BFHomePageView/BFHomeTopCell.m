//
//  BFHomeTopCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeTopCell.h"

@implementation BFHomeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithArray:(NSArray *)info {

    //...
    self.dataArray = (NSArray *)info;
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    
    if (self.dataArray.count > 0) {
        [self.backView addSubview:self.cycleView];
    } else {
        [self.cycleView removeFromSuperview];
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.imgArray addObject:[self.dataArray objectAt:i][@"img"]];
    }
    [self.cycleView reloadData];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexRow:(NSInteger)indexRow{

    _indexRow = indexRow;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self addSubview:self.backView];
    //[self.backView addSubview:self.cycleView];
    [self.backView addSubview:self.btnView];
    
    [self.btnView addSubview:self.sellBtn];
    [self.btnView addSubview:self.rentBtn];
    [self.btnView addSubview:self.hotelBtn];
    [self.btnView addSubview:self.guideBtn];
}


#pragma mark - getter
- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.25);
        _backView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return _backView;
}

- (NSArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)imgArray {
    
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
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
        _cycleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.83);
        _cycleView.collectionView.pagingEnabled = YES;
        _cycleView.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/1.83);
    }
    return _cycleView;
}

- (UIView *)btnView {

    if (_btnView == nil) {
        _btnView = [[UIView alloc] init];
        _btnView.frame = CGRectMake(0, CGRectGetMaxY(self.cycleView.frame) + 10, SCREEN_WIDTH, SCREEN_WIDTH/4.41);
        
        UIView *aline = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, SCREEN_WIDTH, 0.5)];
        aline.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        UIView *bline = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4.41, SCREEN_WIDTH, 0.5)];
        bline.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        [_btnView addSubview:aline];
        [_btnView addSubview:bline];
    }
    return _btnView;
}

- (UIButton *)sellBtn {

    if (_sellBtn == nil) {
        _sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sellBtn.tag = 1;
        _sellBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _sellBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *helpImage = [UIImage imageNamed:@"home_sell"];
        [_sellBtn setImage:helpImage forState:UIControlStateNormal];
        _sellBtn.imageEdgeInsets = UIEdgeInsetsMake((iPhone5 ? 7 : 12),
                                                    (_sellBtn.frame.size.width - helpImage.size.width)/2,
                                                    self.btnView.frame.size.height - helpImage.size.height - (iPhone5 ? 7 : 12),
                                                    (_sellBtn.frame.size.width - helpImage.size.width)/2);
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        /*_sellBtn.frame.size.height - SCREEN_WIDTH/26.78 - 10*/CGRectGetMaxX(_sellBtn.imageView.frame) - 5,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/26.78)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        titleLable.text = @"热门新房";
        [_sellBtn addSubview:titleLable];
    }
    return _sellBtn;
}

- (UIButton *)hotelBtn {
    
    if (_hotelBtn == nil) {
        _hotelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotelBtn.tag = 2;
        _hotelBtn.frame = CGRectMake(CGRectGetMaxX(self.sellBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _hotelBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *helpImage = [UIImage imageNamed:@"home_hotel"];
        [_hotelBtn setImage:helpImage forState:UIControlStateNormal];
        _hotelBtn.imageEdgeInsets = UIEdgeInsetsMake((iPhone5 ? 7 : 12),
                                                     (_hotelBtn.frame.size.width - helpImage.size.width)/2,
                                                     self.btnView.frame.size.height - helpImage.size.height - (iPhone5 ? 7 : 12),
                                                     (_hotelBtn.frame.size.width - helpImage.size.width)/2);
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        /*_hotelBtn.frame.size.height - SCREEN_WIDTH/26.78 - 10*/CGRectGetMaxX(_hotelBtn.imageView.frame) - 5,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/26.78)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        titleLable.text = @"酒店客栈";
        //titleLable.text = @"豪华酒店";
        [_hotelBtn addSubview:titleLable];
    }
    return _hotelBtn;
}

- (UIButton *)rentBtn {
    
    if (_rentBtn == nil) {
        _rentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rentBtn.tag = 3;
        _rentBtn.frame = CGRectMake(CGRectGetMaxX(self.hotelBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _rentBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *helpImage = [UIImage imageNamed:@"home_rent"];
        [_rentBtn setImage:helpImage forState:UIControlStateNormal];
        _rentBtn.imageEdgeInsets = UIEdgeInsetsMake((iPhone5 ? 7 : 12),
                                                    (_rentBtn.frame.size.width - helpImage.size.width)/2,
                                                    self.btnView.frame.size.height - helpImage.size.height - (iPhone5 ? 7 : 12),
                                                    (_rentBtn.frame.size.width - helpImage.size.width)/2);
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        /*_rentBtn.frame.size.height - SCREEN_WIDTH/26.78 - 10*/CGRectGetMaxX(_rentBtn.imageView.frame) - 5,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/26.78)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        //titleLable.text = @"租房";
        titleLable.text = @"热门精品";
        [_rentBtn addSubview:titleLable];
    }
    return _rentBtn;
}


- (UIButton *)guideBtn {
    
    if (_guideBtn == nil) {
        _guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _guideBtn.tag = 4;
        _guideBtn.frame = CGRectMake(CGRectGetMaxX(self.rentBtn.frame), 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4.41 + 1);
        _guideBtn.backgroundColor = [UIColor whiteColor];
        
        UIImage *helpImage = [UIImage imageNamed:@"home_guide"];
        [_guideBtn setImage:helpImage forState:UIControlStateNormal];
        _guideBtn.imageEdgeInsets = UIEdgeInsetsMake((iPhone5 ? 7 : 12),
                                                     (_guideBtn.frame.size.width - helpImage.size.width)/2,
                                                     self.btnView.frame.size.height - helpImage.size.height - (iPhone5 ? 7 : 12),
                                                     (_guideBtn.frame.size.width - helpImage.size.width)/2);
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        /*_guideBtn.frame.size.height - SCREEN_WIDTH/26.78 - 10*/CGRectGetMaxX(_guideBtn.imageView.frame) - 5,
                                                                        SCREEN_WIDTH/4,
                                                                        SCREEN_WIDTH/26.78)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        titleLable.text = @"新手指南";
        [_guideBtn addSubview:titleLable];
    }
    return _guideBtn;
}



#pragma mark - ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    return self.dataArray.count;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index {
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.83);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,0, SCREEN_WIDTH, backView.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgArray objectAt:index]] placeholderImage:[UIImage imageNamed:@"首页banner占位符"]];
    
    [backView addSubview:imageView];
    return backView;
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
