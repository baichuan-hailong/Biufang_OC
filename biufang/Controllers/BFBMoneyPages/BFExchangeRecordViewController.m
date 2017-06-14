//
//  BFExchangeRecordViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFExchangeRecordViewController.h"
#import "BFExchangeRecordView.h"
#import "BFExchangeRecordTableViewCell.h"

@interface BFExchangeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSInteger currentPage;
    NSInteger totalCount;
    NSString  *telNumberStr;
}
@property (nonatomic , strong) BFExchangeRecordView *exchangeRecordView;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) UILabel *footLabel;
@end

@implementation BFExchangeRecordViewController

-(void)loadView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.exchangeRecordView = [[BFExchangeRecordView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view = self.exchangeRecordView;
    self.exchangeRecordView.exchangeRecordTableView.delegate = self;
    self.exchangeRecordView.exchangeRecordTableView.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        
        [self setMJRefreshConfig];
        [self.exchangeRecordView.exchangeRecordTableView.mj_header beginRefreshing];

    }
}

- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}

//updata
- (void)updateDataSource{

    NSString *urlStr = [NSString stringWithFormat:@"%@/biub/order",API];
    NSDictionary *param = @{@"page":@"1"};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
        [self.exchangeRecordView.exchangeRecordTableView.mj_header endRefreshing];
        //NSLog(@"%@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            self.view = self.exchangeRecordView;//网络
            self.dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"items"]];
            telNumberStr = [NSString stringWithFormat:@"%@",object[@"data"][@"service_tel"]];
            NSString *total = [NSString stringWithFormat:@"%@",object[@"data"][@"total"]];
            totalCount = [total integerValue];
            if (self.dataArray.count<totalCount) {
                currentPage++;
            }
            //empty
            if (self.dataArray.count==0) {
                BFEmptyView *empty = [[BFEmptyView alloc] initWithFrame:SCREEN_BOUNDS];
                [empty tipStr:@"暂无兑换记录"];
                self.exchangeRecordView.exchangeRecordTableView.tableHeaderView = empty;
            }
            [self.exchangeRecordView.exchangeRecordTableView reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.exchangeRecordView.exchangeRecordTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.exchangeRecordView.exchangeRecordTableView.mj_header endRefreshing];
    }];
}

//loadMore
- (void)loadMoreData{
    
    if (self.dataArray.count<totalCount) {
        NSString *currentPageStr = [NSString stringWithFormat:@"%ld",(long)currentPage];
        NSString     *urlStr = [NSString stringWithFormat:@"%@/biub/order",API];
        NSDictionary *param = @{@"page":currentPageStr};
        //NSLog(@"传参 -- %@",param);
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
            //NSLog(@"%@",object);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.dataArray addObjectsFromArray:object[@"data"][@"items"]];
                if (self.dataArray.count<totalCount) {
                    currentPage++;
                }
                [self.exchangeRecordView.exchangeRecordTableView reloadData];
            }
            [self.exchangeRecordView.exchangeRecordTableView.mj_footer endRefreshing];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.exchangeRecordView.exchangeRecordTableView.mj_footer endRefreshing];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
            [self.exchangeRecordView.exchangeRecordTableView.mj_footer endRefreshing];
        }];
    }else{
        [self.exchangeRecordView.exchangeRecordTableView.mj_footer endRefreshing];
    }
}

#pragma mark -Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_WIDTH/375*125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return SCREEN_WIDTH/375*7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.dataArray.count==0) {
        return SCREEN_WIDTH/375*0;
    }else{
        return SCREEN_WIDTH/375*25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    self.footLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    //telNumberStr
    if (self.dataArray.count>0) {
        self.footLabel.text = [NSString stringWithFormat:@"更多问题，请咨询客服：%@",telNumberStr];
    }
    self.footLabel.textAlignment = NSTextAlignmentCenter;
    self.footLabel.textColor = [UIColor colorWithHex:@"999999"];
    return _footLabel;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *proDid = self.dataArray[indexPath.row];
    static NSString *cellIndentifire = @"exchangeRecordCell";
    BFExchangeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFExchangeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        cell.userInteractionEnabled = NO;
    }
    [cell setValueWithIssueRecord:proDid];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.exchangeRecordView.exchangeRecordTableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.exchangeRecordView.exchangeRecordTableView.mj_footer = footer;
    
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

//lazy
-(UILabel *)footLabel{

    if (_footLabel==nil) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*10, SCREEN_WIDTH, SCREEN_WIDTH/375*15)];
    }
    return _footLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
