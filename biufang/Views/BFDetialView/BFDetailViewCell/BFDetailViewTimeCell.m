//
//  BFDetailViewTimeCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewTimeCell.h"

@implementation BFDetailViewTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backView];
        [self.backView addSubview:self.titleView];
        [self.backView addSubview:self.footView];
        
        [self.titleView addSubview:self.snLable];
        [self.footView  addSubview:self.tipsLable];
        [self.footView  addSubview:self.timeLable];
    }
    return self;
}



- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 24, SCREEN_WIDTH/5)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)titleView {
    
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, self.backView.frame.size.height/2.68)];
        _titleView.backgroundColor = [UIColor colorWithHex:@"f2f3f3"];
    }
    return _titleView;
}

- (UIView *)footView {
    
    if (_footView == nil) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(self.titleView.frame),
                                                             self.backView.frame.size.width,
                                                             self.backView.frame.size.height - self.titleView.frame.size.height)];
        _footView.backgroundColor = [UIColor colorWithHex:RED_COLOR];
    }
    return _footView;
}

- (UILabel *)snLable {

    if (_snLable == nil) {
        _snLable = [[UILabel alloc] initWithFrame:CGRectMake(12,
                                                            (self.titleView.frame.size.height - SCREEN_WIDTH/31.25)/2,
                                                             self.titleView.frame.size.width - 24,
                                                             SCREEN_WIDTH/31.25)];
        _snLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _snLable.textColor = [UIColor colorWithHex:@"999999"];
        _snLable.textAlignment = NSTextAlignmentLeft;
    }
    return _snLable;
}


- (UILabel *)tipsLable {
    
    if (_tipsLable == nil) {
        _tipsLable = [[UILabel alloc] initWithFrame:CGRectMake(12,
                                                             (self.footView.frame.size.height - SCREEN_WIDTH/31.25)/2,
                                                             (self.footView.frame.size.width - 24)/2,
                                                              SCREEN_WIDTH/31.25)];
        _tipsLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _tipsLable.textColor = [UIColor whiteColor];
        _tipsLable.textAlignment = NSTextAlignmentLeft;
        _tipsLable.text = @"揭晓倒计时:";
        
    }
    return _tipsLable;
}


- (UILabel *)timeLable {
    
    if (_timeLable == nil) {
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(self.footView.frame.size.width/2,
                                                             (self.footView.frame.size.height - SCREEN_WIDTH/12.5)/2,
                                                             (self.footView.frame.size.width - 24)/2,
                                                              SCREEN_WIDTH/12.5)];
        _timeLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/12.5];
        _timeLable.textColor = [UIColor whiteColor];
        _timeLable.textAlignment = NSTextAlignmentRight;
    }
    return _timeLable;
}



@end
