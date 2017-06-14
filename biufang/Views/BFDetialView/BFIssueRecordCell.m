//
//  BFIssueRecordCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFIssueRecordCell.h"
#import "BFIssueRecordModle.h"

@interface BFIssueRecordCell ()

@property (nonatomic , strong) UIImageView *headerImageView;
@property (nonatomic , strong) UILabel *nameLabel;
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UILabel *localCtiyLabel;
@property (nonatomic , strong) UILabel *countLabel;

@end

@implementation BFIssueRecordCell

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
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
        //self.headerImageView.backgroundColor = [UIColor colorWithHex:@"#6D6D72"];
        self.headerImageView.image = [UIImage imageNamed:@"placeHeaderImage"];
        self.headerImageView.layer.cornerRadius = SCREEN_WIDTH/375*25;
        self.headerImageView.layer.masksToBounds= YES;
        [self.contentView addSubview:self.headerImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*24)];
        self.nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        self.nameLabel.textColor = [UIColor colorWithHex:@"74B4FF"];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*(8+24), SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*12)];
        self.timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.timeLabel.textColor = [UIColor colorWithHex:@"979797"];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.timeLabel];
        
        self.localCtiyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*(8+24+12), SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*14)];
        self.localCtiyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.localCtiyLabel.textColor = [UIColor colorWithHex:@"979797"];
        self.localCtiyLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.localCtiyLabel];
        
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*100-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*(60-14)/2, SCREEN_WIDTH/375*100, SCREEN_WIDTH/375*14)];
        self.countLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.countLabel.textColor = [UIColor colorWithHex:@"FF3022"];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        //self.countLabel.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.countLabel];
        
    }
    return self;
}

- (void)setValueWithIssueRecord:(NSDictionary *)issueRecordModel{

    NSString *avatar = [NSString stringWithFormat:@"%@",issueRecordModel[@"avatar"]];
    if (avatar.length>8) {
      [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:issueRecordModel[@"avatar"]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
    }else{
        //placeHeaderImage
        self.headerImageView.image = [UIImage imageNamed:@"placeHeaderImage"];
    }
    
    
    NSString *name = [NSString stringWithFormat:@"%@",issueRecordModel[@"nickname"]];
    if (name==nil||name.length==0) {
        self.nameLabel.text = @"用户";
    }else{
        self.nameLabel.text = name;
        
    }
    
    self.timeLabel.text = [self changeTime:issueRecordModel[@"time"]];
    self.localCtiyLabel.text = [NSString stringWithFormat:@"%@ IP:%@",issueRecordModel[@"locate"],issueRecordModel[@"ip"]];
    self.countLabel.text     = [NSString stringWithFormat:@"%@次",issueRecordModel[@"quantity"]];
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
