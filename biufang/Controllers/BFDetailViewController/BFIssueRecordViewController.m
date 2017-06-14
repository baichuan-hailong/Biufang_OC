//
//  BFIssueRecordViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFIssueRecordViewController.h"
#import "BFIssueRecordView.h"
#import "BFIssueRecordCell.h"
#import "BFIssueRecordModle.h"

@interface BFIssueRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSInteger currentPage;
    NSInteger totalCount;
}
@property (nonatomic , strong) BFIssueRecordView *issueRecordView;
@property (nonatomic , strong) NSMutableArray    *issueRecordMutableArray;
@property (nonatomic , strong) UIView *issueHeaderView;

//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;
//community name
@property (nonatomic , strong) UILabel *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel *issueNumberLabel;

@property (nonatomic , strong) BFEmptyView *empty;
@end

@implementation BFIssueRecordViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.issueRecordView = [[BFIssueRecordView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.issueRecordView;
    self.issueRecordView.issueRecordTableView.delegate   = self;
    self.issueRecordView.issueRecordTableView.dataSource = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本期参与记录";
    
    [self setHeaderViewAc];
    //together sliding
    self.issueRecordView.issueRecordTableView.tableHeaderView =self.issueHeaderView;
    
    
    self.empty = [[BFEmptyView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*103, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*103)];
    [self.empty tipStr:@"还没有人参与本期Biu房"];
    self.empty.alpha = 0;
    [self.issueRecordView.issueRecordTableView addSubview:self.empty];
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        
        [self setMJRefreshConfig];
        [self.issueRecordView.issueRecordTableView.mj_header beginRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}


- (void)backAction:(UIButton *)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setHeaderViewAc{

    self.issueHeaderView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    UIView *headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*6, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    headerBodyView.backgroundColor = [UIColor whiteColor];
    [self.issueHeaderView addSubview:headerBodyView];
    
    
    self.fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    //self.fangImagaView.backgroundColor = [UIColor lightGrayColor];
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [headerBodyView addSubview:self.fangImagaView];
    
    self.communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*34)];
    self.communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.communityNameLabel.text = @"--- ---";
    self.communityNameLabel.textColor = [UIColor blackColor];
    self.communityNameLabel.numberOfLines = 0;
    self.communityNameLabel.textAlignment = NSTextAlignmentLeft;
    [headerBodyView addSubview:self.communityNameLabel];
    
    self.issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*63, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*14)];
    self.issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.issueNumberLabel.text = @"期号：---";
    self.issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    [headerBodyView addSubview:self.issueNumberLabel];
    
    
}


//upload
- (void)updateDataSource{
    
    if (self.issueRecordMutableArray.count>0) {
        [self.issueRecordMutableArray removeAllObjects];
    }
    currentPage = 1;
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-record",API];
    NSDictionary *parame = @{@"fang_id":self.fang_ID,
                             @"page":@"1"};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            self.view        = self.issueRecordView;//网络
            //NSLog(@"%@",object);
            
            NSLog(@"%@",object[@"data"][@"record"][@"total"]);
            //NSLog(@"%@",object[@"data"][@"record"][@"count"]);
            NSLog(@"%@",object[@"data"][@"record"]);
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
    
                
                self.issueRecordMutableArray = [NSMutableArray arrayWithArray:object[@"data"][@"record"][@"items"]];
                
                
                [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:object[@"data"][@"fang_info"][@"cover"]]];
                self.communityNameLabel.text = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"title"]];
                [self.communityNameLabel sizeToFit];
                self.issueNumberLabel.text = [NSString stringWithFormat:@"期号:%@",object[@"data"][@"fang_info"][@"sn"]];
                
                NSString *total = [NSString stringWithFormat:@"%@",object[@"data"][@"record"][@"total"]];
                totalCount = [total integerValue];
                if (self.issueRecordMutableArray.count<totalCount) {
                    currentPage++;
                }
                
                //empty
                if (self.issueRecordMutableArray.count>0) {
                    [self.empty removeFromSuperview];
                }else{
                    self.empty.alpha = 1;
                }
                
                if (self.issueRecordMutableArray.count>0) {
                   [self.issueRecordView.issueRecordTableView reloadData];
                }
            }
        }
        [self.issueRecordView.issueRecordTableView.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.issueRecordView.issueRecordTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.issueRecordView.issueRecordTableView.mj_header endRefreshing];
    }];
    
}
//loadMore
- (void)loadMoreData{
    
    if (self.issueRecordMutableArray.count<totalCount) {
        
        NSString *currentPageStr = [NSString stringWithFormat:@"%ld",(long)currentPage];
        
        NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-record",API];
        NSDictionary *parame = @{@"fang_id":self.fang_ID,
                                 @"page":currentPageStr};
        //NSLog(@"传参 -- %@",param);
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.issueRecordMutableArray addObjectsFromArray:object[@"data"][@"record"][@"items"]];
                if (self.issueRecordMutableArray.count<totalCount) {
                    currentPage++;
                }
                [self.issueRecordView.issueRecordTableView reloadData];
            }
            [self.issueRecordView.issueRecordTableView.mj_footer endRefreshing];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.issueRecordView.issueRecordTableView.mj_footer endRefreshing];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
            [self.issueRecordView.issueRecordTableView.mj_footer endRefreshing];
        }];
    }else{
        
        [self.issueRecordView.issueRecordTableView.mj_footer endRefreshing];
    }
    
}

#pragma mark -Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.issueRecordMutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/375*60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return SCREEN_WIDTH/375*10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *issueRecordDic;
    if (self.issueRecordMutableArray.count>0) {
        issueRecordDic = self.issueRecordMutableArray[indexPath.row];
    }
    static NSString *cellIndentifire = @"issueRecordCell";
    BFIssueRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFIssueRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        cell.userInteractionEnabled = NO;
    }
    [cell setValueWithIssueRecord:issueRecordDic];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.issueRecordView.issueRecordTableView.mj_header = header;
    
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.issueRecordView.issueRecordTableView.mj_footer = footer;
    
}

//lazy
-(UIView *)issueHeaderView{

    if (_issueHeaderView==nil) {
        _issueHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*103)];
    }
    return _issueHeaderView;
}


@end
