//
//  BFUserInfoHeaderImageTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFUserInfoHeaderImageTableViewCell.h"

@interface BFUserInfoHeaderImageTableViewCell ()
@property (nonatomic , strong) UIImageView *arrowImageView;
@property (nonatomic , strong) UILabel *headerImLabel;
@end

@implementation BFUserInfoHeaderImageTableViewCell

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
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
        //self.headerImageView.backgroundColor = [UIColor colorWithHex:@"6D6D72"];
        self.headerImageView.layer.cornerRadius = SCREEN_WIDTH/375*25;
        self.headerImageView.layer.masksToBounds= YES;
        //self.headerImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.headerImageView];

        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-22-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*27, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
        self.arrowImageView.image = [UIImage imageNamed:@"gonext"];
        [self.contentView addSubview:self.arrowImageView];
        
        self.headerImLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*150, SCREEN_WIDTH/375*20)];
        self.headerImLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.headerImLabel.textAlignment = NSTextAlignmentLeft;
        self.headerImLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        self.headerImLabel.text = @"头像";
        [self.contentView addSubview:self.headerImLabel];
        
    }
    return self;
}

@end
