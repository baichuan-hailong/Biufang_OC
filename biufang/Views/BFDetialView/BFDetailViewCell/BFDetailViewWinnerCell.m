//
//  BFDetailViewWinnerCell.m
//  biufang
//
//  Created by 娄耀文 on 16/11/6.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewWinnerCell.h"

@implementation BFDetailViewWinnerCell

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
    
    
    if (![[NSString stringWithFormat:@"%@",info[@"winner"]] isEqualToString:@"<null>"]) {
    
        self.luckyNumLable.text    = [NSString stringWithFormat:@"%@",info[@"lucky_num"] ? info[@"lucky_num"] : @"--"];
        
        //*** 获奖者attributedText ***//
        NSMutableAttributedString *winnerStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"获得者：%@",[NSString stringWithFormat:@"%@",info[@"winner"][@"nickname"]]]];
        [winnerStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"1685FE"] range:NSMakeRange(4, winnerStr.length-4)];
        self.winnerLable.attributedText = winnerStr;

        self.ipLable.text          = [NSString stringWithFormat:@"获得者IP：%@IP:%@",info[@"winner"][@"locate"] ? info[@"winner"][@"locate"] : @"--",
                                      info[@"winner"][@"ip"] ? info[@"winner"][@"ip"] : @"--"];
        //*** 参与次数attributedText ***//
        NSMutableAttributedString *timesStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本期参与：%@人次",info[@"winner"][@"quantity"] ? info[@"winner"][@"quantity"] : @"--"]];
        [timesStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:RED_COLOR] range:NSMakeRange(5, timesStr.length-7)];
        self.timesLable.attributedText = timesStr;
        
        
        self.snNumber.text         = [NSString stringWithFormat:@"期号：%@",info[@"sn"]];
        self.publishTimeLable.text = [NSString stringWithFormat:@"揭晓时间：%@",[self changeTime:info[@"lucky_time"] ? info[@"lucky_time"] : @"--"]];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"winner"][@"avatar"] ? info[@"winner"][@"avatar"] : @"--"]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        //self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleView];
        [self.titleView addSubview:self.titleLable];
        [self.titleView addSubview:self.luckyNumLable];
        [self.titleView addSubview:self.checkBtn];
        
        [self.backView addSubview:self.footView];
        [self.footView addSubview:self.avatarView];
        [self.footView addSubview:self.winnerLable];
        [self.footView addSubview:self.ipLable];
        [self.footView addSubview:self.timesLable];
        [self.footView addSubview:self.snNumber];
        [self.footView addSubview:self.publishTimeLable];
    }
    return self;
}


#pragma mark - getter
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/2.5);
    }
    return _backView;
}

- (UIView *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.frame = CGRectMake(0, 0, self.backView.frame.size.width, (self.backView.frame.size.height)/4.28);
        _titleView.backgroundColor = [UIColor colorWithHex:RED_COLOR];
    }
    return _titleView;
}

- (UILabel *)titleLable {

    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(12, (self.titleView.frame.size.height - SCREEN_WIDTH/31.25)/2, 65, SCREEN_WIDTH/31.25);
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _titleLable.text = @"幸运号码";
        _titleLable.textColor = [UIColor whiteColor];
    }
    return _titleLable;
}

- (UILabel *)luckyNumLable {

    if (_luckyNumLable == nil) {
        _luckyNumLable = [[UILabel alloc] init];
        _luckyNumLable.frame = CGRectMake(CGRectGetMaxX(self.titleLable.frame) + 10,
                                         (self.titleView.frame.size.height - SCREEN_WIDTH/20.83)/2,
                                          SCREEN_WIDTH/3.125,
                                          SCREEN_WIDTH/20.83);
        _luckyNumLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/20.83];
        _luckyNumLable.textAlignment = NSTextAlignmentLeft;
        _luckyNumLable.textColor = [UIColor whiteColor];
    }
    
    return _luckyNumLable;
}

