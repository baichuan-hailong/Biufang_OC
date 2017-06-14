//
//  BFHomeCategoryViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/10/19.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHomeCategoryViewController.h"
#import "BFHomeCategoryView.h"
#import "BFHomeViewCell.h"
#import "BFDetailViewController.h"

#import "BFHomeModel.h"
#import "BFMakeOrderViewController.h"

#define NavBarFrame self.currentView.navBarView.frame

@interface BFHomeCategoryViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) BFHomeCategoryView  *currentView;
@property (nonatomic, assign) BOOL          isHidden;   //导航栏隐藏状态
@property (nonatomic, assign) NSInteger     page;
@property (nonatomic, copy)   NSString      *fang_id;
@property (nonatomic, strong) BFNoNetView   *noNetView; //无网络状态
@property (nonatomic, strong) UIView        *whiteView; //loading背景
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BFHomeCategoryViewController

#pragma mark - lifeCycle
- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _page          = 1;
    _isHidden      = NO;
    
    self.currentView = [[BFHomeCategoryView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.currentView;
    self.currentView.categoryTableView.delegate   = self;
    self.currentView.categoryTableView.dataSource = self;
    self.currentView.categoryTableView.emptyDataSetDelegate = self;
    self.currentView.categoryTableView.emptyDataSetSource = self;
    
    //加载时白色蒙版
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteView];

    
    if ([_currentCategory isEqualToString:@"*"]) {
        self.currentView.titleBtn.alpha   = 0;
        self.currentView.titleLable.alpha = 1;
        self.currentView.titleLable.text = @"即将揭晓";
        
    } else if ([_currentCategory isEqualToString:@"activity"]) {
        self.currentView.titleBtn.alpha   = 0;
        self.currentView.titleLable.alpha = 1;
        self.currentView.titleLable.text = @"";
        
    }else if ([_currentCategory isEqualToString:@"sell"]) {
        self.currentView.titleBtn.alpha   = 1;
        self.currentView.titleLable.alpha = 0;
        [self.currentView.titleBtn     setTitle:@"热门新房" forState:UIControlStateNormal];
        
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 10 - 3/*20*/,
                                                       (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    } else if ([_currentCategory isEqualToString:@"rent"]) {
        self.currentView.titleBtn.alpha   = 1;
        self.currentView.titleLable.alpha = 0;
        [self.currentView.titleBtn     setTitle:@"热门精品" forState:UIControlStateNormal];
        
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 10 - 3,
                                                       (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    } else if ([_currentCategory isEqualToString:@"hotel"]) {
        self.currentView.titleBtn.alpha   = 1;
        self.currentView.titleLable.alpha = 0;
        [self.currentView.titleBtn     setTitle:@"酒店客栈" forState:UIControlStateNormal];
        
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 9 - 3,
                                                       (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    }
    
    [self.currentView.backBlackBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.currentView.titleBtn     addTarget:self action:@selector(classItemWindow) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [[NSMutableArray alloc] initWithArray:_tempdDataSource];
    [self.currentView.categoryTableView reloadData];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    
    [self setMJRefreshConfig];
    
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FangCategaryLoginNextAc) name:@"FangCategaryLoginNextAction" object:nil];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        
        if (_dataSource.count == 0) {
            _noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
            [_noNetView.updateButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            [self.currentView.categoryTableView addSubview:_noNetView];
        }
    }else{
        [_noNetView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"GoodsListPage"];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"GoodsListPage"];
}

- (void)refresh {
    [self.currentView.categoryTableView.mj_header beginRefreshing];
}

//配置MJRefresh
- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"    forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"       forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    
    self.currentView.categoryTableView.mj_header = header;
    self.currentView.categoryTableView.mj_footer = footer;
    
    [self hud];
    [self loadDataSource];
}


#pragma mark - dataSource
//刷新数据
- (void)loadDataSource {
    
    NSString     *urlStr;
    NSDictionary *param;
    if ([_currentCategory isEqualToString:@"*"]) {
        
        //*** 即将揭晓 ***//
        urlStr = [[NSString stringWithFormat:@"%@/fang/ending",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        param  = @{@"page":@1,@"city":_currentCity};
    } else {
        
        urlStr = [[NSString stringWithFormat:@"%@/fang/fang-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        param  = @{@"page":@1,
                   @"city":_currentCity,
                   @"category":_currentCategory,
                   @"status":@"1"};
    }
    
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        [_noNetView removeFromSuperview];
        if (_dataSource.count > 0) {
            [_dataSource removeAllObjects];
        }
        
        _page = 2;
        NSArray *dataArray = object[@"data"][@"items"];
        [_dataSource addObjectsFromArray:dataArray];
        
        //NSLog(@"homeDataSource : %@",object);
        
        [self.currentView.categoryTableView reloadData];
        [self.currentView.categoryTableView.mj_header endRefreshing];
        
        [UIView animateWithDuration:0.28 animations:^{
            [self.hud hide:YES];
            self.whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.whiteView removeFromSuperview];
        }];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentView.categoryTableView.mj_header endRefreshing];
        
        [UIView animateWithDuration:0.28 animations:^{
            [self.hud hide:YES];
            self.whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.whiteView removeFromSuperview];
        }];
        
    } progress:^(float progress) {}];
    
    [self.currentView.categoryTableView.mj_footer endRefreshing];
}

