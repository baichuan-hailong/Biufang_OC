//
//  BFAwardOrderTelEmailCollectionViewCell.h
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFAwardOrderTelEmailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *telImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (void)setValueWithBiuNumberModle:(NSString *)telStr;
@end
