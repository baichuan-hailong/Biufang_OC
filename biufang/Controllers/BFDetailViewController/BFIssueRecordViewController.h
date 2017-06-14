//
//  BFIssueRecordViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPresentBaseViewController.h"

@interface BFIssueRecordViewController : BFPresentBaseViewController

//fang_id
@property (nonatomic , strong) NSString *fang_ID;

//community name
@property (nonatomic , copy) NSString *communityNameStr;

//issue number
@property (nonatomic , copy) NSString *issueNumberStr;
@end
