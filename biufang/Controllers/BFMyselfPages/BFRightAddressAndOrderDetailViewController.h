//
//  BFRightAddressAndOrderDetailViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBaseViewController.h"

@interface BFRightAddressAndOrderDetailViewController : BFBaseViewController
//fang_id
@property (nonatomic , strong) NSString *fang_ID;
//community name
@property (nonatomic , copy) NSString *communityNameStr;
//issue number
@property (nonatomic , copy) NSString *issueNumberStr;
//cover
@property (nonatomic , copy) NSString *cover;

@property (nonatomic, assign)BOOL isWriteAddressBool;

//payload type
@property (nonatomic , copy) NSString  *delivery_status;
@property (nonatomic , copy) NSString  *delivery_type;
@end
