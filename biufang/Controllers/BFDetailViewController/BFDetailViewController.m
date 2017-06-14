//
//  BFDetailViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/9/30.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFDetailViewController.h"
#import "BFDetailView.h"

#import "BFDetailViewTopCell.h"
#import "BFDetailViewProgressCell.h"
#import "BFDetailViewJoinCell.h"
#import "BFDetailViewTimeCell.h"
#import "BFDetailViewWinnerCell.h"
#import "BFDetailViewBuyTitleCell.h"
#import "BFDetailViewFootCell.h"
#import "BFDetailBuyCell.h"

#import "BFShareView.h"
#import "BFSettlementSelectCountView.h"
#import "BFHouseViewController.h"
#import "BFMakeOrderViewController.h"
#import "BFBiuNumbersViewController.h"
#import "BFIssueRecordViewController.h"
#import "BFDetailRuleViewController.h"
#import "BFLuckyNumViewController.h"
#import "BFShowViewController.h"
#import "BFAwardOrderDetailViewController.h"
#import "BFShareOrderViewController.h"

#import "JLPhotoBrowser.h"
#import "JLImageListView.h"

#import "BFRightAddressAndOrderDetailViewController.h"

@interface BFDetailViewController ()<BFShareViewDelegate, ZYBannerViewDelegate,
                                     UITableViewDelegate, UITableViewDataSource,BFSettlementSelectCountDelegate>
{
    BOOL isRemove;
}

@property (nonatomic, strong) BFDetailView  *currentView;
@property (nonatomic, strong) UIView        *whiteView;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSMutableDictionary       *dataSource;
@property (nonatomic, strong) NSMutableArray            *infoSource; //商品信息
@property (nonatomic, strong) NSMutableArray            *biuRecord;  //参与记录
@property (nonatomic, assign) BOOL isStop;
@property (nonatomic, assign) BOOL topPage;
@property (nonatomic, assign) BOOL isShowNav;
@property (nonatomic, assign) BOOL cellAnimation;
@property (nonatomic, assign) BOOL refreshSignal;
@property (nonatomic, assign) BOOL isStartTimer;
@property (nonatomic, assign) BOOL isPublishWinner;
@property (nonatomic, strong) UIButton  *btn;
@property (nonatomic, strong) NSArray   *biuNumbers;
@property (nonatomic, strong) NSArray   *limitNumbers;
@property (nonatomic, assign) NSInteger timeLess;     //倒计时
@property (nonatomic, assign) NSInteger page;

//shareaView
@property (nonatomic , strong) BFShareView *shareView;
@property (nonatomic , copy)   NSString *fang_sn;


//settlementView
@property (nonatomic , strong) BFSettlementSelectCountView *settlementSelectCountView;

@end

@implementation BFDetailViewController

#pragma mark - lifeCycle
- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentView = [[BFDetailView alloc] initWithFrame:SCREEN_BOUNDS];
    self.currentView.detailTableView.delegate = self;
    self.currentView.detailTableView.dataSource = self;
    self.view = self.currentView;
    
    //加载时白色蒙版
    self.whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.whiteView];
    
    [self.currentView.backBtn      addTarget:self action:@selector(backAction)  forControlEvents:UIControlEventTouchUpInside];
    [self.currentView.shareBtn     addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hud];
    [self startTimer];

    _isStop    = NO;
    _topPage   = YES;
    _isShowNav = NO;
    _page      = 1;
    
    _dataSource = [[NSMutableDictionary alloc] init];
    _biuRecord  = [[NSMutableArray alloc] init];
    [self setMJRefreshConfig];
    
    
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FangDetailPageLoginNextAc)   name:@"FangDetailPageLoginNextAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBackToForeGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DetailBiuNumbersLoginNextAc) name:@"DetailBiuNumbersLoginNextAction" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    //** 图片全透  **//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];

    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"GoodsDetailPage"];
    
    isRemove = NO;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"www");
    if (_refreshSignal) {
        [self loadDataSource];
    }
    _refreshSignal = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"GoodsDetailPage"];
    
    if (isRemove) {
        NSLog(@"no remove");
    }else{

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FangDetailPageLoginNextAction" object:nil];
    }
}


