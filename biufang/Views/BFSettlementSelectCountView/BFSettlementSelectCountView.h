//
//  BFSettlementSelectCountView.h
//  biufang
//
//  Created by 杜海龙 on 17/2/17.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFSettlementSelectCountDelegate <NSObject>
- (void)settlementHaveSelectOrderCount:(NSString *)orderText totalPrice:(NSInteger)totalPriceCount onWech:(NSString *)onLine redArray:(NSArray *)redmoneyArray title:(NSString *)fangTitle sn:(NSString *)fang_sn url:(NSString *)fang_url;
@end

@interface BFSettlementSelectCountView : UIView

@property (nonatomic,weak)id<BFSettlementSelectCountDelegate>delegate;

@property (nonatomic , copy) NSString *fang_id;

//settlement
- (void)settlementShow;
@end
