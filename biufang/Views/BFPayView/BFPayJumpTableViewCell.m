
//
//  BFPayJumpTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPayJumpTableViewCell.h"
@interface BFPayJumpTableViewCell ()

@property (nonatomic , strong) UIImageView *arrowImageView;

@end
@implementation BFPayJumpTableViewCell

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
        
        
        self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-22-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
        self.arrowImageView.image = [UIImage imageNamed:@"gonext"];
        [self.contentView addSubview:self.arrowImageView];
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*180, SCREEN_WIDTH/375*20)];
        self.leftLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        //self.leftLabel.backgroundColor = [UIColor lightGrayColor];
        //self.leftLabel.text = @"left";
        [self.contentView addSubview:self.leftLabel];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-150, SCREEN_WIDTH/375*12, 150, SCREEN_WIDTH/375*20)];
        self.rightLabel.textColor = [UIColor colorWithHex:@"999999"];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        //self.rightLabel.backgroundColor = [UIColor lightGrayColor];
        //self.rightLabel.text = @"right";
        [self.contentView addSubview:self.rightLabel];
        
//        self.line = [[UILabel alloc] initWithFrame:CGRectMake(28, SCREEN_WIDTH/375*43, SCREEN_WIDTH-28, SCREEN_WIDTH/375*1)];
//        self.line.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
//        [self.contentView addSubview:self.line];
        
    }
    return self;
}
@end
