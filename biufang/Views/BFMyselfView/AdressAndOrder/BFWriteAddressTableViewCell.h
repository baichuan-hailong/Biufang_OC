//
//  BFWriteAddressTableViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFWriteAddressTableViewCell : UITableViewCell
@property(nonatomic,strong)UIView *coView;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *telTextField;
@property(nonatomic,strong)UITextView *addressTextField;
@property(nonatomic,strong)UILabel *placeAddressLabel;
@end
