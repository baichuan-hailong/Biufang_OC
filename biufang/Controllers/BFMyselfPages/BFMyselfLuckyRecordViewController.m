//
//  BFMyselfLuckyRecordViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/11/21.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfLuckyRecordViewController.h"
#import "BFMyselfLuckyView.h"
#import "BFMyLuckyViewCell.h"
#import "BFMyLuckyCell.h"

#import "BFDetailViewController.h"
#import "BFHomeModel.h"
#import "BFLuckyEmptyView.h"
#import "BFMakeOrderViewController.h"


#import "BFAwardOrderDetailViewController.h"
#import "BFRightAddressAndOrderDetailViewController.h"
#import "BFSettlementSelectCountView.h"
#import "BFSubmitSunListShareViewController.h"

@interface BFMyselfLuckyRecordViewController ()<UITableViewDelegate,UITableViewDataSource,BFSettlementSelectCountDelegate> {
    
    NSInteger currentPage;
    NSInteger totalCount;
}

@property (nonatomic , strong) BFMyselfLuckyView *luckyView;
@property (nonatomic , strong) NSMutableArray    *dataArray;

//settlementView
@property (nonatomic , strong) BFSettlementSelectCountView *settlementSelectCountView;
@property (nonatomic , strong) NSString *nextFangID;

@end

@implementation BFMyselfLuckyRecordViewController
- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.luckyView = [[BFMyselfLuckyView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.luckyView;
    self.luckyView.luckeRecordTableView.delegate   = self;
    self.luckyView.luckeRecordTableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title                = @"我的幸运记录";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        [self setMJRefreshConfig];
        [self.luckyView.luckeRecordTableView.mj_header beginRefreshing];
    }
    //FINISH UPLOAD ADDRESS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(luckyRecordRefreshAC:) name:@"luckyRecordRefresh" object:nil];

    
    //submit success
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSubmitSuccessfulRefresh:) name:@"shareSubmitSuccessfulRefresh" object:nil];
}


- (void)luckyRecordRefreshAC:(NSNotification *)notification{
    NSDictionary *notiDic = (NSDictionary *)[notification object];
    //NSLog(@"%@",notiDic);
    NSString *fangID = [NSString stringWithFormat:@"%@",notiDic[@"fangId"]];
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        NSString *curFangID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        if ([fangID integerValue] == [curFangID integerValue]) {
            NSMutableDictionary *currentDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            //NSLog(@"changedLucky --- %@",currentDic);
            [currentDic setValue:@"processing" forKey:@"delivery_status"];
            //NSLog(@"changedLucky --- %@",currentDic);
            //currentDic[@"delivery_status"] = @"processing";
            //NSLog(@"changedLucky --- %@",currentDic);
            [self.dataArray removeObjectAtIndex:i];
            [self.dataArray insertObject:currentDic atIndex:i];
            [self.luckyView.luckeRecordTableView reloadData];
        }
    }
}

#pragma mark - 刷新
- (void)shareSubmitSuccessfulRefresh:(NSNotification *)notification{
    NSDictionary *notiDic = (NSDictionary *)[notification object];
    NSString *fangID = [NSString stringWithFormat:@"%@",notiDic[@"fangId"]];
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        NSString *curFangID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        if ([fangID integerValue] == [curFangID integerValue]) {
            NSMutableDictionary *currentDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            //NSLog(@"changedLucky --- %@",currentDic);
            [currentDic setValue:@"1" forKey:@"shown"];
            
            
            [self.dataArray removeObjectAtIndex:i];
            [self.dataArray insertObject:currentDic atIndex:i];
            [self.luckyView.luckeRecordTableView reloadData];
        }
    }
}



- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}

- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.luckyView.luckeRecordTableView.mj_header = header;
    
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.luckyView.luckeRecordTableView.mj_footer = footer;
    
}

