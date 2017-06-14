//
//  BFDetailViewBiuNumCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewBuyTitleCell.h"

@implementation BFDetailViewBuyTitleCell

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
    if (info != nil && info.count > 0) {
        
        self.timeLable.alpha = 1;
        self.timeLable.text = [NSString stringWithFormat:@"(%@ 开始)",[myToolsClass changeTime:[info objectAt:0][@"time"]]];
    } else {
    
        self.timeLable.alpha = 0;
    }

    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.timeLable];

    }
    return self;
}

- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/9.375);
        _backView.backgroundColor = [UIColor whiteColor];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = [UIColor colorWithHex:@"e9e9e9"];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        line2.backgroundColor = [UIColor colorWithHex:@"e9e9e9"];
        
        [_backView addSubview:line1];
        [_backView addSubview:line2];
    }
    return _backView;
}


- (UILabel *)titleLable {

    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(12, (self.backView.frame.size.height - SCREEN_WIDTH/26.78)/2, 150, SCREEN_WIDTH/26.78);
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.textColor = [UIColor colorWithHex:@"595959"];
        _titleLable.text = @"所有参与记录";
    }
    return _titleLable;
}

- (UILabel *)timeLable {
    
    if (_timeLable == nil) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.frame = CGRectMake(CGRectGetMaxX(self.titleLable.frame),
                                      (self.backView.frame.size.height - SCREEN_WIDTH/31.25)/2,
                                      self.backView.frame.size.width - self.titleLable.frame.size.width - 24,
                                      SCREEN_WIDTH/31.25);
        _timeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _timeLable.textAlignment = NSTextAlignmentRight;
        _timeLable.textColor = [UIColor colorWithHex:@"9d9d9d"];
        _timeLable.alpha = 0;
    }
    return _timeLable;
}







@end
