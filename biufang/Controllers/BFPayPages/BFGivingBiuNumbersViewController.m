//
//  BFGivingBiuNumbersViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/11/7.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFGivingBiuNumbersViewController.h"
#import "BFGivingBiuNumbersView.h"

@interface BFGivingBiuNumbersViewController ()<BFShareViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger maxCount;
}
@property (nonatomic , strong) BFGivingBiuNumbersView *givingBiuNumbersView;
@property (nonatomic , strong) UIView *givingBiuNumbersHeaderView;
@property (nonatomic , strong) UIView *headerBodyView;
//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;
//community name
@property (nonatomic , strong) UILabel *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel *issueNumberLabel;
@property (nonatomic , strong) UIView *headerLine;

@property (nonatomic , strong) UILabel *leftGivingLabel;
@property (nonatomic , strong) UILabel *tipGivingLabel;
@property (nonatomic , strong) UITextField *inputGivingTextField;
@property (nonatomic , strong) UILabel *rightGivingLabel;
@property (nonatomic , strong) UIButton *givingButton;
@property (nonatomic , strong) UILabel *bomTipLabel;
@property (nonatomic , strong) NSArray *biuNumbersArray;
//shareaView
@property (nonatomic , strong) BFShareView *shareView;
@property (nonatomic , copy) NSString *fang_sn;
//share token
@property (nonatomic , copy) NSString *share_token;

@property (nonatomic , copy) NSString *biu_num_count;

//状态 Biu房中 揭晓中  已揭晓
@property (nonatomic , copy) NSString *fangStatus;
@end

@implementation BFGivingBiuNumbersViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.givingBiuNumbersView = [[BFGivingBiuNumbersView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.givingBiuNumbersView;
    self.givingBiuNumbersView.givingBiuNumbersTableView.delegate   = self;
    self.givingBiuNumbersView.givingBiuNumbersTableView.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赠送biu号码";
    [self setHeaderViewAc];
    self.givingBiuNumbersView.givingBiuNumbersTableView.tableHeaderView = self.givingBiuNumbersHeaderView;

    
    
    //网络
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        BFNoNetView *noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [noNetView.updateButton addTarget:self action:@selector(updateButtonDidClickAc:) forControlEvents:UIControlEventTouchUpInside];
        self.view = noNetView;
    }else{
        
        [self setMJRefreshConfig];
        [self.givingBiuNumbersView.givingBiuNumbersTableView.mj_header beginRefreshing];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"SendBiuPage"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"SendBiuPage"];
}


- (void)updateButtonDidClickAc:(UIButton *)sender{
    
    [self setMJRefreshConfig];
    [self updateDataSource];
}


- (void)updateDataSource{
    
    [self.inputGivingTextField resignFirstResponder];
    
    NSString     *urlStr = [NSString stringWithFormat:@"%@/fang/biu-numbers",API];
    NSDictionary *parame = @{@"fang_id":self.fang_ID};
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parame withSuccessBlock:^(NSDictionary *object) {
        [self.givingBiuNumbersView.givingBiuNumbersTableView.mj_header endRefreshing];
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //NSLog(@"Biu房号码 --- %@",object[@"data"][@"fang_info"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                self.view        = self.givingBiuNumbersView;
                
                self.biuNumbersArray = [NSArray arrayWithArray:object[@"data"][@"biu_numbers"][@"order"]];
                [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:object[@"data"][@"fang_info"][@"cover"]] placeholderImage:[UIImage imageNamed:@"赠送biu房号"]];
                self.communityNameLabel.text = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"title"]];
                [self.communityNameLabel sizeToFit];
                self.issueNumberLabel.text = [NSString stringWithFormat:@"期号:%@",object[@"data"][@"fang_info"][@"sn"]];
                self.fang_sn = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"sn"]];
                
                self.fangStatus = [NSString stringWithFormat:@"%@",object[@"data"][@"fang_info"][@"status"]];
                
                NSString *maxStr = [NSString stringWithFormat:@"%@",object[@"data"][@"pending"]];
                NSInteger pendInt = [maxStr integerValue];
                maxCount = self.biuNumbersArray.count-pendInt;
                
                
                //NSLog(@"Biu房号码 --- %@",object[@"data"][@"pending"]);
                //NSLog(@"%ld --- %ld --- %ld",(long)maxCount,(unsigned long)self.biuNumbersArray.count,(long)pendInt);
                
                self.tipGivingLabel.text = [NSString stringWithFormat:@"可送出%ld个",(long)maxCount];
                
                if (maxCount>0) {
                    self.inputGivingTextField.text = @"1";
                }else{
                    self.inputGivingTextField.text = @"0";
                }
                /*
                 if (maxCount<10) {
                 self.inputGivingTextField.text = [NSString stringWithFormat:@"%ld",(long)maxCount];
                 }else{
                 self.inputGivingTextField.text = @"10";
                 }
                 */
                
            }
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [self.givingBiuNumbersView.givingBiuNumbersTableView.mj_header endRefreshing];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [self.givingBiuNumbersView.givingBiuNumbersTableView.mj_header endRefreshing];
    }];
}



