//
//  BFLuckyNumView.m
//  biufang
//
//  Created by 娄耀文 on 16/11/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFLuckyNumView.h"

@implementation BFLuckyNumView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setValueWithDic:(NSDictionary *)info {

    
    [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"cover"]]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    self.communityNameLabel.text = [NSString stringWithFormat:@"%@",info[@"title"]];
    self.issueNumberLabel.text = [NSString stringWithFormat:@"期号：%@",info[@"sn"]];
    
    CGSize size = CGSizeMake(SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), 0);
    CGSize autoSize = [self.communityNameLabel actualSizeOfLable:[NSString stringWithFormat:@"%@",info[@"title"]]
                                                         andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/375*14]
                                                         andSize:size];
    self.communityNameLabel.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                               SCREEN_WIDTH/375*11,
                                               SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                               autoSize.height);
    
    
    
    
    if (![[NSString stringWithFormat:@"%@",info[@"winner"]] isEqualToString:@"<null>"]) {
        
        self.luckyNumLable.text    = [NSString stringWithFormat:@"%@",info[@"lucky_num"] ? info[@"lucky_num"] : @"--"];
        self.winnerLable.text      = [NSString stringWithFormat:@"获得者：%@",[NSString stringWithFormat:@"%@",info[@"winner"][@"nickname"]]];
        self.timesLable.text       = [NSString stringWithFormat:@"本期参与：%@人次",info[@"winner"][@"quantity"] ? info[@"winner"][@"quantity"] : @"--"];
        self.ipLable.text          = [NSString stringWithFormat:@"获得者IP：%@IP:%@",info[@"winner"][@"locate"] ? info[@"winner"][@"locate"] : @"--",
                                      info[@"winner"][@"ip"] ? info[@"winner"][@"ip"] : @"--"];
        self.publishTimeLable.text = [NSString stringWithFormat:@"揭晓时间：%@",[self changeTime:info[@"lucky_time"] ? info[@"lucky_time"] : @"--"]];
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"winner"][@"avatar"] ? info[@"winner"][@"avatar"] : @"--"]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
    }
}


- (void)setup {
    
    // SETUP...
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.issueHeaderView];
    [self.issueHeaderView addSubview:self.fangImagaView];
    [self.issueHeaderView addSubview:self.communityNameLabel];
    [self.issueHeaderView addSubview:self.issueNumberLabel];
    
    [self.scrollView addSubview:self.backView];
    [self.backView addSubview:self.titleLable];
    [self.backView addSubview:self.luckyNumLable];
    
    [self.backView addSubview:self.footView];
    [self.footView addSubview:self.avatarView];
    [self.footView addSubview:self.winnerLable];
    [self.footView addSubview:self.timesLable];
    [self.footView addSubview:self.ipLable];
    [self.footView addSubview:self.publishTimeLable];
    
    [self.scrollView addSubview:self.webView];
}

- (UIScrollView *)scrollView {

    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.issueHeaderView.frame.size.height + self.backView.frame.size.height + self.webView.frame.size.height);
        _scrollView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return _scrollView;
}


#pragma mark - headView
- (UIView *)issueHeaderView{
    
    if (_issueHeaderView==nil) {
        _issueHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
        _issueHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _issueHeaderView;
}

- (UIImageView *)fangImagaView {

    if (_fangImagaView == nil) {
        
        _fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
        _fangImagaView.backgroundColor = [UIColor lightGrayColor];
        _fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
        _fangImagaView.layer.masksToBounds= YES;
        _fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _fangImagaView;
}

- (UILabel *)communityNameLabel {

    if (_communityNameLabel == nil) {
        
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                                                        SCREEN_WIDTH/375*11,
                                                                        SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                                                        0)];
        _communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        _communityNameLabel.textColor = [UIColor blackColor];
        _communityNameLabel.numberOfLines = 0;
        _communityNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _communityNameLabel;
}

- (UILabel *)issueNumberLabel {

    if (_issueNumberLabel == nil) {
        
        _issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                                                      CGRectGetMaxY(self.fangImagaView.frame) - SCREEN_WIDTH/375*14,
                                                                      SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12),
                                                                      SCREEN_WIDTH/375*14)];
        _issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        _issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
        _issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _issueNumberLabel;
}


