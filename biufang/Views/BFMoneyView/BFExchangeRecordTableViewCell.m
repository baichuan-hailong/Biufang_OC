//
//  BFExchangeRecordTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/27.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFExchangeRecordTableViewCell.h"

@interface BFExchangeRecordTableViewCell ()
@property (nonatomic , strong) UIImageView *bigImageView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *biubiLabel;
@property (nonatomic , strong) UIImageView *biubiImageView;
@property (nonatomic , strong) UILabel *orderLabel;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UIView *line;

@end

@implementation BFExchangeRecordTableViewCell

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
        self.bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*105, SCREEN_WIDTH/375*105)];
        //self.bigImageView.backgroundColor = [UIColor lightGrayColor];
        self.bigImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bigImageView.layer.cornerRadius = SCREEN_WIDTH/375*2;
        self.bigImageView.layer.masksToBounds= YES;
        [self.contentView addSubview:self.bigImageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*11, SCREEN_WIDTH-SCREEN_WIDTH/375*124-SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*18*2)];
        self.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*15];
        self.titleLabel.textColor = [UIColor colorWithHex:@"333333"];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 2;
        //self.titleLabel.backgroundColor = [UIColor redColor];
        //self.titleLabel.text = @"超大号毛绒抱枕";
        [self.contentView addSubview:self.titleLabel];

        self.biubiLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*44, SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*31)];
        self.biubiLabel.font = [UIFont fontWithName:@"Futura-Medium" size:SCREEN_WIDTH/375*24];
        self.biubiLabel.textColor = [UIColor colorWithHex:@"FF3F56"];
        self.biubiLabel.textAlignment = NSTextAlignmentLeft;
        //self.biubiLabel.backgroundColor = [UIColor lightGrayColor];
        //self.biubiLabel.text = @"999999";
        [self.contentView addSubview:self.biubiLabel];
        
        self.biubiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*186, SCREEN_WIDTH/375*53, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*16)];
        //self.biubiImageView.backgroundColor = [UIColor lightGrayColor];
        self.biubiImageView.image = [UIImage imageNamed:@"biubilittleimage"];
        [self.contentView addSubview:self.biubiImageView];
        

        self.orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*80, SCREEN_WIDTH-SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*17)];
        self.orderLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.orderLabel.textColor = [UIColor colorWithHex:@"999999"];
        self.orderLabel.textAlignment = NSTextAlignmentLeft;
        //self.orderLabel.text = @"订单编号：211203234";
        [self.contentView addSubview:self.orderLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*101, SCREEN_WIDTH-SCREEN_WIDTH/375*124, SCREEN_WIDTH/375*13)];
        self.timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.timeLabel.textColor = [UIColor colorWithHex:@"999999"];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        //self.timeLabel.text = @"兑换时间：2015-05-03 13:33:24";
        [self.contentView addSubview:self.timeLabel];
        
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*124, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
        self.line.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)setValueWithIssueRecord:(NSDictionary *)dic{

    //[self.bigImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]]];
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]] placeholderImage:[UIImage imageNamed:@"现金券-礼品"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"title"]];//[@"超大号毛绒抱枕";
    [self.titleLabel sizeToFit];
    self.biubiLabel.text = [NSString stringWithFormat:@"%@",dic[@"price"]];//@"999999";
    [self.biubiLabel sizeToFit];
    self.biubiImageView.frame = CGRectMake(CGRectGetMaxX(self.biubiLabel.frame)+SCREEN_WIDTH/375*2, SCREEN_WIDTH/375*51, SCREEN_WIDTH/375*19, SCREEN_WIDTH/375*19);

    self.orderLabel.text = [NSString stringWithFormat:@"订单编号：%@",dic[@"sn"]];//@"订单编号：211203234";
    NSString *timeS = [self changeTime:dic[@"time"]];
    self.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@",timeS];//@"兑换时间：2015-05-03 13:33:24";
}


- (NSString *)changeTime:(NSString *)timeStr {
    
    NSTimeInterval timeInt = [timeStr doubleValue];// + 28800;//因为时差 == 28800
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInt];
    NSString *currentDateStr = [formatter stringFromDate: date];
    return currentDateStr;
}

@end