//加载更多数据
- (void)loadMoreData {
    
    NSString     *urlStr;
    NSDictionary *param;
    if ([_currentCategory isEqualToString:@"*"]) {
        
        //*** 即将揭晓 ***//
        urlStr = [[NSString stringWithFormat:@"%@/fang/ending",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        param  = @{@"page":[NSNumber numberWithInteger:_page],@"city":_currentCity};
    } else {
        
        urlStr = [[NSString stringWithFormat:@"%@/fang/fang-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        param  = @{@"page":[NSNumber numberWithInteger:_page],
                   @"city":_currentCity,
                   @"category":_currentCategory,
                   @"status":@"1"};
    }
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        //NSLog(@"homeDataSource : %@",object);
        NSInteger totalCount = [object[@"data"][@"total"] integerValue];
        
        if (_dataSource.count < totalCount) {
            
            _page++;
            NSArray *dataArray = object[@"data"][@"items"];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            [tempArray addObjectsFromArray:_dataSource];
            [tempArray addObjectsFromArray:dataArray];
            _dataSource = tempArray;
            
            [self.currentView.categoryTableView reloadData];
            [self.currentView.categoryTableView.mj_footer endRefreshing];
        } else {
            
            NSLog(@"没有更多数据了");
            [self.currentView.categoryTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentView.categoryTableView.mj_footer endRefreshing];
        
    } progress:^(float progress) {}];
}


#pragma mark - UITableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/3.125;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:(NSDictionary *)_dataSource[indexPath.row]];
    
    static NSString *cellIndentifire = @"cell";
    BFHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.biuButton.tag = indexPath.row;
    [cell.biuButton addTarget:self action:@selector(biuAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell setValueWithModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"GoodsListPageGoodsClick"];
    
    BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
    detailVC.detailId = [_dataSource objectAt:indexPath.row][@"id"];
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

// cell animation
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_dataSource.count > 0) {
        //cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    //显示
    if (translation.y > 0) {
        if (_isHidden) {
            _isHidden= NO;
            CGRect navBarFrame=NavBarFrame;
            CGRect scrollViewFrame=self.currentView.categoryTableView.frame;
            
            navBarFrame.origin.y = 0;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = navBarFrame;
                self.currentView.categoryTableView.frame=scrollViewFrame;
                self.currentView.navBarWhiteView.alpha = 0;
            }];
        }
    }
    
    //隐藏
    if (translation.y < 0) {
        if (!_isHidden) {
            _isHidden=YES;
            CGRect frame =NavBarFrame;
            CGRect scrollViewFrame=self.currentView.categoryTableView.frame;
            frame.origin.y = -44;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                self.currentView.categoryTableView.frame=scrollViewFrame;
                self.currentView.navBarWhiteView.alpha = 1;
            }];
        }
    }
}





#pragma mark - customMethod
- (void)classItemWindow {
    
    //*** 分类弹窗 ***//
    YCXMenuItem *buyItem = [YCXMenuItem menuItem:@" 热门新房 " image:[UIImage imageNamed:@"BUY-1"] target:self
                                          action:@selector(selectClass:)];
    buyItem.tag = 1001;
    buyItem.titleFont = [UIFont systemFontOfSize:SCREEN_WIDTH/23.5];
    buyItem.alignment = NSTextAlignmentCenter;
    
    YCXMenuItem *borrowItem = [YCXMenuItem menuItem:@" 热门精品 " image:[UIImage imageNamed:@"sofa"] target:self
                                             action:@selector(selectClass:)];
    borrowItem.tag = 1002;
    borrowItem.titleFont = [UIFont systemFontOfSize:SCREEN_WIDTH/23.5];
    borrowItem.alignment = NSTextAlignmentCenter;
    
    YCXMenuItem *hotelItem = [YCXMenuItem menuItem:@" 酒店客栈 " image:[UIImage imageNamed:@"take-white"] target:self
                                            action:@selector(selectClass:)];
    hotelItem.tag = 1003;
    hotelItem.titleFont = [UIFont systemFontOfSize:SCREEN_WIDTH/23.5];
    hotelItem.alignment = NSTextAlignmentCenter;
    
    
    NSArray *items = @[buyItem, hotelItem, borrowItem];
    //CGRect  aframe = CGRectMake(self.currentView.titleBtn.frame.origin.x, self.currentView.titleBtn.frame.origin.y - 20, 110, 64);
    CGRect  aframe = self.currentView.titleBtn.frame;
    
    [YCXMenu setArrowSize:5.0f];
    [YCXMenu setSelectedColor:[UIColor colorWithHex:@"303030"]];
    [YCXMenu setTintColor:[UIColor colorWithHex:@"464646"]];
    
    if ([YCXMenu isShow]) {
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu showMenuInView:self.view fromRect:aframe menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        }];
    }
}