- (void)setMJRefreshConfig {
    MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(updateDataSource)];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.givingBiuNumbersView.givingBiuNumbersTableView.mj_header = header;
    
    
}

- (void)setHeaderViewAc{
    
    //self.givingBiuNumbersHeaderView.backgroundColor = [UIColor yellowColor];
    self.givingBiuNumbersHeaderView.userInteractionEnabled = YES;
    
    self.headerBodyView.backgroundColor = [UIColor whiteColor];
    [self.givingBiuNumbersHeaderView addSubview:self.headerBodyView];
    
    
    //self.fangImagaView.backgroundColor = [UIColor lightGrayColor];
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerBodyView addSubview:self.fangImagaView];
    
    
    self.communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.communityNameLabel.text = @"--- ---";
    self.communityNameLabel.textColor = [UIColor blackColor];
    self.communityNameLabel.numberOfLines = 0;
    self.communityNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerBodyView addSubview:self.communityNameLabel];
    
    
    self.issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.issueNumberLabel.text = @"期号：---";
    self.issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerBodyView addSubview:self.issueNumberLabel];
    
    self.headerLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    [self.headerBodyView addSubview:self.headerLine];
    
    
    self.leftGivingLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.leftGivingLabel.text = @"送出号码";
    self.leftGivingLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.leftGivingLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerBodyView addSubview:self.leftGivingLabel];
    
    self.rightGivingLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.rightGivingLabel.text = @"个";
    self.rightGivingLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.rightGivingLabel.textAlignment = NSTextAlignmentRight;
    [self.headerBodyView addSubview:self.rightGivingLabel];
    
    
    self.tipGivingLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.tipGivingLabel.text = @"可送出--个";
    self.tipGivingLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.tipGivingLabel.textAlignment = NSTextAlignmentCenter;
    //self.tipGivingLabel.backgroundColor = [UIColor redColor];
    [self.headerBodyView addSubview:self.tipGivingLabel];

    
    self.bomTipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.bomTipLabel.text = @"您的朋友只能在本期Biu房揭晓前领取，在成功领取后才会从您的账户中扣除已购买的Biu号码";
    self.bomTipLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.bomTipLabel.textAlignment = NSTextAlignmentLeft;
    self.bomTipLabel.numberOfLines = 0;
    //self.bomTipLabel.backgroundColor = [UIColor redColor];
    [self.givingBiuNumbersHeaderView addSubview:self.bomTipLabel];
    
    self.inputGivingTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.inputGivingTextField.text = @"--";
    self.inputGivingTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.inputGivingTextField.textAlignment = NSTextAlignmentCenter;
    self.inputGivingTextField.layer.borderColor = [UIColor colorWithHex:@"DDDDDD"].CGColor;
    self.inputGivingTextField.layer.borderWidth = SCREEN_WIDTH/375*1;
    self.inputGivingTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.headerBodyView addSubview:self.inputGivingTextField];
    
    [self.inputGivingTextField addTarget:self action:@selector(inputGivingTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGRAction:)];
    viewTapGR.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:viewTapGR];
    
}

