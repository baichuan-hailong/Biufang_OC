//
//  BFDetailViewFootCell.m
//  biufang
//
//  Created by 娄耀文 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewFootCell.h"

@implementation BFDetailViewFootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueWithDic:(NSDictionary *)info {

    NSInteger index  = [[NSString stringWithFormat:@"%@",info[@"index"]] integerValue];
    
    if (index == 0) {

        self.titleLable.text = @"往期揭晓";
        
    } else if (index == 1) {

        self.titleLable.text = @"晒单分享";
        
    } else {
        self.titleLable.text = @"图文详情";
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.sepLine];
        [self.backView addSubview:self.titleLable];
        [self.backView addSubview:self.goImageView];
    }
    return self;
}

- (UIView *)backView {

    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/8.4);
    }
    return _backView;
}


- (UILabel *)titleLable {

    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(12, 0, 100, self.backView.frame.size.height);
        _titleLable.textColor = [UIColor colorWithHex:@"595959"];
        _titleLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
    }
    return _titleLable;
}


- (UIImageView *)goImageView {

    if (_goImageView == nil) {
        _goImageView = [[UIImageView alloc] init];
        _goImageView.frame = CGRectMake(SCREEN_WIDTH - 8 - 15, (self.backView.frame.size.height - 13)/2, 8, 13);
        _goImageView.image = [UIImage imageNamed:@"gonext"];
    }
    return _goImageView;
}


- (UIView *)sepLine {

    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.frame = CGRectMake(12, self.backView.frame.size.height - 1, SCREEN_WIDTH - 12, 1);
        _sepLine.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    }
    return _sepLine;
}






@end
