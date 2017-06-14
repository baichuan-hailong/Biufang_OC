//
//  UILabel+autoSize.h
//  biufang
//
//  Created by 娄耀文 on 16/12/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (autoSize)

/*
 UILable高度动态改变方法
 
 @param:
 
 @lableStr 文本内容
 @font     字体
 @size     最大尺寸
 
 */
- (CGSize)actualSizeOfLable:(NSString *)lableStr
                    andFont:(UIFont   *)font
                    andSize:(CGSize    )size;

@end
