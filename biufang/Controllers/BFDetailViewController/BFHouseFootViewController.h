//
//  BFHouseFootViewController.h
//  biufang
//
//  Created by 娄耀文 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HeadRefReshBlock)();

@interface BFHouseFootViewController : UIViewController

@property (nonatomic, copy) HeadRefReshBlock headRefReshBlock;
@property (nonatomic, copy) NSString         *webUrl;

@end
