//
//  BFHomeFootCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeFootCell.h"

@implementation BFHomeFootCell


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
    self.dataArray = (NSArray *)[info objectAt:_indexRow-1];
    
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    for (int i = 0; i < self.dataArray.count; i++) {
        [self.imgArray addObject:[self.dataArray objectAt:i][@"cover"]];
    }
    
    if (self.dataArray.count > 0) {
        
        [self.backView addSubview:self.cycleView];
        [self.cycleView reloadData];
    }
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
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self addSubview:self.backView];
    [self.backView addSubview:self.topBtn];
}

- (NSMutableArray *)imgArray {
    
    if (_imgArray == nil) {
        _imgArray = [[NSMutableArray alloc] init];
    }
    return _imgArray;
}

- (NSArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}


#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH - 10);
        _backView.backgroundColor = [UIColor whiteColor];
        
        UIView *aline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        aline.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        UIView *bline = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height + 0.5, SCREEN_WIDTH, 0.5)];
        bline.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        [_backView addSubview:aline];
        [_backView addSubview:bline];
    }
    return _backView;
}

- (UIButton *)topBtn {

    if (_topBtn == nil) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topBtn.tag = _indexRow;
        _topBtn.frame = CGRectMake((SCREEN_WIDTH - 130)/2, 0.5, 130, SCREEN_WIDTH/6.8);
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((_topBtn.frame.size.width  - 80)/2,
                                                                        (_topBtn.frame.size.height - SCREEN_WIDTH/23.44)/2,
                                                                         80,
                                                                         SCREEN_WIDTH/23.44)];
        titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/23.44];
        titleLable.textAlignment = NSTextAlignmentCenter;
        
        UIImage *img;
        switch (_indexRow) {
            case 1:
                titleLable.text = @"即将揭晓";
                img = [UIImage imageNamed:@"topBtn_biuing"];
                break;
            case 2:
                titleLable.text = @"热门精品";
                img = [UIImage imageNamed:@"topBtn_rent"];
                break;
            case 3:
                
                titleLable.text = @"酒店客栈";

                img = [UIImage imageNamed:@"topBtn_hotel"];
                break;
            case 4:

                titleLable.text = @"热门新房";
                img = [UIImage imageNamed:@"topBtn_sell"];
                break;
                
            default:
                break;
        }

        UIImageView *titleImgView = [[UIImageView alloc] initWithImage:img];
        titleImgView.frame = CGRectMake(CGRectGetMinX(titleLable.frame) - img.size.width, (self.topBtn.frame.size.height - img.size.height)/2, img.size.width, img.size.height);
        
        UIImage *nextImg = [UIImage imageNamed:@"topBtn_next"];
        UIImageView *nextImgView = [[UIImageView alloc] initWithImage:nextImg];
        nextImgView.frame = CGRectMake(CGRectGetMaxX(titleLable.frame), (self.topBtn.frame.size.height - nextImg.size.height)/2, nextImg.size.width, nextImg.size.height);
        
        
        [_topBtn addSubview:titleImgView];
        [_topBtn addSubview:titleLable];
        [_topBtn addSubview:nextImgView];
    }
    return _topBtn;
}

- (ZYBannerView *)cycleView {
    
    if (_cycleView == nil) {
        
        _cycleView = [[ZYBannerView alloc] init];
        _cycleView.tag = _indexRow;
        _cycleView.dataSource = self;
        _cycleView.showFooter = YES;
        _cycleView.clipsToBounds = YES;
        _cycleView.pageControl.hidden = YES;
        _cycleView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _cycleView.frame = CGRectMake(0, CGRectGetMaxY(self.topBtn.frame), SCREEN_WIDTH, self.backView.frame.size.height - SCREEN_WIDTH/6.8);
        _cycleView.collectionView.pagingEnabled = NO;
        _cycleView.flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/1.23, self.backView.frame.size.height - SCREEN_WIDTH/6.8);
        _cycleView.imageHeight = SCREEN_WIDTH/1.72;
    }
    return _cycleView;
}




