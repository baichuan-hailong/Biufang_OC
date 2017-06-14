//
//  LXSegmentScrollView.h
//  LiuXSegment
//
//  Created by liuxin on 16/5/17.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiuXSegmentView.h"

@interface LXSegmentScrollView : UIView

@property (strong,nonatomic) LiuXSegmentView *segmentToolView;
@property (assign,nonatomic) NSInteger       titleCount;
@property (strong,nonatomic) UIScrollView    *bgScrollView;

-(instancetype)initWithFrame:(CGRect)frame
                  titleArray:(NSArray *)titleArray
            contentViewArray:(NSArray *)contentViewArray;

@end
