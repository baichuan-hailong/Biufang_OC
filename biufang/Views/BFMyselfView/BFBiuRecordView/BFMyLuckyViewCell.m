//
//  BFMyLuckyViewCell.m
//  biufang
//
//  Created by 娄耀文 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyLuckyViewCell.h"

@implementation BFMyLuckyViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




- (void)setValueWithModel:(BFHomeModel *)model {
    
    //*** 判断当前商品状态 ***//
    if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"1"]) {
        
        //biu房中
        self.progressView.alpha     = 1;
        self.biuBtn.alpha           = 1;
        self.timeView.alpha         = 0;
        self.openingImageView.alpha = 0;
        self.winnerLable.alpha      = 0;
        self.winnerJoinLable.alpha  = 0;
        self.biuAgainBtn.alpha      = 0;
        
    } else if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"2"]) {
    
        //揭晓中（判断是否有lucky_time）
        self.progressView.alpha    = 1;
        self.biuBtn.alpha          = 0;
        self.biuAgainBtn.alpha     = 0;
        self.winnerLable.alpha     = 0;
        self.winnerJoinLable.alpha = 0;
        
        if ([[NSString stringWithFormat:@"%@",model.lucky_time] isEqualToString:@"0"]) {
            self.timeView.alpha        = 0;
            self.openingImageView.alpha = 1;
        } else {
            self.timeView.alpha        = 1;
            self.openingImageView.alpha = 0;
        }
        
    } else if ([[NSString stringWithFormat:@"%@",model.status] isEqualToString:@"3"]) {
    
        //已揭晓
        self.progressView.alpha     = 0;
        self.biuBtn.alpha           = 0;
        self.timeView.alpha         = 0;
        self.openingImageView.alpha = 0;
        self.winnerLable.alpha      = 1;
        self.winnerJoinLable.alpha  = 1;
        
        //*** 判断是否有下一期，显示隐藏再次购买按钮 ***//
        if ([[NSString stringWithFormat:@"%@",model.next_period] isEqualToString:@"0"]) {
            self.biuAgainBtn.alpha      = 0;
        } else {
            self.biuAgainBtn.alpha      = 1;
        }
    }
    
    
    
    
    
    
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
    float leftNum  = model.stock ? [model.stock floatValue] : 1;
    float totalNum = model.quota ? [model.quota floatValue] : 1;
    self.progress.minimumValue = 0;
    self.progress.maximumValue = totalNum;
    self.progress.progress     = totalNum - leftNum;
    
    self.totalLable.text = [NSString stringWithFormat:@"总需%@",model.quota];
    self.leftLable.text  = [NSString stringWithFormat:@"剩余%@",model.stock];
    
    [self.biuBtn setTitle:[NSString stringWithFormat:@"%@元追投",model.biu_price] forState:UIControlStateNormal];
    self.biuBtn.tag = self.tag;
    
    //获奖者
    self.winnerLable.text     = [NSString stringWithFormat:@"获奖者：%@",model.winner[@"nickname"]];
    self.winnerJoinLable.text = [NSString stringWithFormat:@"购买人次：%@",model.winner[@"quantity"]];
    
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
        [self.footView addSubview:self.progressView];
        
        [self.progressView addSubview:self.progress];
        [self.progressView addSubview:self.totalLable];
        [self.progressView addSubview:self.leftLable];
        
        [self.footView addSubview:self.biuBtn];
        [self.footView addSubview:self.biuAgainBtn];
        [self.footView addSubview:self.winnerLable];
        [self.footView addSubview:self.winnerJoinLable];
        
        [self.footView addSubview:self.timeView];
        [self.timeView addSubview:self.timeLable];
        [self.timeView addSubview:self.tiplable];
        [self.timeView addSubview:self.timeImage];
     
        [self.footView addSubview:self.openingImageView];
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


//进度View
- (UIView *)progressView {

    if (_progressView == nil) {
        _progressView = [[UIView alloc] init];
        _progressView.frame = CGRectMake(0,
                                         SCREEN_WIDTH/31.25,
                                         self.footView.frame.size.width/2,
                                         self.footView.frame.size.height - (SCREEN_WIDTH/31.25 * 2));
        _progressView.alpha = 0;
    }
    return _progressView;
}

