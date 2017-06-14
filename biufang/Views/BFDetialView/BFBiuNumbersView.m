//
//  BFBiuNumbersView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBiuNumbersView.h"

@interface BFBiuNumbersView ()
@property (nonatomic,  strong) UICollectionViewFlowLayout *biuNumbersLayout;
@end

@implementation BFBiuNumbersView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUI];
       
    }
    return self;
}

- (void)addUI{
    
    self.biuNumbersCollectionView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor                          = [UIColor colorWithHex:BACK_COLOR];
    
    self.biuNumbersCollectionView.alwaysBounceVertical = YES;
    [self addSubview:self.biuNumbersCollectionView];
}

//lazy
-(UICollectionView *)biuNumbersCollectionView{
    
    if (_biuNumbersCollectionView==nil) {
        _biuNumbersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:self.biuNumbersLayout];
    }
    return _biuNumbersCollectionView;
}

// lazy
-(UICollectionViewFlowLayout *)biuNumbersLayout{
    
    if (_biuNumbersLayout == nil) {
        _biuNumbersLayout =[[UICollectionViewFlowLayout alloc] init];
        //_biuNumbersLayout.headerReferenceSize = CGSizeMake(0, SCREEN_WIDTH/375*(90+5+47));
        _biuNumbersLayout.itemSize                = CGSizeMake((SCREEN_WIDTH)/5, ((SCREEN_WIDTH-80)/2)/119*22);//-SCREEN_WIDTH/375*24
        _biuNumbersLayout.minimumLineSpacing      = 0; // 上下
        _biuNumbersLayout.minimumInteritemSpacing = 0; // 左右5
        _biuNumbersLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //_biuNumbersLayout.sectionInset             = UIEdgeInsetsMake(SCREEN_WIDTH/375*5, SCREEN_WIDTH/375*12, 20, SCREEN_WIDTH/375*12);
    }
    return _biuNumbersLayout;
}

@end
