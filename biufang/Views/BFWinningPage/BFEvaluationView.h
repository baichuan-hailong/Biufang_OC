//
//  BFEvaluationView.h
//  biufang
//
//  Created by 杜海龙 on 17/1/13.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BFEvaluationDelegate <NSObject>
- (void)evaluationClick:(NSInteger)clickInt;
@end


@interface BFEvaluationView : UIView
@property (nonatomic,weak) id<BFEvaluationDelegate>delegate;
- (void)showEvaluation;
@end