- (AMProgressView *)progress {
    
    if (_progress == nil) {
        _progress = [[AMProgressView alloc] initWithFrame:CGRectMake(12,
                                                                     0,
                                                                     SCREEN_WIDTH/2.14,
                                                                    (SCREEN_WIDTH/2.14)/35)
                                            andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:@"ff6f5c"],[UIColor colorWithHex:@"ff2b6f"],nil]
                                             andOutsideBorder:NO
                                                  andVertical:NO];
        _progress.isHidePercent = YES;
        _progress.layer.masksToBounds = YES;
        _progress.layer.borderColor   = [UIColor colorWithHex:RED_COLOR].CGColor;
        _progress.layer.cornerRadius  = (SCREEN_WIDTH/2.14)/70;
    }
    return _progress;
}

- (UILabel *)totalLable {

    if (_totalLable == nil) {
        _totalLable = [[UILabel alloc] init];
        _totalLable.frame = CGRectMake(CGRectGetMinX(self.progress.frame),
                                       CGRectGetMaxY(self.progress.frame) + 5,
                                       self.progress.frame.size.width/2,
                                       SCREEN_WIDTH/31.25);
        _totalLable.textColor = [UIColor colorWithHex:@"494949"];
        _totalLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _totalLable.textAlignment = NSTextAlignmentLeft;
    }
    return _totalLable;
}

- (UILabel *)leftLable {
    
    if (_leftLable == nil) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.frame = CGRectMake(CGRectGetMaxX(self.totalLable.frame),
                                      CGRectGetMaxY(self.progress.frame) + 5,
                                      self.progress.frame.size.width/2,
                                      SCREEN_WIDTH/31.25);
        _leftLable.textColor = [UIColor colorWithHex:@"494949"];
        _leftLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _leftLable.textAlignment = NSTextAlignmentRight;
    }
    return _leftLable;
}


- (UIButton *)biuBtn {

    if (_biuBtn == nil) {
        
        _biuBtn = [[UIButton alloc] init];
        _biuBtn.frame = CGRectMake(self.footView.frame.size.width - SCREEN_WIDTH/3.41 - 12,
                                  (self.footView.frame.size.height - (SCREEN_WIDTH/3.41)/3.33)/2,
                                   SCREEN_WIDTH/3.41,
                                  (SCREEN_WIDTH/3.41)/3.33);
        
        [_biuBtn setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:_biuBtn.frame.size] forState:UIControlStateNormal];
        _biuBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _biuBtn.layer.cornerRadius = 6;
        _biuBtn.layer.masksToBounds = YES;
        _biuBtn.alpha = 0;
    }
    return _biuBtn;
}

