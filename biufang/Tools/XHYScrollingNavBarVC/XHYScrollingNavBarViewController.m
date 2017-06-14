//
//  XHYScrollingNavBarViewController.m
//  XHYScrollingNavBarViewController
//
//  Created by 娄耀文 on 16/10/11.
//  Copyright (c) 2016年 biufang. All rights reserved.
//

#import "XHYScrollingNavBarViewController.h"
#define NavBarFrame self.navigationController.navigationBar.frame

@interface XHYScrollingNavBarViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIView *scrollView;
@property (retain, nonatomic)UIPanGestureRecognizer *panGesture;
@property (retain, nonatomic)UIView *overLay;
@property (assign, nonatomic)BOOL isHidden;

@end

@implementation XHYScrollingNavBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

//设置跟随滚动的滑动试图
-(void)followRollingScrollView:(UIView *)scrollView
{
    self.scrollView = scrollView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] init];
    self.panGesture.delegate=self;
    self.panGesture.minimumNumberOfTouches = 1;
    [self.panGesture addTarget:self action:@selector(handlePanGesture:)];
    [self.scrollView addGestureRecognizer:self.panGesture];
    
    self.overLay = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    self.overLay.alpha=0;
//  self.overLay.backgroundColor=self.navigationController.navigationBar.barTintColor;
    self.overLay.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.overLay];
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

#pragma mark - 兼容其他手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - 手势调用函数
-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:[self.scrollView superview]];

    //显示
    if (translation.y >= 5) {
        if (self.isHidden) {
            
            self.overLay.alpha=0;
            CGRect navBarFrame=NavBarFrame;
            CGRect scrollViewFrame=self.scrollView.frame;
            
            navBarFrame.origin.y = 20;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = navBarFrame;
                self.scrollView.frame=scrollViewFrame;
            }];
            self.isHidden= NO;
        }
    }
    
    //隐藏
    if (translation.y <= -20) {
        if (!self.isHidden) {
            
            CGRect frame =NavBarFrame;
            CGRect scrollViewFrame=self.scrollView.frame;
            frame.origin.y = -24;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                self.scrollView.frame=scrollViewFrame;
                self.overLay.alpha=1;
            } completion:^(BOOL finished) {
                
            }];
            self.isHidden=YES;
        }
    }
    
    
    
}

//强制显示导航
- (void)showNavigation {
    self.overLay.alpha = 0;
    
    if (_isHidden) {
        CGRect navBarFrame=NavBarFrame;
        CGRect scrollViewFrame=self.scrollView.frame;
        
        navBarFrame.origin.y = 20;

        scrollViewFrame.origin.y += 44;
        scrollViewFrame.size.height -= 44;
        
        NavBarFrame = navBarFrame;
        self.isHidden= NO;
        
        [UIView animateWithDuration:1 animations:^{
            self.scrollView.frame = scrollViewFrame;
        }];
    }
}

//隐藏overLay，显示导航
- (void)hideOverLay {
    
    if (_isHidden) {
        CGRect frame = NavBarFrame;
        CGRect scrollViewFrame = self.scrollView.frame;
        frame.origin.y = -24;

        NavBarFrame = frame;
        self.scrollView.frame=scrollViewFrame;
        self.overLay.alpha = 1;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar bringSubviewToFront:self.overLay];
}

@end
