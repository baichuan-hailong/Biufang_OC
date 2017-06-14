//
//  BFFundViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/9.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFFundViewController.h"
#import "BFFundView.h"
#import "BFFundCollectionViewCell.h"
#import "BFFundCollectionReusableView.h"

#import "BFExchangeRecordViewController.h"
#import "BFcClassificationViewController.h"
#import "BFBiuDetailsViewController.h"

#import "BFExchangeSuccessfulView.h"


@interface BFFundViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,BFExchangeSuccessfulDelegate>
@property (nonatomic , strong) BFFundView *fundView;
//Biu币金额
@property (nonatomic , strong) UILabel *biumoneyLabel;
@property (nonatomic , strong) UILabel *biuLabel;
@property (nonatomic , strong) UIImageView *biuImageView;
//dowm
@property (nonatomic , strong) UIView *twoheaderView;

@property (nonatomic , strong) UIButton *rightHeaderButtton;
@property (nonatomic , strong) UIButton *rightHeaderButttonSecTw;
@property (nonatomic , strong) UILabel *leftLabel;
@property (nonatomic , strong) UILabel *leftLabelSecTw;
@property (nonatomic , strong) UIImageView *leftImageView;
@property (nonatomic , strong) UIImageView *leftImageViewSecTw;


//pop
@property (nonatomic , strong) BFExchangeSuccessfulView *exchangeSuccessfulView;

//dataArray
@property (nonatomic , strong) NSMutableDictionary *dataMutableDic;
@property (nonatomic , strong) NSArray *couponArray;
@property (nonatomic , strong) NSArray *goosArray;

@end

static NSString * const reuseIdentifier = @"fundCell";
@implementation BFFundViewController

-(void)loadView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fundView    = [[BFFundView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.fundView;
    self.fundView.fundCollectionView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.fundView.fundCollectionView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
    self.fundView.fundCollectionView.delegate   = self;
    self.fundView.fundCollectionView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    // Register cell classes
    [self.fundView.fundCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BFFundCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    // Register header view
    [self.fundView.fundCollectionView registerClass:[BFFundCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fundHeader"];
    //[self.fundView.fundCollectionView reloadData];
    [self rightButton];
    
    [self requestData];
    
    [self setMJRefreshConfig];
    
    self.biumoneyLabel.text = @"-";
    
    //登录Next
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bexLoginNextAc) name:@"bexLoginNextAction" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        [self askCuttentBiub];
    }else{
        self.biumoneyLabel.text = @"0";
    }
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




#pragma mark - 数据
- (void)requestData{
    
    self.dataMutableDic = [NSMutableDictionary dictionary];
    
    NSString     *urlStr = [NSString stringWithFormat:@"%@/biub/biub-index",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //NSLog(@"coupon -- %@",object[@"data"][@"coupon"]);
            //NSLog(@"goods -- %@",object[@"data"][@"goods"]);
            self.couponArray = [NSArray arrayWithArray:object[@"data"][@"coupon"]];
            [self.dataMutableDic setObject:self.couponArray forKey:@"coupon"];
            self.goosArray  = [NSArray arrayWithArray:object[@"data"][@"goods"]];
            [self.dataMutableDic setObject:self.goosArray forKey:@"goods"];
            
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



#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section==0) {
        return self.couponArray.count;
    }else{
        return self.goosArray.count;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *cellDic;
    if (indexPath.section==0) {
        cellDic = self.couponArray[indexPath.row];
    }else if (indexPath.section==1){
        cellDic = self.goosArray[indexPath.row];
    }
    
    
    
    BFFundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.section==0) {
        [cell.exchangeButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:cell.exchangeButton.frame.size] forState:UIControlStateNormal];
    }else{
        [cell.exchangeButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"5599f5"] size:cell.exchangeButton.frame.size] forState:UIControlStateNormal];
    }
    
    [cell setWithDiction:cellDic];
    
    NSInteger sect = indexPath.section;
    NSInteger row   = indexPath.row;
    NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)sect];
    NSString *rowStr = [NSString stringWithFormat:@"%ld",(long)row];
    objc_setAssociatedObject(cell.exchangeButton, "section", sectionStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.exchangeButton, "row", rowStr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
    [cell.exchangeButton addTarget:self action:@selector(exchangeButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}




//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        BFFundCollectionReusableView *headerV = (BFFundCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fundHeader" forIndexPath:indexPath];
        reusableview = [self setCollecHeaderViewAc:headerV section:indexPath.section];
    }
    return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    if (section==0) {
       return CGSizeMake(0, SCREEN_WIDTH/375*124);
    }else{
        return CGSizeMake(0, SCREEN_WIDTH/375*43);
    }
    
}


