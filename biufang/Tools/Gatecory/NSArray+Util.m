//
//  NSArray+Util.m
//  studyProject
//
//  Created by 娄耀文 on 16/10/9.
//  Copyright © 2016年 娄耀文. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (id)objectAt: (NSInteger)index {

    if (index < self.count) {
        
        return self[index];
    } else {
    
        return nil;
    }
}

@end
