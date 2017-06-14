//
//  BFHomeModel.h
//  biufang
//
//  Created by 娄耀文 on 16/10/19.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFHomeModel : NSObject

@property (nonatomic, copy) NSString *biu_id;
@property (nonatomic, copy) NSString *biu_price;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *quota;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sn;
@property (nonatomic, copy) NSString *lucky_time;
@property (nonatomic, copy) NSDictionary *winner;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *lucky_num;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *next_period;

@property (nonatomic, copy) NSString *delivery_type;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *winner_id;
@property (nonatomic, copy) NSString *award_state;
@property (nonatomic, copy) NSString *delivery_status;



- (id)initWithDictionary:   (NSDictionary *)dic;
- (id)initWithKvcDictionary:(NSDictionary *)KvcDic;


@end
