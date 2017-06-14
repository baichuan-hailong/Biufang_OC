//
//  BFHomeViewCell.m
//  biufang
//
//  Created by 娄耀文 on 16/9/30.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeViewCell.h"

@implementation BFHomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setValueWithModel:(BFHomeModel *)model {

    //cell属性赋值...
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"首页商品"]];
    
    float biuPrice = [model.biu_price floatValue];
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
    
    //introduceLable
    CGSize size = CGSizeMake(self.midView.frame.size.width, (SCREEN_WIDTH/26.78)*2.5);
    CGSize autoSize = [self.introduceLable actualSizeOfLable:model.title andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78] andSize:size];
    self.introduceLable.frame = CGRectMake(0, 0, self.midView.frame.size.width, autoSize.height);
    
    
    self.progressView.minimumValue = 0;
    self.progressView.maximumValue = [model.quota integerValue];
    self.progressView.progress     = (CGFloat)([model.quota integerValue] - [model.stock integerValue]);
    self.totalLable.text =  [NSString stringWithFormat:@"总需%@",model.quota];
    
    NSMutableAttributedString *leftStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@",model.stock]];
    [leftStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:RED_COLOR] range:NSMakeRange(2, leftStr.length-2)];
    self.leftLable.attributedText = leftStr;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.houseImageView];
        [self.backView addSubview:self.priceImageView];
        
        [self.backView addSubview:self.midView];
        [self.midView  addSubview:self.introduceLable];
        
        [self.backView addSubview:self.footView];
        [self.footView addSubview:self.totalLable];
        [self.footView addSubview:self.leftLable];
        [self.footView addSubview:self.progressView];
        [self.footView addSubview:self.biuButton];
    }
    return self;
}


#pragma mark - getter
- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3.125 - 10);
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        
    }
    return _backView;
}


- (UIImageView *)houseImageView {

    if (_houseImageView == nil) {
        _houseImageView = [[UIImageView alloc] init];
        _houseImageView.frame = CGRectMake(10,
                                          (self.backView.frame.size.height - SCREEN_WIDTH/4.16)/2,
                                           SCREEN_WIDTH/4.16,
                                           SCREEN_WIDTH/4.16);
        
        /*  图片自动裁剪宽高来适应imageVIew的Frame  */
        _houseImageView.contentMode = UIViewContentModeScaleAspectFill;
        _houseImageView.clipsToBounds = YES;
        //_houseImageView.userInteractionEnabled = NO;
    }
    return _houseImageView;
}


- (UIImageView *)priceImageView {

    if (_priceImageView == nil) {

        _priceImageView = [[UIImageView alloc] init];
        _priceImageView.frame = CGRectMake(10, 0, SCREEN_WIDTH/9.62, SCREEN_WIDTH/10.14);
    }
    return _priceImageView;
}




//*** midView ****//
- (UIView *)midView {

    if (_midView == nil) {
        _midView = [[UIView alloc] init];
        _midView.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                    CGRectGetMinY(self.houseImageView.frame),
                                    self.backView.frame.size.width - self.houseImageView.frame.size.width - 30,
                                   (SCREEN_WIDTH/26.78)*2.5);
    }
    return _midView;
}


- (UILabel *)introduceLable {

    if (_introduceLable == nil) {
        _introduceLable = [[UILabel alloc] init];
        _introduceLable.frame = CGRectMake(0,
                                           0,
                                           self.midView.frame.size.width,
                                           0);
        _introduceLable.textColor = [UIColor colorWithHex:@"333333"];
        _introduceLable.textAlignment = NSTextAlignmentLeft;
        _introduceLable.numberOfLines = 2;
    }
    return _introduceLable;
}



//** footView **//
- (UIView *)footView {
    
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                     CGRectGetMaxY(self.midView.frame),
                                     self.backView.frame.size.width - self.houseImageView.frame.size.width - 30,
                                     self.houseImageView.frame.size.height - self.midView.frame.size.height);
    }
    return _footView;
}

- (UILabel *)totalLable {
    
    if (_totalLable == nil) {
        _totalLable = [[UILabel alloc] init];
        _totalLable.frame = CGRectMake(0,
                                       self.footView.frame.size.height - SCREEN_WIDTH/31.25,
                                       SCREEN_WIDTH/4.3,
                                       SCREEN_WIDTH/31.25);
        _totalLable.textColor = [UIColor colorWithHex:@"494949"];
        _totalLable.font  = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
    }
    return _totalLable;
}

- (UILabel *)leftLable {
    
    if (_leftLable == nil) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.frame = CGRectMake(CGRectGetMaxX(self.totalLable.frame),
                                      self.footView.frame.size.height - SCREEN_WIDTH/31.25,
                                      SCREEN_WIDTH/4.3,
                                      SCREEN_WIDTH/31.25);
        _leftLable.textColor = [UIColor colorWithHex:@"494949"];
        _leftLable.font  = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _leftLable.textAlignment = NSTextAlignmentRight;
    }
    return _leftLable;
}

- (AMProgressView *)progressView {

    if (_progressView == nil) {
        _progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(0,
                                                                         CGRectGetMinY(self.totalLable.frame) - SCREEN_WIDTH/75.25 - 8,
                                                                         SCREEN_WIDTH/2.15,
                                                                         SCREEN_WIDTH/75.25)
                                                andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:@"ff6f5c"],[UIColor colorWithHex:@"ff2b6f"],nil]
                                                andOutsideBorder:NO
                                                andVertical:NO];
        _progressView.isHidePercent = YES;
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = SCREEN_WIDTH/150.5;
    }
    return _progressView;
}


- (UIButton *)biuButton {

    if (_biuButton == nil) {
        _biuButton = [[UIButton alloc] init];
        _biuButton.frame = CGRectMake(self.footView.frame.size.width - SCREEN_WIDTH/5.36,
                                      self.footView.frame.size.height - (SCREEN_WIDTH/5.36)/2.69,
                                      SCREEN_WIDTH/5.36,
                                     (SCREEN_WIDTH/5.36)/2.69);
        
        [_biuButton setTitle:@"立即购买" forState:UIControlStateNormal];
        _biuButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/28.85];
        [_biuButton setTitleColor:[UIColor colorWithHex:RED_COLOR] forState:UIControlStateNormal];
        _biuButton.layer.cornerRadius = 4;
        _biuButton.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
        _biuButton.layer.borderWidth = 1;
        _biuButton.layer.masksToBounds = YES;
    }
    return _biuButton;
}





@end
