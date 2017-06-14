//
//  BFShareOrderViewController.m
//  biufang
//
//  Created by 娄耀文 on 17/3/8.
//  Copyright © 2017年 biufang. All rights reserved.
//
// *** 晒单 ***//
//
//
#import "BFShareOrderViewController.h"
#import "BFShareOrderCell.h"

@interface BFShareOrderViewController () <UITableViewDelegate,
                                          UITableViewDataSource>


@property (nonatomic, strong) UITableView    *shareTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BFShareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"晒单分享";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    [self.view addSubview:self.shareTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



#pragma mark - UITableView Delegate & Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIndentifire = @"cell";
    BFShareOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFShareOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}








#pragma mark - customMethod

#pragma mark - getter
- (UITableView *)shareTableView {

    if (_shareTableView == nil) {
        _shareTableView = [[UITableView alloc] init];
        _shareTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _shareTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _shareTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        //_shareTableView.showsVerticalScrollIndicator = NO;
        _shareTableView.delegate   = self;
        _shareTableView.dataSource = self;
    }
    return _shareTableView;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
