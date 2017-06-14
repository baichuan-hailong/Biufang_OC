//
//  BFWinningView.h
//  biufang
//
//  Created by 杜海龙 on 16/11/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFWinningDelegate <NSObject>
- (void)lookDetail:(UIButton *)sender;
@end



@interface BFWinningView : UIView
@property (nonatomic,weak) id<BFWinningDelegate>delegate;
- (void)showWinPop;
@end
