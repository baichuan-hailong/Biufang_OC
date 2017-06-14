//
//  BFNewFundViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFNewFundViewController.h"
#import "BFNewFundView.h"
#import "BFNewFundTableViewCell.h"

#import "BFExchangeRecordViewController.h"
#import "BFNewClassViewController.h"
#import "BFBiuDetailsViewController.h"
#import "BFExchangeSuccessfulView.h"
#import "BFNewGuideViewController.h"

@interface BFNewFundViewController ()<UITableViewDataSource,UITableViewDelegate,BFExchangeSuccessfulDelegate>
@property (nonatomic , strong) BFNewFundView *fundView;

//dataArray
@property (nonatomic , strong) NSMutableDictionary *dataMutableDic;
@property (nonatomic , strong) NSArray *couponArray;
@property (nonatomic , strong) NSArray *goosArray;

//Biu币金额
@property (nonatomic , strong) UILabel *biuLabel;
@property (nonatomic , strong) UILabel *biumoneyLabel;
@property (nonatomic , strong) UIImageView *biuImageView;
@property (nonatomic , strong) UIButton *biuloginButton;

//headerView
@property (nonatomic , strong) UIView *sectionOneHeaderView;
@property (nonatomic , strong) UIButton *rightHeaderButtton;
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) UIImageView *leftImageView;

//two
@property (nonatomic , strong) UIView *sectionTwoHeaderView;
@property (nonatomic , strong) UIButton *rightHeaderButttonTw;
@property (nonatomic , strong) UILabel *leftLabelTw;
@property (nonatomic , strong) UIImageView *leftImageViewTw;

//pop
@property (nonatomic , strong) BFExchangeSuccessfulView *exchangeSuccessfulView;
//登录Next 将要兑换的Dic
@property (nonatomic , strong) NSDictionary *willExchangeDic;

@property (nonatomic , strong) BFNoNetView *noNetView;

@property (nonatomic, strong) UIView              *navBarView;
@property (nonatomic, strong) UILabel             *titleLable;
@property (nonatomic, strong) UIButton            *rightBtn;
@property (nonatomic, assign) BOOL                isCanSideBack;  //右滑返回允许状态

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIView *oneheaderView;
@end

@implementation BFNewFundViewController

-(void)loadView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fundView    = [[BFNewFundView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.fundView;
    self.fundView.fundTableView.delegate   = self;
    self.fundView.fundTableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title    = @"Biu币";

    //self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    //self.navigationController.navigationBar.translucent = NO;   //导航栏不透明
    
    //self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view       addSubview:self.navBarView];
    [self.navBarView addSubview:self.titleLable];
    [self.navBarView addSubview:self.rightBtn];
    
    [self.rightBtn addTarget:self action:@selector(rightButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bexLoginNextAc) name:@"bexLoginNextAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BiuBEXLoginNextAc) name:@"BiuBEXLoginNextAction" object:nil];
   
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        self.noNetView = [[BFNoNetView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(64+5), SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*64)];
        [self.noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        //self.view = noNetView;
        [self.view addSubview:self.noNetView];
    }else{
    
        [self setMJRefreshConfig];
        [self.fundView.fundTableView.mj_header beginRefreshing];
    }
    
}

//新手指南
- (void)oneTapGRAc:(UITapGestureRecognizer *)sender{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        BFNewGuideViewController *guideView = [[BFNewGuideViewController alloc] init];
        guideView.webUrl = [NSString stringWithFormat:@"%@",activityUrl];
        guideView.titleStr  = @"新手指南";
        [guideView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:guideView animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        [self askCuttentBiub];
        self.biuloginButton.alpha = 0;
        self.biuImageView.alpha = 1;
        self.biumoneyLabel.alpha = 1;
        
    }else{
        self.biuloginButton.alpha = 1;
        self.biuImageView.alpha = 0;
        self.biumoneyLabel.alpha = 0;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        [[UMManager sharedManager] accountStatistics];
    }
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"MoneyBiuPage"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"MoneyBiuPage"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}

- (void)updateButtonDidClickAc:(UIButton *)sender{

    [self setMJRefreshConfig];
    [self updateDataSource];    
    //[self.fundView.fundTableView.mj_header beginRefreshing];
}


- (void)askCuttentBiub{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/biub-balance",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"Biu币数量 --- %@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            self.biumoneyLabel.text = [NSString stringWithFormat:@"%@",object[@"data"][@"biub_current"]];
        }else{
            self.biumoneyLabel.text = @"0";
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog(@"%@",error);
        self.biumoneyLabel.text = @"0";
    } progress:^(float progress) {
        //NSLog(@"%f",progress);
    }];
}



