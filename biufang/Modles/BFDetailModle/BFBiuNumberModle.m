//
//  BFBiuNumberModle.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBiuNumberModle.h"

@implementation BFBiuNumberModle
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        [self setValue:value forKey:@"ID"];
    }
}
@end
