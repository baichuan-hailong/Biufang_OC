//
//  JLScrollView.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define JLKeyWindow [UIApplication sharedApplication].keyWindow

#define bigScrollVIewTag 101

#import "JLPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface JLPhotoBrowser()<UIScrollViewDelegate>
/**
 *  底层滑动的scrollview
 */
@property (nonatomic,weak) UIScrollView *bigScrollView;
/**
 *  黑色背景view
 */
@property (nonatomic,weak) UIView *blackView;
/**
 *  原始frame数组
 */
@property (nonatomic,strong) NSMutableArray *originRects;
@end

@implementation JLPhotoBrowser

-(NSMutableArray *)originRects{
    
    if (_originRects==nil) {
        
        _originRects = [NSMutableArray array];
        
    }
    
    return _originRects;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //0.创建黑色背景view
        [self setupBlackView];
        
        //1.创建bigScrollView
        [self setupBigScrollView];
        
    }
    return self;
}

#pragma mark 创建黑色背景

-(void)setupBlackView{
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackView];
    self.blackView = blackView;
    
}

#pragma mark 创建背景bigScrollView

-(void)setupBigScrollView{
    
    UIScrollView *bigScrollView = [[UIScrollView alloc] init];
    bigScrollView.backgroundColor = [UIColor clearColor];
    bigScrollView.delegate = self;
    bigScrollView.tag = bigScrollVIewTag;
    bigScrollView.pagingEnabled = YES;
    bigScrollView.bounces = YES;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    bigScrollView.showsVerticalScrollIndicator = NO;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight;
    bigScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self addSubview:bigScrollView];
    self.bigScrollView = bigScrollView;
    
}

-(void)show{
    
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //1.添加photoBrowser
    [JLKeyWindow addSubview:self];
    
    //2.获取原始frame
    [self setupOriginRects];
    
    //3.设置滚动距离
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth*self.photos.count, 0);
    self.bigScrollView.contentOffset = CGPointMake(ScreenWidth*self.currentIndex, 0);
    
    //4.创建子视图
    [self setupSmallScrollViews];
    
}

#pragma mark 创建子视图

-(void)setupSmallScrollViews{
    
    for (int i=0; i<self.photos.count; i++) {
        
        UIScrollView *smallScrollView = [[UIScrollView alloc] init];
        smallScrollView.backgroundColor = [UIColor clearColor];
        smallScrollView.tag = i;
        smallScrollView.frame = CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight);
        smallScrollView.delegate = self;
        smallScrollView.maximumZoomScale=3.0;
        smallScrollView.minimumZoomScale=1;
        smallScrollView.showsVerticalScrollIndicator = NO;
        smallScrollView.showsHorizontalScrollIndicator = NO;
        [self.bigScrollView addSubview:smallScrollView];
        
        JLPhoto *photo = self.photos[i];
        UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
        UITapGestureRecognizer *zonmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zonmTap:)];
        zonmTap.numberOfTapsRequired = 2;
        
        //[photo addGestureRecognizer:photoTap];
        
        [photo addGestureRecognizer:zonmTap];
        [photoTap requireGestureRecognizerToFail:zonmTap];
        
        [smallScrollView addSubview:photo];
        [smallScrollView addGestureRecognizer:photoTap];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:smallScrollView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        
        NSURL *bigImgUrl = [NSURL URLWithString:photo.bigImgUrl];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:photo.bigImgUrl done:^(UIImage *image, SDImageCacheType cacheType) {
            
            if (image==nil) {
                hud.hidden = NO;
            }
            
        }];
        [photo sd_setImageWithURL:bigImgUrl placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            hud.hidden = YES;
            
            if (image!=nil) {
                
                photo.frame = [self.originRects[i] CGRectValue];
                
                if (cacheType==SDImageCacheTypeNone) {
                    
                    photo.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/2);
                    photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                    
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.blackView.alpha = 1.0;
                    
                    CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
                    
                    CGFloat bigW = ScreenWidth;
                    CGFloat bigH = ScreenWidth*ratio;
                    
                    photo.bounds = CGRectMake(0, 0, bigW, bigH);
                    photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                    
                    
                }];
                
                
                
            }else{
                
                UITapGestureRecognizer *loopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopTap)];
                [hud addGestureRecognizer:loopTap];
                
            }
            
        }];
        
    }
    
}

-(void)zonmTap:(UITapGestureRecognizer *)zonmTap{
    
    [UIView animateWithDuration:0.38 animations:^{
        
        UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
        
        if (smallScrollView.zoomScale > 1.0) {
            smallScrollView.zoomScale = 1.0;
        } else {
            smallScrollView.zoomScale = 3.0;
        }
        
    }];
    
}

-(void)photoTap:(UITapGestureRecognizer *)photoTap{
    
//    JLPhoto *photo = (JLPhoto *)photoTap.view;
//    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
//    smallScrollView.zoomScale = 1.0;
//    
//    CGRect frame = [self.originRects[photo.tag] CGRectValue];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        photo.frame = frame;
//        self.blackView.alpha = 0;
//        
//    }completion:^(BOOL finished) {
//        
//        [self removeFromSuperview];
//        
//    }];
    
    
    JLPhoto *photo = (JLPhoto *)[photoTap.view.subviews objectAtIndex:0];
    UIScrollView *smallScrollView = (UIScrollView *)photoTap.view;
    smallScrollView.zoomScale = 1.0;

    CGRect frame = [self.originRects[photo.tag] CGRectValue];

    [UIView animateWithDuration:0.3 animations:^{

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        photo.frame = frame;
        self.blackView.alpha = 0;

    }completion:^(BOOL finished) {

        [self removeFromSuperview];
        
    }];
    
    

//    UIScrollView *smallScrollView = (UIScrollView *)photoTap.view;
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        self.blackView.alpha = 0;
//        smallScrollView.alpha = 0;
//        
//    }completion:^(BOOL finished) {
//        smallScrollView.zoomScale = 1.0;
//        [self removeFromSuperview];
//        
//    }];
    
}

-(void)loopTap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark 获取原始frame

-(void)setupOriginRects{
    
    for (JLPhoto *photo in self.photos) {
        
        UIImageView *sourceImageView = photo.sourceImageView;
        CGRect sourceF = [JLKeyWindow convertRect:sourceImageView.frame fromView:sourceImageView.superview];
        [self.originRects addObject:[NSValue valueWithCGRect:sourceF]];
        
    }
    
}

#pragma mark UIScrollViewDelegate

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    if (scrollView.tag==bigScrollVIewTag) {
        return nil;
    }
    
    JLPhoto *photo = self.photos[scrollView.tag];
    
    return photo;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView.tag==bigScrollVIewTag) {
        return;
    }
    
    JLPhoto *photo = (JLPhoto *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight-photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int currentIndex = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.currentIndex!=currentIndex && scrollView.tag==bigScrollVIewTag) {
        
        self.currentIndex = currentIndex;
        
        for (UIView *view in scrollView.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.zoomScale = 1.0;
            }
            
        }
        
    }
    
    
    
}

#pragma mark 设置frame

-(void)setFrame:(CGRect)frame{
    
    frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [super setFrame:frame];
    
}


@end