//update
- (void)updateDataSource{
    
    currentPage = 1;
    
    NSString     *urlStr = [NSString stringWithFormat:@"%@/user/lucky-record",API];
    NSDictionary *param = @{@"page":@"1"};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //NSLog(@"幸运记录 --- %@",object);
            if (self.dataArray.count>0) {
                [self.dataArray removeAllObjects];
            }
            self.view        = self.luckyView;//网络
            NSString *total = [NSString stringWithFormat:@"%@",object[@"data"][@"total"]];
            totalCount = [total integerValue];
//            if (self.dataArray.count<totalCount) {
//                currentPage++;
//            }
            currentPage = 2;

            self.dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"items"]];

            if (self.dataArray.count==0) {
                BFLuckyEmptyView *empty = [[BFLuckyEmptyView alloc] initWithFrame:SCREEN_BOUNDS];
                [empty tipStr:@"多Biu才会多幸运哦~"];
                [self.luckyView.luckeRecordTableView addSubview:empty];
            }
            [self.luckyView.luckeRecordTableView reloadData];
        }
        [self.luckyView.luckeRecordTableView.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self.luckyView.luckeRecordTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.luckyView.luckeRecordTableView.mj_header endRefreshing];
    }];
}



//loadMore
- (void)loadMoreData{
    
    if (self.dataArray.count<totalCount) {
        NSString *currentPageStr = [NSString stringWithFormat:@"%ld",(long)currentPage];
        NSString     *urlStr = [NSString stringWithFormat:@"%@/user/lucky-record",API];
        NSDictionary *param = @{@"page":currentPageStr};
        //NSLog(@"传参 -- %@",param);
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"%@",object);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.dataArray addObjectsFromArray:object[@"data"][@"items"]];
                if (self.dataArray.count<totalCount) {
                    currentPage++;
                }
                [self.luckyView.luckeRecordTableView reloadData];
            }
            [self.luckyView.luckeRecordTableView.mj_footer endRefreshing];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.luckyView.luckeRecordTableView.mj_footer endRefreshing];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
            [self.luckyView.luckeRecordTableView.mj_footer endRefreshing];
        }];
    }else{
        [self.luckyView.luckeRecordTableView.mj_footer endRefreshing];
    }
    
}


