//
//  ViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/9/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "HomeViewController.h"
#import "BFHomeViewCell.h"
#import "BFHomeTopCell.h"
#import "BFHomeFootCell.h"
#import "BFHomeRecommendCell.h"
#import "BFHomeView.h"
#import "BFHomeModel.h"

#import "BFDetailViewController.h"
#import "BFSelectCityViewController.h"
#import "BFMakeOrderViewController.h"
#import "BFHomeCategoryViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "BFFlashAdViewController.h"
#import "BFBannerWebViewController.h"
#import "BFNewUserViewController.h"
#import "BFBiuDetailsViewController.h"
#import "BFNewClassViewController.h" //biu币类目页
#import "BFRedEnvelopeViewController.h"
#import "BFBiuRecordViewController.h"
#import "UILogRegViewController.h"
#import "BFNewGuideViewController.h"
#import "BFSettlementSelectCountView.h"

//collectionView
#import "homeBannerViewCell.h"
#import "homeTopBtnViewCell.h"
#import "homeOperationViewCell.h"
#import "homeMenuBtnCell.h"
#import "homeGoodsViewCell.h"
#import "menuBtnHeadView.h"

#import "BFAwardOrderDetailViewController.h"
#import "BFRightAddressAndOrderDetailViewController.h"

#define NavBarFrame self.currentView.navBarView.frame

@interface HomeViewController () <ZYBannerViewDelegate,
                                  BFWinningDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDelegate,
                                  UICollectionViewDelegateFlowLayout,
                                  BFSettlementSelectCountDelegate>
{
    BOOL isCheckNotifi;
}
@property (nonatomic, strong) BFHomeView        *currentView;
@property (nonatomic, strong) MBProgressHUD     *hud;
@property (nonatomic, strong) BFNoNetView       *noNetView;     //无网络状态

@property (nonatomic, assign) NSInteger         page;           //当前分页，默认为1
@property (nonatomic, strong) NSDictionary      *winDic;        //获奖信息
@property (nonatomic, copy  ) NSString          *segmentClass;  //顶部segment菜单分类
@property (nonatomic, assign) NSInteger         segmentNum;     //顶部segment菜单分类当前点击
@property (nonatomic, copy  ) NSString          *fang_id;       //未登录状态点击购买，保存当前点击商品id,登录成功之后跳转

//dataSource数据加载判断
@property (nonatomic, assign) BOOL              isLoadMoreData;
@property (nonatomic, assign) BOOL              isNoMoreData;
@property (nonatomic, assign) BOOL              isCanSideBack;  //右滑返回允许状态
@property (nonatomic, assign) BOOL              isHidden;       //导航栏隐藏状态

//settlementView
@property (nonatomic , strong) BFSettlementSelectCountView *settlementSelectCountView;
@property (nonatomic , strong) NSString *fangID;

@end

@implementation HomeViewController

#pragma mark - lifeCycle
- (void)loadView {

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //暂时使用，待启用定位功能则删除
    [[NSUserDefaults standardUserDefaults] setObject:@"全国" forKey:CITY];
    _currentCity     = [[NSUserDefaults standardUserDefaults] objectForKey:CITY] ? [[NSUserDefaults standardUserDefaults] objectForKey:CITY] : @"全国";
    _currentCategory = @"*";
    _page            = 1;
    _isHidden        = NO;
    _segmentClass    = @"hot";
    _segmentNum      = 1;
    _isLoadMoreData  = YES;
    
    self.currentView = [[BFHomeView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.currentView;
    self.currentView.homeCollectionView.delegate   = self;
    self.currentView.homeCollectionView.dataSource = self;
    
    //城市选择按钮设定以及适配长度
    [self.currentView.leftBtn  setTitle:_currentCity forState:UIControlStateNormal];
    [self.currentView.leftBtn  addTarget:self action:@selector(selectCity)      forControlEvents:UIControlEventTouchUpInside];
    CGSize titleSize = [_currentCity sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:self.currentView.leftBtn.titleLabel.font.fontName size:self.currentView.leftBtn.titleLabel.font.pointSize]}];
    titleSize.height = 40;
    titleSize.width += 20;
    self.currentView.leftBtn.frame = CGRectMake(10, 20, titleSize.width, 40);
    [self.currentView rightImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
//    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flashAdAction:)       name:@"flashAdAction"      object:nil]; //监听闪屏广告点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCity:)          name:@"haveSelectedCity"   object:nil]; //监听城市选择事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCityView)         name:@"firstSelectCity"    object:nil]; //监听引导页开始按钮点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabbarRepeatAction:)  name:@"tabbarRepeatAction" object:nil]; //监听tabbar按钮重复点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSource)    name:@"tabbarToHome" object:nil]; //监听tabbar切换回第一屏，刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willBackToForeGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySelfLoginNextAc)    name:@"MySelfLoginNextAction"      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMyMoneyView)        name:@"MyMoneyLoginNextAction"     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMyBiuRecord)        name:@"MyBiuRecordLoginNextAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(biuActionNextAction)  name:@"homeBuyGoodNextAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDetailView:)        name:@"getWinner" object:nil]; //监听获奖点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkUpdateAndWin)    name:@"checkUpdateWinner" object:nil]; //闪屏结束检测强制更新&&获奖通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil]; //点击推送消息跳转指定页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UniversalLinkJump:)   name:@"UniversalLinkJump" object:nil]; //通用连接跳转到商品详情页
    
    
    
    _bannerArray    = [[NSMutableArray alloc] init];
    //[_bannerArray addObjectsFromArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"bannerArray"]];
    
    _dataSource     = [[NSMutableArray alloc] init];
    //NSArray *dataSourceArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"dataSource"]];
    //[_dataSource addObjectsFromArray:(NSArray *)dataSourceArray];
    
    //无网络状态
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {

        if (_dataSource.count == 0) {
            
            if (_noNetView == nil) {
                
                _noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
                [_noNetView.updateButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.currentView.homeCollectionView addSubview:_noNetView];
        }
    }else{
        [_noNetView removeFromSuperview];
    }
    
    [self setMJRefreshConfig];
    
///////////////////////////////////////////////////////////////////////////

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:IS_First]) {
//        
//        //若不是首次运行程序，定位检查当前所在城市是否改变
//        [self checkLoction];
//    } else {
//    
//        
//        //判断是否需要隐藏城市选择按钮
//        NSString *urlStr = [[NSString stringWithFormat:@"%@/fang/city-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
//            
//            NSArray *cityArray = object[@"data"][@"cities"];
//            if (cityArray.count == 1 && [[NSString stringWithFormat:@"%@",[cityArray objectAt:0]] isEqualToString:@"全国"]) {
//                
//                self.currentView.leftBtn.alpha    = 0;
//                self.currentView.rightImage.alpha = 0;
//            } else {
//                
//                self.currentView.leftBtn.alpha    = 1;
//                self.currentView.rightImage.alpha = 1;
//            }
//        } withFailureBlock:^(NSError *error) {
//        } progress:^(float progress) {}];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isCheckNotifi = YES;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
    
        [[UMManager sharedManager] accountStatistics];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"HomePage"];
    
}

