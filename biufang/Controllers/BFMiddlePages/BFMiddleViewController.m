//
//  BFMiddleViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/9/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMiddleViewController.h"
#import "BFDetailViewController.h"
#import "BFMiddleViewCell.h"

#define NavBarFrame self.navBarView.frame


@interface BFMiddleViewController () <DZNEmptyDataSetSource,
                                      DZNEmptyDataSetDelegate,
                                      UIScrollViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView    *endCollectionView;
@property (nonatomic, assign) NSInteger           page;

@property (nonatomic, strong) NSMutableArray      *totalLastTime;
@property (nonatomic, strong) NSMutableArray      *dataSource;

//导航
@property (nonatomic, assign) BOOL                isHidden;       //导航栏隐藏状态
@property (nonatomic, strong) UIView              *navBarView;
@property (nonatomic, strong) UIView              *navBarWhiteView;
@property (nonatomic, strong) UILabel             *titleLable;
@property (nonatomic, strong) BFNoNetView         *noNetView;     //无网络状态
@property (nonatomic, assign) BOOL                isCanSideBack;  //右滑返回允许状态

@end

@implementation BFMiddleViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBackToForeGround) name:UIApplicationDidBecomeActiveNotification object:nil];

    _totalLastTime  = [[NSMutableArray alloc] init];
    _dataSource     = [[NSMutableArray alloc] init];
    

    [self.view       addSubview:self.navBarView];
    [self.navBarView addSubview:self.titleLable];
    [self.navBarView addSubview:self.navBarWhiteView];
    [self.view       addSubview:self.endCollectionView];
    
    [self setMJRefreshConfig];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        
        if (_dataSource.count == 0) {
            if (_noNetView == nil) {
                _noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
                [_noNetView.updateButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.endCollectionView addSubview:_noNetView];
        }
    }else{
        [_noNetView removeFromSuperview];
    }
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"PublishListPage"];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"PublishListPage"];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)willBackToForeGround {
}

- (void)refresh {
    
    [self.endCollectionView.mj_header beginRefreshing];
}

//配置MJRefresh
- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.endCollectionView.mj_header = header;
    self.endCollectionView.mj_footer = footer;
    [self.endCollectionView.mj_header beginRefreshing];
}


#pragma mark - dataSource
//刷新数据
- (void)loadDataSource {

    //*** 揭晓中 ***//
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/ended",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = @{@"page":@1};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {

        [_noNetView removeFromSuperview];
        
        if (_dataSource.count > 0) {
            [_dataSource removeAllObjects];
        }
        
        _page = 2;
        NSArray *dataArray = object[@"data"][@"items"];
        
        [_dataSource addObjectsFromArray:dataArray];
        
        if (_totalLastTime.count > 0) {
            [_totalLastTime removeAllObjects];
        }
        
        for (int i = 0; i < _dataSource.count; i++) {
            
            NSInteger luckyTime = [[_dataSource objectAt:i][@"lucky_time"] integerValue];
            NSInteger serveTime = [object[@"status"][@"time"] integerValue];
            NSInteger timeStamp = luckyTime - serveTime;
            
            NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%i",i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
            [_totalLastTime addObject:dic];
        }
        
        [self.endCollectionView reloadData];
        [self.endCollectionView.mj_header endRefreshing];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.endCollectionView.mj_header endRefreshing];
        
    } progress:^(float progress) {}];
    
    [self.endCollectionView.mj_footer endRefreshing];
}

//加载更多数据
- (void)loadMoreData {
        
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/ended",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = @{@"page":[NSNumber numberWithInteger:_page]};
    
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

            for (int i = 0; i < dataArray.count; i++) {
                
                NSInteger luckyTime = [[dataArray objectAt:i][@"lucky_time"] integerValue];
                NSInteger serveTime = [object[@"status"][@"time"] integerValue];
                NSInteger timeStamp = luckyTime - serveTime;
                
                NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%ld",_totalLastTime.count + i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
                [_totalLastTime addObject:dic];
            }
            
            [self.endCollectionView reloadData];
            [self.endCollectionView.mj_footer endRefreshing];
        } else {
            
            NSLog(@"没有更多数据了");
            [self.endCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.endCollectionView.mj_footer endRefreshing];
        
    } progress:^(float progress) {}];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //*** 商品展示cell ***//
    BFHomeModel      *model = [[BFHomeModel alloc] initWithKvcDictionary:(NSDictionary *)[_dataSource objectAt:indexPath.row]];
    BFMiddleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BFMiddleViewCell" forIndexPath:indexPath];
    [cell setValueWithModel:model];
    
    cell.timeLessLable.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:[[[_totalLastTime objectAtIndex:indexPath.row] objectForKey:@"lastTime"] integerValue]]];

    
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/1.5625);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //*** 商品点击 ***//
    BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
    detailVC.detailId = [NSString stringWithFormat:@"%@",[_dataSource objectAt:indexPath.row][@"id"]];
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    //显示
    if (translation.y > 0) {
        if (_isHidden) {
            _isHidden= NO;
            CGRect navBarFrame = NavBarFrame;
            CGRect scrollViewFrame = self.endCollectionView.frame;
            
            navBarFrame.origin.y = 0;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = navBarFrame;
                self.endCollectionView.frame=scrollViewFrame;
                self.navBarWhiteView.alpha = 0;
            }];
        }
    }
    
    //隐藏
    if (translation.y < 0) {
        if (!_isHidden) {
            _isHidden=YES;
            CGRect frame =NavBarFrame;
            CGRect scrollViewFrame = self.endCollectionView.frame;
            frame.origin.y = -44;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                self.endCollectionView.frame=scrollViewFrame;
                self.navBarWhiteView.alpha = 1;
            }];
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}