- (void)willBackToForeGround {
    
    //*** 每次从后台返回前台都要刷新 ***//
    [self loadDataSource];
}


//配置MJRefresh
- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadRecord)];

    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.currentView.detailTableView.mj_header = header;
    self.currentView.detailTableView.mj_footer = footer;
    [self loadDataSource];
}

#pragma mark - loadDataSource
//刷新数据
- (void)loadDataSource {
    
    
    //***商品信息***//
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/profile",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = @{@"id":_detailId};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        _dataSource = (NSMutableDictionary *)object[@"data"];
        //NSLog(@"detailDatasource : %@",_dataSource);
        
        self.fang_sn = _dataSource[@"sn"];
        
        if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"2"] &&
            ![[NSString stringWithFormat:@"%@",_dataSource[@"lucky_time"]] isEqualToString:@"0"]) {
            
            NSInteger luckTime = [[NSString stringWithFormat:@"%@",_dataSource[@"lucky_time"]] integerValue];
            NSInteger nowTime  = [[NSString stringWithFormat:@"%@",object[@"status"][@"time"]] integerValue];
            _timeLess = (luckTime - nowTime) > 0 ? (luckTime - nowTime) : 0;
        }
        
        [self changeBtnStatus];
        [self.currentView.detailTableView reloadData];
        [self.currentView.detailTableView.mj_header endRefreshing];
        
        
        [UIView animateWithDuration:0.28 animations:^{
            [self.hud hide:YES];
            self.whiteView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.whiteView removeFromSuperview];
        }];
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentView.detailTableView.mj_header endRefreshing];
        
        [self.hud hide:YES];
        
        [self showProgress:@"网络异常，请稍后再试"];
        [self backAction];
        
    } progress:^(float progress) {}];
    
    
    
    
    //***biu号码***//
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        NSString     *urlStr2 = [NSString stringWithFormat:@"%@/fang/biu-numbers",API];
        NSDictionary *parame2 = @{@"fang_id":_detailId};
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr2 withParaments:parame2 withSuccessBlock:^(NSDictionary *object) {
            
            NSLog(@"biuNumber %@",object);
            
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            [tmpArray addObjectsFromArray:object[@"data"][@"biu_numbers"][@"get"]];
            [tmpArray addObjectsFromArray:object[@"data"][@"biu_numbers"][@"order"]];
            _biuNumbers  = tmpArray;
            
            NSMutableArray *tmpArray2 = [[NSMutableArray alloc] init];
            [tmpArray2 addObjectsFromArray:object[@"data"][@"biu_numbers"][@"give"]];
            [tmpArray2 addObjectsFromArray:object[@"data"][@"biu_numbers"][@"order"]];
            _limitNumbers = tmpArray2;
            
            [self changeBtnStatus];
            
            //*** 一个section刷新 ***//
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
            [self.currentView.detailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            
            [self.hud hide:YES];
            [self backAction];
        } progress:^(float progress) {}];
    }
    
    [self.currentView.detailTableView.mj_footer endRefreshing];
}

//加载更多参与记录
- (void)loadRecord {
    
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-record",API];
    NSDictionary *param  = @{@"fang_id":_dataSource[@"id"],
                             @"page":[NSNumber numberWithInteger:_page]};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        

        NSLog(@"homeDataSource : %@",object);
        NSInteger totalCount = [object[@"data"][@"record"][@"total"] integerValue];
        
        if (_biuRecord.count < totalCount) {
            
            _page++;
            NSArray *dataArray = object[@"data"][@"record"][@"items"];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            [tempArray addObjectsFromArray:_biuRecord];
            [tempArray addObjectsFromArray:dataArray];
            _biuRecord = tempArray;
            
            [self.currentView.detailTableView reloadData];
            
            //NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:6];
            //[self.currentView.detailTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.currentView.detailTableView.mj_footer endRefreshing];

        } else {
            
            NSLog(@"没有更多数据了");
            [self.currentView.detailTableView.mj_footer endRefreshingWithNoMoreData];
            
        }
        
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.currentView.detailTableView.mj_footer endRefreshing];
    } progress:^(float progress) {}];
}