- (UIButton *)checkBtn {

    if (_checkBtn == nil) {
        _checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.titleView.frame.size.width - self.titleView.frame.size.width/4.66 - 12,
                                                              (self.titleView.frame.size.height - self.titleView.frame.size.height/1.5)/2,
                                                               self.titleView.frame.size.width/4.66,
                                                               self.titleView.frame.size.height/1.5)];
        _checkBtn.layer.borderColor  = [UIColor whiteColor].CGColor;
        _checkBtn.layer.borderWidth  = 1;
        _checkBtn.layer.cornerRadius = 3;
        [_checkBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/31.25]];
        [_checkBtn setTitle:@"计算详情" forState:UIControlStateNormal];
    }
    return _checkBtn;
}



- (UIView *)footView {

    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.titleView.frame),
                                     self.backView.frame.size.width,
                                     self.backView.frame.size.height - self.titleView.frame.size.height);
        _footView.backgroundColor = [UIColor colorWithHex:@"faf3f0"];
    }
    return _footView;
}


- (UIImageView *)avatarView {

    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.frame = CGRectMake(12, 12, SCREEN_WIDTH/10, SCREEN_WIDTH/10);
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = SCREEN_WIDTH/20;
    }
    return _avatarView;
}

- (UILabel *)winnerLable {

    if (_winnerLable == nil) {
        
        _winnerLable = [[UILabel alloc] init];
        _winnerLable.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                        0,
                                        self.footView.frame.size.width - self.avatarView.frame.size.width - 22,
                                        self.footView.frame.size.height/5);
        _winnerLable.textColor = [UIColor colorWithHex:@"979797"];
        _winnerLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _winnerLable.textAlignment = NSTextAlignmentLeft;
    }
    return _winnerLable;
}

- (UILabel *)ipLable {
    
    if (_ipLable == nil) {
        
        _ipLable = [[UILabel alloc] init];
        _ipLable.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                    CGRectGetMaxY(self.winnerLable.frame),
                                    self.footView.frame.size.width - self.avatarView.frame.size.width - 22,
                                    self.footView.frame.size.height/5);
        _ipLable.textColor = [UIColor colorWithHex:@"979797"];
        _ipLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _ipLable.textAlignment = NSTextAlignmentLeft;
    }
    return _ipLable;
}

- (UILabel *)timesLable {
    
    if (_timesLable == nil) {
        
        _timesLable = [[UILabel alloc] init];
        _timesLable.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                       CGRectGetMaxY(self.ipLable.frame),
                                       self.footView.frame.size.width - self.avatarView.frame.size.width - 22,
                                       self.footView.frame.size.height/5);
        _timesLable.textColor = [UIColor colorWithHex:@"979797"];
        _timesLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _timesLable.textAlignment = NSTextAlignmentLeft;
    }
    return _timesLable;
}


- (UILabel *)snNumber {
    
    if (_snNumber == nil) {
        
        _snNumber = [[UILabel alloc] init];
        _snNumber.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                       CGRectGetMaxY(self.timesLable.frame),
                                       self.footView.frame.size.width - self.avatarView.frame.size.width - 22,
                                       self.footView.frame.size.height/5);
        _snNumber.textColor = [UIColor colorWithHex:@"979797"];
        _snNumber.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _snNumber.textAlignment = NSTextAlignmentLeft;
    }
    return _snNumber;
}



- (UILabel *)publishTimeLable {
    
    if (_publishTimeLable == nil) {
        
        _publishTimeLable = [[UILabel alloc] init];
        _publishTimeLable.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 10,
                                             CGRectGetMaxY(self.snNumber.frame),
                                             self.footView.frame.size.width - self.avatarView.frame.size.width - 22,
                                             self.footView.frame.size.height/5);
        _publishTimeLable.textColor = [UIColor colorWithHex:@"979797"];
        _publishTimeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _publishTimeLable.textAlignment = NSTextAlignmentLeft;
    }
    return _publishTimeLable;
}


- (NSString *)changeTime:(NSString *)timeStr {
    
    NSTimeInterval timeInt = [timeStr doubleValue];// + 28800;//因为时差 == 28800
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
    NSString *currentDateStr = [formatter stringFromDate: date];
    return currentDateStr;
}


@end