- (void)refresh {
    [self.currentView.homeCollectionView.mj_header beginRefreshing];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    isCheckNotifi = NO;
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"HomePage"];
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
    //*** 强制更新检测 && 是否获奖检测 ***//
    [self checkUpdateAndWin];
    
    //*** 每次从后台返回前台都要刷新主页 ***//
    //[self.currentView.homeCollectionView.mj_header beginRefreshing];
    [self loadDataSource];
    
    //*** 推送开关***/
    if (isCheckNotifi) {
        [CheckPopingNotificationPop checkPopingNotiPop];
    }
    
}

//login next
- (void)MySelfLoginNextAc{
    
    [self.tabBarController setSelectedIndex:3];
}

//配置MJRefresh
- (void)setMJRefreshConfig {

    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    //MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.currentView.homeCollectionView.mj_header = header;
    //self.currentView.homeCollectionView.mj_footer = footer;
    [self.currentView.homeCollectionView.mj_header beginRefreshing];
}

#pragma mark - 检测更新&中奖通知
- (void)checkUpdateAndWin{
    
    //*** 收到检查强制更新 && 中奖推送 通知 ***//
    NSString *urlStr = [NSString stringWithFormat:@"%@/common/todo",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"%@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            NSString *cmdStr = [NSString stringWithFormat:@"%@",object[@"data"][@"cmd"]];
            if ([cmdStr isEqualToString:@"win"]) {
                _winDic = (NSDictionary *)object[@"data"];
                [self winingShow];
            }else if ([cmdStr isEqualToString:@"update"]) {
                [CheckStrongUpdateManage checkUpdate:self];
            }
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}


#pragma mark - dataSource
//刷新数据
- (void)loadDataSource {

    //banner广告以及运营位数据
    NSString *bannerUrlStr = [[NSString stringWithFormat:@"%@/common/home-ads",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:bannerUrlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        [_noNetView removeFromSuperview];
        
        //NSLog(@"bannerDataSource: %@",object);
        
        _bannerArray    = object[@"data"][@"banner"];
        //*** 本地数据持久化 ***//
        [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)object[@"data"][@"banner"]    forKey:@"bannerArray"];

        [self.currentView.homeCollectionView reloadData];
        [self.currentView.homeCollectionView.mj_header endRefreshing];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"error %@",error);
        [self.currentView.homeCollectionView.mj_header endRefreshing];
    } progress:^(float progress) {}];
    
    
    //商品数据
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = @{@"cate":_segmentClass,
                             @"page":@1};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        _page = 2;
        _isNoMoreData = NO;
        [_noNetView removeFromSuperview];
        if (_dataSource.count > 0) {
            [_dataSource removeAllObjects];
        }
        
        if (![[NSString stringWithFormat:@"%@",object[@"data"]] isEqualToString:@"<null>"]) {
            [_dataSource addObjectsFromArray:(NSArray *)object[@"data"][@"items"]];
        }
        
        //NSLog(@"homeDataSource : %@",object);
        
        if ([_segmentClass isEqualToString:@"hot"]) {
            
            //*** 本地数据持久化 ***//
            NSArray *dataSourceArray = [_dataSource copy];
            NSData  *dataSourceData = [NSKeyedArchiver archivedDataWithRootObject:dataSourceArray];
            [[NSUserDefaults standardUserDefaults] setObject:dataSourceData forKey:@"dataSource"];
        }

        [self.currentView.homeCollectionView reloadData];
        [self.currentView.homeCollectionView.mj_header endRefreshing];
        
    } withFailureBlock:^(NSError *error) {
        [self.currentView.homeCollectionView.mj_header endRefreshing];
    } progress:^(float progress) {}];
    
    [self.currentView.homeCollectionView.mj_footer endRefreshing];
}

