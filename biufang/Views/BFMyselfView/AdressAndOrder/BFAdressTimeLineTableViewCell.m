//
//  BFAdressTimeLineTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFAdressTimeLineTableViewCell.h"

@implementation BFAdressTimeLineTableViewCell

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
        self.coView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, SCREEN_WIDTH, SCREEN_WIDTH/375*65)];
        self.coView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.coView];
        
        //title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*11, SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*30)];
        //self.titleLabel.backgroundColor = [UIColor yellowColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        self.titleLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.titleLabel.numberOfLines = 0;
        [self.coView addSubview:self.titleLabel];
        
        //time
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*45, SCREEN_WIDTH-SCREEN_WIDTH/375*50-SCREEN_WIDTH/375*29, SCREEN_WIDTH/375*12)];
        //self.timeLabel.backgroundColor = [UIColor yellowColor];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        
        self.timeLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.timeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*10];
        [self.coView addSubview:self.timeLabel];
        
        //line
        self.Line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*0, SCREEN_WIDTH-SCREEN_WIDTH/375*38-SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*1)];
        self.Line.backgroundColor = [UIColor colorWithHex:@"EBEBEB"];
        [self.coView addSubview:self.Line];
        
        //leftline
        UIView *leftline = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*65)];
        leftline.backgroundColor = [UIColor colorWithHex:@"E0E0E0"];
        [self.coView addSubview:leftline];
        
        self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(22-4+0.5), SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*8)];
        self.tipImageView.image = [UIImage imageNamed:@"Oval 3 Copy 2-1"];
        [self.coView addSubview:self.tipImageView];
        
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*5, SCREEN_WIDTH/375*11)];
        self.maskView.backgroundColor = [UIColor whiteColor];
        self.maskView.alpha = 0;
        [self.coView addSubview:self.maskView];
        
        
    }
    return self;
}

- (void)setCellInfo:(NSDictionary *)dic{

    self.titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"s"]];
    NSString *timeStamp  = [NSString stringWithFormat:@"%@",dic[@"t"]];
    self.timeLabel.text  = [self timeChange:timeStamp];
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
