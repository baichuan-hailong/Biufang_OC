//
//  BFBiuRecordViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFBiuRecordViewController.h"
#import "LXSegmentScrollView.h"
#import "BFMyLuckyViewCell.h"
#import "BFHomeViewCell.h"
#import "BFDetailViewController.h"
#import "BFMakeOrderViewController.h"
#import "BFAwardOrderDetailViewController.h"

#import "BFRightAddressAndOrderDetailViewController.h"
#import "BFSettlementSelectCountView.h"

@interface BFBiuRecordViewController () <UITableViewDataSource,
                                         UITableViewDelegate,
                                         UIScrollViewDelegate,
                                         DZNEmptyDataSetSource,
                                         DZNEmptyDataSetDelegate,
                                         BFEvaluationDelegate,
                                         BFSettlementSelectCountDelegate>

@property (nonatomic, strong) UITableView         *endTableView;
@property (nonatomic, assign) NSInteger           page;
@property (nonatomic, strong) BFNoNetView         *noNetView; //无网络状态

@property (nonatomic, strong) LXSegmentScrollView *scView;
@property (nonatomic, strong) NSMutableArray      *tableViewArray;
@property (nonatomic, assign) UITableView         *currentTableView;

@property (nonatomic, assign) NSInteger           page1;
@property (nonatomic, assign) NSInteger           page2;
@property (nonatomic, assign) NSInteger           page3;
@property (nonatomic, strong) NSMutableArray      *dataSource1;
@property (nonatomic, strong) NSMutableArray      *dataSource2;
@property (nonatomic, strong) NSMutableArray      *dataSource3;
@property (nonatomic, strong) NSMutableArray      *totalLastTime1;
@property (nonatomic, strong) NSMutableArray      *totalLastTime2;

//分页

//评价
@property (nonatomic, strong) BFEvaluationView    *evaluationView;

//settlementView
@property (nonatomic , strong) BFSettlementSelectCountView *settlementSelectCountView;
@property (nonatomic , strong) NSString *fangID;

@end

@implementation BFBiuRecordViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //取出登陆时存储的时间
    NSString *loginTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginTimeStamp"];
    NSLog(@"%@",loginTimeStamp);
    
    if (loginTimeStamp.length>5) {
        //取出当前系统的时间
        NSDate          *unifiedDate         = [NSDate date];//获取当前时间，日期
        NSTimeInterval  currenSyetemTimeInla = [unifiedDate timeIntervalSince1970] + 28800;
        NSString *timeSystemStrla            = [NSString stringWithFormat:@"%.f", currenSyetemTimeInla];//转为字符型
        NSLog(@"%@",timeSystemStrla);
        
        //时间差                   当前时间                           登陆时间
        NSInteger poorTimeStamp = [timeSystemStrla integerValue] - [loginTimeStamp integerValue];
        NSLog(@"poor - %ld",(long)poorTimeStamp);
        
        /*
         4天 4x24x3600 = 345600
         5天 5x24x3600 = 432000
         1天 86400     = 432000-345600
         
         if (poorTimeStamp>345600) {
         NSLog(@"第五天以后");
         }else{
         NSLog(@"不满足条件");
         }
         */
        //no
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"havePopevaluation"]) {
            if (poorTimeStamp>345600) {
                //NSLog(@"2分钟以后");
                self.evaluationView          = [[BFEvaluationView alloc] initWithFrame:SCREEN_BOUNDS];
                self.evaluationView.delegate = self;
                [self.evaluationView showEvaluation];
            }else{
                NSLog(@"不满足条件");
            }
        }else{
            //yes
            NSString *logVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"versionSystemTag"];
            logVersion           = [logVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            //NSLog(@"%@",logVersion);
            NSString *currentVersion = [VERSION stringByReplacingOccurrencesOfString:@"." withString:@""];
            //NSLog(@"%@",currentVersion);
            if ([logVersion integerValue]>[currentVersion integerValue]) {
                NSLog(@"新版本");
                if (poorTimeStamp>345600) {
                    NSLog(@"2分钟以后");
                    self.evaluationView          = [[BFEvaluationView alloc] initWithFrame:SCREEN_BOUNDS];
                    self.evaluationView.delegate = self;
                    [self.evaluationView showEvaluation];
                }else{
                    NSLog(@"不满足条件");
                }
            }else{
                NSLog(@"旧版本");
            }
            NSLog(@"---------------------------------------------");
        }
    }
}


