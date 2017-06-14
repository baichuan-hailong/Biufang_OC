//
//  BFDetailViewProgressCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewProgressCell.h"

@implementation BFDetailViewProgressCell

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
    self.percentLable.text = [NSString stringWithFormat:@"期号：%@",[info objectForKey:@"sn"]];
    
    float leftNum = info[@"stock"] ? [info[@"stock"] floatValue] : 1;
    float totalNum = info[@"quota"] ? [info[@"quota"] floatValue] : 1;
    self.progressView.minimumValue = 0;
    self.progressView.maximumValue = totalNum;
    self.progressView.progress     = totalNum - leftNum;
    
    self.totalLable.text = [NSString stringWithFormat:@"总需%@人次（%@元/人次）",info[@"quota"],info[@"biu_price"]];
    
    NSMutableAttributedString *leftStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余%@",info[@"stock"]]];
    NSMutableAttributedString *nullleftStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余--"]];
    [leftStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"268AFB"] range:NSMakeRange(2, leftStr.length-2)];
    [nullleftStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"268AFB"] range:NSMakeRange(2, nullleftStr.length-2)];
    self.leftLable.attributedText = info[@"stock"] ? leftStr : nullleftStr;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.percentLable];
        [self.backView addSubview:self.progressView];
        [self.backView addSubview:self.totalLable];
        [self.backView addSubview:self.leftLable];
    }
    return self;
}

- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/7.5);
    }
    return _backView;
}


- (UILabel *)percentLable {

    if (_percentLable == nil) {
        _percentLable = [[UILabel alloc] init];
        _percentLable.frame = CGRectMake(12, 0, self.backView.frame.size.width - 24, SCREEN_WIDTH/31.25);
        _percentLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _percentLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
    }
    return _percentLable;
}

- (AMProgressView *)progressView {

    if (_progressView == nil) {
        _progressView = [[AMProgressView alloc] initWithFrame:CGRectMake(12,
                                                                        CGRectGetMaxY(self.percentLable.frame) + 3,
                                                                         SCREEN_WIDTH - 24,
                                                                        (SCREEN_WIDTH - 24)/35)
                                                andGradientColors:[NSArray arrayWithObjects:[UIColor colorWithHex:@"ff6f5c"],[UIColor colorWithHex:@"ff2b6f"],nil]
                                                andOutsideBorder:NO
                                                andVertical:NO];
        _progressView.isHidePercent = YES;
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
        _progressView.layer.cornerRadius  = (SCREEN_WIDTH - 24)/70;
    }
    _progressView.frame = CGRectMake(12,
                                     CGRectGetMaxY(self.percentLable.frame) + 5,
                                     SCREEN_WIDTH - 24,
                                    (SCREEN_WIDTH - 24)/35);
    return _progressView;
}


- (UILabel *)totalLable {
    
    if (_totalLable == nil) {
        _totalLable = [[UILabel alloc] init];
        _totalLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
        _totalLable.frame = CGRectMake(12,
                                       CGRectGetMaxY(self.progressView.frame) + 3,
                                       ((self.backView.frame.size.width - 24)*2.3)/3,
                                       SCREEN_WIDTH/31.25);
        _totalLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
    }

    return _totalLable;
}

- (UILabel *)leftLable {
    
    if (_leftLable == nil) {
        _leftLable = [[UILabel alloc] init];
        _leftLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _leftLable.textAlignment = NSTextAlignmentRight;
        _leftLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
        _leftLable.frame = CGRectMake(CGRectGetMaxX(self.totalLable.frame),
                                      CGRectGetMaxY(self.progressView.frame) + 3,
                                      ((self.backView.frame.size.width - 24)*0.7)/3,
                                      SCREEN_WIDTH/31.25);
    }

    return _leftLable;
}






@end
