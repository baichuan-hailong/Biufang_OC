//
//  BFPresentBaseViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPresentBaseViewController.h"

@interface BFPresentBaseViewController ()

@end

@implementation BFPresentBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self leftButton];
    
    //1
    //[[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor colorWithHex:@"E6E6E6E"]]];
    
    //2
    //UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //[navigationBar setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    //[navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHex:@"E6E6E6E"]]];
}

- (void)leftButton {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"close icon"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 15, 64, 40);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)backAction:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
