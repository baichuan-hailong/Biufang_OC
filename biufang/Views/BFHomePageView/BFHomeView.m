//
//  BFHomeView.m
//  biufang
//
//  Created by 娄耀文 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeView.h"
#import "homeBannerViewCell.h"
#import "homeTopBtnViewCell.h"
#import "homeOperationViewCell.h"
#import "homeMenuBtnCell.h"
#import "homeGoodsViewCell.h"
#import "menuBtnHeadView.h"

@implementation BFHomeView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {

    //SETUP...
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    [self addSubview:self.homeCollectionView];
    //[self addSubview:self.homeTableView];
    [self addSubview:self.navBarView];
    [self.navBarView addSubview:self.titleLable];
    //[self.navBarView addSubview:self.leftBtn]; ---暂时隐藏
    //[self.navBarView addSubview:self.rightImage]; ---暂时隐藏
    [self.navBarView addSubview:self.navBarWhiteView];
    
    //加快按钮点按效果，提高touch层级
//    self.homeCollectionView.delaysContentTouches = NO;
//    for (UIView *currentView in self.homeCollectionView.subviews) {
//        
//        if([currentView isKindOfClass:[UIScrollView class]]) {
//            
//            ((UIScrollView *)currentView).delaysContentTouches = NO;
//            break;
//        }
//    }
    
}


#pragma mark - getter
- (UICollectionView *)homeCollectionView {
    
    if (_homeCollectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing      = 0.0f; //上下
        layout.minimumInteritemSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _homeCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
        _homeCollectionView.backgroundColor = [UIColor whiteColor];
        _homeCollectionView.alwaysBounceVertical = YES;
        
        //*** 注册自定义Cell ***//
        [_homeCollectionView registerClass:[homeBannerViewCell    class]   forCellWithReuseIdentifier:@"homeBannerViewCell"];
        [_homeCollectionView registerClass:[homeTopBtnViewCell    class]   forCellWithReuseIdentifier:@"homeTopBtnViewCell"];
        [_homeCollectionView registerClass:[homeOperationViewCell class]   forCellWithReuseIdentifier:@"homeOperationViewCell"];
        [_homeCollectionView registerClass:[homeMenuBtnCell       class]   forCellWithReuseIdentifier:@"homeMenuBtnCell"];
        [_homeCollectionView registerClass:[homeGoodsViewCell     class]   forCellWithReuseIdentifier:@"homeGoodsViewCell"];
        
        [_homeCollectionView registerClass:[menuBtnHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"menuBtnHeadView"];
        
    }
    return _homeCollectionView;
}

//tableView
- (UITableView *)homeTableView {

    if (_homeTableView == nil) {
        _homeTableView = [[UITableView alloc] init];
        _homeTableView.frame = CGRectMake(0,
                                          64,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - 64 - 49);
        _homeTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _homeTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _homeTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _homeTableView.showsVerticalScrollIndicator = NO;
    }
    return _homeTableView;
}


- (UIView *)navBarView {

    if (_navBarView == nil) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        [_navBarView addSubview:line];
    }
    return _navBarView;
}

- (UILabel *)titleLable {
 
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 43);
        //_titleLable.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"Biu房";
    }
    return _titleLable;
}

- (UIView *)navBarWhiteView {
    
    if (_navBarWhiteView == nil) {
        _navBarWhiteView = [[UIView alloc] init];
        _navBarWhiteView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 43);
        _navBarWhiteView.backgroundColor = [UIColor whiteColor];
        _navBarWhiteView.alpha = 0;
    }
    return _navBarWhiteView;
}




- (UIButton *)leftBtn {

    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        [_leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _leftBtn;
}

- (UIImageView *)rightImage {

    if (_rightImage == nil) {
        
        _rightImage = [[UIImageView alloc] init];
        _rightImage.image = [UIImage imageNamed:@"Chevron"];
    }
    _rightImage.frame = CGRectMake(self.leftBtn.frame.size.width - 5, (self.navBarView.frame.size.height - 4)/2 + 8, 9, 4);
    return _rightImage;
}




@end
