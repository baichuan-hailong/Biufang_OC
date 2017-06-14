//
//  BFBiuNumbersViewController.m
//  BFCollectionViewDemo
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 anju. All rights reserved.
//

#import "BFBiuNumbersViewController.h"
#import "BFBiuNumbersCollectionCell.h"
#import "BFBiuNumbersHeaderView.h"
#import "BFLowNumbersHeaderView.h"
#import "BFBiuNumbersView.h"
#import "BFBiuNumberModle.h"

#import "BFGivingBiuNumbersViewController.h"

@interface BFBiuNumbersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) BFBiuNumbersView *biuNumbersView;
//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;
//community name
@property (nonatomic , strong) UILabel *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel *issueNumberLabel;


@property (nonatomic , strong) NSDictionary *biuNumbersDic;
@property (nonatomic , assign) NSInteger    sectionInt;

//赠送biu号
@property (nonatomic , strong) UIView *biuNumberView;

@property (nonatomic , strong) BFEmptyView *empty;

@property (nonatomic , strong) UILabel *orCountlabel;
@property (nonatomic , strong) UILabel *biulabel;

@end

static NSString * const reuseIdentifier = @"biuNumberCell";

@implementation BFBiuNumbersViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.biuNumbersView = [[BFBiuNumbersView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.biuNumbersView;
    self.biuNumbersView.biuNumbersCollectionView.delegate   = self;
    self.biuNumbersView.biuNumbersCollectionView.dataSource = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买详情";
    
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    self.communityNameLabel.text = @"--- ---";
    self.issueNumberLabel.text = @"期号：---";
    
    self.empty = [[BFEmptyView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*103, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*103)];
    [self.empty tipStr:@"尚未参与"];
    [self.biuNumbersView.biuNumbersCollectionView addSubview:self.empty];
    
    
    // Register cell classes
    [self.biuNumbersView.biuNumbersCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BFBiuNumbersCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Register header view
    [self.biuNumbersView.biuNumbersCollectionView registerClass:[BFBiuNumbersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"biuNumberHeader"];
    
    [self.biuNumbersView.biuNumbersCollectionView registerClass:[BFLowNumbersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader"];
    //header view
    //[self setCollecHeaderViewAc];
    //UITapGestureRecognizer *biuTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(biutapGRAction:)];
    //[self.biuNumberView addGestureRecognizer:biuTapGR];
    
    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        
        [self setMJRefreshConfig];
        [self.biuNumbersView.biuNumbersCollectionView.mj_header beginRefreshing];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"MyBiuRecordPage"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"MyBiuRecordPage"];
}

- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}

- (void)backAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)updateDataSource{
    
    _sectionInt = 0;
    
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-numbers",API];
    NSDictionary *parame = @{@"fang_id":self.fangID};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        [self.biuNumbersView.biuNumbersCollectionView.mj_header endRefreshing];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //NSLog(@"房屋详情 --- %@",object[@"data"][@"fang_info"]);
            //NSLog(@"房屋详情 --- %@",object[@"data"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                
                self.view        = self.biuNumbersView;
                
                self.biuNumbersDic = [NSDictionary dictionaryWithDictionary:object[@"data"][@"biu_numbers"]];
                [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:object[@"data"][@"fang_info"][@"cover"]]];
                self.communityNameLabel.text = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"title"]];
                [self.communityNameLabel sizeToFit];
                self.issueNumberLabel.text = [NSString stringWithFormat:@"期号:%@",object[@"data"][@"fang_info"][@"sn"]];
                self.fangStatus = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"status"]];
                
                //NSArray *keysArray = [self.biuNumbersDic allKeys];
                NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
                NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
                NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
                NSMutableArray *totalArray = [NSMutableArray array];
                [totalArray addObjectsFromArray:orderArray];
                [totalArray addObjectsFromArray:giveArray];
                [totalArray addObjectsFromArray:getArray];
                
                if (orderArray.count>0) {
                    _sectionInt++;
                }
                if (giveArray.count>0) {
                    _sectionInt++;
                }
                if (getArray.count>0) {
                    _sectionInt++;
                }
                NSLog(@"total --- %ld",(unsigned long)totalArray.count);
                
                
                //empty
                if (totalArray.count>0) {
                    [self.empty removeFromSuperview];
                }else{
                    self.empty.alpha = 1;
                }
                
                
                [self.biuNumbersView.biuNumbersCollectionView reloadData];
                
            }
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.biuNumbersView.biuNumbersCollectionView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.biuNumbersView.biuNumbersCollectionView.mj_header endRefreshing];
    }];
}


