//
//  BFDetailViewInfoCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewJoinCell.h"

@implementation BFDetailViewJoinCell

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
    
    
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
            if (info != nil) {
                if (info.count > 0) {
                    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/5.13);
                    self.mainView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/5.13 - 10);
                    self.biuNumLable.alpha = 0;
                    self.biuNumView.alpha  = 1;
                    
                    
                    NSMutableAttributedString *joinStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您参与了：%ld人次",info.count]];
                    [joinStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:RED_COLOR] range:NSMakeRange(5, joinStr.length-7)];
                    self.joinLable.attributedText = joinStr;
                    
                    NSString *biuNumStr = @"Biu号码：";
                    for (int i = 0; i < info.count; i++) {
                        biuNumStr = [biuNumStr stringByAppendingFormat:@"%@  ",[info objectAt:i]];
                    }
                    self.numLable.text = biuNumStr;
                    
                } else {
                    self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/9.375);
                    self.mainView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/9.375 - 10);
                    self.biuNumLable.alpha = 1;
                    self.biuNumView.alpha  = 0;
                }
            }
        } else {
        
            self.backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/9.375);
            self.mainView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/9.375 - 10);
            self.biuNumLable.alpha = 1;
            self.biuNumView.alpha  = 0;
        }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.mainView];
        [self.mainView addSubview:self.biuNumLable];
        [self.mainView addSubview:self.biuNumView];
        [self.biuNumView addSubview:self.joinLable];
        [self.biuNumView addSubview:self.numLable];
        [self.biuNumView addSubview:self.moreBtn];
        
    }
    return self;
}


- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    
    return _backView;
}

- (UIView *)mainView {
    
    if (_mainView == nil) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.backgroundColor = [UIColor colorWithHex:@"f3f4f3"];
    }
    
    return _mainView;
}

- (UILabel *)biuNumLable {

    if (_biuNumLable == nil) {
        _biuNumLable = [[UILabel alloc] init];
        _biuNumLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _biuNumLable.textColor = [UIColor colorWithHex:@"999999"];
        _biuNumLable.textAlignment = NSTextAlignmentCenter;
        _biuNumLable.text = @"您还没有参与活动";
        _biuNumLable.alpha = 0;
    }
    _biuNumLable.frame = CGRectMake(0,
                                    (self.mainView.frame.size.height - SCREEN_WIDTH/31.25)/2,
                                    self.mainView.frame.size.width,
                                    SCREEN_WIDTH/31.25);
    return _biuNumLable;
}


- (UIView *)biuNumView {

    if (_biuNumView == nil) {
        _biuNumView = [[UIView alloc] init];
        _biuNumView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/5.13 - 10);
        _biuNumView.alpha = 0;
    }
    return _biuNumView;
}

- (UILabel *)joinLable {
    
    if (_joinLable == nil) {
        _joinLable = [[UILabel alloc] init];
        _joinLable.frame = CGRectMake(12,
                                      5,
                                      self.biuNumView.frame.size.width - 24,
                                      SCREEN_WIDTH/31.25);
        _joinLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _joinLable.textColor = [UIColor colorWithHex:@"999999"];
        _joinLable.textAlignment = NSTextAlignmentLeft;
    }
    return _joinLable;
}

- (UILabel *)numLable {
    
    if (_numLable == nil) {
        _numLable = [[UILabel alloc] init];
        _numLable.frame = CGRectMake(12,
                                      CGRectGetMaxY(self.joinLable.frame),
                                      self.biuNumView.frame.size.width - 24,
                                      self.biuNumView.frame.size.height - self.joinLable.frame.size.height - 10);
        _numLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _numLable.textColor = [UIColor colorWithHex:@"999999"];
        _numLable.textAlignment = NSTextAlignmentLeft;
        _numLable.numberOfLines = 2;
    }
    return _numLable;
}

- (UIButton *)moreBtn {
    
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.biuNumView.frame.size.width - SCREEN_WIDTH/6.25 - 12,
                                                              self.biuNumView.frame.size.height - (SCREEN_WIDTH/31.25) * 2,
                                                              SCREEN_WIDTH/6.25,
                                                              (SCREEN_WIDTH/31.25) * 2)];

        [_moreBtn setBackgroundColor:[UIColor colorWithHex:@"f3f4f3"]];
        [_moreBtn.titleLabel setFont:[UIFont systemFontOfSize:SCREEN_WIDTH/31.25]];
        [_moreBtn setTitleColor:[UIColor colorWithHex:@"1685fe"] forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorWithHex:@"9FCFFF"] forState:UIControlStateHighlighted];
        [_moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    }
    return _moreBtn;
}







@end
