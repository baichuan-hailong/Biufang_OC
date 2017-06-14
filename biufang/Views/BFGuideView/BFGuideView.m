//
//  BFGuideView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFGuideView.h"

@interface BFGuideView ()

@property (nonatomic , strong) UIImageView *pageOneImageView;
@property (nonatomic , strong) UIImageView *pageOneTipImageView;

@property (nonatomic , strong) UIImageView *pageOneDownImageView;
@property (nonatomic , strong) UIImageView *pageOneDownTipImageView;


@property (nonatomic , strong) UIImageView *pageTwoImageView;
@property (nonatomic , strong) UIImageView *pageTwoTipImageView;

@property (nonatomic , strong) UIImageView *pageTwoDownImageView;
@property (nonatomic , strong) UIImageView *pageTwoDownTipImageView;


@property (nonatomic , strong) UIImageView *pageThreeImageView;
@property (nonatomic , strong) UIImageView *pageThreeTipImageView;

@end

@implementation BFGuideView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self addPages];
    }
    return self;
}


//load pages
- (void)addPages{
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentSize = CGSizeMake(3*SCREEN_WIDTH, SCREEN_HEIGHT);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = NO;
    
    //page1
    UIView *onePageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    onePageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:onePageView];
    
    self.pageOneImageView.image = [UIImage imageNamed:@"pageoneimage"];
    [onePageView addSubview:self.pageOneImageView];
    
    self.pageOneTipImageView.image = [UIImage imageNamed:@"pageonetip"];
    [onePageView addSubview:self.pageOneTipImageView];
    

    //self.pageOneDownImageView.image = [UIImage imageNamed:@"pageonetipimage"];
    //self.pageOneDownImageView.contentMode = UIViewContentModeScaleAspectFit;
    //[onePageView addSubview:self.pageOneDownImageView];
    
    self.pageOneDownTipImageView.image = [UIImage imageNamed:@"pageonepoint"];
    self.pageOneDownTipImageView.contentMode = UIViewContentModeScaleAspectFit;
    [onePageView addSubview:self.pageOneDownTipImageView];
    
    
    
    
    //page2
    UIView *twoPageView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    twoPageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:twoPageView];
    
    self.pageTwoImageView.image = [UIImage imageNamed:@"pagetwoimage"];
    [twoPageView addSubview:self.pageTwoImageView];
    self.pageTwoTipImageView.image = [UIImage imageNamed:@"pagetwotip"];
    [twoPageView addSubview:self.pageTwoTipImageView];
    
    
    //self.pageTwoDownImageView.image = [UIImage imageNamed:@"pagetwotipimage"];
    //self.pageTwoDownImageView.contentMode = UIViewContentModeScaleAspectFit;
    //[twoPageView addSubview:self.pageTwoDownImageView];
    
    
    self.pageTwoDownTipImageView.image = [UIImage imageNamed:@"pagetwopoint"];
    self.pageTwoDownTipImageView.contentMode = UIViewContentModeScaleAspectFit;
    [twoPageView addSubview:self.pageTwoDownTipImageView];

    
    
    
    //page3
    UIView *threePageView = [[UIView alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    threePageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:threePageView];
    
    
    self.pageThreeImageView.image = [UIImage imageNamed:@"pagethreeimage"];
    [threePageView addSubview:self.pageThreeImageView];
    self.pageThreeTipImageView.image = [UIImage imageNamed:@"pagethreetip"];
    [threePageView addSubview:self.pageThreeTipImageView];
    
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*194)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*(45+95), SCREEN_WIDTH/375*194, SCREEN_WIDTH/375*45)];
    [self.startButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.startButton.frame.size] forState:UIControlStateNormal];
    [self.startButton setTitle:@"快去试试手气吧" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*20];
    self.startButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
    self.startButton.layer.masksToBounds= YES;
    [threePageView addSubview:self.startButton];
    
}

//1
//@property (nonatomic , strong) UIImageView *pageOneImageView;
-(UIImageView *)pageOneImageView{

    if (_pageOneImageView==nil) {
        _pageOneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/718*790)];
    }
    return _pageOneImageView;
}
//@property (nonatomic , strong) UIImageView *pageOneTipImageView;//486 132
-(UIImageView *)pageOneTipImageView{
    
    if (_pageOneTipImageView==nil) {
        _pageOneTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*243)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*(190+66-20), SCREEN_WIDTH/375*243, SCREEN_WIDTH/375*66)];
    }
    return _pageOneTipImageView;
}

//@property (nonatomic , strong) UIImageView *pageOneDownImageView;
-(UIImageView *)pageOneDownImageView{
    
    if (_pageOneDownImageView==nil) {
        _pageOneDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*62)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*60-SCREEN_WIDTH/375*42, SCREEN_WIDTH/375*62, SCREEN_WIDTH/375*60)];
    }
    return _pageOneDownImageView;
}
//@property (nonatomic , strong) UIImageView *pageOneDownTipImageView;
-(UIImageView *)pageOneDownTipImageView{
    
    if (_pageOneDownTipImageView==nil) {
        _pageOneDownTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*34)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*8-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*34, SCREEN_WIDTH/375*8)];
    }
    return _pageOneDownTipImageView;
}

//2
//@property (nonatomic , strong) UIImageView *pageTwoImageView; 514x640  257x320
-(UIImageView *)pageTwoImageView{
    
    if (_pageTwoImageView==nil) {
        _pageTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*257)/2+SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*60, SCREEN_WIDTH/375*257, SCREEN_WIDTH/375*320)];
    }
    return _pageTwoImageView;
}
//@property (nonatomic , strong) UIImageView *pageTwoTipImageView; 430 124
-(UIImageView *)pageTwoTipImageView{
    
    if (_pageTwoTipImageView==nil) {
        _pageTwoTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*215)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*(190+66-20), SCREEN_WIDTH/375*215, SCREEN_WIDTH/375*62)];
    }
    return _pageTwoTipImageView;
}

//@property (nonatomic , strong) UIImageView *pageTwoDownImageView;
-(UIImageView *)pageTwoDownImageView{
    
    if (_pageTwoDownImageView==nil) {
        _pageTwoDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*62)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*60-SCREEN_WIDTH/375*42, SCREEN_WIDTH/375*62, SCREEN_WIDTH/375*60)];
    }
    return _pageTwoDownImageView;
}
//@property (nonatomic , strong) UIImageView *pageTwoDownTipImageView;
-(UIImageView *)pageTwoDownTipImageView{
    
    if (_pageTwoDownTipImageView==nil) {
        _pageTwoDownTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*34)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*8-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*34, SCREEN_WIDTH/375*8)];
    }
    return _pageTwoDownTipImageView;
}

//3
//@property (nonatomic , strong) UIImageView *pageThreeImageView;574 458
-(UIImageView *)pageThreeImageView{
    
    if (_pageThreeImageView==nil) {
        _pageThreeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*574/2)/2, SCREEN_WIDTH/375*120, SCREEN_WIDTH/375*574/2, SCREEN_WIDTH/375*458/2)];
    }
    return _pageThreeImageView;
}
//@property (nonatomic , strong) UIImageView *pageThreeTipImageView; 528 124
-(UIImageView *)pageThreeTipImageView{
    
    if (_pageThreeTipImageView==nil) {
        _pageThreeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*528/2)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*(190+66-20), SCREEN_WIDTH/375*528/2, SCREEN_WIDTH/375*62)];
    }
    return _pageThreeTipImageView;
}

@end
