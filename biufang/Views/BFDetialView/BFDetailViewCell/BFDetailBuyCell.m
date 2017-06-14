//
//  BFDetailBuyCell.m
//  biufang
//
//  Created by 娄耀文 on 16/11/4.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailBuyCell.h"

@implementation BFDetailBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setValueWithDic:(NSDictionary *)info {
    
    [self.avatarImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",info[@"avatar"]]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
    self.nickName.text = info[@"nickname"];
    self.ipLable.text = [NSString stringWithFormat:@"%@ IP:%@",info[@"locate"],info[@"ip"]];
    
    CGSize titleSize = CGSizeMake(0, self.mainView.frame.size.height/3);
    CGSize autoSize = [self.joinLable actualSizeOfLable:[NSString stringWithFormat:@"参与了%@人次",info[@"quantity"]]
                                                     andFont:[UIFont systemFontOfSize:SCREEN_WIDTH/26.78]
                                                     andSize:titleSize];
    NSMutableAttributedString *joinStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参与了%@人次",info[@"quantity"]]];
    [joinStr     addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:RED_COLOR] range:NSMakeRange(3, joinStr.length-5)];
    self.joinLable.attributedText = joinStr;
    
    _joinLable.frame = CGRectMake(0,
                                  CGRectGetMaxY(self.ipLable.frame),
                                  autoSize.width,
                                  self.mainView.frame.size.height/3);
    
    self.timeLable.text = [myToolsClass changeTime:[NSString stringWithFormat:@"%@",info[@"time"]]];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.avatarImg];
        [self.backView addSubview:self.mainView];
        [self.mainView addSubview:self.nickName];
        [self.mainView addSubview:self.ipLable];
        [self.mainView addSubview:self.joinLable];
        [self.mainView addSubview:self.timeLable];


    }
    return self;
}

- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/5.75);
    }
    return _backView;
}


- (UIImageView *)avatarImg {

    if (_avatarImg == nil) {
        _avatarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15,
                                                                  (self.backView.frame.size.height - SCREEN_WIDTH/10.42)/2,
                                                                   SCREEN_WIDTH/10.42,
                                                                   SCREEN_WIDTH/10.42)];
        _avatarImg.layer.cornerRadius = SCREEN_WIDTH/20.84;
        _avatarImg.layer.masksToBounds = YES;
    }
    return _avatarImg;
}


- (UIView *)mainView {

    if (_mainView == nil) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImg.frame) + 8,
                                                            (self.backView.frame.size.height - (SCREEN_WIDTH/31.25)*3 - 15)/2,
                                                             self.backView.frame.size.width - self.avatarImg.frame.size.width - 35,
                                                             (SCREEN_WIDTH/31.25)*3 + 15)];
    }
    return _mainView;
}


- (UILabel *)nickName {
    
    if (_nickName == nil) {
        _nickName = [[UILabel alloc] init];
        _nickName.frame = CGRectMake(0,
                                     0,
                                     self.mainView.frame.size.width,
                                     self.mainView.frame.size.height/3);
        _nickName.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _nickName.textAlignment = NSTextAlignmentLeft;
        _nickName.textColor = [UIColor colorWithHex:@"1685fe"];
    }
    return _nickName;
}


- (UILabel *)ipLable {
    
    if (_ipLable == nil) {
        _ipLable = [[UILabel alloc] init];
        _ipLable.frame = CGRectMake(0,
                                    CGRectGetMaxY(self.nickName.frame),
                                    self.mainView.frame.size.width,
                                    self.mainView.frame.size.height/3);
        _ipLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _ipLable.textAlignment = NSTextAlignmentLeft;
        _ipLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
    }
    return _ipLable;
}


- (UILabel *)joinLable {
    
    if (_joinLable == nil) {
        _joinLable = [[UILabel alloc] init];
//        _joinLable.frame = CGRectMake(0,
//                                      CGRectGetMaxY(self.ipLable.frame),
//                                      95,
//                                      self.mainView.frame.size.height/3);
        _joinLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _joinLable.textAlignment = NSTextAlignmentLeft;
        _joinLable.textColor = [UIColor colorWithHex:@"595959"];
    }
    return _joinLable;
}


- (UILabel *)timeLable {
    
    if (_timeLable == nil) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _timeLable.textAlignment = NSTextAlignmentLeft;
        _timeLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
    }
    _timeLable.frame = CGRectMake(CGRectGetMaxX(self.joinLable.frame) + 5,
                                  CGRectGetMaxY(self.ipLable.frame),
                                  self.mainView.frame.size.width - self.joinLable.frame.size.width - 5,
                                  self.mainView.frame.size.height/3);
    return _timeLable;
}



@end