#pragma mark - TableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_WIDTH/2.17;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BFHomeModel *model = [[BFHomeModel alloc] initWithKvcDictionary:[self.dataArray objectAt:indexPath.row]];
    static NSString *cellIndentifire = @"luckyRecordCell";

    BFMyLuckyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell=[[BFMyLuckyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setValueWithModel:model];
    //NSLog(@"model --- dic --- %@",[self.dataArray objectAt:indexPath.row]);
    NSDictionary *selectedDic = [self.dataArray objectAtIndex:indexPath.row];
    NSString *delivery_type   = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
    NSString *delivery_status = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
    
    NSString *nextFangId      = [NSString stringWithFormat:@"%@",selectedDic[@"next_period"]];
    
    if ([delivery_type isEqualToString:@"carrier"]) {
        if ([delivery_status isEqualToString:@"none"]) {
            [cell.getBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
        }else{
            [cell.getBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        }
    }else{
        [cell.getBtn setTitle:@"领取奖品" forState:UIControlStateNormal];
    }
    
    if ([nextFangId integerValue]==0) {
        cell.buyBtn.alpha = 0;
    }else{
        cell.buyBtn.alpha = 1;
    }
    
    
    cell.getBtn.tag = 8080+indexPath.row;
    [cell.getBtn addTarget:self action:@selector(getBut:) forControlEvents:UIControlEventTouchUpInside];

    cell.buyBtn.tag = 9090+indexPath.row;
    [cell.buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.sharBtn.tag = 1010+indexPath.row;
    [cell.sharBtn addTarget:self action:@selector(sharBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *selectedDic = [self.dataArray objectAtIndex:indexPath.row];
    [self jumpNextVC:selectedDic];
}


#pragma mark - 跳转
- (void)jumpNextVC:(NSDictionary *)selectedDic{

    NSString *delivery_type   = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
    NSString *delivery_status = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
    
    NSLog(@"%@",selectedDic);
    
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
    }else{
        BFAwardOrderDetailViewController *awardOrderDetailVC = [[BFAwardOrderDetailViewController alloc] init];
        awardOrderDetailVC.fang_ID          = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
        awardOrderDetailVC.cover            = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
        awardOrderDetailVC.communityNameStr = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
        awardOrderDetailVC.issueNumberStr   = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
        awardOrderDetailVC.awardTypeBool    = YES;
        
        awardOrderDetailVC.delivery_type    = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_type"]];
        awardOrderDetailVC.delivery_status  = [NSString stringWithFormat:@"%@",selectedDic[@"delivery_status"]];
        awardOrderDetailVC.fang_Status      = @"3";
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        awardOrderDetailVC.winner_ID        = userID;
        [self.navigationController pushViewController:awardOrderDetailVC animated:YES];
    }
}


#pragma mark - 领取奖品&查看物流
- (void)getBut:(UIButton *)sender{
    NSDictionary *selectedDic = [self.dataArray objectAtIndex:(sender.tag-8080)];
    [self jumpNextVC:selectedDic];
}

#pragma mark - 再次购买
- (void)buyBtn:(UIButton *)sender{
    NSDictionary *selectedDic = [self.dataArray objectAtIndex:(sender.tag-9090)];
    NSLog(@"再次购买 --- %@",selectedDic[@"next_period"]);
    self.nextFangID = [NSString stringWithFormat:@"%@",selectedDic[@"next_period"]];
    
    if ([self.nextFangID integerValue]!=0) {
        self.settlementSelectCountView.fang_id  = self.nextFangID;
        self.settlementSelectCountView.delegate = self;
        [self.settlementSelectCountView settlementShow];
    }
}

#pragma mark - 晒单分享
- (void)sharBtn:(UIButton *)sender{
    
    NSDictionary *selectedDic = [self.dataArray objectAtIndex:(sender.tag-1010)];
    NSString *shown = selectedDic[@"shown"];
    
    if ([shown integerValue]==0) {
        BFSubmitSunListShareViewController *submitSunListShareVC = [[BFSubmitSunListShareViewController alloc] init];
        submitSunListShareVC.fang_title = [NSString stringWithFormat:@"%@",selectedDic[@"title"]];
        submitSunListShareVC.fang_sn    = [NSString stringWithFormat:@"%@",selectedDic[@"sn"]];
        submitSunListShareVC.fang_cover = [NSString stringWithFormat:@"%@",selectedDic[@"cover"]];
        submitSunListShareVC.fang_id    = [NSString stringWithFormat:@"%@",selectedDic[@"id"]];
        [self.navigationController pushViewController:submitSunListShareVC animated:YES];
        
    }else{
        NSLog(@"show share list");
    }
    
    
    
}


#pragma mark - BFSettlementDelegate
-(void)settlementHaveSelectOrderCount:(NSString *)orderText totalPrice:(NSInteger)totalPriceCount onWech:(NSString *)onLine redArray:(NSArray *)redmoneyArray title:(NSString *)fangTitle sn:(NSString *)fang_sn url:(NSString *)fang_url{
    NSLog(@"%@",fang_sn);
    BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    [orderVC setHidesBottomBarWhenPushed:YES];
    orderVC.fang_id            = self.nextFangID;
    orderVC.orderCount         = orderText;
    orderVC.totalPriceCountStr = [NSString stringWithFormat:@"%ld",(long)totalPriceCount];
    orderVC.isWechatonLine     = onLine;
    orderVC.redmoneyArray      = redmoneyArray;
    orderVC.fang_title         = fangTitle;
    orderVC.fang_sn            = fang_sn;
    orderVC.fang_url           = fang_url;
    [self.navigationController pushViewController:orderVC animated:YES];
}


#pragma maek - cuntomMethod
- (void)biuAction: (UIButton *)sender {

    //NSLog(@"~~~~~~~~~~~~~~~~%ld",sender.tag);
    
    BFMakeOrderViewController *orderVC = [[BFMakeOrderViewController alloc] init];
    orderVC.fang_id = [_dataArray objectAtIndex:sender.tag][@"id"];
    [orderVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:orderVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//lazy
-(BFSettlementSelectCountView *)settlementSelectCountView{
    if (_settlementSelectCountView==nil) {
        _settlementSelectCountView = [[BFSettlementSelectCountView alloc] initWithFrame:SCREEN_BOUNDS];
    }
    return _settlementSelectCountView;
}


@end
