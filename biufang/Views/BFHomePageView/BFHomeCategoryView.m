//
//  BFHomeCategoryView.m
//  biufang
//
//  Created by 娄耀文 on 16/10/20.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeCategoryView.h"

@implementation BFHomeCategoryView

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
    
    [self addSubview:self.categoryTableView];
    [self addSubview:self.navBarView];
    [self.navBarView addSubview:self.titleBtn];
    [self.titleBtn   addSubview:self.titleBtnImg];
    [self.navBarView addSubview:self.titleLable];
    [self.navBarView addSubview:self.backBlackBtn];
    [self.navBarView addSubview:self.navBarWhiteView];
    
    //加快按钮点按效果，提高touch层级
    self.categoryTableView.delaysContentTouches = NO;
    for (UIView *currentView in self.categoryTableView.subviews) {
        
        if([currentView isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
}


#pragma mark - getter

//tableView
- (UITableView *)categoryTableView {
    
    if (_categoryTableView == nil) {
        _categoryTableView = [[UITableView alloc] init];
        _categoryTableView.frame = CGRectMake(0,
                                          64,
                                          SCREEN_WIDTH,
                                          SCREEN_HEIGHT - 64);
        _categoryTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _categoryTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _categoryTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _categoryTableView.showsVerticalScrollIndicator = NO;
    }
    return _categoryTableView;
}

- (UIView *)navBarView {
    
    if (_navBarView == nil) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_navBarView addSubview:line];
    }
    return _navBarView;
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




- (UIButton *)backBlackBtn {
    
    if (_backBlackBtn == nil) {
        _backBlackBtn = [[UIButton alloc] init];
        _backBlackBtn.frame = CGRectMake(0, 20, 100, 44);
        [_backBlackBtn setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
        _backBlackBtn.imageEdgeInsets = UIEdgeInsetsMake(0,10,0,72);
    }
    return _backBlackBtn;
}

- (UIButton *)titleBtn {
    
    if (_titleBtn == nil) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 40);
        _titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _titleBtn;
}

- (UIImageView *)titleBtnImg {

    if (_titleBtnImg == nil) {

        _titleBtnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chevron-1"]];
    }
    return _titleBtnImg;
}



- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake((SCREEN_WIDTH - 90)/2, 20, 90, 40);
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"即将揭晓";
    }
    return _titleLable;
}




@end
