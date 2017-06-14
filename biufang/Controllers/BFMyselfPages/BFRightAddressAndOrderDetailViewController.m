//
//  BFRightAddressAndOrderDetailViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/12/24.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFRightAddressAndOrderDetailViewController.h"
#import "BFRightAddressAndOrderDetailView.h"
#import "BFDetailViewController.h"
#import "BFWriteAddressTableViewCell.h"

#import "BFOrderUserAddressTableViewCell.h"
#import "BFAdressTimeLineTableViewCell.h"

#import "BFOrderBiuNumbersViewController.h"

@interface BFRightAddressAndOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
    NSInteger orderInt;
    NSInteger getInt;

}

@property (nonatomic , strong) BFRightAddressAndOrderDetailView *wrightAddressAndOrderDetailView;

//header
@property (nonatomic , strong) UIView        *issueHeaderView;
//fang image
@property (nonatomic , strong) UIImageView   *fangImagaView;
//community name
@property (nonatomic , strong) UILabel       *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel       *issueNumberLabel;
//arrow image
@property (nonatomic , strong) UIImageView   *arrowImagaView;

//commitBtn
@property (nonatomic , strong) UIButton      *commitButton;

@property (nonatomic , strong) MBProgressHUD *HUD;

@property (nonatomic , strong) BFOrderBiuNumbersViewController *orderBiuNumbersVC;


//物流信息
@property (nonatomic , strong) NSDictionary  *orderInfoDid;
//timeLine Array
@property (nonatomic , strong) NSArray       *timeLineArray;
//time
@property (nonatomic , strong) NSString      *timeStr;

//empty
@property (nonatomic , strong) UIView        *emptyView;
@property (nonatomic , strong) UIImageView   *emptyImageView;
@property (nonatomic , strong) UILabel       *emptyLabel;


//物流INFO
@property (nonatomic , strong) UIView        *logisticsView;
//logistics type
@property (nonatomic , strong) UILabel       *logisticsTypeLabel;
//logistics number
@property (nonatomic , strong) UILabel       *logisticsNumberLabel;


//Back Bool
@property (nonatomic , assign) BOOL         isBackVCBool;

@end

@implementation BFRightAddressAndOrderDetailViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.wrightAddressAndOrderDetailView = [[BFRightAddressAndOrderDetailView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.wrightAddressAndOrderDetailView;
    self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.delegate   = self;
    self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.dataSource = self;
    
    self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.timeStr = @"--";
    
    //@property (nonatomic , strong) NSDictionary  *orderInfoDid;
    self.orderInfoDid = @{@"name": @"--",
                          @"mobile": @"--",
                          @"address": @"-- -- --"
                          };
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    [self setUnifiedView];
    self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.tableHeaderView = self.issueHeaderView;

    UITapGestureRecognizer *headerTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapGRAc:)];
    [self.issueHeaderView addGestureRecognizer:headerTapGR];
    
    //commit
    [self.commitButton addTarget:self action:@selector(commitButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.delivery_status = @"none";
    if ([self.delivery_status isEqualToString:@"none"]) {
        self.title          = @"填写收货地址";
    }else{
        self.title          = @"购买详情";
    }
    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
        
    }else{
        if ([self.delivery_status isEqualToString:@"none"]) {
            //self.title          = @"填写收货地址";
            _isWriteAddressBool = YES;
        }else{
            //self.title          = @"订单详情";
            _isWriteAddressBool = NO;
            //[self uploadLogisticsDataAction];
            
            [self setMJRefreshConfig];
            [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.mj_header beginRefreshing];
        }
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numbersRefreshAC:) name:@"numbersRefresh" object:nil];
}

//刷新footer height
- (void)numbersRefreshAC:(NSNotification *)notification{
    NSDictionary *notiDic = (NSDictionary *)[notification object];
    //NSLog(@"gaodu --- %@",notiDic);
    NSString *orderStr = [NSString stringWithFormat:@"%@",notiDic[@"ordernum"]];
    NSString *getStr   = [NSString stringWithFormat:@"%@",notiDic[@"getnum"]];
    
    orderInt = [orderStr integerValue];
    getInt   = [getStr integerValue];
    
    //NSLog(@"%ld---%ld",(long)orderInt,(long)getInt);
}

- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self uploadLogisticsDataAction];
}




#pragma mark - 详情
- (void)headerTapGRAc:(UITapGestureRecognizer *)sender{
    
     //BFDetailViewController *detailVC = [[BFDetailViewController alloc] init];
     //detailVC.detailId = self.fang_ID;
     //[self.navigationController pushViewController:detailVC animated:YES];
     
}


