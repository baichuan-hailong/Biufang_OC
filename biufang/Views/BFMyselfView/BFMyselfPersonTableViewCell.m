//
//  BFMyselfPersonTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/11/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfPersonTableViewCell.h"

@implementation BFMyselfPersonTableViewCell

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
        
        //person
        //self.headerImageViwe.backgroundColor = [UIColor lightGrayColor];
        self.headerImageViwe.layer.cornerRadius = SCREEN_WIDTH/375*50/2;
        self.headerImageViwe.layer.masksToBounds= YES;
        self.headerImageViwe.image = [UIImage imageNamed:@"placeHeaderImage"];
        [self.contentView addSubview:self.headerImageViwe];
        
        
        self.nameLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
        self.nameLabel.text = @"Biu用户";
        [self.contentView addSubview:self.nameLabel];
        
        self.lookPersonInfoLabel.textColor = [UIColor colorWithHex:@"B8B8B8"];
        self.lookPersonInfoLabel.textAlignment = NSTextAlignmentLeft;
        self.lookPersonInfoLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
        self.lookPersonInfoLabel.text = @"查看并编辑个人资料";
        [self.contentView addSubview:self.lookPersonInfoLabel];
        
        //1
        self.arrowImageView.image = [UIImage imageNamed:@"gonext"];
        [self.contentView addSubview:self.arrowImageView];
        
    }
    return self;
}

//@{@"nick":@"请登录",@"headerImage":@"",@"ishid":@"1"};
- (void)setPersonCell{

    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
        
        if (nickName.length==0) {
            nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
        }
        self.nameLabel.text = [NSString stringWithFormat:@"%@",nickName];
        
        NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
        if (avatar.length!=0) {
            [self.headerImageViwe sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
        }else{
            self.headerImageViwe.image = [UIImage imageNamed:@"placeHeaderImage"];
        }
        
    }else{
        self.nameLabel.text = @"请登录";
        self.headerImageViwe.image = [UIImage imageNamed:@"placeHeaderImage"];
    }
    
    
    
}

//person
- (UIImageView *)headerImageViwe{
    
    if (_headerImageViwe==nil) {
        _headerImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(21, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
    }
    return _headerImageViwe;
}

-(UILabel *)nameLabel{
    
    if (_nameLabel==nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(21+SCREEN_WIDTH/375*50+14, SCREEN_WIDTH/375*15, 200, SCREEN_WIDTH/375*19)];
        
    }
    return _nameLabel;
}

-(UILabel *)lookPersonInfoLabel{
    
    if (_lookPersonInfoLabel==nil) {
        _lookPersonInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(21+SCREEN_WIDTH/375*50+14, SCREEN_WIDTH/375*39, 200, SCREEN_WIDTH/375*14)];
    }
    return _lookPersonInfoLabel;
}

-(UIImageView *)arrowImageView{
    
    if (_arrowImageView==nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*28, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _arrowImageView;
}

@end