#pragma mark - BFEvaluationDelegate
-(void)evaluationClick:(NSInteger)clickInt{
    
    //登陆成功存取CN标准时间戳
    NSDate          *unifiedDate    = [NSDate date];//获取当前时间，日期
    NSTimeInterval  currenTimeIntla = [unifiedDate timeIntervalSince1970]+28800;
    NSString *timeLoginStamp        = [NSString stringWithFormat:@"%.f", currenTimeIntla];//转为字符型
    //NSLog(@"%@",timeLoginStamp);
    [[NSUserDefaults standardUserDefaults] setObject:timeLoginStamp forKey:@"loginTimeStamp"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:VERSION forKey:@"versionSystemTag"];
    
    
    if (clickInt==0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"havePopevaluation"];
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", AppIDituns];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (clickInt==2){
        NSLog(@"click Int --- %ld",(long)clickInt);
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"havePopevaluation"];
    }else{
        NSLog(@"click Int --- %ld",(long)clickInt);
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"havePopevaluation"];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的Biu记录";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //加快按钮点按效果，提高touch层级
    self.endTableView.delaysContentTouches = NO;
    for (UIView *currentView in self.endTableView.subviews) {
        
        if([currentView isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }

    _tableViewArray  = [[NSMutableArray alloc] init];
    _totalLastTime1  = [[NSMutableArray alloc] init];
    _totalLastTime2  = [[NSMutableArray alloc] init];
    _dataSource1     = [[NSMutableArray alloc] init];
    _dataSource2     = [[NSMutableArray alloc] init];
    _dataSource3     = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++) {
        
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.tag        = i;
        tableView.delegate   = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight  = 100;
        tableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        [_tableViewArray addObject:tableView];
        
        MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
        [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        
        tableView.mj_header = header;
        tableView.mj_footer = footer;
    }
    
    _scView = [[LXSegmentScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                              titleArray:@[@"全部",@"进行中",@"已揭晓"]
                                        contentViewArray:_tableViewArray];
    _scView.bgScrollView.delegate = self;
    _scView.backgroundColor = [UIColor grayColor];
    _currentTableView = (UITableView *)[_tableViewArray objectAt:0];
    
    [self.view addSubview:_scView];

    [self.currentTableView.mj_header beginRefreshing];
    [self startTimer];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        
        if (_dataSource1.count == 0) {
            _noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
            [_noNetView.updateButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            [self.endTableView addSubview:_noNetView];
        }
    }else{
        [_noNetView removeFromSuperview];
    }
    
    //FINISH UPLOAD ADDRESS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(luckyRecordRefreshAC:) name:@"luckyRecordRefresh" object:nil];
}


- (void)luckyRecordRefreshAC:(NSNotification *)notification{
    
    NSDictionary *notiDic = (NSDictionary *)[notification object];
    
    //NSLog(@"%@",notiDic);
    NSString *fangID = [NSString stringWithFormat:@"%@",notiDic[@"fangId"]];
    for (int i=0; i<_dataSource1.count; i++) {
        NSDictionary *dic = _dataSource1[i];
        NSLog(@"shuju --- %@",dic);
        NSString *curFangID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        if ([fangID integerValue] == [curFangID integerValue]) {
            NSMutableDictionary *currentDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            //NSLog(@"changedLucky --- %@",currentDic);
            [currentDic setValue:@"processing" forKey:@"delivery_status"];
            [_dataSource1 removeObjectAtIndex:i];
            [_dataSource1 insertObject:currentDic atIndex:i];
        }
    }
    
}




- (void)refresh {
    [self.endTableView.mj_header beginRefreshing];
}


#pragma mark - dataSource
//刷新数据
- (void)loadDataSource {
    
    //*** 全部 ***//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSString     *urlStr0 = [[NSString stringWithFormat:@"%@/user/biu-record",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param0  = @{@"page":@1,
                              @"filter":@"all"};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr0 withParaments:param0 withSuccessBlock:^(NSDictionary *object) {
        
        [_noNetView removeFromSuperview];
        if (_dataSource1.count > 0) {
            [_dataSource1 removeAllObjects];
        }
        
        _page1 = 2;
        NSArray *dataArray = object[@"data"][@"items"];
        [_dataSource1 addObjectsFromArray:dataArray];
        
        //NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~11111111   %@",_dataSource1);
        
        if (_totalLastTime1.count > 0) {
            [_totalLastTime1 removeAllObjects];
        }
        
        for (int i = 0; i < _dataSource1.count; i++) {
            
            NSInteger luckyTime = [[_dataSource1 objectAt:i][@"lucky_time"] integerValue];
            NSInteger serveTime = [object[@"status"][@"time"] integerValue];
            NSInteger timeStamp = luckyTime - serveTime;
            
            NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%i",i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
            [_totalLastTime1 addObject:dic];
        }
        
        [(UITableView *)[_tableViewArray objectAt:0] reloadData];
        [self.currentTableView.mj_header endRefreshing];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentTableView.mj_header endRefreshing];
        
    } progress:^(float progress) {}];
    
    
    //*** 进行中 ***//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSString     *urlStr1 = [[NSString stringWithFormat:@"%@/user/biu-record",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param1  = @{@"page":@1,
                              @"filter":@"processing"};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr1 withParaments:param1 withSuccessBlock:^(NSDictionary *object) {

        if (_dataSource2.count > 0) {
            [_dataSource2 removeAllObjects];
        }
        
        _page2 = 2;
        NSArray *dataArray = object[@"data"][@"items"];
        [_dataSource2 addObjectsFromArray:dataArray];
        
        //NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~2222222   %@",_dataSource2);
        
        if (_totalLastTime2.count > 0) {
            [_totalLastTime2 removeAllObjects];
        }
        
        for (int i = 0; i < _dataSource2.count; i++) {
            
            NSInteger luckyTime = [[_dataSource1 objectAt:i][@"lucky_time"] integerValue];
            NSInteger serveTime = [object[@"status"][@"time"] integerValue];
            NSInteger timeStamp = luckyTime - serveTime;
            
            NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%i",i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
            [_totalLastTime2 addObject:dic];
        }
        [(UITableView *)[_tableViewArray objectAt:1] reloadData];
        
    } withFailureBlock:^(NSError *error) {
    } progress:^(float progress) {}];
    
    
    //*** 已揭晓 ***////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    NSString     *urlStr2 = [[NSString stringWithFormat:@"%@/user/biu-record",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param2  = @{@"page":@1,
                              @"filter":@"end"};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr2 withParaments:param2 withSuccessBlock:^(NSDictionary *object) {

        if (_dataSource3.count > 0) {
            [_dataSource3 removeAllObjects];
        }
        
        _page3 = 2;
        NSArray *dataArray = object[@"data"][@"items"];
        [_dataSource3 addObjectsFromArray:dataArray];
        
        NSLog(@"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~3333333   %@",_dataSource3);
        
        [(UITableView *)[_tableViewArray objectAt:2] reloadData];
        
    } withFailureBlock:^(NSError *error) {
    } progress:^(float progress) {}];
    
    [self.currentTableView.mj_footer endRefreshing];
}

