//
//  BFBiuNumbersViewController.h
//  BFCollectionViewDemo
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 anju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFPresentBaseViewController.h"

@interface BFBiuNumbersViewController : BFPresentBaseViewController

//fangID
@property (nonatomic , copy) NSString *fangID;

//community name
@property (nonatomic , copy) NSString *communityNameStr;

//issue number
@property (nonatomic , copy) NSString *issueNumberStr;

//状态 Biu房中 揭晓中  已揭晓
@property (nonatomic , copy) NSString *fangStatus;
@end