- (void)viewTapGRAction:(UITapGestureRecognizer *)sender{

    [self.inputGivingTextField resignFirstResponder];
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -监测改变
- (void)inputGivingTextFieldDidChange{

    NSInteger count = [self.inputGivingTextField.text integerValue];
    NSLog(@"%ld",(long)count);
    if (count>maxCount) {
        self.inputGivingTextField.text = [NSString stringWithFormat:@"%ld",(long)maxCount];
        //self.tipGivingLabel.text = [NSString stringWithFormat:@"共%ld个",(long)maxCount];
        [self showProgress:[NSString stringWithFormat:@"最多赠送%ld个",(long)maxCount]];
    }else{
    
        self.inputGivingTextField.text = [NSString stringWithFormat:@"%ld",(long)count];
        //self.tipGivingLabel.text = [NSString stringWithFormat:@"共%ld个",(long)count];
        
    }
    
//    if (count<1) {
//        self.inputGivingTextField.text = @"1";
//        [self showProgress:@"最少赠送1个"];
//    }
    
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





//转赠Biu号码
- (void)getBiuNumberToken{
    
}




#pragma mark -Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH/375*40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIndentifire = @"issueRecordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    
    
    [self.givingButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.givingButton.frame.size] forState:UIControlStateNormal];
    [self.givingButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.givingButton setTitle:@"赠送给Ta" forState:UIControlStateNormal];
    self.givingButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.givingButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
    self.givingButton.layer.masksToBounds= YES;
    self.givingButton.userInteractionEnabled = NO;
    [cell addSubview:self.givingButton];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.inputGivingTextField resignFirstResponder];
    if ([self.fangStatus isEqualToString:@"1"]) {
        //giveButton.alpha = 1;
        //NSInteger count = [self.inputGivingTextField.text integerValue];
        //NSLog(@"赠送 -- %ld个git",(long)count);
        NSDictionary *parameter = @{@"fang_sn":self.fang_sn,
                                    @"quantity":self.inputGivingTextField.text};
        NSString *urlStr = [NSString stringWithFormat:@"%@/fang/biu-transfer",API];
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
            NSLog(@"Token --- %@",object);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                
                self.share_token = [NSString stringWithFormat:@"%@",object[@"data"][@"token"]];
                NSString *oldStr = [NSString stringWithFormat:@"%@",object[@"data"][@"old"]];
                
                if ([oldStr isEqualToString:@"1"]) {
                    self.biu_num_count = [NSString stringWithFormat:@"%@",object[@"data"][@"quantity"]];
                    if ([self.biu_num_count integerValue]>0) {
                        //pop
                        [self callPopAcQuantity:[NSString stringWithFormat:@"%@",object[@"data"][@"quantity"]]];
                    }else{
                        [self showProgress:@"没有可送的Biu号码"];
                    }
                }else{
                    self.biu_num_count = self.inputGivingTextField.text;
                    if ([self.inputGivingTextField.text integerValue]>0) {
                        //分享
                        self.shareView = [[BFShareView alloc] initWithFrame:SCREEN_BOUNDS];
                        self.shareView.delegate = self;
                        [self.shareView shareShow];
                    }else{
                        [self showProgress:@"没有可送的Biu号码"];
                    }
                }
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
    }else{
        //giveButton.alpha = 0;
        [self showProgress:@"揭晓中 不可赠送了！"];
    }
}




//弹窗
- (void)callPopAcQuantity:(NSString *)quantity{
    
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"我们发现您之前赠送给朋友的%@个Biu号码,尚无人领取", quantity] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        self.shareView = [[BFShareView alloc] initWithFrame:SCREEN_BOUNDS];
        self.shareView.delegate = self;
        [self.shareView shareShow];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertDialog addAction:cancle];
    [alertDialog addAction:okAction];
    [self presentViewController:alertDialog animated:YES completion:nil];
}


