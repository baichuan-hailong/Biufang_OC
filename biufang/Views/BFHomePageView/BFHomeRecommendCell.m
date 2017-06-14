//
//  BFHomeRecommendCell.m
//  biufang
//
//  Created by 娄耀文 on 16/12/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeRecommendCell.h"

@implementation BFHomeRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithModel:(BFHomeModel *)model {
    
    //cell属性赋值...
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.cover]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    
    //title
    CGSize size = CGSizeMake(self.backView.frame.size.width - self.houseImageView.frame.size.width - 30, 0);
    CGSize autoSize = [self.titleLable actualSizeOfLable:[NSString stringWithFormat:@"%@",model.title ? model.title : @""]
                                                andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/25]
                                                andSize:size];
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                       CGRectGetMinY(self.houseImageView.frame),
                                       self.backView.frame.size.width - self.houseImageView.frame.size.width - 25,
                                       autoSize.height);
    
    //进度条
    float quota = [[NSString stringWithFormat:@"%@",model.quota] floatValue];
    float stock = [[NSString stringWithFormat:@"%@",model.stock] floatValue];
    
    _progressView.minimumValue = 0;
    _progressView.maximumValue = quota;
    _progressView.progress = quota - stock;
    
    //价格
    CGSize priceSize = CGSizeMake(0, SCREEN_WIDTH/20.83);
    CGSize priceAutoSize = [self.priceLable actualSizeOfLable:[NSString stringWithFormat:@"¥%.2lf",[model.biu_price floatValue]]
                                                 andFont:[UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/20.83]
                                                 andSize:priceSize];
    
    self.priceLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                       CGRectGetMinY(self.progressView.frame) - SCREEN_WIDTH/20.83 - 10,
                                       priceAutoSize.width,
                                       SCREEN_WIDTH/20.83);

    //元/人次
    self.tipsLable.frame = CGRectMake(CGRectGetMaxX(self.priceLable.frame),
                                      CGRectGetMaxY(self.priceLable.frame) - SCREEN_WIDTH/31.25 - 2,
                                      50,
                                      SCREEN_WIDTH/31.25);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.houseImageView];
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.progressView];
        [self.backView addSubview:self.priceLable];
        [self.backView addSubview:self.tipsLable];
    }
    return self;
}


#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.78);
        _backView.backgroundColor    = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"ececec"];
        [_backView addSubview:line];
    }
    return _backView;
}


- (UIImageView *)houseImageView {
    
    if (_houseImageView == nil) {
        _houseImageView = [[UIImageView alloc] init];
        _houseImageView.frame = CGRectMake(10,
                                          (self.backView.frame.size.height - SCREEN_WIDTH/3.57)/2,
                                           SCREEN_WIDTH/3.57,
                                           SCREEN_WIDTH/3.57);
        /*  图片自动裁剪宽高来适应imageVIew的Frame  */
        _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
        _houseImageView.clipsToBounds = YES;
        //_houseImageView.userInteractionEnabled = NO;
    }
    return _houseImageView;
}


- (UILabel *)titleLable {

    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                       CGRectGetMaxY(self.houseImageView.frame),
                                       self.backView.frame.size.width - self.houseImageView.frame.size.width - 25,
                                       0);
        _titleLable.numberOfLines = 0;
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/25];
    }
    return _titleLable;
}


- (AMProgressView *)progressView {

    if (_progressView == nil) {
        
        _progressView = [[AMProgressView alloc] init];
        _progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                                                         CGRectGetMaxY(self.houseImageView.frame) - (SCREEN_WIDTH/3.68)/8.5,
                                                                         SCREEN_WIDTH/3.68,
                                                                        (SCREEN_WIDTH/3.68)/8.5)
                                       andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:RED_COLOR],nil]
                                        andOutsideBorder:NO
                                             andVertical:NO];
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = (SCREEN_WIDTH/3.68)/17;
    }
    return _progressView;
}


- (UILabel *)priceLable {

    if (_priceLable == nil) {
        _priceLable = [[UILabel alloc] init];
        _priceLable.textColor = [UIColor colorWithHex:RED_COLOR];
        _priceLable.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLable;
}

- (UILabel *)tipsLable {

    if (_tipsLable == nil) {
        _tipsLable = [[UILabel alloc] init];
        _tipsLable.textColor = [UIColor colorWithHex:RED_COLOR];
        _tipsLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _tipsLable.textAlignment = NSTextAlignmentCenter;
        _tipsLable.text = @"元/人次";
    }
    return _tipsLable;
}

@end





