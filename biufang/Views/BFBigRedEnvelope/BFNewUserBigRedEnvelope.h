//
//  BFNewUserBigRedEnvelope.h
//  biufang
//
//  Created by 杜海龙 on 17/2/20.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

//BFNewUserBigRedEnvelope *newUserBigRedEnvelope = [[BFNewUserBigRedEnvelope alloc] initWithFrame:SCREEN_BOUNDS];
//[newUserBigRedEnvelope showPopupView];

@protocol BFNewUserBigRedEnvelopeDelegate <NSObject>
- (void)newUeserBigRedEnvelopeHaveClickedReceiveBtn:(UIButton *)sender;
@end

@interface BFNewUserBigRedEnvelope : UIView
@property (nonatomic,weak) id<BFNewUserBigRedEnvelopeDelegate>delegate;
- (void)showPopupView;
@end