- (UICollectionReusableView *)setCollecHeaderViewAc:(BFFundCollectionReusableView *)hederView section:(NSInteger)section{
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*42, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    
    
    if (section==0) {
        
        self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.leftLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.leftLabel.textAlignment = NSTextAlignmentLeft;
        self.leftLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        
        self.leftImageView.image = [UIImage imageNamed:@"biusectionone"];
        self.leftLabel.text = @"现金券";
        
        hederView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        //top
        UIView *oneheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*70)];
        oneheaderView.backgroundColor = [UIColor whiteColor];
        [hederView addSubview:oneheaderView];
        
        //Biu
        self.biuLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.biuLabel.textAlignment = NSTextAlignmentLeft;
        self.biuLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*17];
        self.biuLabel.text = @"我的Biu币";
        //self.biuLabel.backgroundColor = [UIColor redColor];
        [oneheaderView addSubview:self.biuLabel];
        
        
        //self.biuImageView.backgroundColor = [UIColor redColor];
        self.biuImageView.image = [UIImage imageNamed:@"biubibagimage"];
        [oneheaderView addSubview:self.biuImageView];
        
        
        
        self.biumoneyLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.biumoneyLabel.textAlignment = NSTextAlignmentRight;
        self.biumoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*24];
        //self.biumoneyLabel.backgroundColor = [UIColor yellowColor];
        [oneheaderView addSubview:self.biumoneyLabel];
        
        //dowm
        self.twoheaderView.backgroundColor = [UIColor whiteColor];
        [hederView addSubview:self.twoheaderView];
        
        [self.twoheaderView addSubview:self.rightHeaderButttonSecTw];
        [self.twoheaderView addSubview:line];
        
        [self.twoheaderView addSubview:self.leftImageView];
        [self.twoheaderView addSubview:self.leftLabel];
        
        
        
        //rightHeaderButtton.backgroundColor = [UIColor redColor];
        [self.rightHeaderButttonSecTw setTitle:@"更多>" forState:UIControlStateNormal];
        [self.rightHeaderButttonSecTw setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
        self.rightHeaderButttonSecTw.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.rightHeaderButttonSecTw.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightHeaderButttonSecTw.tag = 666+section;
        [self.rightHeaderButttonSecTw addTarget:self action:@selector(rightHeaderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        
        //left
        self.leftImageViewSecTw.contentMode = UIViewContentModeScaleAspectFit;
        self.leftLabelSecTw.textColor = [UIColor colorWithHex:@"000000"];
        self.leftLabelSecTw.textAlignment = NSTextAlignmentLeft;
        self.leftLabelSecTw.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        
        self.leftImageViewSecTw.image = [UIImage imageNamed:@"biusectiontwo"];
        self.leftLabelSecTw.text = @"礼品";
        
        hederView.backgroundColor = [UIColor whiteColor];
        [hederView addSubview:self.rightHeaderButtton];
        [hederView addSubview:line];
        
        [hederView addSubview:self.leftImageViewSecTw];
        [hederView addSubview:self.leftLabelSecTw];
        
        //rightHeaderButtton.backgroundColor = [UIColor redColor];
        [self.rightHeaderButtton setTitle:@"更多>" forState:UIControlStateNormal];
        [self.rightHeaderButtton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
        self.rightHeaderButtton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
        self.rightHeaderButtton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.rightHeaderButtton.tag = 666+section;
        [self.rightHeaderButtton addTarget:self action:@selector(rightHeaderButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return (UICollectionReusableView *)hederView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld---%ld",(long)indexPath.section,(long)indexPath.row);
    
    BFBiuDetailsViewController *biuDetailsVC = [[BFBiuDetailsViewController alloc] init];
    biuDetailsVC.title = @"商品详情";
    if (indexPath.section==0) {
        NSDictionary *couponDid =  self.couponArray[indexPath.row];
        biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",couponDid[@"id"]];
        biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",couponDid[@"biub"]];
    }else{
        NSDictionary *goosDid = self.goosArray[indexPath.row];
        biuDetailsVC.detailID = [NSString stringWithFormat:@"%@",goosDid[@"id"]];
        biuDetailsVC.detailBiuB = [NSString stringWithFormat:@"%@",goosDid[@"biub"]];
    }
    [biuDetailsVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:biuDetailsVC animated:YES];
    
}

#pragma mark - Header Button 更多
- (void)rightHeaderButtonDidClickedAction:(UIButton *)sender{

    BFcClassificationViewController *classificationVC = [[BFcClassificationViewController alloc] init];
    [classificationVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:classificationVC animated:YES];
    
    switch (sender.tag) {
        case 666:
            //NSLog(@"%ld",(long)sender.tag);
            //classificationVC.title = [NSString stringWithFormat:@"分类%ld",(long)sender.tag];
            classificationVC.title = @"现金券";
            classificationVC.styleType = @"coupon";
            break;
        case 667:
            //NSLog(@"%ld",(long)sender.tag);
            //classificationVC.title = [NSString stringWithFormat:@"分类%ld",(long)sender.tag];
            classificationVC.title = @"礼品";
            classificationVC.styleType = @"goods";
            break;
            
        default:
            break;
    }
}

#pragma mark - 兑换记录
-(void)rightButton{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightButton setTitle:@"兑换记录" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(17, 15, 13, 5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void)rightButtonDidClickedAction:(UIButton *)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        //NSLog(@"兑换记录");
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
//退换记录
- (void)bexLoginNextAc{
    BFExchangeRecordViewController *exchangeRecordVC = [[BFExchangeRecordViewController alloc] init];
    [exchangeRecordVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:exchangeRecordVC animated:YES];
    
}



#pragma mark - 兑换
- (void)exchangeButtonDidClickedAction:(UIButton *)sender{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        NSString *section = objc_getAssociatedObject(sender, "section");
        NSString *row = objc_getAssociatedObject(sender, "row");
        //NSLog(@"%@ --- %@",section,row);
        NSInteger rowIn = [row integerValue];
        NSInteger sectionIn = [section integerValue];
        
        if (sectionIn==0) {
            NSDictionary *couponDid =  self.couponArray[rowIn];
            [self exchangeDic:couponDid];
        }else{
            NSDictionary *goodsDid = self.goosArray[rowIn];
            [self exchangeDic:goodsDid];
        }
    }else{
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
    }
}

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
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.fundView.fundCollectionView.mj_header = header;
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

-(UIView *)twoheaderView{

    if (_twoheaderView==nil) {
        _twoheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*81, SCREEN_WIDTH, SCREEN_WIDTH/375*43)];
    }
    return _twoheaderView;
}

-(UIButton *)rightHeaderButtton{

    if (_rightHeaderButtton==nil) {
        _rightHeaderButtton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*40)];
    }
    return _rightHeaderButtton;
}

-(UIButton *)rightHeaderButttonSecTw{

    if (_rightHeaderButttonSecTw==nil) {
        _rightHeaderButttonSecTw = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*40)];
    }
    return _rightHeaderButttonSecTw;
}

-(UILabel *)leftLabel{

    if (_leftLabel==nil) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/2-SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*21)];
    }
    return _leftLabel;
}

-(UILabel *)leftLabelSecTw{

    if (_leftLabelSecTw==nil) {
        _leftLabelSecTw = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/2-SCREEN_WIDTH/375*37, SCREEN_WIDTH/375*21)];
    }
    return _leftLabelSecTw;
}

-(UIImageView *)leftImageView{

    if (_leftImageView==nil) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*21)];
    }
    return _leftImageView;
}

-(UIImageView *)leftImageViewSecTw{

    if (_leftImageViewSecTw==nil) {
        _leftImageViewSecTw = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*(43-21)/2, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*21)];
    }
    return _leftImageViewSecTw;

}


@end