#pragma mark - 赠送Biu房号
- (void)biutapGRAction:(UIButton *)sender{

    //NSLog(@"赠送Biu房号");
    BFGivingBiuNumbersViewController *givingBiuNumbersVC = [[BFGivingBiuNumbersViewController alloc] init];
    givingBiuNumbersVC.fang_ID = self.fangID;
    [self.navigationController pushViewController:givingBiuNumbersVC animated:YES];
}


#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    /*
     if (_sectionInt>1) {
     return _sectionInt;
     }else{
     
     return 3;
     }
     */
    
    //return _sectionInt;
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    if (section==0) {
        
        return orderArray.count;
    }else if (section==1){
        
        return giveArray.count;
    }else{
        
        return getArray.count;
    }
}

//cell 边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section==0) {
        return UIEdgeInsetsMake(SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }else if (section==1){
        return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }else{
       return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *giveArray  = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray   = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    NSString *modleStr;
    
    if (indexPath.section==0) {
        modleStr = orderArray[indexPath.row];
    }else if (indexPath.section==1){
        modleStr = giveArray[indexPath.row];
    }else{
        modleStr = getArray[indexPath.row];
    }

    BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setValueWithBiuNumberModle:modleStr];
    return cell;
}

//_biuNumbersLayout.headerReferenceSize = CGSizeMake(0, SCREEN_WIDTH/375*(90+5+47));
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    
    
    if (section==0) {
        
        if (orderArray.count==0) {
            return CGSizeMake(0, SCREEN_WIDTH/375*(90+5));
        }else{
            return CGSizeMake(0, SCREEN_WIDTH/375*(90+5+47));
        }
        
    }else if (section==1){
        
        if (giveArray.count==0) {
            return CGSizeMake(0, SCREEN_WIDTH/375*(0));
        }else{
            return CGSizeMake(0, SCREEN_WIDTH/375*(5+47));
        }
        
    }else{
        
        if (getArray.count==0) {
            return CGSizeMake(0, SCREEN_WIDTH/375*(0));
        }else{
            return CGSizeMake(0, SCREEN_WIDTH/375*(5+47));
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    
    
    NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    if (indexPath.section==0) {
        //NSLog(@"kind = %@", kind);
        if (kind == UICollectionElementKindSectionHeader){
            BFBiuNumbersHeaderView *headerV = (BFBiuNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"biuNumberHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaderViewAc:headerV];
        }
        return reusableview;
    }else if (indexPath.section==1){
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"已经赠送的Biu号码" count:giveArray.count];
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


- (UICollectionReusableView *)setCollecHeaView:(BFLowNumbersHeaderView *)hederView tip:(NSString *)tipStr count:(NSInteger)count{
    //90+5+47
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


- (UICollectionReusableView *)setCollecHeaderViewAc:(BFBiuNumbersHeaderView *)hederView{
    //90+5+47
    hederView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    //hederView.backgroundColor = [UIColor redColor];
    //top
    UIView *headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*7, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    headerBodyView.backgroundColor = [UIColor whiteColor];
    [hederView addSubview:headerBodyView];
    

    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [headerBodyView addSubview:self.fangImagaView];
    

    self.communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.communityNameLabel.textColor = [UIColor blackColor];
    self.communityNameLabel.numberOfLines = 0;
    self.communityNameLabel.textAlignment = NSTextAlignmentLeft;
    //self.communityNameLabel.backgroundColor = [UIColor redColor];
    [headerBodyView addSubview:self.communityNameLabel];
    
    self.issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    [headerBodyView addSubview:self.issueNumberLabel];
    
    
    //biu
    self.biuNumberView.backgroundColor = [UIColor whiteColor];
    
    //self.biuNumberView.backgroundColor = [UIColor yellowColor];
    
    
     NSArray *orderArray               = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    if (orderArray.count>0) {
        
        [hederView addSubview:self.biuNumberView];
        self.orCountlabel.font            = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
        self.orCountlabel.textColor       = [UIColor blackColor];
        self.orCountlabel.textAlignment   = NSTextAlignmentRight;
        //self.orCountlabel.backgroundColor = [UIColor redColor];
        self.orCountlabel.text = [NSString stringWithFormat:@"共%ld个",(unsigned long)orderArray.count];
        [self.biuNumberView addSubview:self.orCountlabel];
        
    }
    

    self.biulabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*14];
    self.biulabel.text = @"我购买的Biu号码";
    self.biulabel.textColor = [UIColor blackColor];
    self.biulabel.textAlignment = NSTextAlignmentLeft;
    //biulabel.backgroundColor = [UIColor redColor];
    [self.biuNumberView addSubview:self.biulabel];
    
    //Give Button
    //UIButton *giveButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*15-SCREEN_WIDTH/375*116, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*116, SCREEN_WIDTH/375*31)];
    //[giveButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:giveButton.frame.size] forState:UIControlStateNormal];
    //[giveButton setTitle:@"赠送Biu房号码" forState:UIControlStateNormal];
    //[giveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //giveButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    //giveButton.layer.cornerRadius = SCREEN_WIDTH/375*6;
    //giveButton.layer.masksToBounds= YES;
    if ([self.fangStatus isEqualToString:@"1"]) {
        //giveButton.alpha = 0;
    }else{
        //giveButton.alpha = 0;
    }
    //[self.biuNumberView addSubview:giveButton];
    //biutapGRAction:
    //[giveButton addTarget:self action:@selector(biutapGRAction:) forControlEvents:UIControlEventTouchUpInside];
    return (UICollectionReusableView *)hederView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"%ld",indexPath.row);
    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.biuNumbersView.biuNumbersCollectionView.mj_header = header;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//UILabel *biulabel
-(UILabel *)biulabel{

    //self.biulabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*20, SCREEN_WIDTH/2, SCREEN_WIDTH/375*14)];
    if (_biulabel==nil) {
        _biulabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*20, SCREEN_WIDTH/2, SCREEN_WIDTH/375*14)];
    }
    return _biulabel;
}
//UILabel *orderCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*45, SCREEN_WIDTH/2, SCREEN_WIDTH/375*17)];
-(UILabel *)orCountlabel{
    
    if (_orCountlabel==nil) {
        _orCountlabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*15-SCREEN_WIDTH/2, SCREEN_WIDTH/375*20, SCREEN_WIDTH/2, SCREEN_WIDTH/375*14)];
    }
    return _orCountlabel;
}

//lazay
-(UIView *)biuNumberView{

    if (_biuNumberView==nil) {
        _biuNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*104, SCREEN_WIDTH, SCREEN_WIDTH/375*(45))];
    }
    return _biuNumberView;
}


////fang image
//@property (nonatomic , strong) UIImageView *fangImagaView;
-(UIImageView *)fangImagaView{

    if (_fangImagaView==nil) {
        _fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    }
    return _fangImagaView;
}
////community name
//@property (nonatomic , strong) UILabel *communityNameLabel;
-(UILabel *)communityNameLabel{

    if (_communityNameLabel==nil) {
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*34)];
    }
    return _communityNameLabel;
}
////issue number
//@property (nonatomic , strong) UILabel *issueNumberLabel;
-(UILabel *)issueNumberLabel{

    if (_issueNumberLabel==nil) {
        _issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*63, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*14)];
    }
    return _issueNumberLabel;
}


@end