- (UIButton *)biuAgainBtn {
    
    if (_biuAgainBtn == nil) {
        
        _biuAgainBtn = [[UIButton alloc] init];
        _biuAgainBtn.frame = CGRectMake(self.footView.frame.size.width - SCREEN_WIDTH/3.41 - 12,
                                       (self.footView.frame.size.height - (SCREEN_WIDTH/3.41)/3.33)/2,
                                        SCREEN_WIDTH/3.41,
                                       (SCREEN_WIDTH/3.41)/3.33);
        
        _biuAgainBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        [_biuAgainBtn setTitleColor:[UIColor colorWithHex:RED_COLOR] forState:UIControlStateNormal];
        _biuAgainBtn.layer.cornerRadius = 4;
        _biuAgainBtn.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
        _biuAgainBtn.layer.borderWidth = 1;
        _biuAgainBtn.layer.masksToBounds = YES;
        [_biuAgainBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        _biuAgainBtn.alpha = 0;
    }
    return _biuAgainBtn;
}


//获奖者
- (UILabel *)winnerLable {
    
    if (_winnerLable == nil) {
        _winnerLable = [[UILabel alloc] init];
        _winnerLable.frame = CGRectMake(12,
                                        self.footView.frame.size.height/2 - SCREEN_WIDTH/31.25 - 3,
                                       (self.footView.frame.size.width - 24)/2,
                                        SCREEN_WIDTH/31.25);
        _winnerLable.textColor = [UIColor colorWithHex:@"494949"];
        _winnerLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _winnerLable.textAlignment = NSTextAlignmentLeft;
        _winnerLable.alpha = 0;
    }
    return _winnerLable;
}

- (UILabel *)winnerJoinLable {
    
    if (_winnerJoinLable == nil) {
        _winnerJoinLable = [[UILabel alloc] init];
        _winnerJoinLable.frame = CGRectMake(12,
                                            self.footView.frame.size.height/2 + 3,
                                            (self.footView.frame.size.width - 24)/2,
                                            SCREEN_WIDTH/31.25);
        _winnerJoinLable.textColor = [UIColor colorWithHex:@"494949"];
        _winnerJoinLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _winnerJoinLable.textAlignment = NSTextAlignmentLeft;
        _winnerJoinLable.alpha = 0;
    }
    return _winnerJoinLable;
}


//倒计时View
- (UIView *)timeView {

    if (_timeView == nil) {
        _timeView = [[UIView alloc] init];
        _timeView.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame),
                                     SCREEN_WIDTH/46.875,
                                     self.footView.frame.size.width/2,
                                     self.footView.frame.size.height - (SCREEN_WIDTH/46.875 * 2));
        _timeView.alpha = 0;
    }
    return _timeView;
}

- (UILabel *)timeLable {

    if (_timeLable == nil) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.frame  = CGRectMake(self.timeView.frame.size.width - 100 - 12,
                                      /*(self.timeView.frame.size.height - SCREEN_WIDTH/18.75)/2*/0,
                                       100,
                                       SCREEN_WIDTH/18.75);
        _timeLable.textColor = [UIColor colorWithHex:RED_COLOR];
        _timeLable.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/18.75];
        _timeLable.textAlignment = NSTextAlignmentCenter;
        _timeLable.text = @"";
    }
    return _timeLable;
}

- (UILabel *)tiplable {
    
    if (_tiplable == nil) {
        _tiplable = [[UILabel alloc] init];
        _tiplable.frame  = CGRectMake(/*CGRectGetMinX(self.timeLable.frame) - 50 - 3*/CGRectGetMidX(self.timeLable.frame) - 20,
                                     /*(self.timeView.frame.size.height - SCREEN_WIDTH/37.5)/2*/self.timeView.frame.size.height - SCREEN_WIDTH/37.5,
                                      50,
                                      SCREEN_WIDTH/37.5);
        _tiplable.textColor = [UIColor colorWithHex:@"494949"];
        _tiplable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/37.5];
        _tiplable.textAlignment = NSTextAlignmentCenter;
        _tiplable.text = @"即将揭晓";
    }
    return _tiplable;
}

- (UIImageView *)timeImage {

    if (_timeImage == nil) {
        _timeImage = [[UIImageView alloc] init];
        _timeImage.frame = CGRectMake(CGRectGetMinX(self.tiplable.frame) - SCREEN_WIDTH/37.5,
                                     /*(self.timeView.frame.size.height - SCREEN_WIDTH/37.5)/2*/self.timeView.frame.size.height - SCREEN_WIDTH/37.5,
                                      SCREEN_WIDTH/37.5,
                                      SCREEN_WIDTH/37.5);
        _timeImage.image = [UIImage imageNamed:/*@"awardPersonTime"*/@"detailView_time"];
    }
    return _timeImage;
}

- (UIImageView *)openingImageView {
    
    if (_openingImageView == nil) {
        
        UIImage *img = [UIImage imageNamed:@"detailView_publishing"];
        _openingImageView = [[UIImageView alloc] init];
        _openingImageView.frame = CGRectMake(self.footView.frame.size.width - img.size.width - 12,
                                            (self.footView.frame.size.height - img.size.height)/2,
                                            img.size.width,
                                            img.size.height);
        _openingImageView.image = img;
    }
    return _openingImageView;
}




@end