#pragma mark - TextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    //NSLog(@"%@",string);
    //name
    if (textField.tag==776) {
    
        if (textField.text.length>19) {
            [self showProgress:@"最多输入20个字符"];
            return NO;
        }else{
            return YES;
        }
    }else{
    //tel
        if (textField.text.length>10) {
            [self showProgress:@"请输入正确的手机号"];
            return NO;
        }else{
            return YES;
        }
    }
}


#pragma mark - TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    BFWriteAddressTableViewCell *writeCell = [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *addressText = [writeCell.addressTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (addressText.length>0) {
        [writeCell.placeAddressLabel removeFromSuperview];
    }else{
        [writeCell.coView addSubview:writeCell.placeAddressLabel];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 50) {
            
            [self showProgress:@"最多输入50个字符"];
            return NO;
        }
        else {
            return YES;
        }
    }
}




#pragma mark -Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isWriteAddressBool) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isWriteAddressBool) {
        return 1;
    }else{
        if (section==0) {
            return 1;
        }else{
            return self.timeLineArray.count;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isWriteAddressBool) {
        static NSString *cellIndentifire = @"writeAddressTableViewCell";
        BFWriteAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell=[[BFWriteAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        }
        cell.addressTextField.delegate = self;
        cell.nameTextField.delegate    = self;
        cell.telTextField.delegate     = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        if (indexPath.section==0) {
            static NSString *ordercellIndentifire = @"orderUserAddressTableViewCell";
            BFOrderUserAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ordercellIndentifire];
            if (!cell) {
                cell=[[BFOrderUserAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ordercellIndentifire];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setCell:self.orderInfoDid time:self.timeStr];
            return cell;
        }else{
            static NSString *addcellIndentifire = @"adressTimeLineTableViewCell";
            BFAdressTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addcellIndentifire];
            if (!cell) {
                cell=[[BFAdressTimeLineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addcellIndentifire];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row==0) {
                cell.maskView.alpha = 1;
                cell.tipImageView.image = [UIImage imageNamed:@"Oval 3"];
                cell.tipImageView.frame = CGRectMake(SCREEN_WIDTH/375*(22-6.5+0.5), SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*13, SCREEN_WIDTH/375*13);
                cell.Line.alpha = 0;
            }else{
                cell.maskView.alpha = 0;
                cell.tipImageView.image = [UIImage imageNamed:@"Oval 3 Copy 2-1"];
                cell.tipImageView.frame = CGRectMake(SCREEN_WIDTH/375*(22-4+0.5), SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*8);
                cell.Line.alpha = 1;
            }
            
            NSDictionary *currentDic = self.timeLineArray[indexPath.row];
            NSLog(@"%ld",(unsigned long)self.timeLineArray.count);
            [cell setCellInfo:currentDic];
            return cell;
        }
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isWriteAddressBool) {
        return SCREEN_WIDTH/375*233;
    }else{
        if (indexPath.section==0) {
            return SCREEN_WIDTH/375*131;
        }else{
            return SCREEN_WIDTH/375*65;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (_isWriteAddressBool) {
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor clearColor];
        [footView addSubview:self.commitButton];
        [self.commitButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.commitButton.frame.size] forState:UIControlStateNormal];
        [self.commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
        self.commitButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
        self.commitButton.layer.masksToBounds= YES;
        return footView;
    }else{
        
        if (section==0) {
            UIView *footView = [[UIView alloc] init];
            return footView;
        }else{
            //BFOrderBiuNumbersViewController *orderBiuNumbersVC = [[BFOrderBiuNumbersViewController alloc] init];
            self.orderBiuNumbersVC.fang_ID = self.fang_ID;
            [self addChildViewController:self.orderBiuNumbersVC];
            self.orderBiuNumbersVC.view.backgroundColor = [UIColor redColor];
            return self.orderBiuNumbersVC.view;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_isWriteAddressBool) {
        return SCREEN_WIDTH/375*(40+35);
    }else{
        if (section==0) {
            return SCREEN_WIDTH/375*5;
        }else{
            //(orderInt/5+1);
            //(getInt/5+1);
            //orderInt*
            if (((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*30)>SCREEN_HEIGHT) {
                
                //self.orderBiuNumbersVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, ((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*30));
                
                //self.orderBiuNumbersVC.awardOrderDetailView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*30));
                
                self.orderBiuNumbersVC.awardOrderDetailView.awardOrderDetailTableView.frame      = CGRectMake(0, 0, SCREEN_WIDTH, ((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*25));
                
                //return SCREEN_HEIGHT;
                return ((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*25);
            }else{
            
                return ((orderInt/5+1)*SCREEN_WIDTH/375*30+(getInt/5+1)*SCREEN_WIDTH/375*30);
            }
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_isWriteAddressBool) {
        return SCREEN_WIDTH/375*0;
    }else{
        if (section==0) {
            return SCREEN_WIDTH/375*0.1;
        }else{
            if (self.timeLineArray.count>0) {
                return SCREEN_WIDTH/375*(10+87);
            }else{
                return SCREEN_WIDTH/375*200;
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_isWriteAddressBool) {
        
        return nil;
    }else{
        
        
        if (section==0) {
            //return SCREEN_WIDTH/375*0.1;
            UIView *headerView = [[UIView alloc] init];
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        }else{
            if (self.timeLineArray.count>0) {
                
                self.logisticsView.backgroundColor = [UIColor whiteColor];
                
                [self setLogisticsAc];
                
                return self.logisticsView;
                
            }else{
                
                //return SCREEN_WIDTH/375*200;
                [self setEmptyView];
                return _emptyView;
            }
            
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}


#pragma mark - 空物流
- (void)setEmptyView{

    //awardlogisticsEmpty
    //SCREEN_WIDTH/375*200
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*200)];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    
    self.emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*56)/2, (SCREEN_WIDTH/375*200-SCREEN_WIDTH/375*52)/2, SCREEN_WIDTH/375*56, SCREEN_WIDTH/375*52)];
    self.emptyImageView.image = [UIImage imageNamed:@"awardlogisticsEmpty"];
    [self.emptyView addSubview:self.emptyImageView];
    
    
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emptyImageView.frame)+SCREEN_WIDTH/375*10, SCREEN_WIDTH, SCREEN_WIDTH/375*17)];
    self.emptyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.emptyLabel.text = @"没有查询到物流信息";
    self.emptyLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:self.emptyLabel];
    
}


#pragma mark - 物流信息
- (void)setLogisticsAc{
    
    UIImageView *logistixsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*14)];
    logistixsImageView.image = [UIImage imageNamed:@"logisticTipImage"];
    [self.logisticsView addSubview:logistixsImageView];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*33, SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*14)];
    tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    tipLabel.text = @"物流信息";
    tipLabel.textColor = [UIColor colorWithHex:@"000000"];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    [self.logisticsView addSubview:tipLabel];
    

    [self.logisticsView addSubview:self.logisticsTypeLabel];
    self.logisticsTypeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.logisticsTypeLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.logisticsTypeLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [self.logisticsView addSubview:self.logisticsNumberLabel];
    self.logisticsNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.logisticsNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.logisticsNumberLabel.textAlignment = NSTextAlignmentLeft;
    
}


