
//
//  BFAwardOrderDetailViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/12/28.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFAwardOrderDetailViewController.h"
#import "BFAwardOrderDetailView.h"

#import "BFDetailViewController.h"
#import "BFBiuNumbersCollectionCell.h"
#import "BFAwardOrderBigImageCollectionViewCell.h"
#import "BFAwardOrderTelEmailCollectionViewCell.h"

#import "BFBiuNumbersHeaderView.h"
#import "BFLowNumbersHeaderView.h"

#import "BFRightAddressAndOrderDetailViewController.h"
#import "BFPerfectAwardInfoViewController.h"

static NSString * const reuseIdentifier         = @"biuNumberCell";
static NSString * const reuseIdentifierBigImag  = @"bigImagNumberCell";
static NSString * const reuseIdentifierTelEmail = @"telEmailNumberCell";

@interface BFAwardOrderDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)BFAwardOrderDetailView *awardOrderDetailView;

//header
@property (nonatomic , strong) UIView *issueHeaderView;
//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;
//community name
@property (nonatomic , strong) UILabel *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel *issueNumberLabel;
//arrow image
@property (nonatomic , strong) UIImageView *arrowImagaView;


//Biu Numbers
@property (nonatomic , strong) NSDictionary *biuNumbersDic;
//section
@property (nonatomic , assign) NSInteger    sectionInt;

//tel
@property (nonatomic , strong) NSString     *telStr;


@property (nonatomic , strong) BFEmptyView *empty;

@end

@implementation BFAwardOrderDetailViewController

-(void)loadView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.awardOrderDetailView = [[BFAwardOrderDetailView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.awardOrderDetailView;
    self.awardOrderDetailView.awardOrderDetailTableView.delegate   = self;
    self.awardOrderDetailView.awardOrderDetailTableView.dataSource = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.telStr = @"--";
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.awardOrderDetailView.awardOrderDetailTableView.backgroundColor = [UIColor whiteColor];
    
    self.title = @"购买详情";
    
    
    self.empty = [[BFEmptyView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*103, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*103)];
    self.empty.backgroundColor = [UIColor whiteColor];
    [self.empty tipStr:@"尚未参与"];
    [self.awardOrderDetailView.awardOrderDetailTableView addSubview:self.empty];
   
    // Register cell classes
    [self.awardOrderDetailView.awardOrderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BFBiuNumbersCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    //bigImag
    [self.awardOrderDetailView.awardOrderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BFAwardOrderBigImageCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierBigImag];
    
    //reuseIdentifierTelEmail
    [self.awardOrderDetailView.awardOrderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BFAwardOrderTelEmailCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifierTelEmail];
    
    
    // Register header view
    [self.awardOrderDetailView.awardOrderDetailTableView registerClass:[BFBiuNumbersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"biuNumberHeader"];
    
    [self.awardOrderDetailView.awardOrderDetailTableView registerClass:[BFLowNumbersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader"];

    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        //[self updateDataSource];
        [self setMJRefreshConfig];
        [self.awardOrderDetailView.awardOrderDetailTableView.mj_header beginRefreshing];
    }
    
    //FINISH UPLOAD ADDRESS
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(luckyRecordRefreshAC) name:@"luckyRecordRefresh" object:nil];


    //FINISH REAL NAME
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAwardOrderOpreationAC) name:@"finishAwardOrderOpreation" object:nil];
    
    
    /*
         NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
         NSLog(@"%@ -- %@ -- %@",userID,self.winner_ID,self.fang_Status);
         if ([self.winner_ID integerValue]==[userID integerValue]) {
             [self uploadLogisticsDataAction];}
     */
    
    if ([self.delivery_type isEqualToString:@"manual"]) {
        
        [self uploadLogisticsDataAction];
    }
}


#pragma mark - Tel Info
- (void)uploadLogisticsDataAction{
    //sender coder
    NSDictionary *parm = @{@"fang_id":self.fang_ID};
    NSString *urlStr   = [NSString stringWithFormat:@"%@/fang/get-delivery",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parm withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"电话交付信息 --- %@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            NSDictionary *data = object[@"data"];
            if (![data isEqual:[NSNull null]]) {
                NSString *telStr = [NSString stringWithFormat:@"%@",object[@"data"][@"payload"][@"mobile"]];
                NSLog(@"tel --- %@",telStr);
                self.telStr = telStr;
                [self.awardOrderDetailView.awardOrderDetailTableView reloadData];
            }
            
            
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
    
}





- (void)luckyRecordRefreshAC{
    
    //[self.awardOrderDetailView.awardOrderDetailTableView.mj_header beginRefreshing];
    self.delivery_type   = @"carrier";
    self.delivery_status = @"processing";
}




- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}

#pragma mark - BACK
- (void)backButton{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"close icon"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 15, 64, 40);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateDataSource{
    
    _sectionInt          = 1;
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-numbers",API];
    NSDictionary *parame = @{@"fang_id":self.fang_ID};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        [self.awardOrderDetailView.awardOrderDetailTableView.mj_header endRefreshing];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //NSLog(@"房屋详情 --- %@",object[@"data"][@"fang_info"]);
            //NSLog(@"房屋详情 --- %@",object[@"data"]);
            self.view                  = self.awardOrderDetailView;//net
            self.biuNumbersDic         = [NSDictionary dictionaryWithDictionary:object[@"data"][@"biu_numbers"]];
            NSArray *orderArray        = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
            NSArray *giveArray         = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
            NSArray *getArray          = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
            if (orderArray.count>0) {
                _sectionInt++;
            }
            if (giveArray.count>0) {
                _sectionInt++;
            }
            if (getArray.count>0) {
                _sectionInt++;
            }
            
            //empty
            if (orderArray.count>0||giveArray.count>0||getArray.count>0) {
                [self.empty removeFromSuperview];
            }else{
                self.empty.alpha = 1;
            }
            
            
            [self.awardOrderDetailView.awardOrderDetailTableView reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog(@"%@",error);
        [self.awardOrderDetailView.awardOrderDetailTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        //NSLog(@"%f",progress);
        [self.awardOrderDetailView.awardOrderDetailTableView.mj_header endRefreshing];
    }];
}




#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _sectionInt;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *getArray   = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    if (section==0) {
        return 1;
    }else if (section==1){
        return orderArray.count;
    }else{
        return getArray.count;
    }
    
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0) {
        
        if (_isMyselfBiuRecord) {
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
            //NSLog(@"%@ -- %@ -- %@",userID,self.winner_ID,self.fang_Status);
            //BIUFANG 记录
            if ([self.winner_ID integerValue]==[userID integerValue]) {
                NSLog(@"显示");
                return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*167);
            }else{
                NSLog(@"不显示");
                return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*0.1);
            }
        }else{
            //幸运记录
            return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*167);
        }
        
        
    }else{
        return CGSizeMake((SCREEN_WIDTH)/5, ((SCREEN_WIDTH-80)/2)/119*22);
    }
}