//加载更多数据
- (void)loadMoreData {
    
    NSString     *urlStr    = [[NSString stringWithFormat:@"%@/fang/list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param     = @{@"cate":_segmentClass,
                                @"page":[NSNumber numberWithInteger:_page]};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        [_noNetView removeFromSuperview];
        
        if (![[NSString stringWithFormat:@"%@",object[@"data"]] isEqualToString:@"<null>"]) {
            
            NSInteger totalCount = [object[@"data"][@"total"] integerValue];
            if (_dataSource.count < totalCount) {
                
                _page++;
                _isNoMoreData = NO;
                NSArray *dataArray = object[@"data"][@"items"];
                
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                [tempArray addObjectsFromArray:_dataSource];
                [tempArray addObjectsFromArray:dataArray];
                _dataSource = tempArray;
                
                
                [self.currentView.homeCollectionView reloadData];
                [self.currentView.homeCollectionView.mj_footer endRefreshing];
                
            } else {
                
                _isNoMoreData = YES;
                [self.currentView.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
        
            _isNoMoreData = YES;
            [self.currentView.homeCollectionView.mj_footer endRefreshingWithNoMoreData];
        }
        _isLoadMoreData = YES;

    } withFailureBlock:^(NSError *error) {
        _isLoadMoreData = YES;
        [self.currentView.homeCollectionView.mj_footer endRefreshing];
    } progress:^(float progress) {}];
    
    [self.currentView.homeCollectionView.mj_footer endRefreshing];
}

//分类点击刷新数据
- (void)refreshDataSource {
    
    [self.view addSubview:self.hud];
    [self.hud show:YES];

    NSString     *urlStr    = [[NSString stringWithFormat:@"%@/fang/list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param     = @{@"cate":_segmentClass,
                                @"page":@1};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        //NSLog(@"homeDataSource : %@",object);
        _page = 2;
        _isNoMoreData = NO;
        if (_dataSource.count > 0) {
            [_dataSource removeAllObjects];
        }
        
        if (![[NSString stringWithFormat:@"%@",object[@"data"]] isEqualToString:@"<null>"]) {
            [_dataSource addObjectsFromArray:(NSArray *)object[@"data"][@"items"]];
        }

        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:4];
        [self.currentView.homeCollectionView reloadSections:indexSet];

        [self.hud removeFromSuperview];
        
    } withFailureBlock:^(NSError *error) {

        [self.hud removeFromSuperview];
        
    } progress:^(float progress) {}];
    [self.currentView.homeCollectionView.mj_footer endRefreshing];
}




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 4) {
        return _dataSource.count;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = nil;
    if (indexPath.section == 0) {
        
        //*** 顶部banner ***//
        homeBannerViewCell *bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeBannerViewCell" forIndexPath:indexPath];
        [bannerCell setValueWithArray:_bannerArray];
        bannerCell.cycleView.delegate = self;
        
        cell = bannerCell;
        
        
    } else if (indexPath.section == 1) {
    
        //*** 顶部按钮 ***//
        homeTopBtnViewCell *btnCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeTopBtnViewCell" forIndexPath:indexPath];
        [btnCell.sellBtn  addTarget:self action:@selector(bannerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnCell.rentBtn  addTarget:self action:@selector(bannerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnCell.hotelBtn addTarget:self action:@selector(bannerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnCell.guideBtn addTarget:self action:@selector(bannerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell = btnCell;
        
    } else if (indexPath.section == 2) {
        
        //*** 广播位 ***//
        homeOperationViewCell *operationCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeOperationViewCell" forIndexPath:indexPath];
        [operationCell setValueWithDic:(NSDictionary *)[_operationArray objectAt:indexPath.row]];
        cell = operationCell;
        
    } else if (indexPath.section == 3) {
        
        //*** 切换菜单按钮 ***//
        homeMenuBtnCell *menuBtnCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeMenuBtnCell" forIndexPath:indexPath];
        [menuBtnCell.hotBtn      addTarget:self action:@selector(segmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuBtnCell.lastBtn     addTarget:self action:@selector(segmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuBtnCell.progressBtn addTarget:self action:@selector(segmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [menuBtnCell.houseBtn    addTarget:self action:@selector(segmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell = menuBtnCell;
        
    } else {
        
        //*** 商品展示cell ***//
        BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:(NSDictionary *)[_dataSource objectAt:indexPath.row]];
        homeGoodsViewCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeGoodsViewCell" forIndexPath:indexPath];
        [goodsCell setValueWithModel:model];
        goodsCell.buyBtn.tag = indexPath.row;
        [goodsCell.buyBtn addTarget:self action:@selector(biuAction:) forControlEvents:UIControlEventTouchUpInside];
        cell = goodsCell;
    }
    return cell;
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/3.125 + 6);
        
    } else if (indexPath.section == 1) {
    
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/4.17);
        
    } else if (indexPath.section == 2) {
        
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/10 + 6);
        
    } else if (indexPath.section == 3) {
        
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/10);
        
    } else {
        
        return CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/1.5625);
    }
    
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    //如果是头部视图 (因为这里的kind 有头部和尾部所以需要判断  默认是头部,严谨判断比较好)
//    /*
//     JHHeaderReusableView 头部的类
//     kHeaderID  重用标识
//     */
//    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 4) {
//        menuBtnHeadView *headerRV = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"menuBtnHeadView" forIndexPath:indexPath];
//        return headerRV;
//        
//    } else {
//        return nil;
//    }
//}


#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        
        //*** 商品点击 ***//
        BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
        detailVC.detailId = [_dataSource objectAt:indexPath.row][@"id"];
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ZYBannerViewDelegate && banner广告
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index{
    
    if (banner.tag == 0) {
        
        //*** banner广告 ***//
        NSLog(@"点击了banner广告  第%ld个cell 第%ld张图片!",banner.tag,index);
        
        if (_bannerArray.count > 0) {
            
            NSDictionary *adDic = (NSDictionary *)[_bannerArray objectAt:index];
            NSLog(@"%@",adDic);
            
            //统计次数
            [UMSocialData setAppKey:UMAppKey];
            NSDictionary *dict = @{@"bannerID":adDic[@"id"]};
            [MobClick event:@"ADTopBannerClick" attributes:dict];

            
            NSString *actor = [NSString stringWithFormat:@"%@",adDic[@"actor"]];
            if ([actor isEqualToString:@"web"]) {
                
                //*** WEB ***//
                BFBannerWebViewController *bannerWebView = [[BFBannerWebViewController alloc] init];
                bannerWebView.webUrl = [NSString stringWithFormat:@"%@",adDic[@"param"]];
                [bannerWebView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:bannerWebView animated:YES];
                
            } else if (/*[actor isEqualToString:@""]*/[actor isEqualToString:@"hybird"]) {
                
                //*** 新人红包WEB ***//
                BFNewUserViewController *newWebView = [[BFNewUserViewController alloc] init];
                NSString *isLogin;
                if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
                    isLogin = @"1";
                } else {
                    isLogin = @"0";
                }
                newWebView.webUrl = [NSString stringWithFormat:@"%@",adDic[@"param"]];
                [newWebView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:newWebView animated:YES];
                
            } else if ([actor isEqualToString:@"goods_detail"]) {
                
                //*** 普通商品详情页 ***//
                BFDetailViewController *detailView = [[BFDetailViewController alloc] init];
                detailView.detailId = [NSString stringWithFormat:@"%@",adDic[@"param"]];
                [detailView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:detailView animated:YES];
                
            } else if ([actor isEqualToString:@"biu_detail"]) {
                
                //*** Biu币商品详情页 ***//
                BFBiuDetailsViewController *detailBiu = [[BFBiuDetailsViewController alloc] init];
                detailBiu.title = @"商品详情";
                detailBiu.detailID = [NSString stringWithFormat:@"%@",adDic[@"param"]];
                
                NSLog(@"idididid %@",[NSString stringWithFormat:@"%@",adDic[@"param"]]);
                [detailBiu setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:detailBiu animated:YES];
                
            } else if ([actor isEqualToString:@"goods_classify"]) {
                
                //*** 商品类目页 ***//
                BFHomeCategoryViewController *categoryView = [[BFHomeCategoryViewController alloc] init];
                if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"sell"]) {
                    categoryView.currentCity = self.currentCity;
                } else {
                    categoryView.currentCity = @"全国";
                };
                categoryView.currentCategory = [NSString stringWithFormat:@"%@",adDic[@"param"]];
                [categoryView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:categoryView animated:YES];
                
            } else if ([actor isEqualToString:@"biu_classify"]) {
                //*** Biu币类目页 ***//
                BFNewClassViewController *biuClass = [[BFNewClassViewController alloc] init];
                if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"coupon"]) {
                    
                    biuClass.styleType = @"coupon";
                    biuClass.title = @"现金券";
                } else if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"goods"]) {
                    
                    biuClass.styleType = @"goods";
                    biuClass.title = @"礼品";
                }
                [biuClass setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:biuClass animated:YES];
                
            } else if ([actor isEqualToString:@"lucky"]) {
                //*** 红包页 ***//
                if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
                    
                    BFRedEnvelopeViewController *redEnvelopeVC = [[BFRedEnvelopeViewController alloc] init];
                    [redEnvelopeVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:redEnvelopeVC animated:YES];
                    
                } else {
                
                    UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
                    UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
                    loginView.entranceType = @"MyMoney";
                    [self.navigationController presentViewController:loginNc animated:YES completion:nil];
                }
                
            } else if ([actor isEqualToString:@"mybiu_record"]) {
                //*** 我的biu房记录 ***//
                if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
                    
                    BFBiuRecordViewController *recordView = [[BFBiuRecordViewController alloc] init];
                    [recordView setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:recordView animated:YES];
                } else {
                    
                    UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
                    UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
                    loginView.entranceType = @"MyBiuRecord";
                    [self.navigationController presentViewController:loginNc animated:YES completion:nil];
                }
            }
        }
        
    } else {
    
        NSLog(@"点击了第%ld个cell 第%ld张图片!",banner.tag,index);
        
        
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"HomePageGoodsClick"];
        
        NSArray *dataArray = (NSArray *)[_dataSource objectAt:banner.tag-1];
        BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
        detailVC.detailId = [dataArray objectAt:index][@"id"];
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