#pragma mark - 倒计时
- (void)startTimer {

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime {
    
    NSInteger time;
    for (int i = 0; i < _totalLastTime.count; i++) {
        
        time = [[[_totalLastTime objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        BFMiddleViewCell *cell = (BFMiddleViewCell *)[self.endCollectionView cellForItemAtIndexPath:indexPath];
        
        --time;
        if (time > 0) {
            
            if (time > 0) {
                
                cell.timeLessLable.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:time]];
                NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time]};
                [_totalLastTime replaceObjectAtIndex:i withObject:dic];
            }
            
        } else if (time == 0){
            
            cell.timeLessLable.text = @"00:00:00";
            
            NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time]};
            [_totalLastTime replaceObjectAtIndex:i withObject:dic];
            
            //*** 刷新当前cell ***//
            NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/get-winner",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *param  = @{@"fang_id":[NSString stringWithFormat:@"%@",[_dataSource objectAt:i][@"id"]]};
            [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
                
                
                NSLog(@"获奖者：%@",object);
                if ([[NSString stringWithFormat:@"%@",object[@"status"][@"state"]] isEqualToString:@"success"]) {
                    
                    //已揭晓
                    cell.timeView.alpha = 0;
                    cell.winnerView.alpha = 1;
                    
                    cell.nickName.text  = [NSString stringWithFormat:@"获奖者：%@",object[@"data"][@"nickname"]];
                    cell.joinTimes.text = [NSString stringWithFormat:@"参与人次：%@",object[@"data"][@"quantity"]];
                    cell.snLable.text   = [NSString stringWithFormat:@"期号：%@",[_dataSource objectAt:i][@"sn"]];
                    cell.timeLable.text = [myToolsClass changeTime:[NSString stringWithFormat:@"%@",object[@"status"][@"time"]]];
                }
                
            } withFailureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            } progress:^(float progress) {}];
        }
    }
}

- (NSString *)lessSecondToDay:(NSInteger)seconds {
    
    NSInteger day    = (NSInteger)(seconds / (24 * 3600));
    NSInteger hour   = (NSInteger)(seconds % (24 * 3600)) / 3600;
    NSInteger min    = (NSInteger)(seconds % (3600)) / 60;
    NSInteger second = (NSInteger)(seconds %  60);
    
    if (day >= 1) {
        return [NSString stringWithFormat:@"%lu天",(long)day];
    } else {
        return [NSString stringWithFormat:@"%.2lu:%.2lu:%.2lu",(long)hour,(long)min,(long)second];
    }
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
    tipsLable.text = @"老爷！暂无揭晓中的大宅..";
    [emptyView addSubview:tipsLable];
    
    return emptyView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}




#pragma mark - getter
- (UIView *)navBarView {
    
    if (_navBarView == nil) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navBarView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"e6e6e6"];
        [_navBarView addSubview:line];
    }
    return _navBarView;
}

- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 43);
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"揭晓";
    }
    return _titleLable;
}

- (UIView *)navBarWhiteView {
    
    if (_navBarWhiteView == nil) {
        _navBarWhiteView = [[UIView alloc] init];
        _navBarWhiteView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 43);
        _navBarWhiteView.backgroundColor = [UIColor whiteColor];
        _navBarWhiteView.alpha = 0;
    }
    return _navBarWhiteView;
}

- (UICollectionView *)endCollectionView {
    
    if (_endCollectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing      = 0.0f; //上下
        layout.minimumInteritemSpacing = 0.0f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _endCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
        _endCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
        _endCollectionView.alwaysBounceVertical = YES;
        _endCollectionView.delegate    = self;
        _endCollectionView.dataSource  = self;
        _endCollectionView.backgroundColor = [UIColor whiteColor];
        
        //*** 注册自定义Cell ***//
        [_endCollectionView registerClass:[BFMiddleViewCell class] forCellWithReuseIdentifier:@"BFMiddleViewCell"];
    }
    return _endCollectionView;
}



#pragma mark - rootView开启和关闭右滑返回
//禁用边缘返回
-(void)forbiddenSideBack{
    
    self.isCanSideBack = NO;
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

//恢复边缘返回
- (void)resetSideBack {
    
    self.isCanSideBack=YES;
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return self.isCanSideBack;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