//cell 边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section==0) {
        return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }else if (section==1){
        return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }else{
        return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *getArray   = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    NSString *modleStr;
    if (indexPath.section==0) {
        
        if ([self.delivery_type isEqualToString:@"manual"]) {
            BFAwardOrderTelEmailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierTelEmail forIndexPath:indexPath];
            [cell setValueWithBiuNumberModle:self.telStr];
            return cell;
        }else{
            BFAwardOrderBigImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierBigImag forIndexPath:indexPath];
            return cell;
        }
    }else if (indexPath.section==1){
        modleStr = orderArray[indexPath.row];
        //modleStr = giveArray[indexPath.row];
        BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setValueWithBiuNumberModle:modleStr];
        //cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }else{
        modleStr = getArray[indexPath.row];
        BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setValueWithBiuNumberModle:modleStr];
        //cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(103));
    }else if (section==1){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(5+47));
    }else{
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(5+47));
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    //NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    if (indexPath.section==0) {
        //NSLog(@"kind = %@", kind);
        if (kind == UICollectionElementKindSectionHeader){
            BFBiuNumbersHeaderView *headerV = (BFBiuNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"biuNumberHeader" forIndexPath:indexPath];
            reusableview = [self setUnifiedView:headerV];
        }
        return reusableview;
        
    }else if (indexPath.section==1){
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"我购买的Biu号码" count:orderArray.count];
        }
        return reusableview;
    }else{
        
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"我收到的Biu号码" count:getArray.count];
        }
        return reusableview;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"%ld",(long)indexPath.row);
    //[self dismissViewControllerAnimated:YES completion:nil];
    if (indexPath.section==0) {
        
        if ([self.delivery_type isEqualToString:@"manual"]) {
            
            //NSLog(@"call");
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telStr];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
            
        }else{
        
            NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
            if (realName.length>0) {
                
                BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
                writeAddressAndOrderDetailVC.fang_ID          = self.fang_ID;
                writeAddressAndOrderDetailVC.cover            = self.cover;
                writeAddressAndOrderDetailVC.communityNameStr = self.communityNameStr;
                writeAddressAndOrderDetailVC.issueNumberStr   = self.issueNumberStr;
                writeAddressAndOrderDetailVC.delivery_type    = self.delivery_type;
                writeAddressAndOrderDetailVC.delivery_status  = self.delivery_status;
                [self.navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
                
                
            }else{
                
                [self getUserInfoAction];
                
            }
        }
    }
}


