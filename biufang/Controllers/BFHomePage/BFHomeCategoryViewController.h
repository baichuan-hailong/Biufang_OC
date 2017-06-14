//
//  BFHomeCategoryViewController.h
//  biufang
//
//  Created by 娄耀文 on 16/10/19.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFHomeCategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//DataSource
@property (nonatomic, strong) NSArray        *tempdDataSource;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy)   NSString       *currentCity;     //当前城市
@property (nonatomic, copy)   NSString       *currentCategory; //当前分类

@end
