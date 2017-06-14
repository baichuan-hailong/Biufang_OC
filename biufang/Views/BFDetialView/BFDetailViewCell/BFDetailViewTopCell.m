//
//  BFDetailViewTopCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/12.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewTopCell.h"

@implementation BFDetailViewTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithDic:(NSDictionary *)info {

    //...
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    
    if (info[@"meta"][@"album"] != nil) {
        
        NSArray *dataArray = (NSArray *)info[@"meta"][@"album"];
        
        for (int i = 0; i < dataArray.count; i++) {
            NSString *imgStr = [NSString stringWithFormat:@"%@%@",info[@"meta"][@"cdn_prefix"],[dataArray objectAt:i]];
            [self.imgArray addObject:imgStr];
        }
    } else {
        
        //没有图片
        [self.imgArray addObject:@""];
    }
    
    //价格标签
    float biuPrice = [info[@"biu_price"] floatValue];
    if (biuPrice == 10) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"十元商品"];
    } else if (biuPrice == 100) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"百元商品"];
    } else if (biuPrice == 1000) {
        self.priceImageView.hidden = NO;
        self.priceImageView.image = [UIImage imageNamed:@"千元商品"];
    } else {
        self.priceImageView.hidden = YES;
    }
    
    [self.contentView addSubview:self.cycleView];
    [self.cycleView addSubview:self.priceImageView];
    //[self.cycleView addSubview:self.addressLable];
    //[self.addressLable addSubview:self.addressImageView];
    [self.cycleView reloadData];

    
    if (info[@"category"] &&
        ([[NSString stringWithFormat:@"%@",info[@"category"]] isEqualToString:@"sell"] ||
         [[NSString stringWithFormat:@"%@",info[@"category"]] isEqualToString:@"hotel"])) {
        self.addressImageView.alpha = 1;
        self.addressLable.alpha = 0.8;
    } else {
        self.addressImageView.alpha = 0;
        self.addressLable.alpha = 0;
    }
    UIFont *font = [UIFont systemFontOfSize:14];
    self.addressLable.font = font;
    self.addressLable.text = info[@"location"];
    
    CGSize size = CGSizeMake(0, 28);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualSize = [self.addressLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.addressLable.frame = CGRectMake(self.cycleView.frame.size.width - actualSize.width - 14 - 20,
                                         self.cycleView.frame.size.height - 42,
                                         actualSize.width + 28 + 20,
                                         28);
    
    
    
    CGSize titleSize = CGSizeMake(SCREEN_WIDTH/1.33, 0);
    CGSize autoSize = [self.introduceLable actualSizeOfLable:[NSString stringWithFormat:@"%@",info[@"title"] ? info[@"title"] : @""]
                                                 andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]
                                                 andSize:titleSize];
    self.introduceLable.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, autoSize.height);
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.footView];
        [self.footView addSubview:self.introduceLable];
    }
    return self;
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
        _cycleView.showFooter = YES;
        _cycleView.dataSource = self;
        _cycleView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _cycleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.34);
        _cycleView.collectionView.pagingEnabled = YES;
        _cycleView.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/1.34);
        _cycleView.imageHeight = SCREEN_WIDTH/1.34;
        _cycleView.pageControlFrame = CGRectMake(0, CGRectGetMaxY(_cycleView.frame), SCREEN_WIDTH, 25);
    }
    return _cycleView;
}

- (UIImageView *)priceImageView {
    
    if (_priceImageView == nil) {
        _priceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12,
                                                                        self.cycleView.frame.size.height - SCREEN_WIDTH/10.14 - 12,
                                                                        SCREEN_WIDTH/9.62,
                                                                        SCREEN_WIDTH/10.14)];
        _priceImageView.hidden = YES;
        
    }
    return _priceImageView;
}

- (UILabel *)addressLable {
    
    if (_addressLable == nil) {
        _addressLable = [[UILabel alloc] init];
        _addressLable.frame = CGRectMake(self.cycleView.frame.size.width - 71, self.cycleView.frame.size.height - 42, 71, 28);
        _addressLable.textAlignment = NSTextAlignmentCenter;
        _addressLable.textColor = [UIColor whiteColor];
        _addressLable.backgroundColor = [UIColor blackColor];
        _addressLable.layer.masksToBounds = YES;
        _addressLable.layer.cornerRadius = 14;
        _addressLable.alpha = 0;
    }
    return _addressLable;
}

- (UIImageView *)addressImageView {
    
    if (_addressImageView == nil) {
        _addressImageView = [[UIImageView alloc] init];
        _addressImageView.frame = CGRectMake(10, 8, 9, 12);
        _addressImageView.image = [UIImage imageNamed:@"location_white"];
        _addressImageView.alpha = 0;
    }
    return _addressImageView;
}



//*** midView ***//
- (UIView *)footView {
    
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.cycleView.frame) + 25,
                                    SCREEN_WIDTH,
                                    (SCREEN_WIDTH/23.5) * 3);
    }
    return _footView;
}


- (UILabel *)introduceLable {
    
    if (_introduceLable == nil) {
        _introduceLable = [[UILabel alloc] init];
        _introduceLable.frame = CGRectMake(12,
                                           0,
                                           SCREEN_WIDTH - 24,
                                           0);
        _introduceLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _introduceLable.textColor = [UIColor colorWithHex:@"333333"];
        _introduceLable.textAlignment = NSTextAlignmentLeft;
        _introduceLable.numberOfLines = 3;
    }
    return _introduceLable;
}



#pragma mark - ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{

    return self.imgArray.count;
}


- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index {
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.34);
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0,0, SCREEN_WIDTH, backView.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgArray objectAt:index]] placeholderImage:[UIImage imageNamed:@"详情图片占位符"]];
    
    [backView addSubview:imageView];
    return backView;
}


- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState {
    
    if (footerState == ZYBannerFooterStateIdle) {
        return @"滑动查看图文详情";
    } else if (footerState == ZYBannerFooterStateTrigger) {
        return @"释放查看图文详情";
    }
    return nil;
}

@end
