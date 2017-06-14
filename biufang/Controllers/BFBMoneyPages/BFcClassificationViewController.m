//
//  BFcClassificationViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/26.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFcClassificationViewController.h"
#import "BFFundView.h"
#import "BFFundCollectionViewCell.h"

#import "BFBiuDetailsViewController.h"
#import "BFExchangeSuccessfulView.h"

@interface BFcClassificationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,BFExchangeSuccessfulDelegate>
{

    NSInteger currentPage;
    NSInteger totalCount;
}
@property (nonatomic , strong) BFFundView *fundView;
//pop
@property (nonatomic , strong) BFExchangeSuccessfulView *exchangeSuccessfulView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@end


static NSString * const reuseIdentifier = @"fundCell";
@implementation BFcClassificationViewController

-(void)loadView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fundView = [[BFFundView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.fundView;
    self.fundView.fundCollectionView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.fundView.fundCollectionView.delegate   = self;
    self.fundView.fundCollectionView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    // Register cell classes
    [self.fundView.fundCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BFFundCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    [self setMJRefreshConfig];
    [self.fundView.fundCollectionView.mj_header beginRefreshing];
}


#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellDic = self.dataArray[indexPath.row];
    
    BFFundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if ([self.styleType isEqualToString:@"coupon"]) {
        [cell.exchangeButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:cell.exchangeButton.frame.size] forState:UIControlStateNormal];
    }else{
        [cell.exchangeButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"5599f5"] size:cell.exchangeButton.frame.size] forState:UIControlStateNormal];
    }
    
    [cell setWithDiction:cellDic];
    
    NSInteger sect       = indexPath.section;
    NSInteger row        = indexPath.row;
    NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)sect];
    NSString *rowStr     = [NSString stringWithFormat:@"%ld",(long)row];
    objc_setAssociatedObject(cell.exchangeButton, "section", sectionStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.exchangeButton, "row", rowStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.exchangeButton addTarget:self action:@selector(exchangeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, SCREEN_WIDTH/375*7);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *proDid =  self.dataArray[indexPath.row];
    
    NSLog(@"%ld---%ld",(long)indexPath.section,(long)indexPath.row);
    BFBiuDetailsViewController *biuDetailsVC = [[BFBiuDetailsViewController alloc] init];
    biuDetailsVC.title                       = @"商品详情";
    biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",proDid[@"id"]];
    biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",proDid[@"biub"]];
    [biuDetailsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:biuDetailsVC animated:YES];
    
}

#pragma mark - 兑换
- (void)exchangeButtonDidClickedAction:(UIButton *)sender{
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        NSString *section = objc_getAssociatedObject(sender, "section");
        NSString *row = objc_getAssociatedObject(sender, "row");
        NSLog(@"%@ --- %@",section,row);
        
        //NSInteger sessionIn = [section integerValue];
        NSInteger rowIn = [row integerValue];
        NSDictionary *couponDid =  self.dataArray[rowIn];
        [self exchangeDic:couponDid];
    }else{
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}


#pragma mark - 兑换接口
- (void)exchangeDic:(NSDictionary *)dic{
    //NSLog(@"%@",dic);
    //NSLog(@"%@",dic[@"id"]);
    NSString *urlStr = [NSString stringWithFormat:@"%@/biub/redeem",API];
    NSDictionary *parame = @{@"pid":dic[@"id"]};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"%@",object);
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
        
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}


#pragma mark - 兑换成功代理
-(void)exchangeSuccessful:(UIButton *)sender{
    NSLog(@"finish");
}


- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.fundView.fundCollectionView.mj_header = header;
    
    
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.fundView.fundCollectionView.mj_footer = footer;
    
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
                
                [self.fundView.fundCollectionView reloadData];
            }
            [self.fundView.fundCollectionView.mj_footer endRefreshing];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            [self.fundView.fundCollectionView.mj_footer endRefreshing];
        } progress:^(float progress) {
            NSLog(@"%f",progress);
            [self.fundView.fundCollectionView.mj_footer endRefreshing];
        }];
    }else{
        
        [self.fundView.fundCollectionView.mj_footer endRefreshing];
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
            
            //NSLog(@"%@",object[@"data"]);
            //NSLog(@"%@",object[@"data"][@"count"]);
            //NSLog(@"%@",object[@"data"][@"total"]);
            
            NSString *total = [NSString stringWithFormat:@"%@",object[@"data"][@"total"]];
            totalCount = [total integerValue];
            
            if (self.dataArray.count<totalCount) {
                currentPage++;
            }
            //NSLog(@"之前 -- %ld",(unsigned long)self.dataArray.count);
            self.dataArray = [NSMutableArray arrayWithArray:object[@"data"][@"items"]];
            //NSLog(@"之后 -- %ld",(unsigned long)self.dataArray.count);
            [self.fundView.fundCollectionView reloadData];
        }
        
        [self.fundView.fundCollectionView.mj_header endRefreshing];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.fundView.fundCollectionView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.fundView.fundCollectionView.mj_header endRefreshing];
    }];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
