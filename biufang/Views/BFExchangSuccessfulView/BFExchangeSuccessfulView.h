//
//  BFExchangeSuccessfulView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/27.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFExchangeSuccessfulDelegate <NSObject>

- (void)exchangeSuccessful:(UIButton *)sender;

@end

@interface BFExchangeSuccessfulView : UIView

@property (nonatomic,weak)id<BFExchangeSuccessfulDelegate>delegate;
- (void)showSuccessful;

@end
