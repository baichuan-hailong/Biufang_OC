//
//  BFTabBarController.m
//  biufang
//
//  Created by 杜海龙 on 16/9/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFTabBarController.h"
#import "HomeViewController.h"
#import "BFMiddleViewController.h"
#import "BFFundViewController.h"
#import "BFNewFundViewController.h"
#import "BFMyselfViewController.h"


#import "BFGuideView.h"

@interface BFTabBarController () 

@property (nonatomic, strong) BFGuideView *guideView;
@property (nonatomic, strong) NSArray     *naArray;

@end

@implementation BFTabBarController


+ (void)addAllChildViewController:(UITabBarController *)tabBarController{
    
    tabBarController.view.backgroundColor = [UIColor whiteColor];
    
    HomeViewController *homeVC     = [[HomeViewController alloc] init];
    BFMiddleViewController *secondeVC = [[BFMiddleViewController alloc] init];
    //BFFundViewController *fundVC = [[BFFundViewController alloc] init];
    BFNewFundViewController *newFundVC = [[BFNewFundViewController alloc] init];
    BFMyselfViewController *thirdVC = [[BFMyselfViewController alloc] init];
    
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationController *newFunNC = [[UINavigationController alloc] initWithRootViewController:newFundVC];
    UINavigationController *secondeNC = [[UINavigationController alloc] initWithRootViewController:secondeVC];
    UINavigationController *thirdNC = [[UINavigationController alloc] initWithRootViewController:thirdVC];
    
    
    NSArray *naArray = [NSArray arrayWithObjects:homeNC,secondeNC,newFunNC,thirdNC,nil];
    [tabBarController setViewControllers:naArray animated:YES];
    
    
    //UIView * mView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];//这是整个tabbar的颜色
    //[mView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar.png"]]];
    //mView.backgroundColor = [UIColor whiteColor];
    //[tabBarController.tabBar insertSubview:mView atIndex:1];
    
    
    
//    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    //[tabBarController.tabBar setBackgroundImage:img];
//    [tabBarController.tabBar setShadowImage:img];
//    //[tabBarController.tabBar setBackgroundColor:[UIColor whiteColor]];
    
    tabBarController.tabBar.alpha = 1.0;
   
    
    
    
    [homeNC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHex:RED_COLOR]} forState:UIControlStateSelected];
    [secondeNC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHex:RED_COLOR]} forState:UIControlStateSelected];
    [newFunNC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHex:RED_COLOR]} forState:UIControlStateSelected];
    [thirdNC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor colorWithHex:RED_COLOR]} forState:UIControlStateSelected];
    
    
    
    //secondeVC.title = @"2";
    newFunNC.title    = @"Biu币";
    secondeNC.title = @"揭晓";
    
    homeNC.tabBarItem.title    = @"Biu";
    secondeNC.tabBarItem.title = @"揭晓";
    newFunNC.tabBarItem.title  = @"Biu币";
    thirdNC.tabBarItem.title   = @"我的";
    
    homeNC.tabBarItem.image    = [[UIImage imageNamed:@"HOME1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondeNC.tabBarItem.image = [[UIImage imageNamed:@"HIS1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newFunNC.tabBarItem.image     = [[UIImage imageNamed:@"MONEY1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdNC.tabBarItem.image   = [[UIImage imageNamed:@"SETTING1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    homeNC.tabBarItem.selectedImage    = [[UIImage imageNamed:@"HOME"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secondeNC.tabBarItem.selectedImage = [[UIImage imageNamed:@"HIS"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newFunNC.tabBarItem.selectedImage     = [[UIImage imageNamed:@"MONEY"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thirdNC.tabBarItem.selectedImage   = [[UIImage imageNamed:@"SETTING"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


//+ (void)initialize{
//    
//    // self -> TabBarViewController
//    UITabBarItem *item                      = [UITabBarItem appearanceWhenContainedIn:self, nil];
//    NSMutableDictionary *attDict            = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor blackColor];  //color
//    [item setTitleTextAttributes:attDict forState:UIControlStateSelected];
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    self.naArray = [NSMutableArray array];
//    
//    //Add NCS
//    [self addAllChildViewController];
//    
//    //login
//}
//
//
//-(void)viewDidAppear:(BOOL)animated{
//
//    
//
//    //self.selectedIndex = 0;
//
//    //add git
//    //Guide pages
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_First]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
//        NSLog(@"first");
//        
//        [self.guideView.startButton addTarget:self action:@selector(guideStartButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.guideView];
//    }
//}
//
//- (void)guideStartButtonDidClicked:(UIButton *)sender{
//
//    [self.guideView removeFromSuperview];
//}
//
//
//- (void)addAllChildViewController{
//    // 模块一
//    HomeViewController *homeVC     = [[HomeViewController alloc] init];
//
//    homeVC.view.backgroundColor    = [UIColor lightGrayColor];
//    
//
//    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    
////    [self addOneChildViewController:homeNC
////                              image:[UIImage imageNamed:@"one"]
////                      selectedImege:[UIImage imageNamed:@"one"]
////                        stringTitle:@"BIU"];
//    
//    // 模块二
//    BFMiddleViewController *secondeVC = [[BFMiddleViewController alloc] init];
//    
//    UINavigationController *secondeNC = [[UINavigationController alloc] initWithRootViewController:secondeVC];
//    
////    [self addOneChildViewController:secondeNC
////                              image:[UIImage imageNamed:@"two"]
////                      selectedImege:[UIImage imageNamed:@"two"]
////                        stringTitle:@"往期"];
//    
//    
//    
//    //三
//    BFFundViewController *fundVC = [[BFFundViewController alloc] init];
//    
//    UINavigationController *funNC = [[UINavigationController alloc] initWithRootViewController:fundVC];
//    
////    [self addOneChildViewController:funNC
////                              image:[UIImage imageNamed:@"two"]
////                      selectedImege:[UIImage imageNamed:@"two"]
////                        stringTitle:@"B积金"];
//    
//    // 模块4
//    BFMyselfViewController *thirdVC = [[BFMyselfViewController alloc] init];
//    thirdVC.view.backgroundColor    = [UIColor whiteColor];
//    
//    UINavigationController *thirdNC = [[UINavigationController alloc] initWithRootViewController:thirdVC];
////    [self addOneChildViewController:thirdNC
////                              image:[UIImage imageNamed:@"three"]
////                      selectedImege:[UIImage imageNamed:@"three"]
////                        stringTitle:@"我的"];
//    
//    
//    self.naArray = @[homeNC,secondeNC,funNC,thirdNC];
//
//    self.viewControllers = self.naArray;
//
//    homeNC.title                   = @"BIU";
//    secondeNC.title                   = @"2";
//    funNC.title                   = @"3";
//    thirdNC.title                   = @"我的";
//}
//
//
//#pragma mark -添加一个控制器的方法
//- (void)addOneChildViewController:(UINavigationController *)nc image:(UIImage *)image selectedImege:(UIImage *)selectedImage stringTitle:(NSString *)title{
//    
//    nc.tabBarItem.image         = image;
//    nc.tabBarItem.selectedImage = selectedImage;
//    nc.tabBarItem.title         = title;
//    
//    //[self addChildViewController:nc];
//    //[self.naArray addObject:nc];
//    
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
////lazy
//-(BFGuideView *)guideView{
//
//    if (_guideView==nil) {
//        _guideView = [[BFGuideView alloc] initWithFrame:SCREEN_BOUNDS];
//    }
//    return _guideView;
//}

@end
