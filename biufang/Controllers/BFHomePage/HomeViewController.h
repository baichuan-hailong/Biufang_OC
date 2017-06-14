//
//  ViewController.h
//  biufang
//
//  Created by 娄耀文 on 16/9/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController


//DataSource
@property (nonatomic, strong) NSMutableArray *bannerArray;     //banner广告
@property (nonatomic, strong) NSMutableArray *dataSource;      //首页商品
@property (nonatomic, strong) NSMutableArray *operationArray;  //运营位数据

@property (nonatomic, copy)   NSString       *currentCity;     //当前城市
@property (nonatomic, copy)   NSString       *currentCategory; //当前分类

@end

