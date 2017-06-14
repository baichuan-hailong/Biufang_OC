//
//  BFSelectCityCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFSelectCityCell.h"
#import "BFCityModle.h"

@interface BFSelectCityCell ()

@property (nonatomic , strong) UIView      *line;
@property (nonatomic , strong) UIImageView *rowImageView;
@end

@implementation BFSelectCityCell

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
        
        //Disclosure Indicator Copy 2
        self.line = [[UIView alloc] initWithFrame:CGRectMake(20, 49, SCREEN_WIDTH-20, 0.5)];
        self.line.backgroundColor    = [UIColor colorWithHex:@"DDDDDD"];
        [self.contentView addSubview:self.line];
        
        self.cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, (50-20)/2, 200, 20)];
        self.cityNameLabel.textColor    = [UIColor blackColor];
        self.cityNameLabel.font         = [UIFont systemFontOfSize:18];
        self.cityNameLabel.textAlignment= NSTextAlignmentLeft;
        [self.contentView addSubview:self.cityNameLabel];
        
        self.rowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-19-8, (50-13)/2, 8, 13)];
        self.rowImageView.image = [UIImage imageNamed:@"gonext"];
        [self.contentView addSubview:self.rowImageView];
        
    }
    return self;
}

- (void)setValueWithCity:(BFCityModle *)cityModel{

    self.cityNameLabel.text = cityModel.name;
}

@end
