//
//  BFMyLuckyCell.m
//  biufang
//
//  Created by 娄耀文 on 17/2/28.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFMyLuckyCell.h"

@implementation BFMyLuckyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setValueWithModel:(BFHomeModel *)model {
    

    //NSLog(@"幸运记录modle---%@",model);
    
    //商品信息（必须）...
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.cover]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    
    CGSize size = CGSizeMake(self.backView.frame.size.width - self.houseImageView.frame.size.width - 32, 0);
    CGSize autoSize = [self.titleLable actualSizeOfLable:[NSString stringWithFormat:@"%@",model.title]
                                                 andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]
                                                 andSize:size];
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                       CGRectGetMinY(self.houseImageView.frame),
                                       self.backView.frame.size.width - self.houseImageView.frame.size.width - 32,
                                       autoSize.height);
    
    NSMutableAttributedString *joinStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我参与人次：%@次",model.quantity]];
    [joinStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:RED_COLOR] range:NSMakeRange(6, joinStr.length-7)];
    self.joinLable.attributedText = joinStr;
    self.snLable.text   = [NSString stringWithFormat:@"期号：%@",model.sn];
    
    
    //foot信息（根据商品状态显示隐藏部分控件）...
    [self.getBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.topView];
        [self.backView addSubview:self.footView];
        
        //*** topView ***//
        [self.topView addSubview:self.houseImageView];
        [self.topView addSubview:self.titleLable];
        [self.topView addSubview:self.joinLable];
        [self.topView addSubview:self.snLable];
        
        //*** footView ***//
        [self.footView addSubview:self.sharBtn];
        [self.footView addSubview:self.buyBtn];
        [self.footView addSubview:self.getBtn];

    }
    return self;
}


#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2.27);
        _backView.backgroundColor     = [UIColor whiteColor];
        _backView.layer.masksToBounds = YES;
        
    }
    return _backView;
}

- (UIView *)topView {
    
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.backView.frame.size.height/1.42);
        _topView.backgroundColor     = [UIColor whiteColor];
        _topView.layer.masksToBounds = YES;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"ebebeb"];
        [_topView addSubview:line];
        
    }
    return _topView;
}

- (UIView *)footView {
    
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, self.backView.frame.size.height/3.37);
        _footView.backgroundColor     = [UIColor whiteColor];
        _footView.layer.masksToBounds = YES;
        
    }
    return _footView;
}



//商品信息
- (UIImageView *)houseImageView {
    
    if (_houseImageView == nil) {
        _houseImageView = [[UIImageView alloc] init];
        _houseImageView.frame = CGRectMake(12, 12, self.topView.frame.size.height - 24, self.topView.frame.size.height - 24);
        _houseImageView.layer.cornerRadius  = 4;
        _houseImageView.layer.masksToBounds = YES;
        _houseImageView.contentMode   = UIViewContentModeScaleAspectFill;
        _houseImageView.clipsToBounds = YES;
    }
    return _houseImageView;
}

- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                       CGRectGetMinY(self.houseImageView.frame),
                                       self.backView.frame.size.width - self.houseImageView.frame.size.width - 32,
                                       0);
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _titleLable.numberOfLines = 0;
    }
    return _titleLable;
}

- (UILabel *)joinLable {
    
    if (_joinLable == nil) {
        _joinLable = [[UILabel alloc] init];
        _joinLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                      CGRectGetMaxY(self.houseImageView.frame) - SCREEN_WIDTH/31.25,
                                      self.backView.frame.size.width - self.houseImageView.frame.size.width - 32,
                                      SCREEN_WIDTH/31.25);
        _joinLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _joinLable.textColor = [UIColor colorWithHex:@"979797"];
    }
    return _joinLable;
}

- (UILabel *)snLable {
    
    if (_snLable == nil) {
        _snLable = [[UILabel alloc] init];
        _snLable.frame = CGRectMake(CGRectGetMaxX(self.houseImageView.frame) + 10,
                                    CGRectGetMinY(self.joinLable.frame) - SCREEN_WIDTH/31.25 - 4,
                                    self.backView.frame.size.width - self.houseImageView.frame.size.width - 32,
                                    SCREEN_WIDTH/31.25);
        _snLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _snLable.textColor = [UIColor colorWithHex:@"979797"];
    }
    return _snLable;
}


//*** 底部按钮 ***//
- (UIButton *)sharBtn {
    
    if (_sharBtn == nil) {
        _sharBtn = [[UIButton alloc] init];
        _sharBtn.frame = CGRectMake(12,
                                   (self.footView.frame.size.height - (SCREEN_WIDTH/4.166)/3)/2,
                                    SCREEN_WIDTH/4.166,
                                   (SCREEN_WIDTH/4.166)/3);
        [_sharBtn setImage:[UIImage imageNamed:@"晒单分享"] forState:UIControlStateNormal];
        _sharBtn.imageEdgeInsets = UIEdgeInsetsMake(SCREEN_WIDTH/46.875,
                                                    0,
                                                    SCREEN_WIDTH/46.875,
                                                    SCREEN_WIDTH/37.5);
        _sharBtn.layer.masksToBounds = YES;
    }
    return _sharBtn;
}


- (UIButton *)getBtn {
    
    if (_getBtn == nil) {
        _getBtn = [[UIButton alloc] init];
        _getBtn.frame = CGRectMake(CGRectGetMinX(self.buyBtn.frame) - SCREEN_WIDTH/4.166 - 10,
                                  (self.footView.frame.size.height - (SCREEN_WIDTH/4.166)/3)/2,
                                   SCREEN_WIDTH/4.166,
                                  (SCREEN_WIDTH/4.166)/3);
        
        _getBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        [_getBtn setTitleColor:[UIColor colorWithHex:RED_COLOR] forState:UIControlStateNormal];
        _getBtn.layer.cornerRadius = 4;
        _getBtn.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
        _getBtn.layer.borderWidth = 1;
        _getBtn.layer.masksToBounds = YES;
    }
    return _getBtn;
}


- (UIButton *)buyBtn {
    
    if (_buyBtn == nil) {
        _buyBtn = [[UIButton alloc] init];
        _buyBtn.frame = CGRectMake(self.footView.frame.size.width - SCREEN_WIDTH/4.166 - 12,
                                  (self.footView.frame.size.height - (SCREEN_WIDTH/4.166)/3)/2,
                                   SCREEN_WIDTH/4.166,
                                  (SCREEN_WIDTH/4.166)/3);
        
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        [_buyBtn setTitleColor:[UIColor colorWithHex:RED_COLOR] forState:UIControlStateNormal];
        _buyBtn.layer.cornerRadius = 4;
        _buyBtn.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
        _buyBtn.layer.borderWidth = 1;
        _buyBtn.layer.masksToBounds = YES;
        [_buyBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    }
    return _buyBtn;
}






@end