- (void)updateDataSource{
    
    self.dataMutableDic = [NSMutableDictionary dictionary];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/biub/biub-index",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"BIU币模块 --- %@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            [self.noNetView removeFromSuperview];
            self.view        = self.fundView;//网络
            self.couponArray = [NSArray arrayWithArray:object[@"data"][@"coupon"]];
            self.goosArray   = [NSArray arrayWithArray:object[@"data"][@"goods"]];
            [self.dataMutableDic setObject:self.couponArray forKey:@"coupon"];
            [self.dataMutableDic setObject:self.goosArray forKey:@"goods"];
            
            [self setSecOneHeaer];
            self.fundView.fundTableView.tableHeaderView = self.sectionOneHeaderView;
            
            
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


#pragma mark - 兑换记录
-(void)rightButton{
  
}

- (void)rightButtonDidClickedAction:(UIButton *)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        BFExchangeRecordViewController *exchangeRecordVC = [[BFExchangeRecordViewController alloc] init];
        [exchangeRecordVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:exchangeRecordVC animated:YES];
    }else{
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        loginRegVC.entranceType = @"BEX";
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}

#pragma mark - 登录NEXT
//兑换记录
- (void)bexLoginNextAc{
    BFExchangeRecordViewController *exchangeRecordVC = [[BFExchangeRecordViewController alloc] init];
    [exchangeRecordVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:exchangeRecordVC animated:YES];
}

//兑换
- (void)BiuBEXLoginNextAc{
    [self exchangeDic:self.willExchangeDic];
}


