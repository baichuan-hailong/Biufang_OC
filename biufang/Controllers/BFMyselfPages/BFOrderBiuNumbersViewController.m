//
//  BFOrderBiuNumbersViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/12/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFOrderBiuNumbersViewController.h"


#import "BFBiuNumbersCollectionCell.h"
#import "BFLowNumbersHeaderView.h"
#import "BFRightAddressAndOrderDetailViewController.h"

static NSString * const reuseIdentifier         = @"biuNumberCell";

@interface BFOrderBiuNumbersViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


//Biu Numbers
@property (nonatomic , strong) NSDictionary *biuNumbersDic;
//section
@property (nonatomic , assign) NSInteger    sectionInt;


@end

@implementation BFOrderBiuNumbersViewController

-(void)loadView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.awardOrderDetailView = [[BFAwardOrderDetailView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view                 = self.awardOrderDetailView;
    self.awardOrderDetailView.awardOrderDetailTableView.frame      = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.awardOrderDetailView.awardOrderDetailTableView.delegate   = self;
    self.awardOrderDetailView.awardOrderDetailTableView.dataSource = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.awardOrderDetailView.awardOrderDetailTableView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.awardOrderDetailView.awardOrderDetailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BFBiuNumbersCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Register header view
    [self.awardOrderDetailView.awardOrderDetailTableView registerClass:[BFLowNumbersHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader"];
    
    [self updateDataSource];
}


- (void)updateDataSource{
    
    _sectionInt = 0;
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-numbers",API];
    NSDictionary *parame = @{@"fang_id":self.fang_ID};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        [self.awardOrderDetailView.awardOrderDetailTableView.mj_header endRefreshing];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
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
            
            
            NSDictionary *notiNumberParam = @{@"ordernum":[NSString stringWithFormat:@"%ld",(unsigned long)orderArray.count],
                                              @"getnum":[NSString stringWithFormat:@"%ld",(unsigned long)getArray.count]};
            
            //refresh lucky list
            [[NSNotificationCenter defaultCenter] postNotificationName:@"numbersRefresh" object:notiNumberParam];
            
            
            [self.awardOrderDetailView.awardOrderDetailTableView reloadData];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}




#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _sectionInt;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NSArray *orderArray        = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *giveArray         = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray          = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    if (section==0) {
        return orderArray.count;
    }else if (section==1){
        return getArray.count;
    }else{
        return giveArray.count;
    }
}

//设置每个item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH)/5, ((SCREEN_WIDTH-80)/2)/119*22);
}

//cell 边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*0, 0, SCREEN_WIDTH/375*0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *orderArray        = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *getArray          = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    NSArray *giveArray         = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSString *modleStr;
    
    if (indexPath.section==0) {
        modleStr = orderArray[indexPath.row];
        BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setValueWithBiuNumberModle:modleStr];
        return cell;
    }else if (indexPath.section==1){
        modleStr = getArray[indexPath.row];
        BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setValueWithBiuNumberModle:modleStr];
        return cell;
    }else{
        modleStr = giveArray[indexPath.row];
        BFBiuNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setValueWithBiuNumberModle:modleStr];
        return cell;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(5+47));
    }else if (section==1){
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(5+47));
    }else{
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/375*(5+47));
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    NSArray *orderArray = [NSArray arrayWithArray:self.biuNumbersDic[@"order"]];
    NSArray *giveArray = [NSArray arrayWithArray:self.biuNumbersDic[@"give"]];
    NSArray *getArray = [NSArray arrayWithArray:self.biuNumbersDic[@"get"]];
    
    if (indexPath.section==0) {
        
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"我购买的Biu号码" count:orderArray.count];
        }
        return reusableview;
        
    }else if (indexPath.section==1){
        
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"我收到的Biu号码" count:getArray.count];
        }
        return reusableview;
        
        
    }else{
        
        if (kind == UICollectionElementKindSectionHeader){
            BFLowNumbersHeaderView *headerV = (BFLowNumbersHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"lowNumbersHeader" forIndexPath:indexPath];
            reusableview = [self setCollecHeaView:headerV tip:@"已经赠送的Biu号码" count:giveArray.count];
        }
        return reusableview;
        
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"%ld",(long)indexPath.row);
    //[self dismissViewControllerAnimated:YES completion:nil];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
