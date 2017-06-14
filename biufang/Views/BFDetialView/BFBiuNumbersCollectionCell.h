//
//  BFBiuNumbersCollectionCell.h
//  BFCollectionViewDemo
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 anju. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFBiuNumberModle;

@interface BFBiuNumbersCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *biuNumberBodyView;

@property (weak, nonatomic) IBOutlet UILabel *biuNumberLabel;

- (void)setValueWithBiuNumberModle:(NSString *)biuNumberModle;

@end
