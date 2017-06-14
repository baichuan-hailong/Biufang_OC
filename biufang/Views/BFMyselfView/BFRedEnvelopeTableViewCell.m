//
//  BFRedEnvelopeTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/10/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFRedEnvelopeTableViewCell.h"
#import "BFRedEnavleModle.h"

@interface BFRedEnvelopeTableViewCell ()
@property (nonatomic , strong) UIImageView *bodyImageView;
@property (nonatomic , strong) UILabel *tipLabel;
@property (nonatomic , strong) UILabel *tipchileLabel;
@property (nonatomic , strong) UILabel *tipMonLabel;
@property (nonatomic , strong) UILabel *moneyLabel;
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) UILabel *rightLabel;
@end
@implementation BFRedEnvelopeTableViewCell

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
        
        self.bodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*301)/2, SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*301, SCREEN_WIDTH/375*108)];
        self.bodyImageView.image = [UIImage imageNamed:@"couponsBackImage"];
        [self.contentView addSubview:self.bodyImageView];
        
        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*17, SCREEN_WIDTH/375*25, (SCREEN_WIDTH/375*301-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*120), SCREEN_WIDTH/375*22)];
        self.tipLabel.textColor       = [UIColor colorWithHex:@"666666"];
        self.tipLabel.textAlignment   = NSTextAlignmentLeft;
        self.tipLabel.font            = [UIFont systemFontOfSize:SCREEN_WIDTH/375*22];
        //self.tipLabel.backgroundColor = [UIColor redColor];
        [self.bodyImageView addSubview:self.tipLabel];
        
        self.tipchileLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*9, SCREEN_WIDTH/375*48, SCREEN_WIDTH/375*150, SCREEN_WIDTH/375*22)];
        self.tipchileLabel.textColor     = [UIColor colorWithHex:@"666666"];
        self.tipchileLabel.textAlignment = NSTextAlignmentLeft;
        self.tipchileLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
        //self.tipchileLabel.backgroundColor= [UIColor orangeColor];
        [self.bodyImageView addSubview:self.tipchileLabel];
        
        
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*(108-9-14), SCREEN_WIDTH/375*150, SCREEN_WIDTH/375*14)];
        self.leftLabel.textColor        = [UIColor colorWithHex:@"999999"];
        self.leftLabel.textAlignment    = NSTextAlignmentLeft;
        self.leftLabel.font             = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        //self.leftLabel.backgroundColor  = [UIColor yellowColor];
        [self.bodyImageView addSubview:self.leftLabel];
        
    
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(301-18-150), SCREEN_WIDTH/375*(108-9-14), SCREEN_WIDTH/375*150, SCREEN_WIDTH/375*14)];
        self.rightLabel.textColor     = [UIColor colorWithHex:@"999999"];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        [self.bodyImageView addSubview:self.rightLabel];
        
        
        self.tipMonLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(301-70-30-20), SCREEN_WIDTH/375*35, SCREEN_WIDTH/375*30, SCREEN_WIDTH/375*17)];
        self.tipMonLabel.textColor     = [UIColor colorWithHex:@"FB344C"];
        self.tipMonLabel.textAlignment = NSTextAlignmentRight;
        self.tipMonLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.tipMonLabel.text          = @"￥";
        //self.tipMonLabel.backgroundColor = [UIColor yellowColor];
        [self.bodyImageView addSubview:self.tipMonLabel];
        
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(301-16-54-20), SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*(100), SCREEN_WIDTH/375*40)];
        self.moneyLabel.textColor     = [UIColor colorWithHex:@"FB344C"];
        self.moneyLabel.textAlignment = NSTextAlignmentLeft;
        self.moneyLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*40];
        //self.moneyLabel.backgroundColor = [UIColor yellowColor];
        [self.bodyImageView addSubview:self.moneyLabel];
    }
    return self;
}

- (void)setValueWithRedEnavle:(NSDictionary *)redEnavleModelDic{
    
    //NSLog(@"%@",metaDid);
    NSDictionary *metaDid  = redEnavleModelDic[@"profile"][@"meta"];
    self.tipLabel.text = [NSString stringWithFormat:@"%@",metaDid[@"title"]];
    self.tipchileLabel.text = [NSString stringWithFormat:@"【%@】",metaDid[@"hint"]];
    
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",redEnavleModelDic[@"value"]];
    [self.moneyLabel sizeToFit];
    self.moneyLabel.frame = CGRectMake(SCREEN_WIDTH/375*(301-16)-self.moneyLabel.frame.size.width, SCREEN_WIDTH/375*20, self.moneyLabel.frame.size.width, SCREEN_WIDTH/375*40);
    //self.moneyLabel.textAlignment = NSTextAlignmentRight;
    
    
    self.tipMonLabel.frame = CGRectMake(CGRectGetMinX(self.moneyLabel.frame)-SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*35, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*17);
    
    self.leftLabel.text = [NSString stringWithFormat:@"满%@元-%@元",redEnavleModelDic[@"condition"],redEnavleModelDic[@"value"]];
    self.rightLabel.text = [NSString stringWithFormat:@"%@到期",[self timeChange:redEnavleModelDic[@"profile"][@"expire"]]];

    
}

#pragma mark - 时间戳转换为标准时间
- (NSString *)timeChange:(NSString *)timeStamp {
    NSTimeInterval time = [timeStamp doubleValue];// + 28800;  //因为时差问题要加8小时 == 28800
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *currentDateStr = [formatter stringFromDate: date];
    return currentDateStr;
}




@end