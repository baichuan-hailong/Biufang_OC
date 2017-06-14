//
//  BFWriteAddressTableViewCell.m
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFWriteAddressTableViewCell.h"

@implementation BFWriteAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        NSString *realName      = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
        NSString *telName       = [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME];
        NSString *order_Address = [[NSUserDefaults standardUserDefaults] objectForKey:Order_Address];
        NSLog(@"收货人-%@联系电话-%@收货地址-%@",realName,telName,order_Address);
        
        
        self.coView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, SCREEN_WIDTH, SCREEN_WIDTH/375*233)];
        self.coView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.coView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*50, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
        topLine.backgroundColor = [UIColor colorWithHex:@"EBEBEB"];
        [self.coView addSubview:topLine];
        
        UIView *middleLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*99, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
        middleLine.backgroundColor = [UIColor colorWithHex:@"EBEBEB"];
        [self.coView addSubview:middleLine];
        
        //name
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*17)];
        //nameLabel.backgroundColor = [UIColor yellowColor];
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.text = @"收货人：";
        nameLabel.textColor = [UIColor colorWithHex:@"000000"];
        nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:nameLabel];
        
        self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*92, SCREEN_WIDTH/375*8, (SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*92), SCREEN_WIDTH/375*37)];
        //self.nameTextField.backgroundColor = [UIColor yellowColor];
        self.nameTextField.textAlignment = NSTextAlignmentLeft;
        self.nameTextField.placeholder = @"输入姓名";
        self.nameTextField.tag = 776;
        
        if (realName.length>0) {
            self.nameTextField.text = realName;
        }
        self.nameTextField.textColor = [UIColor colorWithHex:@"000000"];
        self.nameTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.nameTextField setValue:[UIColor lightGrayColor]forKeyPath:@"_placeholderLabel.textColor"];
        [self.coView addSubview:self.nameTextField];
        
        
        //tel
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*66, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*17)];
        //telLabel.backgroundColor = [UIColor yellowColor];
        telLabel.textAlignment = NSTextAlignmentRight;
        telLabel.text = @"联系电话：";
        telLabel.textColor = [UIColor colorWithHex:@"000000"];
        telLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:telLabel];
        
        
        self.telTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*92, SCREEN_WIDTH/375*56, (SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*92), SCREEN_WIDTH/375*37)];
        //self.telTextField.backgroundColor = [UIColor yellowColor];
        self.telTextField.textAlignment = NSTextAlignmentLeft;
        self.telTextField.placeholder = @"输入手机号";
        self.telTextField.tag = 777;
        
        if (telName.length>0) {
            self.telTextField.text = telName;
        }
        self.telTextField.textColor = [UIColor colorWithHex:@"000000"];
        self.telTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.telTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.telTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.telTextField setValue:[UIColor lightGrayColor]forKeyPath:@"_placeholderLabel.textColor"];
        [self.coView addSubview:self.telTextField];
        
        //address
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*108, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*17)];
        //addressLabel.backgroundColor = [UIColor yellowColor];
        addressLabel.textAlignment = NSTextAlignmentRight;
        addressLabel.text = @"收货地址：";
        addressLabel.textColor = [UIColor colorWithHex:@"000000"];
        addressLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:addressLabel];
        
        
        self.addressTextField = [[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*(92-4), SCREEN_WIDTH/375*(108-7), (SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*92), SCREEN_WIDTH/375*92)];
        //self.addressTextField.backgroundColor = [UIColor yellowColor];
        self.addressTextField.textAlignment = NSTextAlignmentLeft;
        self.addressTextField.textColor = [UIColor colorWithHex:@"000000"];
        self.addressTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:self.addressTextField];
        
        self.placeAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*92, SCREEN_WIDTH/375*(108-4), (SCREEN_WIDTH-SCREEN_WIDTH/375*17-SCREEN_WIDTH/375*92), SCREEN_WIDTH/375*26)];
        //self.placeAddressLabel.backgroundColor = [UIColor redColor];
        self.placeAddressLabel.textAlignment = NSTextAlignmentLeft;
        self.placeAddressLabel.text = @"城市街道、楼牌号等";
        self.placeAddressLabel .textColor = [UIColor lightGrayColor];
        self.placeAddressLabel .font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        [self.coView addSubview:self.placeAddressLabel];
        
        if (order_Address.length>0) {
            [self.placeAddressLabel removeFromSuperview];
            self.addressTextField.text  = order_Address;
        }
        
   
    }
    return self;
}


@end
