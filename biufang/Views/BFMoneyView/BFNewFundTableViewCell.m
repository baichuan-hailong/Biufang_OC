//
//  BFNewFundTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewFundTableViewCell.h"

@interface BFNewFundTableViewCell ()
@property (nonatomic , strong) UIImageView *bigImageView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *biubiLabel;
@property (nonatomic , strong) UIImageView *biubiImageView;

@property (nonatomic , strong) UIView *line;

@end

@implementation BFNewFundTableViewCell

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
        self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*87, SCREEN_WIDTH/375*87)];
        //self.bigImageView.backgroundColor = [UIColor lightGrayColor];
        self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bigImageView.layer.cornerRadius = SCREEN_WIDTH/375*2;
        self.bigImageView.layer.masksToBounds= YES;
        [self.contentView addSubview:self.bigImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*116, SCREEN_WIDTH/375*17, SCREEN_WIDTH-SCREEN_WIDTH/375*116-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*18*2)];
        self.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*15];
        self.titleLabel.textColor = [UIColor colorWithHex:@"333333"];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        
        self.biubiLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*116, SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*20)];
        self.biubiLabel.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/375*24];//Futura-Medium
        self.biubiLabel.textColor = [UIColor colorWithHex:@"FF3F56"];
        self.biubiLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.biubiLabel];
        
        self.biubiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*175, SCREEN_WIDTH/375*84, SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*25)];
        self.biubiImageView.image = [UIImage imageNamed:@"biubilittleimage"];
        [self.contentView addSubview:self.biubiImageView];
        
        
        
        self.exchangeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*269, SCREEN_WIDTH/375*73, SCREEN_WIDTH/375*87, SCREEN_WIDTH/375*30)];
        [self.exchangeButton setBackgroundColor:[UIColor colorWithHex:RED_COLOR]];
        [self.exchangeButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
        [self.exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        self.exchangeButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.exchangeButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
        self.exchangeButton.layer.masksToBounds= YES;
        [self.contentView addSubview:self.exchangeButton];
        
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*116, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
        self.line.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
        [self.contentView addSubview:self.line];
        
    }
    return self;
}

- (void)setNewFund:(NSDictionary *)dic{
    //NSLog(@"cellDetailDic --- %@",dic);
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    
    self.titleLabel.frame = CGRectMake(SCREEN_WIDTH/375*116, SCREEN_WIDTH/375*17, SCREEN_WIDTH-SCREEN_WIDTH/375*116-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*18*2);
    self.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*15];
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.biubiLabel.text = [NSString stringWithFormat:@"%@",dic[@"biub"]];
    [self.biubiLabel sizeToFit];
    self.biubiImageView.frame = CGRectMake(CGRectGetMaxX(self.biubiLabel.frame)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*82, SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*20);
}




@end
