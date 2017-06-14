//
//  BFShareOrderCell.m
//  biufang
//
//  Created by 娄耀文 on 17/3/8.
//  Copyright © 2017年 biufang. All rights reserved.
//
// *** 晒单Cell ***//
//

#import "BFShareOrderCell.h"

@implementation BFShareOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setValueWithDic:(NSDictionary *)info {
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
        NSLog(@"cell高度 %lf",self.frame.size.height);
        [self.contentView addSubview:self.backView];
        
        
    }
    return self;
}

- (UIView *)backView {
    
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"ebebeb"];
        [_backView addSubview:line];
    }
    return _backView;
}




@end