#pragma mark - ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    return self.dataArray.count;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index {
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH/1.23, self.backView.frame.size.height - SCREEN_WIDTH/6.8);
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 0, SCREEN_WIDTH/1.29, SCREEN_WIDTH/1.72);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imgArray objectAt:index]] placeholderImage:[UIImage imageNamed:@"首页商品"]];
    
    [imageView.layer setShadowOffset:CGSizeMake(1, 1)];
    [imageView.layer setShadowRadius:2];
    [imageView.layer setShadowOpacity:0.3];
    [imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    
        //图片底部阴影
    UIImageView *shadowImg = [[UIImageView alloc] init];
    shadowImg.frame = CGRectMake(0,
                                 imageView.frame.size.height - imageView.frame.size.height/6.23,
                                 imageView.frame.size.width,
                                 imageView.frame.size.height/6.23);
    shadowImg.image = [UIImage imageNamed:@"homeImg_shadow"];
    [imageView addSubview:shadowImg];
    
        //阴影上控件-价值
    UIImage *valueImg = [UIImage imageNamed:@"value"];
    UIImageView *valueImgView = [[UIImageView alloc] initWithImage:valueImg];
    valueImgView.frame = CGRectMake(10,
                                    shadowImg.frame.size.height - valueImg.size.height - 10,
                                    valueImg.size.width,
                                    valueImg.size.height);
    [shadowImg addSubview:valueImgView];
    
        //阴影上控件-价格
    float price = [[self.dataArray objectAt:index][@"total_price"] floatValue];
    UILabel *totalPrice = [[UILabel alloc] init];
    totalPrice.frame = CGRectMake(CGRectGetMaxX(valueImgView.frame) + 5,
                                  shadowImg.frame.size.height - SCREEN_WIDTH/26.78 - 10,
                                  120,
                                  SCREEN_WIDTH/26.78);
    totalPrice.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
    totalPrice.textColor = [UIColor whiteColor];
    
    if (price >= 100000 ) {
        
        NSString *subStr = [NSString stringWithFormat:@"%lf",price/10000];
        totalPrice.text = [NSString stringWithFormat:@"%@万人民币",@(subStr.floatValue)];
    } else {
        NSString *sepStr = [NSString stringWithFormat:@"%.0lf",price];
        totalPrice.text = [NSString stringWithFormat:@"%@元人民币",sepStr];
    }
    
    [shadowImg addSubview:totalPrice];
    
        //阴影上控件-地址
    UILabel *addLable = [[UILabel alloc] init];
    addLable.frame = CGRectMake(0, shadowImg.frame.size.height - SCREEN_WIDTH/26.78 - 10, 0, SCREEN_WIDTH/26.78);
    addLable.textColor = [UIColor whiteColor];
    
    UIFont *addLableFont = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/26.78];
    addLable.font = addLableFont;
    addLable.text = [NSString stringWithFormat:@"%@",[self.dataArray objectAt:index][@"location"]];
    CGSize addLableSize = CGSizeMake(0, SCREEN_WIDTH/26.78);
    NSDictionary *addLableDic = [NSDictionary dictionaryWithObjectsAndKeys:addLableFont,NSFontAttributeName, nil];
    CGSize addLableActualSize = [addLable.text boundingRectWithSize:addLableSize options:NSStringDrawingUsesLineFragmentOrigin attributes:addLableDic context:nil].size;
    addLable.frame = CGRectMake(shadowImg.frame.size.width - addLableActualSize.width - 5,
                                shadowImg.frame.size.height - SCREEN_WIDTH/26.78 - 10,
                                addLableActualSize.width,
                                SCREEN_WIDTH/26.78);
    [shadowImg addSubview:addLable];
    
        //阴影上控件-定位图标
    UIImage *locationImg = [UIImage imageNamed:@"location_white"];
    UIImageView *locationImgView = [[UIImageView alloc] initWithImage:locationImg];
    locationImgView.frame = CGRectMake(CGRectGetMinX(addLable.frame) - 13,
                                       shadowImg.frame.size.height - 11 - 12,
                                       9,
                                       12);
    [shadowImg addSubview:locationImgView];
    
    
    //详细信息
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                CGRectGetMaxY(imageView.frame),
                                                                SCREEN_WIDTH/1.29,
                                                                backView.frame.size.height - imageView.frame.size.height)];
    
    //标题
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.frame = CGRectMake(0, 10, footView.frame.size.width, (SCREEN_WIDTH/25) * 2.5);
    titleLable.numberOfLines = 2;
    titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/25];
    titleLable.text = [self.dataArray objectAt:index][@"title"];
    [titleLable sizeToFit];
    
    
    //进度条
    AMProgressView *progress = [[AMProgressView alloc] init];
    progress = [[AMProgressView alloc] initWithFrame:CGRectMake(0,
                                                                footView.frame.size.height - 22 - (SCREEN_WIDTH/3.68)/8.5,
                                                                SCREEN_WIDTH/3.68,
                                                               (SCREEN_WIDTH/3.68)/8.5)
                                        andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:RED_COLOR],nil]
                                         andOutsideBorder:NO
                                              andVertical:NO];
    progress.layer.masksToBounds = YES;
    progress.layer.cornerRadius = (SCREEN_WIDTH/3.68)/17;
    
    float quota = [[NSString stringWithFormat:@"%@",[self.dataArray objectAt:index][@"quota"]] floatValue];
    float stock = [[NSString stringWithFormat:@"%@",[self.dataArray objectAt:index][@"stock"]] floatValue];
    
    progress.minimumValue = 0;
    progress.maximumValue = quota;
    progress.progress = quota - stock;
    
    //元/人次
    UILabel *tagLable = [[UILabel alloc] init];
    tagLable.frame = CGRectMake(footView.frame.size.width - 50, CGRectGetMaxY(progress.frame) - SCREEN_WIDTH/31.25, 50, SCREEN_WIDTH/31.25);
    tagLable.textColor = [UIColor colorWithHex:RED_COLOR];
    tagLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
    tagLable.textAlignment = NSTextAlignmentCenter;
    tagLable.text = @"元/人次";
    
    //价格
    UILabel *priceLable = [[UILabel alloc] init];
    priceLable.frame = CGRectMake(CGRectGetMinX(tagLable.frame) - 120, CGRectGetMaxY(progress.frame) - SCREEN_WIDTH/20.83 + 2, 120, SCREEN_WIDTH/20.83);
    priceLable.textColor = [UIColor colorWithHex:RED_COLOR];
    priceLable.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/20.83];
    priceLable.textAlignment = NSTextAlignmentRight;
    priceLable.text = [NSString stringWithFormat:@"¥%.2lf",[[self.dataArray objectAt:index][@"biu_price"] floatValue]];
    
    
    [footView addSubview:titleLable];
    [footView addSubview:progress];
    [footView addSubview:tagLable];
    [footView addSubview:priceLable];
    
    [backView addSubview:imageView];
    [backView addSubview:footView];
    return backView;
}

- (NSString *)banner:(ZYBannerView *)banner titleForFooterWithState:(ZYBannerFooterState)footerState {
    
    if (footerState == ZYBannerFooterStateIdle) {
        return @"滑动查看更多";
    } else if (footerState == ZYBannerFooterStateTrigger) {
        return @"释放查看更多";
    }
    return nil;
}



#pragma mark - getter cycleViewCell属性
- (UIView *)cellBackView {
    
    if (_cellBackView == nil) {
        _cellBackView = [[UIView alloc] init];
        _cellBackView.backgroundColor = [UIColor redColor];
        _cellBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH/1.23, SCREEN_WIDTH - SCREEN_WIDTH/6.8);
    }
    return _cellBackView;
}

@end
