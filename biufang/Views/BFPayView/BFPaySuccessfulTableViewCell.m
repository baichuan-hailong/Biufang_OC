//
//  BFPaySuccessfulTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPaySuccessfulTableViewCell.h"

@interface BFPaySuccessfulTableViewCell ()

@property (nonatomic , strong) UIImageView *paySuccImageView;

@property (nonatomic , strong) UILabel *leftLabel;


@end

@implementation BFPaySuccessfulTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//paySuccessful
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        //8896
        self.paySuccImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*44)/2, SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*44, SCREEN_WIDTH/375*48)];
        self.paySuccImageView.image = [UIImage imageNamed:@"paynewSuccessfulimage"];
        [self.contentView addSubview:self.paySuccImageView];
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*86, SCREEN_WIDTH, SCREEN_WIDTH/375*18)];
        self.leftLabel.textColor = [UIColor colorWithHex:@"030303"];
        self.leftLabel.textAlignment = NSTextAlignmentCenter;
        self.leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:SCREEN_WIDTH/375*17];
        self.leftLabel.text = @"支付成功";
        [self.contentView addSubview:self.leftLabel];
        
        self.rightLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*111, SCREEN_WIDTH, SCREEN_WIDTH/375*16)];
        [self.rightLabel setTitle:@"查看我的Biu号码" forState:UIControlStateNormal];
        [self.rightLabel setTitleColor:[UIColor colorWithHex:@"4A90E2"] forState:UIControlStateNormal];
        self.rightLabel.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.rightLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [self.contentView addSubview:self.rightLabel];
    }
    return self;
}
@end
