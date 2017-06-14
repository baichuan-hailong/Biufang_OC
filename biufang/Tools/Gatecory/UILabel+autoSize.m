//
//  UILabel+autoSize.m
//  biufang
//
//  Created by 娄耀文 on 16/12/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "UILabel+autoSize.h"

@implementation UILabel (autoSize)

- (CGSize)actualSizeOfLable:(NSString *)lableStr
                    andFont:(UIFont   *)font
                    andSize:(CGSize    )size {
    
    self.font    = font;
    self.text    = lableStr;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualSize = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return actualSize;
}

@end