#pragma mark - ZYBannerViewDataSource && ZYBannerViewDelegate

- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index{

    NSArray *tmpArray = (NSArray *)_dataSource[@"meta"][@"album"];
    
    NSMutableArray *photos = [NSMutableArray array];
    UIImageView    *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/1.34)];
    
    for (int i=0; i < tmpArray.count; i++) {
        
        UIImageView *child = imgView;
        JLPhoto *photo = [[JLPhoto alloc] init];
        photo.sourceImageView = child;
        
        NSString *url = [NSString stringWithFormat:@"%@%@",_dataSource[@"meta"][@"cdn_prefix"],[tmpArray objectAt:i]];
        photo.bigImgUrl = url;
        [photos addObject:photo];
    }
    
    if (photos.count > 1) {
        
        JLPhotoBrowser *photoBrowser = [[JLPhotoBrowser alloc] init];
        photoBrowser.photos = photos;
        photoBrowser.currentIndex = (int)index;
        [photoBrowser show];
    }
}

- (void)bannerFooterDidTrigger:(ZYBannerView *)banner {
    
    BFHouseViewController *detailVc = [[BFHouseViewController alloc] init];
    detailVc.webUrl = [NSString stringWithFormat:@"%@%@",_dataSource[@"meta"][@"cdn_prefix"],_dataSource[@"meta"][@"detail"]];
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark - UITableView Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1 || section == 2 || section == 3 || section == 6) {
        return 0.00001;
    } else {
        return 10;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 5) {
        return 3;
    } else if (section == 6) {
        return _biuRecord.count + 1;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return SCREEN_WIDTH/1.34 + SCREEN_WIDTH/5.51;
            break;
        case 1:
            
            //*** 进度条 ***//
            if (([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"1"] ||
                [[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"2"]) &&
                [[NSString stringWithFormat:@"%@",_dataSource[@"lucky_time"]] isEqualToString:@"0"]) {
                return SCREEN_WIDTH/7.5;
            } else {
                return 0;
            }
            break;
        case 2:
            //*** 倒计时 ***//
            if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"2"] &&
                ![[NSString stringWithFormat:@"%@",_dataSource[@"lucky_time"]] isEqualToString:@"0"]) {
                return SCREEN_WIDTH/5 + 10;
            } else {
                return 0;
            }
            break;
        case 3: {
            
            //BFDetailViewInfoCell *cell = (BFDetailViewInfoCell *)[self tableView:self.currentView.detailTableView cellForRowAtIndexPath:indexPath];
            //return cell.frame.size.height;
            
            //*** 用户参与情况 ***//
            if (_biuNumbers.count > 0) {
                return SCREEN_WIDTH/5.13;
            } else {
                return SCREEN_WIDTH/9.375;
            }
        }
            break;
        case 4:
            //*** 获奖者 ***//
            if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"3"]) {
                
                return SCREEN_WIDTH/2.5;
            } else {
                return 0;
            }
            break;
        case 5:
            
            return SCREEN_WIDTH/8.4;
            break;
        case 6:
            if (indexPath.row == 0) {
                return SCREEN_WIDTH/9.375;
            } else {
                return SCREEN_WIDTH/5.75;
            }
            break;
        default:
            return 0;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIndentifire = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    if (indexPath.section == 0) {
        
        //*** cycleView ***//
        BFDetailViewTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            cell.cycleView.delegate   = self;
        }

        [cell setValueWithDic:_dataSource];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1){
        
        //*** 进度条 ***//
        BFDetailViewProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        [cell setValueWithDic:_dataSource];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2){
        
        //*** 倒计时 ***//
        BFDetailViewTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        cell.snLable.text   = [NSString stringWithFormat:@"期号：%@",_dataSource[@"sn"]];
        cell.timeLable.text = [self lessSecondToDay:_timeLess];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 3){
        
        
        //*** 用户参与情况 ***//
        BFDetailViewJoinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewJoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        [cell setValueWithArray:_biuNumbers];
        [cell.moreBtn addTarget:self action:@selector(myBiuNumber) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    } else if (indexPath.section == 4){
        
        //*** 用户获奖信息 ***//
        BFDetailViewWinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewWinnerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setValueWithDic:_dataSource];
        [cell.checkBtn addTarget:self action:@selector(toLuckyView) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }  else if (indexPath.section == 5){
        
        //*** 往期，晒单，图文 ***//
        BFDetailViewFootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFDetailViewFootCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        NSInteger num = [[NSString stringWithFormat:@"%@",_dataSource[@"quota"]] integerValue] - [[NSString stringWithFormat:@"%@",_dataSource[@"stock"]] integerValue];
        NSDictionary *info = @{@"index":[NSString stringWithFormat:@"%ld",(long)indexPath.row],
                               @"num":[NSNumber numberWithInteger:num]};
        [cell setValueWithDic:info];
        
        return cell;
        
    } else {

        //*** 参与记录 ***//
        if (indexPath.row == 0) {
        
            BFDetailViewBuyTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
            if (!cell) {
                cell = [[BFDetailViewBuyTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            }
            [cell setValueWithArray:(NSArray *)_biuRecord];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
        
            BFDetailBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
            if (!cell) {
                cell = [[BFDetailBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            }
            [cell setValueWithDic:[_biuRecord objectAt:indexPath.row - 1]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}


//登录Next
- (void)DetailBiuNumbersLoginNextAc{
    
    BFBiuNumbersViewController *biuNumView = [[BFBiuNumbersViewController alloc] init];
    biuNumView.fangID = _detailId;
    if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"1"]) {
        
        //*** biu房中 ***//
        biuNumView.fangStatus = @"1";
        
    } else if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"2"]) {
        
        //*** 揭晓中 ***//
        biuNumView.fangStatus = @"2";
    } else if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"3"]) {
        
        //*** 已揭晓 ***//
        biuNumView.fangStatus = @"3";
    } else {
        
    }
    [self.navigationController pushViewController:biuNumView animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 5) {
        
        if (indexPath.row == 0) {
            
            //往期揭晓

        } else if (indexPath.row == 1) {
            
            //晒单分享
//            BFShowViewController *showView = [[BFShowViewController alloc] init];
//            showView.dataSource = _dataSource;
//            showView.webUrl = [NSString stringWithFormat:@"%@%@",_dataSource[@"meta"][@"cdn_prefix"],_dataSource[@"meta"][@"show"]];
//            [self.navigationController pushViewController:showView animated:YES];

            BFShareOrderViewController *shareView = [[BFShareOrderViewController alloc] init];
            [self.navigationController pushViewController:shareView animated:YES];
            
        } else {
            
            //图文详情
            BFHouseViewController *detailVc = [[BFHouseViewController alloc] init];
            detailVc.webUrl = [NSString stringWithFormat:@"%@%@",_dataSource[@"meta"][@"cdn_prefix"],_dataSource[@"meta"][@"detail"]];
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
}

// cell animation
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_cellAnimation) {
        
        if (_dataSource.count > 0) {
            
            if (indexPath.section == 1 || indexPath.section == 2) {
                cell.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
                
                [UIView animateWithDuration:0.38 animations:^{
                    cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
                }];
            }
        }
        if (indexPath.section == 2) {
            _cellAnimation = YES;
        }
    }
}



#pragma mark - customMethod
- (void)backAction {
    
    //remove noti - bug
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FangDetailPageLoginNextAction" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//计算详情
- (void)toLuckyView {
    
    BFLuckyNumViewController *luckyView = [[BFLuckyNumViewController alloc] init];
    luckyView.dataSource = _dataSource;
    [self.navigationController pushViewController:luckyView animated:YES];
}

//查看我的biu号码
- (void)myBiuNumber {

    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"GoodsDetailPageMyBiuRecordClick"];
        
        /*跳转逻辑*/
        NSDictionary *selectedDic = _dataSource;
        
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
        
        if ([fangStatus isEqualToString:@"3"]) {
            
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
            NSString *winnerID = [NSString stringWithFormat:@"%@",selectedDic[@"winner"][@"id"]];
            
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
        
    }else{
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        loginRegVC.entranceType = @"DetailBiuNumbers";
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}


#pragma mark - 登录Next
- (void)FangDetailPageLoginNextAc{
    
    isRemove = NO;
    
    NSLog(@"登录Next111");
    self.settlementSelectCountView.fang_id  = self.detailId;
    self.settlementSelectCountView.delegate = self;
    [self.settlementSelectCountView settlementShow];
    
}

#pragma mark - Biu AC
- (void)biuAction {
    
    //NSLog(@"biu房");
    if (_isBiuRecordBool) {
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"MyBiuRecordPageGoodsRepurchase"];
    }else{
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"GoodsDetailPagePurchaseClick"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        //self.settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
        self.settlementSelectCountView.fang_id  = self.detailId;
        self.settlementSelectCountView.delegate = self;
        [self.settlementSelectCountView settlementShow];
    }else{
        isRemove = YES;
        UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
        loginView.entranceType = @"FangDetailPage";
        UINavigationController *loginNV = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self.navigationController presentViewController:loginNV animated:YES completion:nil];
    }
}


