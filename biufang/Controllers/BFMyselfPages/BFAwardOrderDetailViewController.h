//
//  BFAwardOrderDetailViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBaseViewController.h"

@interface BFAwardOrderDetailViewController : BFBaseViewController
//fang_id
@property (nonatomic , strong) NSString *fang_ID;
//community name
@property (nonatomic , copy) NSString   *communityNameStr;
//issue number
@property (nonatomic , copy) NSString   *issueNumberStr;
//cover
@property (nonatomic , copy) NSString   *cover;
//type
@property (nonatomic, assign)BOOL       awardTypeBool;


//payload type
@property (nonatomic , copy) NSString  *delivery_status;
@property (nonatomic , copy) NSString  *delivery_type;


//come type
@property (nonatomic, assign)BOOL       isMyselfBiuRecord;

//isshow
@property (nonatomic, assign)BOOL       isShow;

//Fang status
@property (nonatomic , strong) NSString  *fang_Status;
//winnerID
@property (nonatomic , strong) NSString  *winner_ID;

@end