- (void)bannerFooterDidTrigger:(ZYBannerView *)banner {
    NSLog(@"拖动了第%ld个banner",banner.tag);
}

//** 健全之后action **//
- (void)toMyBiuRecord {
    //*** 进入我的biu房记录 ***//
    BFBiuRecordViewController *recordView = [[BFBiuRecordViewController alloc] init];
    [recordView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:recordView animated:YES];
}

- (void)toMyMoneyView {
    //*** 进入我的红包页 ***//
    BFRedEnvelopeViewController *redEnvelopeVC = [[BFRedEnvelopeViewController alloc] init];
    [redEnvelopeVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:redEnvelopeVC animated:YES];
}


#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    //显示
    if (translation.y > 0) {
        if (_isHidden) {
            _isHidden = NO;
            CGRect navBarFrame=NavBarFrame;
            CGRect scrollViewFrame=self.currentView.homeCollectionView.frame;
            
            navBarFrame.origin.y = 0;
            scrollViewFrame.origin.y += 44;
            scrollViewFrame.size.height -= 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = navBarFrame;
                self.currentView.homeCollectionView.frame=scrollViewFrame;
                self.currentView.navBarWhiteView.alpha = 0;
            }];
        }
    }
    
    //隐藏
    if (translation.y < 0) {
        if (!_isHidden) {
            _isHidden=YES;
            CGRect frame =NavBarFrame;
            CGRect scrollViewFrame=self.currentView.homeCollectionView.frame;
            frame.origin.y = -44;
            scrollViewFrame.origin.y -= 44;
            scrollViewFrame.size.height += 44;
            
            [UIView animateWithDuration:0.2 animations:^{
                NavBarFrame = frame;
                self.currentView.homeCollectionView.frame=scrollViewFrame;
                self.currentView.navBarWhiteView.alpha = 1;
            }];
        }
    }

    
    //*** 滑到底部自动加载 ***//
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset - 200;
    if (distanceFromBottom <= height) {

        if (_isLoadMoreData && !_isNoMoreData) {
            
            [self loadMoreData];
            _isLoadMoreData = NO;
        }
    }

}

