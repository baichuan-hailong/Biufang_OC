
//
//  BFFundView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/22.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFFundView.h"

@interface BFFundView ()
@property (nonatomic,  strong) UICollectionViewFlowLayout *fundFlowLayout;
@end

@implementation BFFundView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.fundCollectionView.backgroundColor       = [UIColor colorWithHex:BACK_COLOR];
    self.backgroundColor                          = [UIColor colorWithHex:BACK_COLOR];
    self.fundCollectionView.showsVerticalScrollIndicator = NO;
    
    self.fundCollectionView.alwaysBounceVertical = YES;
    [self addSubview:self.fundCollectionView];
}

//lazy
-(UICollectionView *)fundCollectionView{
    
    if (_fundCollectionView==nil) {
        _fundCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:self.fundFlowLayout];
    }
    return _fundCollectionView;
}

// lazy
-(UICollectionViewFlowLayout *)fundFlowLayout{
    
    if (_fundFlowLayout == nil) {
        _fundFlowLayout =[[UICollectionViewFlowLayout alloc] init];
        //_fundFlowLayout.headerReferenceSize = CGSizeMake(0, SCREEN_WIDTH/375*71);
        _fundFlowLayout.itemSize                = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/375*205);
        _fundFlowLayout.minimumLineSpacing      = 0; // 上下
        _fundFlowLayout.minimumInteritemSpacing = 0; // 左右
        _fundFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _fundFlowLayout.sectionInset             = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    return _fundFlowLayout;
}


@end