#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    NSArray *keysArray = [self.dataMutableDic allKeys];
    return keysArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section==0) {
        return self.couponArray.count;
    }else{
        return self.goosArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return SCREEN_WIDTH/375*117;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return SCREEN_WIDTH/375*1;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifire = @"exchangeRecordCell";
    BFNewFundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFNewFundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section==0) {
        NSDictionary *coupDid = self.couponArray[indexPath.row];
        //NSLog(@"coup --- %@",coupDid);
        [cell setNewFund:coupDid];
    }else{
        NSDictionary *goodDid = self.goosArray[indexPath.row];
        //NSLog(@"good --- %@",goodDid);
        [cell setNewFund:goodDid];
    }
    
    
    NSInteger sect = indexPath.section;
    NSInteger row   = indexPath.row;
    NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)sect];
    NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)row];
    objc_setAssociatedObject(cell.exchangeButton, "section", sectionStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.exchangeButton, "row", rowStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.exchangeButton addTarget:self action:@selector(exchangeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*50)];
    self.sectionTwoHeaderView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.sectionTwoHeaderView];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*39, SCREEN_WIDTH, SCREEN_WIDTH/375*0.8)];
    line.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    [self.sectionTwoHeaderView addSubview:line];
    
    
    //two
    self.leftImageViewTw.contentMode = UIViewContentModeScaleAspectFit;
    self.leftImageViewTw.image = [UIImage imageNamed:@"biusectiontwo"];
    [self.sectionTwoHeaderView addSubview:self.leftImageViewTw];
    
    
    self.leftLabelTw.textColor = [UIColor colorWithHex:@"000000"];
    self.leftLabelTw.textAlignment = NSTextAlignmentLeft;
    //self.leftLabelTw.font = [UIFont fontWithName:@"Helvetica-Bold" size:SCREEN_WIDTH/375*14];
    self.leftLabelTw.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    self.leftLabelTw.text = @"礼品";
    [self.sectionTwoHeaderView addSubview:self.leftLabelTw];
    
    
    [self.rightHeaderButttonTw setImage:[UIImage imageNamed:@"topBtn_next"] forState:UIControlStateNormal];
    [self.rightHeaderButttonTw setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    self.rightHeaderButttonTw.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.rightHeaderButttonTw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightHeaderButttonTw.tag = 667;
    [self.rightHeaderButttonTw addTarget:self action:@selector(rightHeaderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sectionTwoHeaderView addSubview:self.rightHeaderButttonTw];
    
    if (self.goosArray.count>0){
        headerView.alpha = 1;
    }else{
        headerView.alpha = 0;
    }
    
    return headerView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 0;
    }else{
        if (self.goosArray.count==0) {
            return 0;
        }else{
            return SCREEN_WIDTH/375*50;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MoneyBiuPageGoodsClick"];
    
    BFBiuDetailsViewController *biuDetailsVC = [[BFBiuDetailsViewController alloc] init];
    biuDetailsVC.title = @"商品详情";
    if (indexPath.section==0) {
        NSDictionary *coupDid = self.couponArray[indexPath.row];
        //NSLog(@"cou --- %@",coupDid);
        biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",coupDid[@"id"]];
        biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",coupDid[@"biub"]];
        biuDetailsVC.detailWebUrl = [NSString stringWithFormat:@"%@",coupDid[@"detail"]];
    }else{
        NSDictionary *goodDid = self.goosArray[indexPath.row];
        //NSLog(@"goods --- %@",goodDid);
        biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",goodDid[@"id"]];
        biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",goodDid[@"biub"]];
        biuDetailsVC.detailWebUrl = [NSString stringWithFormat:@"%@",goodDid[@"detail"]];
    }
    [biuDetailsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:biuDetailsVC animated:YES];
}

#pragma mark - 兑换
- (void)exchangeButtonDidClickedAction:(UIButton *)sender{
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"MoneyBiuPageGoodsPurchase"];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
    
    NSString *section = objc_getAssociatedObject(sender, "section");
    NSString *row = objc_getAssociatedObject(sender, "row");
    NSInteger rowIn = [row integerValue];
    NSInteger sectionIn = [section integerValue];
    NSDictionary *exDic;
    if (sectionIn==0) {
        exDic =  self.couponArray[rowIn];
    }else{
        exDic =  self.goosArray[rowIn];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
       [self exchangeDic:exDic];
        
    }else{
        
        [_hud hide:YES];
        
        self.willExchangeDic = exDic;
        
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        loginRegVC.entranceType = @"BiuBEX";
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
    
    //NSLog(@"finish");
    //- (void)askCuttentBiub
    [self askCuttentBiub];
}



#pragma mark - 头部
- (void)setSecOneHeaer{
    
    //_sectionOneHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(50+70))];
    if (self.couponArray.count==0) {
        self.sectionOneHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(70));
    }else{
        self.sectionOneHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(50+70));
    }
    
    
    //top
    self.oneheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*70)];
    self.oneheaderView.backgroundColor = [UIColor whiteColor];
    [self.sectionOneHeaderView addSubview:self.oneheaderView];
    
    
    UITapGestureRecognizer *oneTopGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapGRAc:)];
    [self.oneheaderView addGestureRecognizer:oneTopGR];
    
    //Biu
    self.biuLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.biuLabel.textAlignment = NSTextAlignmentLeft;
    self.biuLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:SCREEN_WIDTH/375*17];
    self.biuLabel.text = @"我的Biu币";
    //self.biuLabel.backgroundColor = [UIColor redColor];
    [self.oneheaderView addSubview:self.biuLabel];
    
    
    //self.biuImageView.backgroundColor = [UIColor redColor];
    self.biuImageView.image = [UIImage imageNamed:@"biubibagimage"];
    [self.oneheaderView addSubview:self.biuImageView];
    
    
    self.biumoneyLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.biumoneyLabel.textAlignment = NSTextAlignmentRight;
    self.biumoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*24];
    //self.biumoneyLabel.text = @"0";
    [self.oneheaderView addSubview:self.biumoneyLabel];
    
    
    
    
    [self.biuloginButton setTitle:@"登录查看" forState:UIControlStateNormal];
    [self.biuloginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.biuloginButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.biuloginButton.layer.cornerRadius = SCREEN_WIDTH/375*3;
    self.biuloginButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.biuloginButton.layer.borderWidth = SCREEN_WIDTH/375*1.2;
    self.biuloginButton.layer.masksToBounds= YES;
    [self.biuloginButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor whiteColor] size:self.biuloginButton.frame.size] forState:UIControlStateNormal];
    [self.oneheaderView addSubview:self.biuloginButton];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        self.biuloginButton.alpha = 0;
        self.biuImageView.alpha = 1;
        self.biumoneyLabel.alpha = 1;
    }else{
        self.biuloginButton.alpha = 1;
        self.biuImageView.alpha = 0;
        self.biumoneyLabel.alpha = 0;
    }
    
    [self.biuloginButton addTarget:self action:@selector(biuloginButtonDidClick) forControlEvents:UIControlEventTouchUpInside];

    //dowm
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*80, SCREEN_WIDTH, SCREEN_WIDTH/375*40)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.sectionOneHeaderView addSubview:downView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*39, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
    line.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    [downView addSubview:line];
    
    
    //one
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftImageView.image = [UIImage imageNamed:@"biusectionone"];
    [downView addSubview:self.leftImageView];
    
    
    self.leftLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.leftLabel.textAlignment = NSTextAlignmentLeft;
    //self.leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:SCREEN_WIDTH/375*14];
    self.leftLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    self.leftLabel.text = @"代金券";
    [downView addSubview:self.leftLabel];
    
    
    [self.rightHeaderButtton setImage:[UIImage imageNamed:@"topBtn_next"] forState:UIControlStateNormal];
    [self.rightHeaderButtton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    self.rightHeaderButtton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.rightHeaderButtton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightHeaderButtton.tag = 666;
    //self.rightHeaderButtton.backgroundColor = [UIColor redColor];
    [self.rightHeaderButtton addTarget:self action:@selector(rightHeaderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:self.rightHeaderButtton];
}

#pragma mark - 登录
- (void)biuloginButtonDidClick{
    UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
    UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
    [self presentViewController:loginRegNC animated:YES completion:nil];
}

#pragma mark - Header Button 更多
- (void)rightHeaderButtonDidClickedAction:(UIButton *)sender{
    
    BFNewClassViewController *classificationVC = [[BFNewClassViewController alloc] init];
    [classificationVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:classificationVC animated:YES];
    
    switch (sender.tag) {
        case 666:
            classificationVC.title = @"代金券";
            classificationVC.styleType = @"coupon";
            break;
        case 667:
            classificationVC.title = @"礼品";
            classificationVC.styleType = @"goods";
            break;
            
        default:
            break;
    }
}


- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.fundView.fundTableView.mj_header = header;
    
    
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

//lazy
-(UILabel *)biumoneyLabel{
    
    if (_biumoneyLabel==nil) {
        _biumoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*47-(SCREEN_WIDTH/2-SCREEN_WIDTH/375*47), 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*47, SCREEN_WIDTH/375*70)];
    }
    return _biumoneyLabel;
}