#pragma mark - customMethod
//segment底部分类按钮点击
- (void)segmentBtnAction :(UIButton *)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
    homeMenuBtnCell *cell = (homeMenuBtnCell *)[self.currentView.homeCollectionView cellForItemAtIndexPath:indexPath];
    
    [cell.hotBtn      setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    [cell.lastBtn     setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    [cell.progressBtn setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    [cell.houseBtn    setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    UIButton *currentBtn = (UIButton *)[cell viewWithTag:sender.tag];
    [currentBtn       setTitleColor:[UIColor colorWithHex:@"ff2b6f"] forState:UIControlStateNormal];
    
    //移动选择条
    [UIView animateWithDuration:0.28 animations:^{
        cell.segmentView.frame = CGRectMake((SCREEN_WIDTH/4 - SCREEN_WIDTH/6.82)/2 + (SCREEN_WIDTH/4) * (sender.tag - 1),
                                            cell.backView.frame.size.height - 0.5 - 3,
                                            SCREEN_WIDTH/6.82,
                                            3);
    }];
    
    //*** 网络请求刷新dataSource ***//
    if (sender.tag != _segmentNum) {
        
        if (sender.tag == 1) {
            _segmentClass = @"hot";
        } else if (sender.tag == 2) {
            _segmentClass = @"new";
        } else if (sender.tag == 3) {
            _segmentClass = @"fast";
        } else if (sender.tag == 4) {
            _segmentClass = @"quota_asc";
            cell.upDownImg.image = [UIImage imageNamed:@"home_up"];
        }
  
        _segmentNum = sender.tag;
        [self refreshDataSource];
        
    } else {
    
        //重复点击第四个总需人次按钮，替换排序
        if (sender.tag == 4 && _segmentNum == 4) {
            
            if ([_segmentClass isEqualToString:@"quota_asc"]) {
                _segmentClass = @"quota_desc";
                cell.upDownImg.image = [UIImage imageNamed:@"home_down"];
                
            } else if ([_segmentClass isEqualToString:@"quota_desc"]) {
                _segmentClass = @"quota_asc";
                cell.upDownImg.image = [UIImage imageNamed:@"home_up"];
            }
            [self refreshDataSource];
        }
    }
}

- (void)selectCity {
    
    //*** 选择城市 ***//
    BFSelectCityViewController *selectCityVC = [[BFSelectCityViewController alloc] init];
    UINavigationController     *selectCityNC = [[UINavigationController alloc] initWithRootViewController:selectCityVC];
    [self presentViewController:selectCityNC animated:YES completion:nil];
}

- (void)topBtnAction: (UIButton *)sender {

    BFHomeCategoryViewController *categoryView = [[BFHomeCategoryViewController alloc] init];
    
    if (sender.tag == 1) {
        _currentCategory = @"*";
        categoryView.currentCity = @"全国";
    } else if (sender.tag == 2) {
        _currentCategory = @"rent";
        categoryView.currentCity = @"全国";
    } else if (sender.tag == 3) {
        _currentCategory = @"hotel";
        categoryView.currentCity = @"全国";
    } else if (sender.tag == 4) {
        _currentCategory = @"sell";
        categoryView.currentCity = _currentCity;
    }
    categoryView.currentCategory = _currentCategory;
    [categoryView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:categoryView animated:YES];
}

//banner按钮轮播点击
- (void)bannerBtnAction: (UIButton *)sender {

    BFHomeCategoryViewController *categoryView = [[BFHomeCategoryViewController alloc] init];
    if (sender.tag == 1) {
        
        _currentCategory = @"sell";
        categoryView.currentCity = _currentCity;
        categoryView.currentCategory = _currentCategory;
        [categoryView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:categoryView animated:YES];
    } else if (sender.tag == 2) {
        
        _currentCategory = @"hotel";
        categoryView.currentCity = @"全国";
        categoryView.currentCategory = _currentCategory;
        [categoryView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:categoryView animated:YES];
        
    } else if (sender.tag == 3) {
        
        _currentCategory = @"rent";
        categoryView.currentCity = @"全国";
        categoryView.currentCategory = _currentCategory;
        [categoryView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:categoryView animated:YES];
    } else if (sender.tag == 4) {
        
        //新手指南
        BFNewGuideViewController *guideView = [[BFNewGuideViewController alloc] init];
        guideView.webUrl   = [NSString stringWithFormat:@"%@",activityUrl];
        guideView.titleStr = @"新手指南";
        [guideView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:guideView animated:YES];
    }
}



//登录状态直接购买
- (void)biuAction:(UIButton *)sender {

    //NSLog(@"%ld",(long)sender.tag);
    
    self.fangID = [_dataSource objectAtIndex:sender.tag][@"id"];
    
    _fang_id = [_dataSource objectAtIndex:sender.tag][@"id"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        [UMSocialData setAppKey:UMAppKey];
        [MobClick event:@"GoodsListPagePerchaseClick"];
        
        
        //self.settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
        self.settlementSelectCountView.fang_id  = [_dataSource objectAtIndex:sender.tag][@"id"];
        self.settlementSelectCountView.delegate = self;
        [self.settlementSelectCountView settlementShow];
        
        //BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
        //[orderVC setHidesBottomBarWhenPushed:YES];
        //orderVC.fang_id = [_dataSource objectAtIndex:sender.tag][@"id"];
        //[self.navigationController pushViewController:orderVC animated:YES];
        
    } else {
        
        //000
        UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
        loginView.entranceType = @"homeBuyGood";
        UINavigationController *loginNV = [[UINavigationController alloc] initWithRootViewController:loginView];
        [self.navigationController presentViewController:loginNV animated:YES completion:nil];
    }
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


//监听登录成功之后
- (void)biuActionNextAction{
        
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"GoodsListPagePerchaseClick"];
    
    //BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    //[orderVC setHidesBottomBarWhenPushed:YES];
    //orderVC.fang_id = _fang_id;
    //[self.navigationController pushViewController:orderVC animated:YES];
    

    //self.settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
    self.settlementSelectCountView.fang_id  = self.fangID;
    self.settlementSelectCountView.delegate = self;
    [self.settlementSelectCountView settlementShow];
}


#pragma mark - NSNOtification通知监听事件
//*** 改变城市并刷新数据 ***//
- (void)changeCity:(NSNotification *)info {

    _currentCity = info.userInfo[@"name"];
    [self.currentView.leftBtn  setTitle:_currentCity  forState:UIControlStateNormal];
    CGSize titleSize = [_currentCity sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:self.currentView.leftBtn.titleLabel.font.fontName size:self.currentView.leftBtn.titleLabel.font.pointSize]}];
    titleSize.height = 40;
    titleSize.width += 20;
    self.currentView.leftBtn.frame = CGRectMake(10, 20, titleSize.width, 40);
    [self.currentView rightImage];
    
    [self.currentView.homeCollectionView.mj_header beginRefreshing];
}

//*** 首次运行程序，弹出城市选择页 ***//
- (void)showCityView {
    
//    BFSelectCityViewController *selectCityVC = [[BFSelectCityViewController alloc] init];
//    UINavigationController     *selectCityNC = [[UINavigationController alloc] initWithRootViewController:selectCityVC];
//    [self presentViewController:selectCityNC animated:YES completion:nil];
}

//*** 重复点击tabbar按钮下拉刷新 ***//
- (void)tabbarRepeatAction:(NSNotification *)info {
    
    if ([info.userInfo[@"index"] integerValue] == 0) {
        [self.currentView.homeCollectionView setContentOffset:CGPointMake(0,0)animated:YES];
    }
}

//*** 监听闪屏广告点击事件 ***//
- (void)flashAdAction:(NSNotification *)info {
 
    NSLog(@"首页-点击了闪屏广告 : %@",info.userInfo);
    
    NSDictionary *adDic = (NSDictionary *)info.userInfo[@"data"];
    NSString     *actor = [NSString stringWithFormat:@"%@",adDic[@"actor"]];
    if ([actor isEqualToString:@"web"]) {
        
        
        BFFlashAdViewController *flashAdView = [[BFFlashAdViewController alloc] init];
        flashAdView.webUrl = [NSString stringWithFormat:@"%@",adDic[@"param"]];
        [flashAdView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:flashAdView animated:YES];

        
    } else if ([actor isEqualToString:@"hybird"]) {
        
        //*** 新人红包WEB ***//
        BFNewUserViewController *newWebView = [[BFNewUserViewController alloc] init];
        newWebView.webUrl = [NSString stringWithFormat:@"%@",adDic[@"param"]];
        [newWebView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newWebView animated:YES];
        
    } else if ([actor isEqualToString:@"goods_detail"]) {
        
        //*** 普通商品详情页 ***//
        BFDetailViewController *detailView = [[BFDetailViewController alloc] init];
        detailView.detailId = [NSString stringWithFormat:@"%@",adDic[@"param"]];
        [detailView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailView animated:YES];
        
    } else if ([actor isEqualToString:@"biu_detail"]) {
        
        //*** Biu币商品详情页 ***//
        BFBiuDetailsViewController *detailBiu = [[BFBiuDetailsViewController alloc] init];
        detailBiu.title = @"商品详情";
        detailBiu.detailID = [NSString stringWithFormat:@"%@",adDic[@"param"]];
        [detailBiu setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailBiu animated:YES];
        
    } else if ([actor isEqualToString:@"goods_classify"]) {
        
        //*** 商品类目页 ***//
        BFHomeCategoryViewController *categoryView = [[BFHomeCategoryViewController alloc] init];
        if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"sell"]) {
            categoryView.currentCity = self.currentCity;
        } else {
            categoryView.currentCity = @"全国";
        };
        categoryView.currentCategory = [NSString stringWithFormat:@"%@",adDic[@"param"]];
        [categoryView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:categoryView animated:YES];
        
    } else if ([actor isEqualToString:@"biu_classify"]) {
        //*** Biu币类目页 ***//
        BFNewClassViewController *biuClass = [[BFNewClassViewController alloc] init];
        if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"coupon"]) {
            
            biuClass.styleType = @"coupon";
            biuClass.title = @"现金券";
        } else if ([[NSString stringWithFormat:@"%@",adDic[@"param"]] isEqualToString:@"goods"]) {
            
            biuClass.styleType = @"goods";
            biuClass.title = @"礼品";
        }
        [biuClass setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:biuClass animated:YES];
        
    } else if ([actor isEqualToString:@"lucky"]) {
        //*** 红包页 ***//
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
            
            BFRedEnvelopeViewController *redEnvelopeVC = [[BFRedEnvelopeViewController alloc] init];
            [redEnvelopeVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:redEnvelopeVC animated:YES];
            
        } else {
            
            UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
            UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
            loginView.entranceType = @"MyMoney";
            [self.navigationController presentViewController:loginNc animated:YES completion:nil];
        }
        
    } else if ([actor isEqualToString:@"mybiu_record"]) {
        //*** 我的biu房记录 ***//
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
            
            BFBiuRecordViewController *recordView = [[BFBiuRecordViewController alloc] init];
            [recordView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:recordView animated:YES];
        } else {
            
            UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
            UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
            loginView.entranceType = @"MyBiuRecord";
            [self.navigationController presentViewController:loginNc animated:YES completion:nil];
        }
    }
}

