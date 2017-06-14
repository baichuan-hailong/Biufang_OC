//
//  BFFlashAdView.m
//  biufang
//
//  Created by 娄耀文 on 16/11/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFFlashAdView.h"
#import "DrawCircleProgressButton.h"

@implementation BFFlashAdView

+ (BFFlashAdView *)sharedManager {
    
    static BFFlashAdView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        sharedAccountManagerInstance.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    });
    return sharedAccountManagerInstance;
}


- (void)showFlashAdView:(NSDictionary *)adInfo andImage:(UIImage *)img{
    
    _adInfo = adInfo;
    self.alpha = 1;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [self addSubview:self.backImageView];
    [self.backImageView addSubview:self.adImageView];
    [self.adImageView   addSubview:self.drawCircleView];
    self.adImageView.image = img;
}


- (void)hideFlashAdView {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIView animateWithDuration:0.68 animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1.6, 1.6);
    } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkUpdateWinner" object:nil];
        [self removeFromSuperview];
    }];
    
}


#pragma mark - getter
- (UIImageView *)adImageView {

    if (_adImageView == nil) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 1.4);
        
        /*  图片自动裁剪宽高来适应imageVIew的Frame  */
        _adImageView.contentMode   = UIViewContentModeScaleAspectFill;
        _adImageView.clipsToBounds = YES;
        _adImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [_adImageView addGestureRecognizer:tapGes];
    }
    return _adImageView;
}

- (UIImageView *)backImageView {
    
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _backImageView.image = [self getLaunchImage];
        
        /*  图片自动裁剪宽高来适应imageVIew的Frame  */
        _backImageView.contentMode   = UIViewContentModeScaleAspectFill;
        _backImageView.clipsToBounds = YES;
        _backImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [_backImageView addGestureRecognizer:tapGes];
    }
    return _backImageView;
}

- (DrawCircleProgressButton *)drawCircleView {

    if (_drawCircleView == nil) {
        
        _drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 55, 35, SCREEN_WIDTH/11.72, SCREEN_WIDTH/11.72)];
        _drawCircleView.lineWidth = 2;
        [_drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
        [_drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _drawCircleView.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        
        [_drawCircleView addTarget:self action:@selector(hideFlashAdView) forControlEvents:UIControlEventTouchUpInside];
        
        /**
         *  progress 完成时候的回调
         */
        __weak BFFlashAdView *weakSelf = self;
        [_drawCircleView startAnimationDuration:3 withBlock:^{
            [weakSelf hideFlashAdView];
        }];
    }
    return _drawCircleView;
}







#pragma mark - customMethod
- (void)imageTap:(UITapGestureRecognizer *)sender {
    
    [UIView animateWithDuration:0.06 animations:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } completion:^(BOOL finished) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"flashAdAction" object:nil userInfo:_adInfo];
        self.alpha = 0;
        
    }];
    
    //统计闪屏广告点击次数
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"ADFlashClick"];
}


//获取启动页
- (UIImage *)getLaunchImage {

    CGSize    viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray  *imagesDic = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in imagesDic) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && ([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])) {
            
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImage];
}


@end