#pragma mark - 获取用户信息
- (void)getUserInfoAction{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/info?fields=username,avatar&expand=real",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"%@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"realname"] forKey:REAL_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"id_num"] forKey:CARD_ID];
            
            NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
            if (realName.length>0) {
                
                BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
                writeAddressAndOrderDetailVC.fang_ID          = self.fang_ID;
                writeAddressAndOrderDetailVC.cover            = self.cover;
                writeAddressAndOrderDetailVC.communityNameStr = self.communityNameStr;
                writeAddressAndOrderDetailVC.issueNumberStr   = self.issueNumberStr;
                writeAddressAndOrderDetailVC.delivery_type    = self.delivery_type;
                writeAddressAndOrderDetailVC.delivery_status  = self.delivery_status;
                [self.navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
                
                
            }else{
                
                BFPerfectAwardInfoViewController *perfectAwardInfoVC = [[BFPerfectAwardInfoViewController alloc] init];
                perfectAwardInfoVC.isLuckyBool = YES;
                UINavigationController           *perfectAwardInfoNC = [[UINavigationController alloc] initWithRootViewController:perfectAwardInfoVC];
                [self presentViewController:perfectAwardInfoNC animated:YES completion:nil];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error type:@"login" viewController:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

//noti
- (void)finishAwardOrderOpreationAC{
    
    BFRightAddressAndOrderDetailViewController *writeAddressAndOrderDetailVC = [[BFRightAddressAndOrderDetailViewController alloc] init];
    writeAddressAndOrderDetailVC.fang_ID          = self.fang_ID;
    writeAddressAndOrderDetailVC.cover            = self.cover;
    writeAddressAndOrderDetailVC.communityNameStr = self.communityNameStr;
    writeAddressAndOrderDetailVC.issueNumberStr   = self.issueNumberStr;
    writeAddressAndOrderDetailVC.delivery_type    = self.delivery_type;
    writeAddressAndOrderDetailVC.delivery_status  = self.delivery_status;
    [self.navigationController pushViewController:writeAddressAndOrderDetailVC animated:YES];
    
}


#pragma mark - Set Section Header
- (UICollectionReusableView *)setCollecHeaView:(BFLowNumbersHeaderView *)hederView tip:(NSString *)tipStr count:(NSInteger)count{
    //5+47
    hederView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    //top
    UIView *headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*5, SCREEN_WIDTH, SCREEN_WIDTH/375*47)];
    headerBodyView.backgroundColor = [UIColor whiteColor];
    [hederView addSubview:headerBodyView];
    
    
    UILabel *biulabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*20, SCREEN_WIDTH/2, SCREEN_WIDTH/375*14)];
    //biulabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    biulabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    biulabel.text = tipStr;
    biulabel.textColor = [UIColor blackColor];
    biulabel.textAlignment = NSTextAlignmentLeft;
    [headerBodyView addSubview:biulabel];
    
    UILabel *orderCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*15-SCREEN_WIDTH/2, SCREEN_WIDTH/375*20, SCREEN_WIDTH/2, SCREEN_WIDTH/375*14)];
    orderCountlabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    orderCountlabel.textColor = [UIColor blackColor];
    orderCountlabel.textAlignment = NSTextAlignmentRight;
    //orderCountlabel.backgroundColor = [UIColor yellowColor];
    [headerBodyView addSubview:orderCountlabel];
    orderCountlabel.text = [NSString stringWithFormat:@"共%ld个",(unsigned long)count];
    
    return (UICollectionReusableView *)hederView;
}


#pragma mark - 统一
- (UICollectionReusableView *)setUnifiedView:(BFBiuNumbersHeaderView *)headerV{
    
    //self.issueHeaderView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    UIView *headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*6, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    headerBodyView.backgroundColor = [UIColor whiteColor];
    [headerV addSubview:headerBodyView];
    
    
    self.fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [headerBodyView addSubview:self.fangImagaView];
    
    self.communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+45), SCREEN_WIDTH/375*34)];
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
    
    self.arrowImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*(17+8), SCREEN_WIDTH/375*(91-13)/2, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    self.arrowImagaView.image = [UIImage imageNamed:@"Path"];
    self.arrowImagaView.contentMode = UIViewContentModeScaleAspectFill;
    //self.arrowImagaView.backgroundColor = [UIColor redColor];
    //[headerBodyView addSubview:self.arrowImagaView];
    
    //NSLog(@"picture --- %@",self.cover);
    
    [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    self.communityNameLabel.text = self.communityNameStr;
    [self.communityNameLabel sizeToFit];
    self.issueNumberLabel.text = [NSString stringWithFormat:@"期号:%@",self.issueNumberStr];
    
    UITapGestureRecognizer *headerTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapGRAc:)];
    [headerV addGestureRecognizer:headerTapGR];
    
    return (UICollectionReusableView *)headerV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.awardOrderDetailView.awardOrderDetailTableView.mj_header = header;
    
    
}

#pragma mark - 详情
- (void)headerTapGRAc:(UITapGestureRecognizer *)sender{
    
    //BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
    //detailVC.detailId = self.fang_ID;
    //[self.navigationController pushViewController:detailVC animated:YES];
    
}

//lazy
-(UIView *)issueHeaderView{
    if (_issueHeaderView==nil) {
        _issueHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*103)];
    }
    return _issueHeaderView;
}



@end