-(UILabel *)biuLabel{
    
    if (_biuLabel==nil) {
        _biuLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*70)];
    }
    return _biuLabel;
}

-(UIImageView *)biuImageView{
    
    if (_biuImageView==nil) {
        _biuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*20-SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*(70-24)/2, SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*24)];
    }
    return _biuImageView;
}

-(UIButton *)biuloginButton{

    if (_biuloginButton==nil) {
        _biuloginButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*87-SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*(70-31)/2, SCREEN_WIDTH/375*87, SCREEN_WIDTH/375*31)];
    }
    return _biuloginButton;
}


//one
-(UIView *)sectionOneHeaderView{

    if (_sectionOneHeaderView==nil) {
        _sectionOneHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(50+70))];
    }
    return _sectionOneHeaderView;
}

-(UIButton *)rightHeaderButtton{
    
    if (_rightHeaderButtton==nil) {
        _rightHeaderButtton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/375*5, 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*40)];
    }
    return _rightHeaderButtton;
}



-(UILabel *)leftLabel{
    
    if (_leftLabel==nil) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/2-SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*21)];
    }
    return _leftLabel;
}



-(UIImageView *)leftImageView{
    
    if (_leftImageView==nil) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*21)];
    }
    return _leftImageView;
}

//@property (nonatomic , strong) UIView *sectionTwoHeaderView;
-(UIView *)sectionTwoHeaderView{

    if (_sectionTwoHeaderView==nil) {
        _sectionTwoHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*10, SCREEN_WIDTH, SCREEN_WIDTH/375*41)];
    }
    return _sectionTwoHeaderView;
}
//@property (nonatomic , strong) UIButton *rightHeaderButttonTw;
-(UIButton *)rightHeaderButttonTw{
    
    if (_rightHeaderButttonTw==nil) {
        _rightHeaderButttonTw = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/375*5, 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*40)];
    }
    return _rightHeaderButttonTw;
}

//@property (nonatomic , strong) UILabel *leftLabelTw;
-(UILabel *)leftLabelTw{
    
    if (_leftLabelTw==nil) {
        _leftLabelTw = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*(40-21)/2, SCREEN_WIDTH/2-SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*21)];
    }
    return _leftLabelTw;
}
//@property (nonatomic , strong) UIImageView *leftImageViewTw;
-(UIImageView *)leftImageViewTw{
    
    if (_leftImageViewTw==nil) {
        _leftImageViewTw = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*(40-21)/2, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*21)];
    }
    return _leftImageViewTw;
}

#pragma mark - getter
- (UIView *)navBarView {
    
    if (_navBarView == nil) {
        _navBarView = [[UIView alloc] init];
        _navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navBarView.backgroundColor = [UIColor whiteColor];
        _navBarView.clipsToBounds = NO;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:@"E6E6E6"];
        [_navBarView addSubview:line];
    }
    return _navBarView;
}

- (UILabel *)titleLable {
    
    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 40);
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.text = @"Biu币";
    }
    return _titleLable;
}

-(UIButton *)rightBtn{

    if (_rightBtn==nil) {
        
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80-SCREEN_WIDTH/375*20, 20, 80, 44)];
        [_rightBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
    }
    return _rightBtn;
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



@end