#pragma mark - winnerView
- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, CGRectGetMaxY(self.issueHeaderView.frame) + 7, SCREEN_WIDTH, SCREEN_WIDTH/2.78);
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(12, 10, 65, (SCREEN_WIDTH/3.125)/4.62);
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _titleLable.text = @"幸运号码";
    }
    return _titleLable;
}

- (UILabel *)luckyNumLable {
    
    if ( _luckyNumLable == nil) {
        _luckyNumLable = [[UILabel alloc] init];
        _luckyNumLable.frame = CGRectMake(CGRectGetMaxX(self.titleLable.frame), 10, SCREEN_WIDTH/3.125, (SCREEN_WIDTH/3.125)/4.62);
        _luckyNumLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _luckyNumLable.textAlignment = NSTextAlignmentCenter;
        _luckyNumLable.textColor = [UIColor whiteColor];
        _luckyNumLable.layer.backgroundColor = [UIColor colorWithHex:@"febd01"].CGColor;
        _luckyNumLable.layer.cornerRadius  = 10;
        _luckyNumLable.layer.masksToBounds = YES;
    }
    
    return _luckyNumLable;
}


- (UIView *)footView {
    
    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0,
                                     CGRectGetMaxY(self.titleLable.frame) + 10,
                                     SCREEN_WIDTH - 12,
                                     self.backView.frame.size.height - self.titleLable.frame.size.height - 30);
    }
    return _footView;
}


- (UIImageView *)avatarView {
    
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.frame = CGRectMake((SCREEN_WIDTH/375*97 - SCREEN_WIDTH/7.5)/2,
                                       /*(self.footView.frame.size.height - SCREEN_WIDTH/7.5)/2*/0,
                                        SCREEN_WIDTH/7.5,
                                        SCREEN_WIDTH/7.5);
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius  = SCREEN_WIDTH/15;
    }
    return _avatarView;
}

- (UILabel *)winnerLable {
    
    if (_winnerLable == nil) {
        
        _winnerLable = [[UILabel alloc] init];
        _winnerLable.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                        0,
                                        self.footView.frame.size.width - self.avatarView.frame.size.width - 10,
                                        self.footView.frame.size.height/4);
        _winnerLable.textColor = [UIColor colorWithHex:@"979797"];
        _winnerLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/28];
        _winnerLable.textAlignment = NSTextAlignmentLeft;
    }
    return _winnerLable;
}

- (UILabel *)timesLable {
    
    if (_timesLable == nil) {
        
        _timesLable = [[UILabel alloc] init];
        _timesLable.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                       CGRectGetMaxY(self.winnerLable.frame),
                                       self.footView.frame.size.width - self.avatarView.frame.size.width - 10,
                                       self.footView.frame.size.height/4);
        _timesLable.textColor = [UIColor colorWithHex:@"979797"];
        _timesLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/28];
        _timesLable.textAlignment = NSTextAlignmentLeft;
    }
    return _timesLable;
}

- (UILabel *)ipLable {
    
    if (_ipLable == nil) {
        
        _ipLable = [[UILabel alloc] init];
        _ipLable.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                    CGRectGetMaxY(self.timesLable.frame),
                                    self.footView.frame.size.width - self.avatarView.frame.size.width - 10,
                                    self.footView.frame.size.height/4);
        _ipLable.textColor = [UIColor colorWithHex:@"979797"];
        _ipLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/28];
        _ipLable.textAlignment = NSTextAlignmentLeft;
    }
    return _ipLable;
}

- (UILabel *)publishTimeLable {
    
    if (_publishTimeLable == nil) {
        
        _publishTimeLable = [[UILabel alloc] init];
        _publishTimeLable.frame = CGRectMake(CGRectGetMaxX(self.fangImagaView.frame) + 10,
                                             CGRectGetMaxY(self.ipLable.frame),
                                             self.footView.frame.size.width - self.avatarView.frame.size.width - 10,
                                             self.footView.frame.size.height/4);
        _publishTimeLable.textColor = [UIColor colorWithHex:@"979797"];
        _publishTimeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/28];
        _publishTimeLable.textAlignment = NSTextAlignmentLeft;
    }
    return _publishTimeLable;
}

#pragma mark - getter
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame) + 7, SCREEN_WIDTH, 400);
        _webView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return _webView;
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
