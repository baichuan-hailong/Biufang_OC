//
//  BFShareView.h
//  biufang
//
//  Created by 杜海龙 on 16/10/8.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BFShareViewDelegate <NSObject>

- (void)shareViewDidSelectButWithBtnTag:(NSInteger)btnTag;

@end



@interface BFShareView : UIView

@property (nonatomic,weak)id<BFShareViewDelegate>delegate;

- (void)shareShow;

- (void)shareHide;

@end
