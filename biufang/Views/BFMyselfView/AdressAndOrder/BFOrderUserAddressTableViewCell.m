//
//  BFOrderUserAddressTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFOrderUserAddressTableViewCell.h"

@interface BFOrderUserAddressTableViewCell ()

@property (nonatomic,strong)UIImageView *nameImageView;

@end

@implementation BFOrderUserAddressTableViewCell

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
        
        self.coView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, SCREEN_WIDTH, SCREEN_WIDTH/375*131)];
        self.coView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.coView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*45, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
        topLine.backgroundColor = [UIColor colorWithHex:@"EBEBEB"];
        [self.coView addSubview:topLine];
        
        UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*(16+1.5), SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*14)];
        timeImageView.image = [UIImage imageNamed:@"awardPersonTime"];
        //timeImageView.backgroundColor = [UIColor redColor];
        [self.coView addSubview:timeImageView];
        
        
        //time
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame)+SCREEN_WIDTH/375*6, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*17)];
        //timeLabel.backgroundColor = [UIColor yellowColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.text = @"提交时间";
        timeLabel.textColor = [UIColor colorWithHex:@"000000"];
        timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:timeLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*200), SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*17)];
        //self.timeLabel.backgroundColor = [UIColor yellowColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
        self.timeLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:self.timeLabel];
        
        
        self.nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*(65+1), SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*15)];
        self.nameImageView.image = [UIImage imageNamed:@"awardPersonAddress"];
        //nameImageView.backgroundColor = [UIColor redColor];
        [self.coView addSubview:self.nameImageView];

        //name
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameImageView.frame)+SCREEN_WIDTH/375*6, SCREEN_WIDTH/375*65, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*17)];
        //self.nameLabel.backgroundColor = [UIColor yellowColor];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        
        self.nameLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:self.nameLabel];
        
        //tel
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*200), SCREEN_WIDTH/375*65, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*17)];
        //self.telLabel.backgroundColor = [UIColor yellowColor];
        self.telLabel.textAlignment = NSTextAlignmentRight;
        
        self.telLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.telLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:self.telLabel];
        
        //address
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameImageView.frame)+SCREEN_WIDTH/375*6, SCREEN_WIDTH/375*95, (SCREEN_WIDTH-CGRectGetMaxX(self.nameImageView.frame)-SCREEN_WIDTH/375*6-SCREEN_WIDTH/375*17), SCREEN_WIDTH/375*17*2)];
        //self.addressLabel.backgroundColor = [UIColor yellowColor];
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        
        self.addressLabel.textColor = [UIColor colorWithHex:@"979797"];
        self.addressLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.addressLabel.numberOfLines = 0;
        
        [self.coView addSubview:self.addressLabel];
        
        
    }
    return self;
}

- (void)setCell:(NSDictionary *)dic time:(NSString *)time{
    
    NSString *telStr         = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    NSLog(@"tel --- %@",telStr);
    self.telLabel.text       = telStr;
    
    if (telStr.length>8) {
        NSString *currentStr = [NSString stringWithFormat:@"%@****%@",[telStr substringToIndex:3],[telStr substringFromIndex:7]];
        NSLog(@"tel --- %@",currentStr);
        self.telLabel.text      = currentStr;
    }
    
    
    
    
    
    self.timeLabel.text     = [self timeChange:time];
    self.addressLabel.text  = [NSString stringWithFormat:@"%@",dic[@"address"]];
    self.addressLabel.frame = CGRectMake(CGRectGetMaxX(self.nameImageView.frame)+SCREEN_WIDTH/375*6, SCREEN_WIDTH/375*95, (SCREEN_WIDTH-CGRectGetMaxX(self.nameImageView.frame)-SCREEN_WIDTH/375*6-SCREEN_WIDTH/375*17), SCREEN_WIDTH/375*17*2);
    [self.addressLabel sizeToFit];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
}

#pragma mark - 时间戳转换为标准时间
- (NSString *)timeChange:(NSString *)timeStamp {
    if (timeStamp.length<6) {
        return @"--";
    }else{
        NSTimeInterval time = [timeStamp doubleValue];// + 28800;  //因为时差问题要加8小时 == 28800
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        NSString *currentDateStr = [formatter stringFromDate: date];
        return currentDateStr;
    }
}


@end
