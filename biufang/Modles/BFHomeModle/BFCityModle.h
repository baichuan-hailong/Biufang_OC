//
//  BFCityModle.h
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFCityModle : NSObject

@property (nonatomic, copy) NSString *name;

- (id)initWithDictionary:   (NSDictionary *)dic;
- (id)initWithKvcDictionary:(NSDictionary *)KvcDic;

@end
