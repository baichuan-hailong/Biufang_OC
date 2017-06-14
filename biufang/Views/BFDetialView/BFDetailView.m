//
//  BFDetailView.m
//  biufang
//
//  Created by 娄耀文 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailView.h"

@implementation BFDetailView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup {

    // SETUP...
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self addSubview:self.detailTableView];
    
    //[self addSubview:self.navBarView];
    [self addSubview:self.shareBtn];
    [self addSubview:self.backBtn];

    [self addSubview:self.footView];
    [self.footView addSubview:self.publishingImageView];
    [self.footView addSubview:self.footBtn];
    
    //加快按钮点按效果，提高touch层级
    self.detailTableView.delaysContentTouches = NO;
    for (UIView *currentView in self.detailTableView.subviews) {
        
        if([currentView isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
}

#pragma mark - getter

//tableView
- (UITableView *)detailTableView {
    
    if (_detailTableView == nil) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_HEIGHT/11.5)
                                                style:UITableViewStyleGrouped];
        _detailTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _detailTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _detailTableView.showsVerticalScrollIndicator = NO;
        _detailTableView.bounces = YES;
        _detailTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.000001)];
        //_detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
    return _detailTableView;
}

- (UIView *)navBarView {

    if (_navBarView == nil) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navBarView.backgroundColor = [UIColor whiteColor];
        _navBarView.alpha = 0;
        
        [_navBarView.layer setShadowOffset:CGSizeMake(1, 1)];
        [_navBarView.layer setShadowRadius:2];
        [_navBarView.layer setShadowOpacity:0.3];
        [_navBarView.layer setShadowColor:[UIColor blackColor].CGColor];

        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.frame = CGRectMake(0, 34, SCREEN_WIDTH, 16);
        titleLable.font = [UIFont fontWithName:@"Helvetica-bold" size:16];
        titleLable.textAlignment = NSTextAlignmentCenter;
        //titleLable.text = @"房屋详情";
        [_navBarView addSubview:titleLable];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5);
        lineView.backgroundColor = [UIColor lightGrayColor];
        //[_navBarView addSubview:lineView];
    }
    return _navBarView;
}


- (UIButton *)backBtn {

    if (_backBtn == nil) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(0, 20, 100, 44);
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(5,15,5,51);
    }
    return _backBtn;
}

- (UIButton *)shareBtn {
    
    if (_shareBtn == nil) {
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.frame = CGRectMake(SCREEN_WIDTH - 100, 20, 100, 44);
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(5,51,5,15);
    }
    return _shareBtn;
}

- (UIView *)footView {

    if (_footView == nil) {
        _footView = [[UIView alloc] init];
        _footView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT/11.5, SCREEN_WIDTH, SCREEN_HEIGHT/11.5);
        _footView.backgroundColor = [UIColor whiteColor];
        
        [_footView.layer setShadowOffset:CGSizeMake(1, 1)];
        [_footView.layer setShadowRadius:2];
        [_footView.layer setShadowOpacity:0.3];
        [_footView.layer setShadowColor:[UIColor blackColor].CGColor];
    }
    return _footView;
}

- (UIButton *)footBtn {

    if (_footBtn == nil) {
        _footBtn = [[UIButton alloc] init];
        _footBtn.frame = CGRectMake(10, (self.footView.frame.size.height - SCREEN_HEIGHT/16.675)/2,
                                    self.footView.frame.size.width - 20,
                                    SCREEN_HEIGHT/16.675);
        [_footBtn setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:_footBtn.frame.size] forState:UIControlStateNormal];
        [_footBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _footBtn.layer.masksToBounds = YES;
        _footBtn.layer.cornerRadius = 4;
        [_footBtn setTitle:@". . ." forState:UIControlStateNormal];
        [_footBtn setUserInteractionEnabled:NO];
        _footBtn.alpha = 0.38;
    }
    return _footBtn;
}


- (UIImageView *)publishingImageView {

    if (_publishingImageView == nil) {
        UIImage *img = [UIImage imageNamed:@"detailView_publishing"];
        _publishingImageView = [[UIImageView alloc] initWithImage:img];
        _publishingImageView.frame = CGRectMake((self.footView.frame.size.width - img.size.width)/2,
                                                (self.footView.frame.size.height - img.size.height)/2,
                                                 img.size.width,
                                                 img.size.height);
        _publishingImageView.alpha = 0;
    }
    return _publishingImageView;
}






@end