//加载更多数据
- (void)loadMoreData {
        
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/user/biu-record",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = nil;
    if (_currentTableView.tag == 0) {
    
        param  = @{@"filter":@"all",@"page":[NSNumber numberWithInteger:_page1]};
    } else if (_currentTableView.tag == 1) {
    
        param  = @{@"filter":@"processing",@"page":[NSNumber numberWithInteger:_page2]};
    } else {
    
        param  = @{@"filter":@"end",@"page":[NSNumber numberWithInteger:_page3]};
    }
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"homeDataSource : %@",object);
        NSInteger totalCount = [object[@"data"][@"total"] integerValue];
        
        ////////////////////////////////////////////
        if (_currentTableView.tag == 0) {
            
            if (_dataSource1.count < totalCount) {
                
                _page1++;
                NSArray        *dataArray = object[@"data"][@"items"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                [tempArray addObjectsFromArray:_dataSource1];
                [tempArray addObjectsFromArray:dataArray];
                _dataSource1 = tempArray;
                
                for (int i = 0; i < dataArray.count; i++) {
                    
                    NSInteger luckyTime = [[dataArray objectAt:i][@"lucky_time"] integerValue];
                    NSInteger serveTime = [object[@"status"][@"time"] integerValue];
                    NSInteger timeStamp = luckyTime - serveTime;
                    
                    NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%ld",_totalLastTime1.count + i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
                    [_totalLastTime1 addObject:dic];
                }
                [self.currentTableView reloadData];
                [self.currentTableView.mj_footer endRefreshing];
        
            } else {
                [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else if (_currentTableView.tag == 1) {
            
            if (_dataSource2.count < totalCount) {
                
                _page2++;
                NSArray        *dataArray = object[@"data"][@"items"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                [tempArray addObjectsFromArray:_dataSource2];
                [tempArray addObjectsFromArray:dataArray];
                _dataSource2 = tempArray;
                
                for (int i = 0; i < dataArray.count; i++) {
                    
                    NSInteger luckyTime = [[dataArray objectAt:i][@"lucky_time"] integerValue];
                    NSInteger serveTime = [object[@"status"][@"time"] integerValue];
                    NSInteger timeStamp = luckyTime - serveTime;
                    
                    NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%ld",_totalLastTime2.count + i],@"lastTime":[NSString stringWithFormat:@"%ld",timeStamp > 0 ? timeStamp : 0]};
                    [_totalLastTime2 addObject:dic];
                }
                [self.currentTableView reloadData];
                [self.currentTableView.mj_footer endRefreshing];
                
            } else {
                [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else {
            
            if (_dataSource3.count < totalCount) {
                
                _page3++;
                NSArray        *dataArray = object[@"data"][@"items"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                [tempArray addObjectsFromArray:_dataSource3];
                [tempArray addObjectsFromArray:dataArray];
                _dataSource3 = tempArray;
                
                [self.currentTableView reloadData];
                [self.currentTableView.mj_footer endRefreshing];

            } else {
                [self.currentTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        ////////////////////////////////////////////
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentTableView.mj_footer endRefreshing];
        
    } progress:^(float progress) {}];

}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView.tag == 0) {
        return _dataSource1.count;
    } else if (tableView.tag == 1){
        return _dataSource2.count;
    } else {
        return _dataSource3.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return SCREEN_WIDTH/2.17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0) {
        
        //*** 全部 ***//
        BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:[_dataSource1 objectAt:indexPath.row]];
        
        NSString *cellid = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        //*** biu房中 ***//
        BFMyLuckyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[BFMyLuckyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            [cell setValueWithModel:model];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.biuBtn.tag = indexPath.row;
        [cell.biuBtn addTarget:self action:@selector(biuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.timeLable.text = [self lessSecondToDay:[[[_totalLastTime1 objectAtIndex:indexPath.row] objectForKey:@"lastTime"] integerValue]];
        
        return cell;

        
    }else if (tableView.tag == 1) {
        
        //*** 进行中 ***//
        BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:[_dataSource2 objectAt:indexPath.row]];
        
        NSString *cellid = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        //*** biu房中 ***//
        BFMyLuckyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[BFMyLuckyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            [cell setValueWithModel:model];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.biuBtn.tag = indexPath.row;
        [cell.biuBtn addTarget:self action:@selector(biuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.timeLable.text = [self lessSecondToDay:[[[_totalLastTime2 objectAtIndex:indexPath.row] objectForKey:@"lastTime"] integerValue]];
        
        return cell;
        
    } else {
    
        //*** 已揭晓 ***//
        BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:[_dataSource3 objectAt:indexPath.row]];
        
        NSString *cellid = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        //*** biu房中 ***//
        BFMyLuckyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell=[[BFMyLuckyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            [cell setValueWithModel:model];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeLable.text = @"00:00:00";
        
        cell.biuBtn.tag = indexPath.row;
        [cell.biuBtn addTarget:self action:@selector(biuAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.biuAgainBtn.tag = indexPath.row;
        [cell.biuAgainBtn addTarget:self action:@selector(biuAgainAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MyBiuRecordPageGoodsClick"];
    
    NSDictionary *selectedDic = nil;
    if (tableView.tag == 0) {
        selectedDic = [_dataSource1 objectAt:indexPath.row];
    } else if (tableView.tag == 1) {
        selectedDic = [_dataSource2 objectAt:indexPath.row];
    } else {
        selectedDic = [_dataSource3 objectAt:indexPath.row];
    }
    
    BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
    awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
    awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
    awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
    awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
    awardOrderDetailVC.awardTypeBool    = YES;
    awardOrderDetailVC.isMyselfBiuRecord= YES;
    awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
    awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
    
    
    NSString *fangStatus                = [NSString stringWithFormat:@"%@",selectedDic[@"status"]];
    awardOrderDetailVC.fang_Status      = [NSString stringWithFormat:@"%@",selectedDic[@"status"]];
    
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
    NSString *winnerID = [NSString stringWithFormat:@"%@",selectedDic[@"winner"][@"id"]];
    
    if ([fangStatus isEqualToString:@"3"]) {
        awardOrderDetailVC.winner_ID  = [NSString stringWithFormat:@"%@",selectedDic[@"winner"][@"id"]];
        if ([winnerID integerValue] == [userID integerValue]) {
            awardOrderDetailVC.isShow = YES;
            NSString *delivery_status = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
            NSString *delivery_type   = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
            
            if ([delivery_type isEqualToString:@"manual"]) {
                [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
            }else{
                if ([delivery_status isEqualToString:@"none"]) {
                    [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
                }else{
                    BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
                    writeAddressAndOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
                    writeAddressAndOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
                    writeAddressAndOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
                    writeAddressAndOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
                    writeAddressAndOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
                    writeAddressAndOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
                    [self.navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
                }
            }
        }else{
            [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
        }
    }else{
        
        [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
    }
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    [_scView.segmentToolView updateselectLineFrameWithoffset:point.x];
    
    
    if (_scView.bgScrollView.contentOffset.x == 0 ||
        _scView.bgScrollView.contentOffset.x == SCREEN_WIDTH ||
        _scView.bgScrollView.contentOffset.x == SCREEN_WIDTH * 2) {
        
        
        NSInteger currentPage = _scView.bgScrollView.contentOffset.x/SCREEN_WIDTH;
        _currentTableView = (UITableView *)[_tableViewArray objectAt:currentPage];
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger currentPage = _scView.bgScrollView.contentOffset.x/SCREEN_WIDTH;
    if (currentPage == 0 || currentPage == 1 || currentPage == 2) {
        
        _currentTableView = (UITableView *)[_tableViewArray objectAt:currentPage];
    }
    
    if (scrollView == _scView.bgScrollView) {
        
        NSInteger p=_scView.bgScrollView.contentOffset.x/SCREEN_WIDTH;
        _scView.segmentToolView.defaultIndex=p+1;
    }
}


#pragma mark - 倒计时
- (void)startTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime2) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime {
    
    ///////////////////////////////////tableView1
    NSInteger time1;
    for (int i = 0; i < _totalLastTime1.count; i++) {
        
        time1 = [[[_totalLastTime1 objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        BFMyLuckyViewCell *cell1 = (BFMyLuckyViewCell *)[(UITableView *)[_tableViewArray objectAt:0] cellForRowAtIndexPath:indexPath];
        
        --time1;
        if (time1 > 0) {
                
                cell1.timeLable.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:time1]];
                NSDictionary *dic1 = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time1]};
                [_totalLastTime1 replaceObjectAtIndex:i withObject:dic1];
            
        } else if (time1 == 0){
            
            cell1.timeLable.text = @"00:00:00";
            
            NSDictionary *dic1 = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time1]};
            [_totalLastTime1 replaceObjectAtIndex:i withObject:dic1];
            
            //*** 刷新当前cell ***//
            NSString     *urlStr1 = [[NSString stringWithFormat:@"%@/fang/get-winner",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *param1  = @{@"fang_id":[NSString stringWithFormat:@"%@",[_dataSource1 objectAt:i][@"id"]]};
            [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr1 withParaments:param1 withSuccessBlock:^(NSDictionary *object) {
                
                
                NSLog(@"获奖者：%@",object);
                if ([[NSString stringWithFormat:@"%@",object[@"status"][@"state"]] isEqualToString:@"success"]) {
                    
                    //已揭晓
                    cell1.timeView.alpha = 0;
                    cell1.progressView.alpha = 0;
                    cell1.winnerLable.alpha = 1;
                    cell1.winnerJoinLable.alpha = 1;
                    
                    cell1.winnerLable.text     = [NSString stringWithFormat:@"获奖者：%@",object[@"data"][@"nickname"]];
                    cell1.winnerJoinLable.text = [NSString stringWithFormat:@"购买人次：%@",object[@"data"][@"quantity"]];
                }
                
            } withFailureBlock:^(NSError *error) {
                NSLog(@"%@",error);
            } progress:^(float progress) {}];
        }
    }
}

- (void)refreshLessTime2 {
    
    /////////////////////////////////tableView2
    NSInteger time2;
    for (int i = 0; i < _totalLastTime2.count; i++) {

        time2 = [[[_totalLastTime2 objectAtIndex:i] objectForKey:@"lastTime"] integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        BFMyLuckyViewCell *cell2 = (BFMyLuckyViewCell *)[(UITableView *)[_tableViewArray objectAt:1] cellForRowAtIndexPath:indexPath];

        --time2;
        if (time2 > 0) {

            if (time2 > 0) {

                cell2.timeLable.text = [NSString stringWithFormat:@"%@",[self lessSecondToDay:time2]];
                NSDictionary *dic2 = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time2]};
                [_totalLastTime1 replaceObjectAtIndex:i withObject:dic2];
            }

        } else if (time2 == 0){

            cell2.timeLable.text = @"00:00:00";

            NSDictionary *dic2 = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time2]};
            [_totalLastTime1 replaceObjectAtIndex:i withObject:dic2];

            //*** 刷新当前cell ***//
            NSString     *urlStr2 = [[NSString stringWithFormat:@"%@/fang/get-winner",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *param2  = @{@"fang_id":[NSString stringWithFormat:@"%@",[_dataSource2 objectAt:i][@"id"]]};
            [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr2 withParaments:param2 withSuccessBlock:^(NSDictionary *object) {


                NSLog(@"获奖者：%@",object);
                if ([[NSString stringWithFormat:@"%@",object[@"status"][@"state"]] isEqualToString:@"success"]) {

                    //已揭晓
                    cell2.timeView.alpha = 0;
                    cell2.progressView.alpha = 0;
                    cell2.winnerLable.alpha = 1;
                    cell2.winnerJoinLable.alpha = 1;
                    
                    cell2.winnerLable.text     = [NSString stringWithFormat:@"获奖者：%@",object[@"data"][@"nickname"]];
                    cell2.winnerJoinLable.text = [NSString stringWithFormat:@"购买人次：%@",object[@"data"][@"quantity"]];
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
    NSInteger second = (NSInteger)(seconds % 60);
    
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
    tipsLable.text = @"老爷！您还没有Biu过房";
    [emptyView addSubview:tipsLable];
    
    return emptyView;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}



#pragma mark - cuntomMethod
- (void)biuAction: (UIButton *)sender {
    
    
    NSDictionary *selectedDic = nil;
    if(self.currentTableView.tag == 0) {
        selectedDic = [_dataSource1 objectAt:sender.tag];
    }else if (self.currentTableView.tag == 1) {
        selectedDic = [_dataSource2 objectAt:sender.tag];
    }else {
        selectedDic = [_dataSource3 objectAt:sender.tag];
    }

    NSLog(@"%@",selectedDic);
    
    self.fangID = selectedDic[@"id"];
    self.settlementSelectCountView.fang_id  = self.fangID;
    self.settlementSelectCountView.delegate = self;
    [self.settlementSelectCountView settlementShow];
}

#pragma mark - BFSettlementDelegate
-(void)settlementHaveSelectOrderCount:(NSString *)orderText totalPrice:(NSInteger)totalPriceCount onWech:(NSString *)onLine redArray:(NSArray *)redmoneyArray title:(NSString *)fangTitle sn:(NSString *)fang_sn url:(NSString *)fang_url{
    NSLog(@"%@",fang_sn);
    BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    [orderVC setHidesBottomBarWhenPushed:YES];
    orderVC.fang_id            = self.fangID;
    orderVC.orderCount         = orderText;
    orderVC.totalPriceCountStr = [NSString stringWithFormat:@"%ld",(long)totalPriceCount];
    orderVC.isWechatonLine     = onLine;
    orderVC.redmoneyArray      = redmoneyArray;
    orderVC.fang_title         = fangTitle;
    orderVC.fang_sn            = fang_sn;
    orderVC.fang_url           = fang_url;
    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)biuAgainAction: (UIButton *)sender {
    
    NSDictionary *selectedDic = nil;
    if (self.currentTableView.tag == 0) {
        selectedDic = [_dataSource1 objectAt:sender.tag];
    }else if (self.currentTableView.tag == 1) {
        selectedDic = [_dataSource2 objectAt:sender.tag];
    }else {
        selectedDic = [_dataSource3 objectAt:sender.tag];
    }
    NSLog(@"%@",selectedDic);
    
    
    self.fangID = selectedDic[@"next_period"];
    self.settlementSelectCountView.fang_id  = self.fangID;
    self.settlementSelectCountView.delegate = self;
    [self.settlementSelectCountView settlementShow];
}


//lazy
-(BFSettlementSelectCountView *)settlementSelectCountView{
    if (_settlementSelectCountView==nil) {
        _settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
    }
    return _settlementSelectCountView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
