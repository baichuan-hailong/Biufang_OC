//
//  BFSelectedRedEnvelopeViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/11/8.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFSelectedRedEnvelopeViewController.h"
#import "BFRedEnvelopeView.h"
#import "WTReTextField.h"
#import "BFSelectRedEnvelopeTableViewCell.h"
#import "BFRedEnavleModle.h"



@interface BFSelectedRedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

{

    NSInteger rowCount;
    
    NSInteger redSection;
}
@property (nonatomic , strong) BFRedEnvelopeView *redEnvelopView;

@property (nonatomic , strong) UIView *redEnvelHeaderView;
//兑换码
@property (nonatomic , strong) WTReTextField     *conversionTextField;
@property (nonatomic , strong) UIView            *conversionView;
@property (nonatomic , strong) UIView            *converLine;
//兑换
@property (nonatomic , strong) UIButton          *conversionButton;
@property (nonatomic , strong) NSMutableArray    *redEnvelArray;
@property (nonatomic , strong) UIButton          *sureButton;

//change
@property (nonatomic , strong) UILabel           *tipSwitchLabel;
@property (nonatomic , strong) UISwitch          *isOnSwitch;

//available
@property (nonatomic , strong) NSMutableArray    *availableRedEnvelArry;
//disAvailable
@property (nonatomic , strong) NSMutableArray    *disAvailableRedEnvelArry;


//NSDictionary *modelDic
@property (nonatomic , strong) NSDictionary      *selectedModelDic;
@end

@implementation BFSelectedRedEnvelopeViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.redEnvelopView = [[BFRedEnvelopeView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.redEnvelopView;
    self.redEnvelopView.redEnvelopeTableView.delegate   = self;
    self.redEnvelopView.redEnvelopeTableView.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title                = @"选择红包";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self setHeaderViewAc];
    self.redEnvelopView.redEnvelopeTableView.tableHeaderView =self.redEnvelHeaderView;
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    viewTapGR.delegate = self;
    [self.view addGestureRecognizer:viewTapGR];
    
    
    [self.sureButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.sureButton.frame.size] forState:UIControlStateNormal];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.sureButton.layer.cornerRadius = SCREEN_WIDTH/375*3;
    self.sureButton.layer.masksToBounds= YES;
    self.sureButton.alpha = 0;
    [self.view addSubview:self.sureButton];
    [self.sureButton addTarget:self action:@selector(sureButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];

    [self requestData];
    
}

