//
//  BFBaseViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/9/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBaseViewController.h"

@interface BFBaseViewController ()

@end

@implementation BFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self backButton];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"tokenFailureAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenFailureAction) name:@"tokenFailureAction" object:nil];


    

    
    //UINavigationBar *navigationBar = self.navigationController.navigationBar;
    //[navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; //此处使底部线条颜色为红色
    //[navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //[navigationBar setShadowImage:[UIImage imageWithColor:[UIColor redColor]]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)tokenFailureAction{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
}



- (void)backButton {
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 64, 64);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0,-50, 0, 10);    
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=item;
}



- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