#pragma mark - BFShareDelegate
-(void)shareViewDidSelectButWithBtnTag:(NSInteger)btnTag{
    //NSLog(@"%ld",(long)btnTag);
    
    NSLog(@"期号：%@",self.fang_sn);
    NSLog(@"份数：%@",self.inputGivingTextField.text);
    
    switch (btnTag) {
        case 701:
            [[ShareManager defaulShaer] shareWechatSession:self type:@"GBN" sn:self.fang_sn token:self.share_token biuNumCount:self.biu_num_count];
            break;
        case 702:
            [[ShareManager defaulShaer] shareWechatTimeLine:self type:@"GBN" sn:self.fang_sn token:self.share_token biuNumCount:self.biu_num_count];
            break;
        case 703:
            //[[ShareManager defaulShaer] shareWebo:self sn:self.fang_sn biuNumCount:self.biu_num_count];
            break;
        case 704:
            [[ShareManager defaulShaer] shareQQ:self type:@"GBN" sn:self.fang_sn token:self.share_token biuNumCount:self.biu_num_count];
            break;
        case 705:
            [[ShareManager defaulShaer] shareQQZone:self type:@"GBN" sn:self.fang_sn token:self.share_token biuNumCount:self.biu_num_count];
            break;
        case 706:
            [[ShareManager defaulShaer] shareSms:self type:@"GBN" sn:self.fang_sn token:self.share_token biuNumCount:self.biu_num_count];
            break;
        default:
            break;
    }
}










//lazy
-(UIView *)givingBiuNumbersHeaderView{
    
    if (_givingBiuNumbersHeaderView==nil) {
        _givingBiuNumbersHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*(91+43+13+7+55))];
    }
    return _givingBiuNumbersHeaderView;//91 43 13 40 7
}

-(UIView *)headerBodyView{

    if (_headerBodyView==nil) {
        _headerBodyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*7, SCREEN_WIDTH, SCREEN_WIDTH/375*(91+43))];
    }
    return _headerBodyView;
}

//bomLabel
-(UILabel *)bomTipLabel{
    
    if (_bomTipLabel==nil) {
        _bomTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*(91+43+13+7), SCREEN_WIDTH-SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*32)];
    }
    return _bomTipLabel;
}

-(UIImageView *)fangImagaView{

    if (_fangImagaView==nil) {
        _fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    }
    return _fangImagaView;
}

-(UILabel *)communityNameLabel{

    if (_communityNameLabel==nil) {
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*34)];
    }
    return _communityNameLabel;
}

-(UILabel *)issueNumberLabel{

    if (_issueNumberLabel==nil) {
        _issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*63, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*14)];
    }
    return _issueNumberLabel;
}

-(UIView *)headerLine{
    
    if (_headerLine==nil) {
        _headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*91, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
    }
    return _headerLine;
}

//lazy
//@property (nonatomic , strong) UILabel *leftGivingLabel;
-(UILabel *)leftGivingLabel{
    
    if (_leftGivingLabel==nil) {
        _leftGivingLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*91, SCREEN_WIDTH/3, SCREEN_WIDTH/375*43)];
    }
    return _leftGivingLabel;
}

//@property (nonatomic , strong) UILabel *tipGivingLabel;
-(UILabel *)tipGivingLabel{
    
    if (_tipGivingLabel==nil) {
        _tipGivingLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*115-SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*91, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*43)];
    }
    return _tipGivingLabel;
}

//@property (nonatomic , strong) UILabel *inputGivingTextField;
-(UITextField *)inputGivingTextField{
    
    if (_inputGivingTextField==nil) {
        _inputGivingTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*40-SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*(91+9), SCREEN_WIDTH/375*64, SCREEN_WIDTH/375*26)];
    }
    return _inputGivingTextField;
}

//@property (nonatomic , strong) UILabel *rightGivingLabel;
-(UILabel *)rightGivingLabel{
    
    if (_rightGivingLabel==nil) {
        _rightGivingLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*19-SCREEN_WIDTH/375*13, SCREEN_WIDTH/375*91, SCREEN_WIDTH/375*13, SCREEN_WIDTH/375*43)];
    }
    return _rightGivingLabel;
}

-(UIButton *)givingButton{

    if (_givingButton==nil) {
        _givingButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, 0, SCREEN_WIDTH-SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*40)];
    }
    return _givingButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