#pragma mark - 确定按钮
- (void)sureButtonDidClickedAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)requestData{
    
    redSection = 0;
    self.availableRedEnvelArry    = [NSMutableArray array];
    self.disAvailableRedEnvelArry = [NSMutableArray array];
    
    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/trade/valid-discount",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"%@",object);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            
            self.redEnvelArray = [NSMutableArray arrayWithArray:object[@"data"]];
            rowCount = self.redEnvelArray.count;
            
            
            
            /*
             for (int i=0; i <self.redEnvelArray.count; i++) {
             NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
             NSString *condition = [NSString stringWithFormat:@"%@",redDic[@"condition"]];
             NSLog(@"qian - 红包 --- %@ %@",[NSString stringWithFormat:@"%@",redDic[@"id"]],condition);
             }
             */
            
            
            /*
             
             //满足条件的红包 移前
             if (self.redEnvelArray.count>0) {
             
             for (int i=0; i <self.redEnvelArray.count; i++) {
             NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
             NSString     *condition = [NSString stringWithFormat:@"%@",redDic[@"condition"]];
             NSInteger    conditionIn = [condition integerValue];
             
             if (conditionIn<=_orderMoCount) {
             //[self.redEnvelArray removeObjectAtIndex:i];
             //[self.redEnvelArray addObject:redDic];
             [self.redEnvelArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
             [self.redEnvelArray exchangeObjectAtIndex:i withObjectAtIndex:(self.redEnvelArray.count-1)];
             }
             }
             }
             
             */
            
            
            //满足条件的红包 移前
            if (self.redEnvelArray.count>0) {
                
                for (int i=0; i <self.redEnvelArray.count; i++) {
                    NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
                    NSString     *condition = [NSString stringWithFormat:@"%@",redDic[@"condition"]];
                    NSInteger    conditionIn = [condition integerValue];
                    
                    if (conditionIn<=_orderMoCount) {
                        
                        //[self.redEnvelArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
                        //[self.redEnvelArray exchangeObjectAtIndex:i withObjectAtIndex:(self.redEnvelArray.count-1)];
                    
                        [self.availableRedEnvelArry    addObject:redDic];
                    }else{
                        [self.disAvailableRedEnvelArry addObject:redDic];
                        
                    }
                }
            }
            
            
            
            /*
             for (int i=0; i <self.redEnvelArray.count; i++) {
             NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
             NSString *condition = [NSString stringWithFormat:@"%@",redDic[@"condition"]];
             NSLog(@"middle 红包 --- %@ %@",[NSString stringWithFormat:@"%@",redDic[@"id"]],condition);
             }
             */
            
            
            
            
            
            /*
             
             //first
             if (self.redEnvelArray.count>0) {
             for (int i=0; i <self.redEnvelArray.count; i++) {
             NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
             NSString     *redID = [NSString stringWithFormat:@"%@",redDic[@"id"]];
             NSString *seledtRedID = [NSString stringWithFormat:@"%@",self.redDic[@"id"]];
             
             if ([redID isEqualToString:seledtRedID]) {
             [self.redEnvelArray removeObjectAtIndex:i];
             [self.redEnvelArray insertObject:self.redDic atIndex:0];
             }
             }
             }
             */
            
            //first
            if (self.availableRedEnvelArry.count>0) {

                for (int i=0; i <self.availableRedEnvelArry.count; i++) {
                    
                    NSDictionary *redDic  = [self.availableRedEnvelArry objectAtIndex:i];
                    NSString     *redID   = [NSString stringWithFormat:@"%@",redDic[@"id"]];
                    NSString *seledtRedID = [NSString stringWithFormat:@"%@",self.redDic[@"id"]];
                    
                    
                    if ([redID isEqualToString:seledtRedID]) {
                        [self.availableRedEnvelArry removeObjectAtIndex:i];
                        [self.availableRedEnvelArry insertObject:self.redDic atIndex:0];
                    }
                }
            }
            
            
            if (self.availableRedEnvelArry.count>0) {
                redSection++;
            }
            
            if (self.disAvailableRedEnvelArry.count>0) {
                redSection++;
            }
            
            
            
            /*
             for (int i=0; i <self.redEnvelArray.count; i++) {
             NSDictionary *redDic = [self.redEnvelArray objectAtIndex:i];
             NSString *condition = [NSString stringWithFormat:@"%@",redDic[@"condition"]];
             NSLog(@"hou 红包 --- %@ %@",[NSString stringWithFormat:@"%@",redDic[@"id"]],condition);
             }
             */
            
            
            [self.redEnvelopView.redEnvelopeTableView reloadData];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}



#pragma mark - TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 0;
    }else if (section==1){
        return self.availableRedEnvelArry.count;
    }else{
        return self.disAvailableRedEnvelArry.count;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_WIDTH/375*124;
}

//header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return SCREEN_WIDTH/375*0;
    }else if (section==1){
        if (self.availableRedEnvelArry.count>0) {
            return SCREEN_WIDTH/375*33;
        }else{
            return SCREEN_WIDTH/375*0.1;
        }
        
    }else{
        if (self.disAvailableRedEnvelArry.count>0) {
            return SCREEN_WIDTH/375*33;
        }else{
            return SCREEN_WIDTH/375*0.1;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    if (section==0) {
        return nil;
    }else if (section==1){
        if (self.availableRedEnvelArry.count>0) {
            
            UIView *headerView = [[UIView alloc] init];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*17)];
            tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
            tipLabel.textAlignment = NSTextAlignmentLeft;
            tipLabel.textColor = [UIColor colorWithHex:@"000000"];
            tipLabel.text = @"可用红包";
            [headerView addSubview:tipLabel];
            
            return headerView;
        }else{
        
            return nil;
        }
    }else{
        if (self.disAvailableRedEnvelArry.count>0) {
            UIView *headerView = [[UIView alloc] init];
            headerView.backgroundColor = [UIColor whiteColor];
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*21, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*17)];
            tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
            tipLabel.textAlignment = NSTextAlignmentLeft;
            tipLabel.textColor = [UIColor colorWithHex:@"000000"];
            tipLabel.text = @"不可用红包";
            [headerView addSubview:tipLabel];
            
            return headerView;
        }else{
        
            return nil;
        }
    }
    
    
}