//通用链接跳转详情页
- (void)UniversalLinkJump:(NSNotification*)notification {

    NSDictionary *dict = notification.userInfo;
    NSString *good_id = [dict objectForKey:@"good_id"];
    
    BFDetailViewController *detailView = [[BFDetailViewController alloc] init];
    detailView.detailId = [NSString stringWithFormat:@"%@",good_id];
    [detailView setHidesBottomBarWhenPushed:YES];
    [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:detailView animated:YES];
    //[self.navigationController pushViewController:detailView animated:YES];
}




//点击推送消息跳转指定页面
- (void)userInfoNotification:(NSNotification*)notification {
    
    NSDictionary *dict  = [notification userInfo];
    NSString     *actor = [dict valueForKey:@"actor"];
    
    NSLog(@"~~~~~~~~~~~~点击推送通知~~~~~~~~~~~~~%@",dict);
    if (![actor isEqualToString:@""]) {
        
        if ([actor isEqualToString:@"web"]) {
            
            
            BFFlashAdViewController *flashAdView = [[BFFlashAdViewController alloc] init];
            flashAdView.webUrl = [NSString stringWithFormat:@"%@",dict[@"param"]];
            [flashAdView setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:flashAdView animated:YES];
            //[self.navigationController pushViewController:flashAdView animated:YES];
            
            
        } else if ([actor isEqualToString:@"hybird"]) {
            
            //*** 新人红包WEB ***//
            BFNewUserViewController *newWebView = [[BFNewUserViewController alloc] init];
            newWebView.webUrl = [NSString stringWithFormat:@"%@",dict[@"param"]];
            [newWebView setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:newWebView animated:YES];
            //[self.navigationController pushViewController:newWebView animated:YES];
            
        } else if ([actor isEqualToString:@"goods_detail"]) {
            
            //*** 普通商品详情页 ***//
            BFDetailViewController *detailView = [[BFDetailViewController alloc] init];
            detailView.detailId = [NSString stringWithFormat:@"%@",dict[@"param"]];
            [detailView setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:detailView animated:YES];
            //[self.navigationController pushViewController:detailView animated:YES];
            
        } else if ([actor isEqualToString:@"biu_detail"]) {
            
            //*** Biu币商品详情页 ***//
            BFBiuDetailsViewController *detailBiu = [[BFBiuDetailsViewController alloc] init];
            detailBiu.title = @"商品详情";
            detailBiu.detailID = [NSString stringWithFormat:@"%@",dict[@"param"]];
            [detailBiu setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:detailBiu animated:YES];
            //[self.navigationController pushViewController:detailBiu animated:YES];
            
        } else if ([actor isEqualToString:@"goods_classify"]) {
            
            //*** 商品类目页 ***//
            BFHomeCategoryViewController *categoryView = [[BFHomeCategoryViewController alloc] init];
            if ([[NSString stringWithFormat:@"%@",dict[@"param"]] isEqualToString:@"sell"]) {
                categoryView.currentCity = self.currentCity;
            } else {
                categoryView.currentCity = @"全国";
            };
            categoryView.currentCategory = [NSString stringWithFormat:@"%@",dict[@"param"]];
            [categoryView setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:categoryView animated:YES];
            //[self.navigationController pushViewController:categoryView animated:YES];
            
        } else if ([actor isEqualToString:@"biu_classify"]) {
            //*** Biu币类目页 ***//
            BFNewClassViewController *biuClass = [[BFNewClassViewController alloc] init];
            if ([[NSString stringWithFormat:@"%@",dict[@"param"]] isEqualToString:@"coupon"]) {
                
                biuClass.styleType = @"coupon";
                biuClass.title = @"现金券";
            } else if ([[NSString stringWithFormat:@"%@",dict[@"param"]] isEqualToString:@"goods"]) {
                
                biuClass.styleType = @"goods";
                biuClass.title = @"礼品";
            }
            [biuClass setHidesBottomBarWhenPushed:YES];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:biuClass animated:YES];
            //[self.navigationController pushViewController:biuClass animated:YES];
            
        } else if ([actor isEqualToString:@"lucky"]) {
            //*** 红包页 ***//
            if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
                
                BFRedEnvelopeViewController *redEnvelopeVC = [[BFRedEnvelopeViewController alloc] init];
                [redEnvelopeVC setHidesBottomBarWhenPushed:YES];
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:redEnvelopeVC animated:YES];
                //[self.navigationController pushViewController:redEnvelopeVC animated:YES];
                
            } else {
                
                UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
                UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
                loginView.entranceType = @"MyMoney";
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:loginNc animated:YES];
                //[self.navigationController presentViewController:loginNc animated:YES completion:nil];
            }
            
        } else if ([actor isEqualToString:@"mybiu_record"]) {
            //*** 我的biu房记录 ***//
            if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
                
                BFBiuRecordViewController *recordView = [[BFBiuRecordViewController alloc] init];
                [recordView setHidesBottomBarWhenPushed:YES];
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:recordView animated:YES];
                //[self.navigationController pushViewController:recordView animated:YES];
            } else {
                
                UILogRegViewController *loginView = [[UILogRegViewController alloc] init];
                UINavigationController *loginNc = [[UINavigationController alloc] initWithRootViewController:loginView];
                loginView.entranceType = @"MyBiuRecord";
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:loginNc animated:YES];
                //[self.navigationController presentViewController:loginNc animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - Winner弹窗代理
