//
//  BFOrderBiuNumbersViewController.h
//  biufang
//
//  Created by 杜海龙 on 16/12/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBaseViewController.h"
#import "BFAwardOrderDetailView.h"

@interface BFOrderBiuNumbersViewController : BFBaseViewController

//body
@property (nonatomic, strong)BFAwardOrderDetailView *awardOrderDetailView;

//fang_id
@property (nonatomic , strong) NSString *fang_ID;

@end