#pragma mark - BFSettlementDelegate
-(void)settlementHaveSelectOrderCount:(NSString *)orderText totalPrice:(NSInteger)totalPriceCount onWech:(NSString *)onLine redArray:(NSArray *)redmoneyArray title:(NSString *)fangTitle sn:(NSString *)fang_sn url:(NSString *)fang_url{
    NSLog(@"%@",fang_sn);
    BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    [orderVC setHidesBottomBarWhenPushed:YES];
    orderVC.fang_id            = self.detailId;
    orderVC.orderCount         = orderText;
    orderVC.totalPriceCountStr = [NSString stringWithFormat:@"%ld",(long)totalPriceCount];
    orderVC.isWechatonLine     = onLine;
    orderVC.redmoneyArray      = redmoneyArray;
    orderVC.fang_title         = fangTitle;
    orderVC.fang_sn            = fang_sn;
    orderVC.fang_url           = fang_url;
    [self.navigationController pushViewController:orderVC animated:YES];
}



- (void)shareAction {

    NSLog(@"分享");
    self.shareView = [[BFShareView alloc] initWithFrame:SCREEN_BOUNDS];
    self.shareView.delegate = self;
    [self.shareView shareShow];
}

//已揭晓底部按钮事件（拨打领奖电话 && 查看获奖信息）
- (void)publishedAction {

//    NSLog(@"拨打领奖电话");
//    NSString *telNum = [NSString stringWithFormat:@"%@",_dataSource[@"meta"][@"award_tel"]];
//    if (telNum != nil) {
//        
//        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telNum];
//        UIWebView * callWebview = [[UIWebView alloc] init];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//        [self.view addSubview:callWebview];
//    }
    
    //*** 跳转到领奖详情页面 ***//
    
    /*
     NSLog(@"Fang -- %@",_dataSource);
     */
    NSString *delivery_status               = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_status"]];
    NSString *delivery_type                 = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_type"]];
    
    NSString *fangStatus                    = [NSString stringWithFormat:@"%@",_dataSource[@"status"]];
    
    if ([delivery_type isEqualToString:@"manual"]) {
        
        BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
        awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",_dataSource[@"id"]];
        awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",_dataSource[@"cover"]];
        awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",_dataSource[@"title"]];
        awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",_dataSource[@"sn"]];
        awardOrderDetailVC.awardTypeBool    = YES;
        
        awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_type"]];
        awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_status"]];
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        NSString *winnerID = [NSString stringWithFormat:@"%@",_dataSource[@"winner"][@"id"]];
        if ([fangStatus isEqualToString:@"3"]) {
            awardOrderDetailVC.winner_ID  = [NSString stringWithFormat:@"%@",_dataSource[@"winner"][@"id"]];
            if ([winnerID integerValue] == [userID integerValue]) {
                awardOrderDetailVC.isShow = YES;
            }
        }
        [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
        
        
    }else{
    
        if ([delivery_status isEqualToString:@"none"]) {
            
            BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
            awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",_dataSource[@"id"]];
            awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",_dataSource[@"cover"]];
            awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",_dataSource[@"title"]];
            awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",_dataSource[@"sn"]];
            awardOrderDetailVC.awardTypeBool    = YES;
            
            awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_type"]];
            awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_status"]];
            
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
            NSString *winnerID = [NSString stringWithFormat:@"%@",_dataSource[@"winner"][@"id"]];
            if ([fangStatus isEqualToString:@"3"]) {
                awardOrderDetailVC.winner_ID  = [NSString stringWithFormat:@"%@",_dataSource[@"winner"][@"id"]];
                if ([winnerID integerValue] == [userID integerValue]) {
                    awardOrderDetailVC.isShow = YES;
                }
            }
            [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
            
        }else{
            
            BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
            writeAddressAndOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",_dataSource[@"id"]];
            writeAddressAndOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",_dataSource[@"cover"]];
            writeAddressAndOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",_dataSource[@"title"]];
            writeAddressAndOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",_dataSource[@"sn"]];
            writeAddressAndOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_type"]];
            writeAddressAndOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",_dataSource[@"delivery_status"]];
            [self.navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
        }
        
    }
    
    
}





//已揭晓底部按钮事件（拨打领奖电话 && 查看获奖信息）
- (void)publishedActionCheck {
    
    NSLog(@"查看获奖信息");
    BFLuckyNumViewController *luckyView = [[BFLuckyNumViewController alloc] init];
    luckyView.dataSource = _dataSource;
    [self.navigationController pushViewController:luckyView animated:YES];
}

//改变底部按钮状态
- (void)changeBtnStatus {

    [self.currentView.footBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.currentView.footBtn setUserInteractionEnabled:YES];
    [self.currentView.footBtn setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.currentView.footBtn.frame.size] forState:UIControlStateNormal];
    
    if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"1"]) {
        
        //*** biu房中 ***//
        self.currentView.footBtn.alpha = 1;
        self.currentView.publishingImageView.alpha = 0;
        
        if (_limitNumbers.count > 0 && _limitNumbers.count < [[_dataSource objectForKey:@"limit"] integerValue]) {
            //追投状态
            [self.currentView.footBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            [self.currentView.footBtn addTarget:self action:@selector(biuAction)  forControlEvents:UIControlEventTouchUpInside];
            
        } else if (_limitNumbers.count >= [[_dataSource objectForKey:@"limit"] integerValue]) {
        
            [self.currentView.footBtn setTitle:[NSString stringWithFormat:@"购买人次已达上限"] forState:UIControlStateNormal];
            [self.currentView.footBtn setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"9b9b9b"] size:self.currentView.footBtn.frame.size] forState:UIControlStateNormal];
            [self.currentView.footBtn setUserInteractionEnabled:NO];
            
        } else {
        
            [self.currentView.footBtn setTitle:@"立即购买" forState:UIControlStateNormal];
            [self.currentView.footBtn addTarget:self action:@selector(biuAction)  forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"2"]) {
    
        //*** 揭晓中 ***//
        self.currentView.footBtn.alpha = 0;
        self.currentView.publishingImageView.alpha = 1;
        
    } else if ([[NSString stringWithFormat:@"%@",_dataSource[@"status"]] isEqualToString:@"3"]) {

        //*** 已揭晓 ***//
        self.currentView.footBtn.alpha = 1;
        self.currentView.publishingImageView.alpha = 0;
        
        NSLog(@"myID %@     winnerID %@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],_dataSource[@"winner"][@"id"]);
        if (_dataSource[@"winner"] != nil &&
            [[NSString stringWithFormat:@"%@",_dataSource[@"winner"][@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]]]) {
            //自己中奖
            //[self.currentView.footBtn setTitle:[NSString stringWithFormat:@"领奖电话：%@",_dataSource[@"meta"][@"award_tel"]] forState:UIControlStateNormal];
            //[self.currentView.footBtn addTarget:self action:@selector(publishedActionCall)  forControlEvents:UIControlEventTouchUpInside];
            
            [self.currentView.footBtn setTitle:@"领取幸运商品" forState:UIControlStateNormal];
            [self.currentView.footBtn addTarget:self action:@selector(publishedAction)  forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            //别人中奖
            [self.currentView.footBtn setTitle:[NSString stringWithFormat:@"查看揭晓结果"] forState:UIControlStateNormal];
            [self.currentView.footBtn addTarget:self action:@selector(publishedActionCheck)  forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else {
    
    }
}



#pragma mark - BFShareDelegate
-(void)shareViewDidSelectButWithBtnTag:(NSInteger)btnTag{
    //NSLog(@"detailDatasource : %@",_dataSource[@"title"]);
    NSLog(@"%ld",(long)btnTag);
    switch (btnTag) {
        case 701:
            [[ShareManager defaulShaer] shareWechatSession:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            break;
        case 702:
            [[ShareManager defaulShaer] shareWechatTimeLine:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            break;
        case 703:
            
            if (![WeiboSDK isWeiboAppInstalled]){
                
                [self.shareView shareHide];
                [self showProgress:@"未安装微博客户端"];
                
            }else{
                [[ShareManager defaulShaer] shareWebo:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            }
            
            
            break;
        case 704:
            [[ShareManager defaulShaer] shareQQ:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            break;
        case 705:
            [[ShareManager defaulShaer] shareQQZone:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            break;
        case 706:
            [[ShareManager defaulShaer] shareSms:self type:@"FDS" sn:self.fang_sn token:_dataSource[@"title"] biuNumCount:@"0"];
            break;
            
        default:
            break;
    }
}


//MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tipStr;
    hud.margin = 20.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma mark - 倒计时
- (void)startTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}


- (void)refreshLessTime {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    BFDetailViewTimeCell *cell = (BFDetailViewTimeCell *)[self.currentView.detailTableView cellForRowAtIndexPath:indexPath];
    
    --_timeLess;
    if (_timeLess > 0) {
        
        cell.timeLable.text = [self lessSecondToDay:_timeLess];
    } else if (_timeLess == 0) {
    
        [self loadDataSource];
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



#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (_topPage) {
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 150) {

            self.currentView.navBarView.alpha = (scrollView.contentOffset.y)/150;
            _isShowNav = NO;
            
        } else if (scrollView.contentOffset.y <= 0) {

            self.currentView.navBarView.alpha = 0;
            _isShowNav = NO;
        } else {

            self.currentView.navBarView.alpha = 1;
            _isShowNav = YES;
        }
    }
}


- (MBProgressHUD *)hud {
    
    if (_hud == nil) {
        
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.userInteractionEnabled = NO;
        _hud.removeFromSuperViewOnHide = YES;
    }
    return _hud;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//lazy
//self.settlementSelectCountView          = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
-(BFSettlementSelectCountView *)settlementSelectCountView{
    if (_settlementSelectCountView==nil) {
        _settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
    }
    return _settlementSelectCountView;
}


@end