- (void)winingShow{
    
    BFWinningView *winingView = [[BFWinningView alloc] initWithFrame:SCREEN_BOUNDS];
    winingView.delegate = self;
    [winingView showWinPop];
}

- (void)lookDetail:(UIButton *)sender{
    
    //获奖了，跳转至商品详情页
//    BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
//    detailVC.detailId = [NSString stringWithFormat:@"%@",_winDic[@"param"]];
//    [detailVC setHidesBottomBarWhenPushed:YES];
//    [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:detailVC animated:YES];
    
    [self judgeJump:[NSString stringWithFormat:@"%@",_winDic[@"param"]]];
}

//监听到获奖信息 && 点击进入详情页面
- (void)toDetailView:(NSNotification *)info {
    
    NSLog(@"推送 获奖信息 %@",info.userInfo);
    NSDictionary *winDic = (NSDictionary *)info.userInfo;
    if ([[NSString stringWithFormat:@"%@",winDic[@"cmd"]] isEqualToString:@"win"]) {
        
        //获奖了，跳转至商品详情页
//        BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
//        detailVC.detailId = [NSString stringWithFormat:@"%@",winDic[@"param"]];
//        [detailVC setHidesBottomBarWhenPushed:YES];
//        [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:detailVC animated:YES];
        [self judgeJump:[NSString stringWithFormat:@"%@",winDic[@"param"]]];
    }
}