#pragma mark - 统一顶栏
- (void)setUnifiedView{
    
    self.issueHeaderView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    UIView *headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*6, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    headerBodyView.backgroundColor = [UIColor whiteColor];
    [self.issueHeaderView addSubview:headerBodyView];
    
    
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
    
    
    NSLog(@"picture --- %@",self.cover);
    
    [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:self.cover]];
    self.communityNameLabel.text = self.communityNameStr;
    [self.communityNameLabel sizeToFit];
    self.issueNumberLabel.text = [NSString stringWithFormat:@"期号:%@",self.issueNumberStr];
}

#pragma mark - 提交
- (void)commitButtonDidClickedAction:(UIButton *)sender{

    BFWriteAddressTableViewCell *writeCell = [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //NSLog(@"姓名---%@手机号---%@地址---%@",writeCell.nameTextField.text,writeCell.telTextField.text,writeCell.addressTextField.text);
    NSDictionary *payload = @{@"name":writeCell.nameTextField.text,
                              @"mobile":writeCell.telTextField.text,
                              @"address":writeCell.addressTextField.text};
    
    NSDictionary *parameter = @{@"fang_id":self.fang_ID,
                                @"payload":payload};
    
    //NSLog(@"参数 ---- %@",parameter);
    
    if ((writeCell.nameTextField.text.length>0)&(writeCell.telTextField.text.length>0)&(writeCell.addressTextField.text.length>0)) {
        
        
        
        
        if ([BFRegularManage checkMobile:writeCell.telTextField.text]&&writeCell.nameTextField.text.length<21&&writeCell.addressTextField.text.length<51) {
            [self showProgress];
            NSString *urlStr = [NSString stringWithFormat:@"%@/fang/set-delivery",API];
            [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
                
                NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
                if ([stateStr isEqualToString:@"success"]) {
                    
                    _isBackVCBool = YES;
                    self.title = @"订单详情";
                    _isWriteAddressBool = NO;
                    [self hidProgress];
                    [self uploadLogisticsDataAction];
                    //local storage
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",writeCell.addressTextField.text] forKey:Order_Address];
                    
                    NSDictionary *notiParam = @{@"fangId":self.fang_ID};
                    
                    //refresh lucky list
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"luckyRecordRefresh" object:notiParam];
                }else{
                    [self hidProgress];
                    [self showProgress:object[@"status"][@"message"]];
                }
            } withFailureBlock:^(NSError *error) {
                [self hidProgress];
                NSLog(@"%@",error.localizedDescription);
            } progress:^(float progress) {
                NSLog(@"%f",progress);
            }];
            
        }else{
            
            if (![BFRegularManage checkMobile:writeCell.telTextField.text]) {
                [self showProgress:@"请输入正确的手机号"];
            }else if (writeCell.nameTextField.text.length>20){
                [self showProgress:@"请输入正确的收货人信息"];
            }else if (writeCell.addressTextField.text.length>50){
                [self showProgress:@"请输入正确的收货地址"];
            }
        }
    }else{
        [self showProgress:@"请完善收货地址"];
    }
    
}


