//
//  BFIssueRecordModle.h
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFIssueRecordModle : NSObject
// issueID
@property(nonatomic,copy)NSString *issue_id;
// image url
@property(nonatomic,copy)NSString *headerImageUrl;
// name
@property(nonatomic,copy)NSString *userNameStr;
// time
@property(nonatomic,copy)NSString *timeStr;
// local
@property(nonatomic,copy)NSString *local_city;
// count
@property(nonatomic,copy)NSString *countStr;

@end
