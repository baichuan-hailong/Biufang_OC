//
//  BFPayFailedView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BFPayFailedDelegate <NSObject>

- (void)canclePay:(UIButton *)sender;
- (void)continuePay:(UIButton *)sender;

@end

@interface BFPayFailedView : UIView
@property (nonatomic,weak)id<BFPayFailedDelegate>delegate;
- (void)showPayFailed;
- (void)hiddenPayFailed;
@end