- (void)selectClass:(UIButton *)sender {
    
    //*** 选择分类并刷新数据 ***//
    if (sender.tag == 1001) {
        _currentCategory = @"sell";
    } else if (sender.tag == 1002) {
        _currentCategory = @"rent";
    } else if (sender.tag == 1003) {
        _currentCategory = @"hotel";
    }
    if ([_currentCategory isEqualToString:@"sell"]) {
        [self.currentView.titleBtn     setTitle:@"热门新房" forState:UIControlStateNormal];
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 10 - 3,
                                                        (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    } else if ([_currentCategory isEqualToString:@"rent"]) {
        [self.currentView.titleBtn     setTitle:@"热门精品" forState:UIControlStateNormal];
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 10 - 3,
                                                        (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    } else if ([_currentCategory isEqualToString:@"hotel"]) {
        [self.currentView.titleBtn     setTitle:@"酒店客栈" forState:UIControlStateNormal];
        self.currentView.titleBtnImg.frame = CGRectMake(self.currentView.titleBtn.frame.size.width - 10 - 3,
                                                        (self.currentView.titleBtn.frame.size.height - 4)/2,
                                                        10,6);
        
    }
    [self.currentView.categoryTableView.mj_header beginRefreshing];
}


//登录状态直接购买
- (void)biuAction: (UIButton *)sender {

    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"GoodsListPagePerchaseClick"];
    
    self.fang_id = [_dataSource objectAtIndex:sender.tag][@"id"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
        [orderVC setHidesBottomBarWhenPushed:YES];
        orderVC.fang_id = [_dataSource objectAtIndex:sender.tag][@"id"];
        [self.navigationController pushViewController:orderVC animated:YES];
    } else {
        
        UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
        loginView.entranceType = @"FangCategaryPage";
        UINavigationController *loginNV = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self.navigationController presentViewController:loginNV animated:YES completion:nil];
    }
}




- (void)FangCategaryLoginNextAc{

    BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    [orderVC setHidesBottomBarWhenPushed:YES];
    orderVC.fang_id = self.fang_id;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (MBProgressHUD *)hud {
    
    if (_hud == nil) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.userInteractionEnabled = NO;
        _hud.removeFromSuperViewOnHide = YES;
    }
    return _hud;
}



#pragma mark - DZNEmptyDataSetDelegate 列表空视图
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIView *emptyView = [[UIView alloc] init];
    emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    UIImage *img = [UIImage imageNamed:@"empty"];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake((emptyView.frame.size.width - img.size.width)/2, -100, img.size.width, img.size.height);
    [emptyView addSubview:imgView];
    
    UILabel *tipsLable = [[UILabel alloc] init];
    tipsLable.frame = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 10, SCREEN_WIDTH, SCREEN_WIDTH/26.78);
    tipsLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/26.78];
    tipsLable.textColor = [UIColor colorWithHex:@"9a9a9a"];
    tipsLable.textAlignment = NSTextAlignmentCenter;
    
    if ([_currentCategory isEqualToString:@"sell"]) {
        tipsLable.text = @"老爷！暂无热门新房可Biu!";
    } else if ([_currentCategory isEqualToString:@"rent"]) {
        tipsLable.text = @"老爷！暂无热门精品可Biu!";
    } else if ([_currentCategory isEqualToString:@"hotel"]) {
        tipsLable.text = @"老爷！暂无酒店客栈可Biu!";
    } else {
        tipsLable.text = @"老爷！暂无即将揭晓的大宅!";
    }
    [emptyView addSubview:tipsLable];
    
    return emptyView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}



@end
