//
//  BFNewClassViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewClassViewController.h"
#import "BFNewFundView.h"
#import "BFExchangeSuccessfulView.h"
#import "BFNewFundTableViewCell.h"
#import "BFBiuDetailsViewController.h"

@interface BFNewClassViewController ()<UITableViewDataSource,UITableViewDelegate,BFExchangeSuccessfulDelegate>
{
    
    NSInteger currentPage;
    NSInteger totalCount;
}

@property (nonatomic , strong) BFNewFundView *fundView;

//pop
@property (nonatomic , strong) BFExchangeSuccessfulView *exchangeSuccessfulView;
@property (nonatomic , strong) NSMutableArray *dataArray;

//登录Next 将要兑换的Dic
@property (nonatomic , strong) NSDictionary *willExchangeDic;

@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation BFNewClassViewController

-(void)loadView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fundView    = [[BFNewFundView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.fundView;
    self.fundView.fundTableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.fundView.fundTableView.delegate   = self;
    self.fundView.fundTableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BClassEXLoginNextAc) name:@"BClassEXLoginNextAction" object:nil];
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        
        [self setMJRefreshConfig];
        [self.fundView.fundTableView.mj_header beginRefreshing];
        
    }
}

- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.fundView.fundTableView.mj_header = header;
    
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.fundView.fundTableView.mj_footer = footer;
    
}

//loadMore
- (void)loadMoreData{
    
    if (self.dataArray.count<totalCount) {
        
        NSString *currentPageStr = [NSString stringWithFormat:@"%ld",(long)currentPage];
        
        NSString     *urlStr = [NSString stringWithFormat:@"%@/biub/biub-products",API];
        NSDictionary *param = @{@"category":self.styleType,
                                @"page":currentPageStr};
        //NSLog(@"传参 -- %@",param);
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.dataArray addObjectsFromArray:object[@"data"][@"items"]];
                if (self.dataArray.count<totalCount) {
                    currentPage++;
                }
            }
            [self.fundView.fundTableView.mj_footer endRefreshing];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.fundView.fundTableView.mj_footer endRefreshing];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
            [self.fundView.fundTableView.mj_footer endRefreshing];
        }];
    }else{
        
        [self.fundView.fundTableView.mj_footer endRefreshing];
    }
}

//update
- (void)updateDataSource{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    
    currentPage = 1;
    NSString     *urlStr = [NSString stringWithFormat:@"%@/biub/biub-products",API];
    NSDictionary *param = @{@"category":self.styleType,
                            @"page":@"1"};
    //NSLog(@"传参 -- %@",param);
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            self.view        = self.fundView;//网络
            NSString *total = [NSString stringWithFormat:@"%@",object[@"data"][@"total"]];
            totalCount = [total integerValue];
            
            if (self.dataArray.count<totalCount) {
                currentPage++;
            }
            //NSLog(@"之前 -- %ld",(unsigned long)self.dataArray.count);
            self.dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"items"]];
            //NSLog(@"之后 -- %ld",(unsigned long)self.dataArray.count);
            
            
            //empty
            if (self.dataArray.count==0) {
                BFEmptyView *empty = [[BFEmptyView alloc] initWithFrame:SCREEN_BOUNDS];
                [empty tipStr:@"尚无数据"];
                [self.fundView.fundTableView addSubview:empty];
            }
            
            
            [self.fundView.fundTableView reloadData];
        }
        [self.fundView.fundTableView.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.fundView.fundTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.fundView.fundTableView.mj_header endRefreshing];
    }];
}




#pragma mark - TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_WIDTH/375*117;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SCREEN_WIDTH/375*7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifire = @"exchangeRecordCell";
    BFNewFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFNewFundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *coupDid = self.dataArray[indexPath.row];
    NSLog(@"cou --- %@",coupDid);
    [cell setNewFund:coupDid];
    
    NSInteger sect = indexPath.section;
    NSInteger row   = indexPath.row;
    NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)sect];
    NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)row];
    objc_setAssociatedObject(cell.exchangeButton, "section", sectionStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.exchangeButton, "row", rowStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.exchangeButton addTarget:self action:@selector(exchangeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MoneyBiuListPageGoodsClick"];
    
    BFBiuDetailsViewController *biuDetailsVC = [[BFBiuDetailsViewController alloc] init];
    biuDetailsVC.title = @"商品详情";
    NSDictionary *coupDid = self.dataArray[indexPath.row];
    biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",coupDid[@"id"]];
    biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",coupDid[@"biub"]];
    biuDetailsVC.detailWebUrl = [NSString stringWithFormat:@"%@",coupDid[@"detail"]];
    [biuDetailsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:biuDetailsVC animated:YES];
    
}

#pragma mark - 登录Next
- (void)BClassEXLoginNextAc{
    
    [self exchangeDic:self.willExchangeDic];
}

#pragma mark - 兑换
- (void)exchangeButtonDidClickedAction:(UIButton *)sender{
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MoneyBiuListPageGoodsPurchase"];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    
    //NSString *section = objc_getAssociatedObject(sender, "section");
    NSString *row = objc_getAssociatedObject(sender, "row");
    //NSLog(@"%@ --- %@",section,row);
    NSInteger rowIn = [row integerValue];
    //NSInteger sectionIn = [section integerValue];
    NSDictionary *couponDid =  self.dataArray[rowIn];
    self.willExchangeDic = couponDid;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        [self exchangeDic:couponDid];
    }else{
        
        [_hud hide:YES];
        
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        loginRegVC.entranceType = @"BClassEX";
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}


- (void)exchangeDic:(NSDictionary *)dic{
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/biub/redeem",API];
    NSDictionary *parame = @{@"pid":dic[@"id"]};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
        [_hud hide:YES];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            self.exchangeSuccessfulView = [[BFExchangeSuccessfulView alloc] initWithFrame:SCREEN_BOUNDS];
            self.exchangeSuccessfulView.delegate = self;
            [self.exchangeSuccessfulView showSuccessful];
        }else{
            [self showProgress:object[@"status"][@"message"]];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [_hud hide:YES];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}



#pragma mark - 兑换成功代理
-(void)exchangeSuccessful:(UIButton *)sender{
    
    NSLog(@"finish");
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