//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    if (section==0) {
        return SCREEN_WIDTH/375*0.1;
    }else if (section==1){
        if (self.availableRedEnvelArry.count>0&self.disAvailableRedEnvelArry.count==0) {
            return SCREEN_WIDTH/375*100;
        }else{
            return SCREEN_WIDTH/375*0.1;
        }
    }else{
        if (self.disAvailableRedEnvelArry.count>0) {
            return SCREEN_WIDTH/375*80;
        }else{
            return SCREEN_WIDTH/375*0.1;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView         = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        return nil;
        
    }else if (indexPath.section==1) {
        
        NSDictionary *modelDic = self.availableRedEnvelArry[indexPath.row];
        static NSString *cellIndentifire = @"redEnCell";
        
        BFSelectRedEnvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFSelectRedEnvelopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        NSString *condition = [NSString stringWithFormat:@"%@",modelDic[@"condition"]];
        NSInteger conditionIn = [condition integerValue];
        
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_OnSwitch]) {
            cell.bodyImageView.image    = [UIImage imageNamed:@"couponsBackImage"];
            cell.moneyLabel.textColor   = [UIColor colorWithHex:@"A2A2A2"];
            cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"A2A2A2"];
            cell.ableImageView.alpha    = 0;
            cell.userInteractionEnabled = NO;
            self.sureButton.alpha       = 0;
        }else{
            if (conditionIn>_orderMoCount) {
                cell.bodyImageView.image    = [UIImage imageNamed:@"undisableredenvo"];
                cell.moneyLabel.textColor   = [UIColor colorWithHex:@"A2A2A2"];
                cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"A2A2A2"];
                cell.ableImageView.alpha    = 0;
                cell.userInteractionEnabled = NO;
            }else{
                cell.bodyImageView.image    = [UIImage imageNamed:@"couponsBackImage"];
                cell.moneyLabel.textColor   = [UIColor colorWithHex:@"FB344C"];
                cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"FB344C"];
                cell.ableImageView.alpha    = 1;
                self.sureButton.alpha       = 1;
                cell.userInteractionEnabled = YES;
            }
        }
        
        
        NSString *redID = [NSString stringWithFormat:@"%@",modelDic[@"id"]];
        NSString *seledtRedID = [NSString stringWithFormat:@"%@",self.redDic[@"id"]];
        if ([redID isEqualToString:seledtRedID]) {
            cell.ableImageView.image = [UIImage imageNamed:@"redenvoright"];
        }else{
            cell.ableImageView.image = [UIImage imageNamed:@"redenvowrong"];
        }
        [cell setValueWithRedEnavle:modelDic];
        return cell;
        
    }else{

        NSDictionary *modelDic = self.disAvailableRedEnvelArry[indexPath.row];
        static NSString *cellIndentifire = @"redEnCell";
        
        BFSelectRedEnvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFSelectRedEnvelopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSString *condition = [NSString stringWithFormat:@"%@",modelDic[@"condition"]];
        NSInteger conditionIn = [condition integerValue];
        
        
        cell.bodyImageView.frame = CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*301)/2, SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*301, SCREEN_WIDTH/375*108);
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_OnSwitch]) {
            cell.bodyImageView.image    = [UIImage imageNamed:@"undisableredenvo"];
            cell.moneyLabel.textColor   = [UIColor colorWithHex:@"A2A2A2"];
            cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"A2A2A2"];
            cell.ableImageView.alpha    = 0;
            cell.userInteractionEnabled = NO;
            self.sureButton.alpha       = 0;
        }else{
            if (conditionIn>_orderMoCount) {
                cell.bodyImageView.image    = [UIImage imageNamed:@"undisableredenvo"];
                cell.moneyLabel.textColor   = [UIColor colorWithHex:@"A2A2A2"];
                cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"A2A2A2"];
                cell.ableImageView.alpha    = 0;
                cell.userInteractionEnabled = NO;
            }else{
                cell.bodyImageView.image    = [UIImage imageNamed:@"couponsBackImage"];
                cell.moneyLabel.textColor   = [UIColor colorWithHex:@"FB344C"];
                cell.tipMonLabel.textColor  = [UIColor colorWithHex:@"FB344C"];
                cell.ableImageView.alpha    = 1;
                self.sureButton.alpha       = 1;
                cell.userInteractionEnabled = YES;
            }
        }
        
        
        NSString *redID = [NSString stringWithFormat:@"%@",modelDic[@"id"]];
        NSString *seledtRedID = [NSString stringWithFormat:@"%@",self.redDic[@"id"]];
        if ([redID isEqualToString:seledtRedID]) {
            cell.ableImageView.image = [UIImage imageNamed:@"redenvoright"];
        }else{
            cell.ableImageView.image = [UIImage imageNamed:@"redenvowrong"];
        }
        [cell setValueWithRedEnavle:modelDic];
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section==1) {
        
        self.selectedModelDic = self.availableRedEnvelArry[indexPath.row];
        //当前红包
        self.redDic = self.selectedModelDic;
        [self.redEnvelopView.redEnvelopeTableView reloadData];
        //NSLog(@"红包 --- %@",modelDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelecdRedEnvelNotifa" object:self.selectedModelDic];

        //[self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - tap
- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.conversionTextField resignFirstResponder];
}

