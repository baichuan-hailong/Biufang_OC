//
//  BFHomeModel.m
//  biufang
//
//  Created by 娄耀文 on 16/10/19.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeModel.h"

@implementation BFHomeModel

- (id)initWithDictionary:(NSDictionary *)dic{
    
    if (self = [super init]) {
        //self.name = dic[@"name"];
    }
    return self;
}

- (id)initWithKvcDictionary:(NSDictionary *)KvcDic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:KvcDic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    //NSLog(@"UnKnownKey: %@",key);
    if([key isEqualToString:@"id"]){

        [self setValue:value forKey:@"biu_id"];
    }
}

@end
