//
//  BFMyselfDetailTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/11/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfDetailTableViewCell.h"

@implementation BFMyselfDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:self.detailImageView];
        
        self.detailLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        self.detailLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        
        [self.contentView addSubview:self.detailLabel];
        
        self.arrowImageView.image = [UIImage imageNamed:@"gonext"];
        [self.contentView addSubview:self.arrowImageView];
        
        self.biuLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
        [self.contentView addSubview:self.biuLine];
       
        
    }
    return self;
}


- (void)setDetaillCell:(NSDictionary *)dic{

    //"tipIm":@"Unknown1",@"tipStr
    self.detailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",dic[@"tipIm"]]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",dic[@"tipStr"]];
}

-(UIImageView *)detailImageView{
    
    if (_detailImageView==nil) {
        _detailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _detailImageView;
}

-(UILabel *)detailLabel{
    
    if (_detailLabel==nil) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _detailLabel;
}

-(UIImageView *)arrowImageView{
    
    if (_arrowImageView==nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _arrowImageView;
}
-(UIView *)biuLine{
    
    if (_biuLine==nil) {
        _biuLine = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*49, SCREEN_WIDTH-29, 1)];
    }
    return _biuLine;
}
@end
