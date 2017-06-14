//
//  BFAwardOrderDetailView.m
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFAwardOrderDetailView.h"

@interface BFAwardOrderDetailView ()

@property (nonatomic,  strong) UICollectionViewFlowLayout *biuNumbersLayout;

@end

@implementation BFAwardOrderDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
        
    }
    return self;
}

- (void)addUI{
    
    self.awardOrderDetailTableView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor                           = [UIColor colorWithHex:BACK_COLOR];
    
    self.awardOrderDetailTableView.alwaysBounceVertical = YES;
    [self addSubview:self.awardOrderDetailTableView];
}

//lazy
-(UICollectionView *)awardOrderDetailTableView{
    
    if (_awardOrderDetailTableView==nil) {
        _awardOrderDetailTableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:self.biuNumbersLayout];
    }
    return _awardOrderDetailTableView;
}

// lazy
-(UICollectionViewFlowLayout *)biuNumbersLayout{
    
    if (_biuNumbersLayout == nil) {
        _biuNumbersLayout =[[UICollectionViewFlowLayout alloc] init];
        //_biuNumbersLayout.headerReferenceSize = CGSizeMake(0, SCREEN_WIDTH/375*(90+5+47));
        //_biuNumbersLayout.itemSize                = CGSizeMake((SCREEN_WIDTH)/5, ((SCREEN_WIDTH-80)/2)/119*22);//-SCREEN_WIDTH/375*24
        _biuNumbersLayout.minimumLineSpacing      = 0; // 上下
        _biuNumbersLayout.minimumInteritemSpacing = 0; // 左右5
        _biuNumbersLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //_biuNumbersLayout.sectionInset             = UIEdgeInsetsMake(SCREEN_WIDTH/375*5, SCREEN_WIDTH/375*12, 20, SCREEN_WIDTH/375*12);
    }
    return _biuNumbersLayout;
}

/*
 @implementation BFAwardOrderDetailView
 
 - (instancetype)initWithFrame:(CGRect)frame {
 
 self = [super initWithFrame:frame];
 if (self) {
 
 [self addUI];
 }
 return self;
 }
 
 - (void)addUI{
 
 [self addSubview:self.awardOrderDetailTableView];
 }
 
 
 -(UITableView *)awardOrderDetailTableView{
 
 if (_awardOrderDetailTableView==nil) {
 _awardOrderDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
 _awardOrderDetailTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
 _awardOrderDetailTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
 }
 return _awardOrderDetailTableView;
 }
 
 */



@end
