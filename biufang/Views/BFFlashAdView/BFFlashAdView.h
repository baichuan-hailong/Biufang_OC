//
//  BFFlashAdView.h
//  biufang
//
//  Created by 娄耀文 on 16/11/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawCircleProgressButton.h"

@interface BFFlashAdView : UIView

+ (BFFlashAdView *)sharedManager;
- (void)showFlashAdView:(NSDictionary *)adInfo andImage:(UIImage *)img;
- (void)hideFlashAdView;

@property (nonatomic, strong) NSDictionary *adInfo;
@property (nonatomic, strong) UIImageView  *backImageView;
@property (nonatomic, strong) UIImageView  *adImageView;
@property (nonatomic, strong) DrawCircleProgressButton *drawCircleView;

@end