- (void)setMJRefreshConfig {
    
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(uploadLogisticsDataAction)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.mj_header = header;

    
}


#pragma mark - 物流信息
- (void)uploadLogisticsDataAction{
    
    [self showProgress];
    
    //sender coder
    NSDictionary *parm = @{@"fang_id":self.fang_ID};
    NSString *urlStr = [NSString stringWithFormat:@"%@/fang/get-delivery",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parm withSuccessBlock:^(NSDictionary *object) {
        NSLog(@"物流信息 --- %@",object[@"data"][@"result"]);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            self.view          = self.wrightAddressAndOrderDetailView;//net
            
            self.orderInfoDid  = [NSDictionary dictionary];
            self.timeLineArray = [NSArray array];
            
            
            self.timeStr = [NSString stringWithFormat:@"%@",object[@"data"][@"time"]];
            
            //@property (nonatomic , strong) NSDictionary  *orderInfoDid;
            self.orderInfoDid = object[@"data"][@"payload"];
            //NSLog(@"用户提交信息 -- %@",self.orderInfoDid);
            //timeLine Array
            
            
            NSObject *resultObject = object[@"data"][@"result"];
            if (![resultObject isEqual:[NSNull null]]) {
                self.timeLineArray = object[@"data"][@"result"][@"process"];
                
                
                self.logisticsTypeLabel.text   = [NSString stringWithFormat:@"承运来源：%@",object[@"data"][@"result"][@"type"]];
                self.logisticsNumberLabel.text = [NSString stringWithFormat:@"运单编号：%@",object[@"data"][@"result"][@"number"]];
                
            }
            //NSLog(@"物流信息 -- %@",self.timeLineArray);
            [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView reloadData];
        }else{
            [self showProgress:object[@"status"][@"message"]];
        }
        [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.mj_header endRefreshing];
        [self hidProgress];
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.mj_header endRefreshing];
        [self hidProgress];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.wrightAddressAndOrderDetailView.writeAddressOrderDetailTableView.mj_header endRefreshing];
        [self hidProgress];
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

//progress
- (void)showProgress{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
}

- (void)hidProgress{
    [self.HUD hide:YES];
}

//lazy
-(UIView *)issueHeaderView{
    if (_issueHeaderView==nil) {
        _issueHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*103)];
    }
    return _issueHeaderView;
}

-(UIButton *)commitButton{

    if (_commitButton==nil) {
        _commitButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*19, SCREEN_WIDTH/375*35, SCREEN_WIDTH-SCREEN_WIDTH/375*38, SCREEN_WIDTH/375*40)];
    }
    return _commitButton;
}

-(BFOrderBiuNumbersViewController *)orderBiuNumbersVC{

    if (_orderBiuNumbersVC==nil) {
        _orderBiuNumbersVC = [[BFOrderBiuNumbersViewController alloc] init];
    }
    return _orderBiuNumbersVC;
}

//back
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
    
    
    if (_isBackVCBool) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//lazy
//物流INFO
//@property (nonatomic , strong) UIView        *logisticsView;
-(UIView *)logisticsView{
    if (_logisticsView==nil) {
        _logisticsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(10+87))];
        _logisticsView.backgroundColor = [UIColor orangeColor];
    }
    return _logisticsView;
}
//logistics type
//@property (nonatomic , strong) UILabel       *logisticsTypeLabel;
-(UILabel *)logisticsTypeLabel{

    if (_logisticsTypeLabel==nil) {
        _logisticsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*33, SCREEN_WIDTH/375*39, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*14)];
        _logisticsTypeLabel.text = @"承运来源：--";
    }
    return _logisticsTypeLabel;
}
//logistics number
//@property (nonatomic , strong) UILabel       *logisticsNumberLabel;
-(UILabel *)logisticsNumberLabel{

    if (_logisticsNumberLabel==nil) {
        _logisticsNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*33, SCREEN_WIDTH/375*62, SCREEN_WIDTH/375*200, SCREEN_WIDTH/375*14)];
        _logisticsNumberLabel.text= @"运单编号：--";
    }
    return _logisticsNumberLabel;
}


@end