//*** 弹出获奖弹窗之后判断跳转目标页面 ***//
- (void)judgeJump: (NSString *)fang_id {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    
    NSString     *urlStr = [[NSString stringWithFormat:@"%@/fang/profile",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *param  = @{@"id":fang_id};
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {

        NSLog(@"detailDatasource : %@",object);
        NSDictionary *selectedDic = (NSDictionary *)object[@"data"];
        
        NSString *delivery_type = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
        NSString *delivery_status = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
        
        if ([delivery_type isEqualToString:@"carrier"]) {
            
            if ([delivery_status isEqualToString:@"none"]) {
                
                BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
                awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
                awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
                awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
                awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
                awardOrderDetailVC.awardTypeBool    = YES;
                
                awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
                awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:awardOrderDetailVC animated:YES];
                
            }else{
                BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
                writeAddressAndOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
                writeAddressAndOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
                writeAddressAndOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
                writeAddressAndOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
                writeAddressAndOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
                writeAddressAndOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
                [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
                
            }
        }else{
            BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
            awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
            awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
            awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
            awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
            awardOrderDetailVC.awardTypeBool    = YES;
            
            awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
            awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
            [[[UIApplication sharedApplication] activityViewController].navigationController pushViewController:awardOrderDetailVC animated:YES];
            
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
        

    } withFailureBlock:^(NSError *error) {
        [hud hide:YES];
    } progress:^(float progress) {}];
}




#pragma mark - 定位当前城市并判断是否发生改变
- (void)checkLoction {

    NSString *urlStr = [[NSString stringWithFormat:@"%@/fang/city-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        NSArray *cityArray = object[@"data"][@"cities"];
        if (cityArray.count == 1 && [[NSString stringWithFormat:@"%@",[cityArray objectAt:0]] isEqualToString:@"全国"]) {
            
            self.currentView.leftBtn.alpha    = 0;
            self.currentView.rightImage.alpha = 0;
        } else {
        
            self.currentView.leftBtn.alpha    = 1;
            self.currentView.rightImage.alpha = 1;
        }
        
        __block BOOL isOnece = YES;
        [GpsManager getGps:^(double lat, double lng, NSString *city) {
            
            if (isOnece) {
                isOnece = NO;
                [GpsManager stop];
                
                if (lat == 0 && lng == 0 && city == nil) {
                    //*** 定位失败 ***//
                } else {
                    
                    NSString *CURRENTCITY = [city substringToIndex:city.length - 1];
                    
                    NSLog(@"lat lng (%f, %f)  %@", lat, lng, CURRENTCITY);
                    if ([cityArray containsObject:CURRENTCITY]) {
                        
                        //*** 城市在列表中,判断和当前城市是否一致，询问是否要切换 ***//
                        if (![CURRENTCITY isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CITY]]]) {
                            
                            //双按键弹窗
                            UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"位置改变"
                                                                                message:[NSString stringWithFormat:@"我们检测到您的地理位置发生改变，是否切换到当前城市-%@？",CURRENTCITY]
                                                                                preferredStyle:UIAlertControllerStyleAlert];

                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:CURRENTCITY forKey:CITY];
                                _currentCity = CURRENTCITY;
                                [self.currentView.leftBtn  setTitle:_currentCity  forState:UIControlStateNormal];
                                CGSize titleSize = [_currentCity sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:self.currentView.leftBtn.titleLabel.font.fontName size:self.currentView.leftBtn.titleLabel.font.pointSize]}];
                                titleSize.height = 40;
                                titleSize.width += 20;
                                self.currentView.leftBtn.frame = CGRectMake(10, 20, titleSize.width, 40);
                                [self.currentView rightImage];
                                [self.currentView.homeCollectionView.mj_header beginRefreshing];
                                
                            }];
                        
                            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            }];
                            [alertDialog addAction:okAction];
                            [alertDialog addAction:cancle];
                            [self presentViewController:alertDialog animated:YES completion:nil];
                        }
                    } else {
                        //*** 城市不在列表中 ***//
                    }
                }
            }
        }];
        
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {}];
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




- (MBProgressHUD *)hud {
    
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.currentView.homeCollectionView];
        _hud.userInteractionEnabled = NO;
        //_hud.mode = MBProgressHUDModeAnnularDeterminate;
        _hud.removeFromSuperViewOnHide = YES;
        
    }
    return _hud;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
