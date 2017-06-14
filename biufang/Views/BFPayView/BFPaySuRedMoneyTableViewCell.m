//
//  BFPaySuRedMoneyTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/15.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPaySuRedMoneyTableViewCell.h"
@interface BFPaySuRedMoneyTableViewCell ()

@property (nonatomic , strong) UIImageView *paySuccRedMoImageView;

@end
@implementation BFPaySuRedMoneyTableViewCell

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
        
        self.paySuccRedMoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/750*236)];
        self.paySuccRedMoImageView.image = [UIImage imageNamed:@"newsharebanner"];
        [self.contentView addSubview:self.paySuccRedMoImageView];
        
    }
    return self;
}

@end