#pragma mark - GR代理
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    [self.conversionTextField resignFirstResponder];
    //NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


- (void)setHeaderViewAc{
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*6, SCREEN_WIDTH, SCREEN_WIDTH/375*60)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.redEnvelHeaderView addSubview:headerView];
    self.redEnvelHeaderView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    //self.redEnvelHeaderView.backgroundColor = [UIColor redColor];
    
    self.tipSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*20, SCREEN_WIDTH/375*10, SCREEN_WIDTH/2, SCREEN_WIDTH/375*40)];
    self.tipSwitchLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.tipSwitchLabel.text = @"不使用红包优惠";
    self.tipSwitchLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.tipSwitchLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:self.tipSwitchLabel];
    
    
    self.isOnSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*20-SCREEN_WIDTH/375*50), SCREEN_WIDTH/375*(60-25)/2, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*60)];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OnSwitch]) {
        self.isOnSwitch.on = NO;
    }else{
        self.isOnSwitch.on = YES;
    }
    [self.isOnSwitch addTarget:self action:@selector(isOnSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:self.isOnSwitch];
    
    
}

#pragma mark - red switch
- (void)isOnSwitchAction:(UISwitch *)sender{

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"onSwitchRefresh"];
    if (self.isOnSwitch.on) {
        //yes
        [self.redEnvelopView.redEnvelopeTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_OnSwitch];
        
    }else{
        //no
        [self.redEnvelopView.redEnvelopeTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IS_OnSwitch];
        
    }
}


#pragma mark - 输入框
- (void)conversionTextFieldDidChange:(WTReTextField *)sender{
    if (self.conversionTextField.text.length!=0) {
        self.conversionButton.alpha = 1;
        self.conversionButton.userInteractionEnabled = YES;
    }
}

#pragma mark - 兑换
- (void)conversionButtonDidClickedAction:(UIButton *)sender{
    if (self.conversionTextField.text.length>0) {
        NSDictionary *parameter = @{@"symbol":self.conversionTextField.text};
        NSString *urlStr = [NSString stringWithFormat:@"%@/common/voucher-redeem",API];
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
            self.conversionTextField.text = @"";
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.redEnvelArray addObjectsFromArray:object[@"data"]];
                rowCount = self.redEnvelArray.count;
                [self.redEnvelopView.redEnvelopeTableView reloadData];
                [self showProgress:@"兑换成功"];
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
            self.conversionTextField.text = @"";
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }else{
        [self showProgress:@"请输入正确的兑换码"];
    }
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
-(UIView *)redEnvelHeaderView{
    
    if (_redEnvelHeaderView==nil) {
        _redEnvelHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*72)];
    }
    return _redEnvelHeaderView;
}

-(UIView *)conversionView{
    
    if (_conversionView==nil) {
        _conversionView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*39, SCREEN_WIDTH/375*22, SCREEN_WIDTH-SCREEN_WIDTH/375*(37+67), SCREEN_WIDTH/375*40)];
    }
    return _conversionView;
}

-(WTReTextField *)conversionTextField{
    
    if (_conversionTextField==nil) {
        _conversionTextField = [[WTReTextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*10, 0, SCREEN_WIDTH-SCREEN_WIDTH/375*(37+67)-SCREEN_WIDTH/375*40, SCREEN_WIDTH/375*40)];
    }
    return _conversionTextField;
}


-(UIButton *)conversionButton{
    
    if (_conversionButton==nil) {
        _conversionButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*(37+67), SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*67, SCREEN_WIDTH/375*40)];
    }
    return _conversionButton;
}

//sureButon
-(UIButton *)sureButton{

    if (_sureButton==nil) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*231)/2, SCREEN_HEIGHT-SCREEN_WIDTH/375*61, SCREEN_WIDTH/375*231, SCREEN_WIDTH/375*41)];
    }
    return _sureButton;
}

@end
