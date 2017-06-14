//
//  BFMakeOrderViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMakeOrderViewController.h"
#import "BFMakeOrderView.h"

#import "BFPaySuccessfulView.h"
#import "BFPayFailedView.h"

#import "BFPayJumpTableViewCell.h"
#import "BFPaySuccessfulTableViewCell.h"
#import "BFPaySuRedMoneyTableViewCell.h"
#import "BFSelectedRedEnvelopeViewController.h"

#import "BFBiuNumbersViewController.h"
#import "BFPerfectAwardInfoViewController.h"
#import "BFGivingBiuNumbersViewController.h"

@interface BFMakeOrderViewController ()<UITableViewDelegate,UITableViewDataSource,BFPayFailedDelegate,BFShareViewDelegate>{
    
    //订单金额
    float orderMoneyCount;
    //实付款
    float actualMoneyCount;
    NSInteger oneInt;
    NSInteger twoInt;
    NSInteger threeInt;
    NSInteger fourInt;
    
    NSString *biuPrice;
    
    BOOL isBack;
    
    
}
//是否支付成功
@property (nonatomic , assign) bool isPaySuccessfulBool;

//shareaView
@property (nonatomic , strong) BFShareView *shareView;
@property (nonatomic , strong) BFMakeOrderView *makeOrderView;
//pay successful
@property (nonatomic , strong) BFPaySuccessfulView *paySuccessfulView;
//pay failed
@property (nonatomic , strong) BFPayFailedView *payFailedView;
// NSTimer
@property(nonatomic,strong)NSTimer *valiCodeTimer;
@property(nonatomic,strong)NSTimer *valiCodeTimerGo;
// 秒数
@property(nonatomic)NSInteger startTime;

@property (nonatomic , assign) bool isRoot;

//当前优惠红包ID
@property (nonatomic , copy) NSString *redID;
//可用优惠红包
@property (nonatomic , strong) NSMutableArray *nowRedArray;
@property (nonatomic , strong) NSMutableArray *nowIntArray;
@property (nonatomic , assign) BOOL isAliPay;
@property (nonatomic , strong) UITableView *badyTableView;
//当前使用的红包
@property (nonatomic , strong) NSDictionary *currentRedEnavalDic;




@property (nonatomic , strong) MBProgressHUD *HUD;

//wehcat
@property(nonatomic,strong)NSString *partnerId;
@property(nonatomic,strong)NSString *prepayId;
@property(nonatomic,strong)NSMutableString *timeStamp;
@property(nonatomic,strong)NSString *nonceStr;
@property(nonatomic,strong)NSString *package;
@property(nonatomic,strong)NSString *sign;
@end

@implementation BFMakeOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isBack = YES;
    
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.title = @"确认下单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self orderPage];
    //[self.badyTableView.mj_header beginRefreshing];
    self.isAliPay = YES;
    [self setAction];
    [self getUserInfoAction];
    
    //[self requestData];
    //have selected redEn
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveSelecdRedEnvelNotifaAction:) name:@"haveSelecdRedEnvelNotifa" object:nil];
    //aliPay successful
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPaySuccessfulAc) name:@"aliPaySuccessful" object:nil];
    //failed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayFaliedAc) name:@"aliPayFailed" object:nil];
    //BUG
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advanceFailedPopupAc) name:@"advanceFailedPopup" object:nil];
    //BUG
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnUseEnableSettleAc) name:@"returnUseEnableSettlement" object:nil];
    
    //wap pay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActiveAc) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //init
    [self requestData];
}

#pragma mark - 检测是否支付成功
- (void)didBecomeActiveAc{
    
    //self.view.userInteractionEnabled = NO;
    
    //NSLog(@"check pay is successful");
    NSString *orderSn = [[NSUserDefaults standardUserDefaults] objectForKey:@"wapOrderSn"];
    NSLog(@"%@",orderSn);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"wapOrderSnBool"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
        //look pay status
        NSString     *urlStr = [NSString stringWithFormat:@"%@/trade/order-status",API];
        NSDictionary *parm = @{@"sn":orderSn};
        [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:parm withSuccessBlock:^(NSDictionary *object) {
            isBack = YES;
            //self.view.userInteractionEnabled = YES;
            NSLog(@"wechat pay status --- %@",object);
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            NSString *paidStr  = [NSString stringWithFormat:@"%@",object[@"data"][@"status"]];
            if ([stateStr isEqualToString:@"success"]) {
                if ([paidStr isEqualToString:@"paid"]) {
                    //NSLog(@"pay successful");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
                }else{
                    //NSLog(@"pay failed");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPayFailed" object:nil];
                }
            }
            self.makeOrderView.settlementButton.userInteractionEnabled = YES;
            [self.HUD hide:YES];
        } withFailureBlock:^(NSError *error) {
            NSLog(@"%@",error);
            isBack = YES;
            //self.view.userInteractionEnabled = YES;
            self.makeOrderView.settlementButton.userInteractionEnabled = YES;
            [self.HUD hide:YES];
        } progress:^(float progress) {
            isBack = YES;
            //self.view.userInteractionEnabled = YES;
            NSLog(@"%f",progress);
        }];
    }
}



#pragma mark - 下单页
- (void)orderPage{

    [self.view addSubview:self.badyTableView];
    
    self.makeOrderView = [[BFMakeOrderView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //[self.view addSubview:self.makeOrderView];
    self.badyTableView.tableHeaderView = self.makeOrderView;
    [self.view addSubview:self.makeOrderView.sureView];
    
    /*
     MJRefreshNormalHeader     *header = [MJRefreshNormalHeader     headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
     header.lastUpdatedTimeLabel.hidden = YES;
     [header setTitle:@"下拉刷新"  forState:MJRefreshStateIdle];
     [header setTitle:@"释放更新"  forState:MJRefreshStatePulling];
     [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
     //self.badyTableView.mj_header = header;
     */
    
}


#pragma mark - Net 详情
- (void)requestData{

    /*
     //[self showProgress:@"刷新中..."];
     NSDictionary *parameter = @{@"fang_id":self.fang_id};
     NSString *urlStr        = [NSString stringWithFormat:@"%@/trade/pre-order",API];
     [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
     [self.badyTableView.mj_header endRefreshing];
     //[self hideProgress];
     
     //NSLog(@"%@",self.fang_id);
     NSLog(@"Fang --- %@",object);
     
     NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
     if ([stateStr isEqualToString:@"success"]) {
     //标题
     self.makeOrderView.communityNameLabel.text = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"title"]];
     [self.makeOrderView.communityNameLabel sizeToFit];
     //期号
     self.makeOrderView.issueNumberLabel.text   = [NSString stringWithFormat:@"期号：%@",object[@"data"][@"fang"][@"sn"]];
     self.fang_sn = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"sn"]];
     //fang
     [self.makeOrderView.fangImagaView sd_setImageWithURL:[NSURL URLWithString:object[@"data"][@"fang"][@"cover"]]];
     //单价
     self.makeOrderView.renciLabel.text         = [NSString stringWithFormat:@"￥%@/人次",object[@"data"][@"fang"][@"biu_price"]];
     
     biuPrice = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"biu_price"]];
     
     //单价
     NSString *biuPriceStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"biu_price"]];
     //单价
     biuPriceCount = [biuPriceStr integerValue];
     
     
     //is show wechat
     NSString *online = [NSString stringWithFormat:@"%@",object[@"data"][@"online"]];
     if ([online integerValue]==1) {
     self.makeOrderView.frame                = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
     self.makeOrderView.payTypeView.frame    = CGRectMake(0, CGRectGetMaxY(self.makeOrderView.orderView.frame)+9, SCREEN_WIDTH, SCREEN_WIDTH/375*104);
     self.makeOrderView.payLine.alpha        = 1;
     self.makeOrderView.wechatTypeView.alpha = 1;
     }else{
     self.makeOrderView.frame                = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*49);
     self.makeOrderView.payTypeView.frame    = CGRectMake(0, CGRectGetMaxY(self.makeOrderView.orderView.frame)+9, SCREEN_WIDTH, SCREEN_WIDTH/375*52);
     self.makeOrderView.payLine.alpha        = 0;
     self.makeOrderView.wechatTypeView.alpha = 0;
     }
     
     //限次
     NSString *limitStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"limit"]];
     NSString *stockStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"stock"]];
     if ([limitStr integerValue]<=[stockStr integerValue]) {
     //限次
     limitCount = [limitStr integerValue];
     }else{
     //限次
     limitCount = [stockStr integerValue];
     }
     //当前红包
     self.redmoneyArray = [NSArray arrayWithArray:object[@"data"][@"discount"]];
     //4个档位
     self.fixArray = [NSArray arrayWithArray:object[@"data"][@"fixed"]];
     [self gearInit:self.fixArray];
     
     self.makeOrderView.settlementButton.alpha = 1;
     self.makeOrderView.willBuyCountLabel.text  = [NSString stringWithFormat:@"可购买%ld人次",(long)limitCount];
     if (limitCount==0) {
     self.makeOrderView.settlementButton.userInteractionEnabled = NO;
     self.makeOrderView.leftCountButton.userInteractionEnabled = NO;
     [self.makeOrderView.settlementButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor lightGrayColor] size:self.makeOrderView.settlementButton.frame.size] forState:UIControlStateNormal];
     }else{
     self.makeOrderView.settlementButton.userInteractionEnabled = YES;
     self.makeOrderView.leftCountButton.userInteractionEnabled = YES;
     [self.makeOrderView.settlementButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.makeOrderView.settlementButton.frame.size] forState:UIControlStateNormal];
     }
     //初始化 计算金额
     [self calculateOriderDetailFunction];
     
     [self.badyTableView reloadData];
     }else{
     [self showProgress:object[@"status"][@"message"]];
     }
     } withFailureBlock:^(NSError *error) {
     //NSLog(@"%@",error);
     [self.badyTableView.mj_header endRefreshing];
     } progress:^(float progress) {
     //NSLog(@"%f",progress);
     //[self hideProgress];
     [self.badyTableView.mj_header endRefreshing];
     }];
     
     
     */
    
    
    
    
    //标题
    self.makeOrderView.communityNameLabel.text = [NSString stringWithFormat:@"%@",self.fang_title];
    [self.makeOrderView.communityNameLabel sizeToFit];
    //期号
    self.makeOrderView.issueNumberLabel.text   = [NSString stringWithFormat:@"期号：%@",self.fang_sn];
    //fang
    [self.makeOrderView.fangImagaView sd_setImageWithURL:[NSURL URLWithString:self.fang_url]];
    
    //is show wechat
    if ([self.isWechatonLine integerValue]==1) {
        self.makeOrderView.frame                = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.makeOrderView.payTypeView.frame    = CGRectMake(0, CGRectGetMaxY(self.makeOrderView.orderView.frame)+9, SCREEN_WIDTH, SCREEN_WIDTH/375*104);
        self.makeOrderView.payLine.alpha        = 1;
        self.makeOrderView.wechatTypeView.alpha = 1;
    }else{
        self.makeOrderView.frame                = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/375*49);
        self.makeOrderView.payTypeView.frame    = CGRectMake(0, CGRectGetMaxY(self.makeOrderView.orderView.frame)+9, SCREEN_WIDTH, SCREEN_WIDTH/375*52);
        self.makeOrderView.payLine.alpha        = 0;
        self.makeOrderView.wechatTypeView.alpha = 0;
    }
    
    self.makeOrderView.settlementButton.alpha = 1;
    
    //初始化 计算金额
    [self calculateOriderDetailFunction];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"onSwitchRefresh"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"onSwitchRefresh"];
       [self calculateOriderDetailFunction];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userInfoVCIsShowProgress"]) {
        //update
        [self.paySuccessfulView.paySuccessfulTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userInfoVCIsShowProgress"];
    }
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"PaymentPage"];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"PaymentPage"];
}



- (void)setAction{
    
    //-Action
    [self.makeOrderView.leftCountButton addTarget:self action:@selector(leftCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIControlEventTouchDown  //start
    [self.makeOrderView.leftCountButton addTarget:self action:@selector(leftCountButtonDidStartAction:) forControlEvents:UIControlEventTouchDown];
    
    //+Action  //stop
    [self.makeOrderView.rightCountButton addTarget:self action:@selector(rightCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //UIControlEventTouchDown  //start
    [self.makeOrderView.rightCountButton addTarget:self action:@selector(rightCountButtonDidStartAction:) forControlEvents:UIControlEventTouchDown];
    
    [self.makeOrderView.rightCountButton addTarget:self action:@selector(rightCountButtonDidOutAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    //tack back keybord
    UITapGestureRecognizer *keybordTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takeBackKeyBord)];
    [self.view addGestureRecognizer:keybordTapGR];
    
    //listen TF
    [self.makeOrderView.orderCountTextField addTarget:self action:@selector(orderCountTextFieldValueChaged:) forControlEvents:UIControlEventEditingChanged];
    
    //pay type
    UITapGestureRecognizer *wechatGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatTapAction:)];
    [self.makeOrderView.wechatTypeView addGestureRecognizer:wechatGR];
    
    UITapGestureRecognizer *aliGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliTapAction:)];
    [self.makeOrderView.aliTypeView addGestureRecognizer:aliGR];
    
    //结算
    [self.makeOrderView.settlementButton addTarget:self action:@selector(settlementButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //滑杆
    [self.makeOrderView.oneGearButton addTarget:self action:@selector(gearButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.makeOrderView.towGearButton addTarget:self action:@selector(gearButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.makeOrderView.threeGearButton addTarget:self action:@selector(gearButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.makeOrderView.fourGearButton addTarget:self action:@selector(gearButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //红包优惠
    UITapGestureRecognizer *edenvelopeGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edenvelopeGRTapAction:)];
    [self.makeOrderView.redenvelopeView addGestureRecognizer:edenvelopeGR];
    
}

#pragma mark - 选择红包
- (void)haveSelecdRedEnvelNotifaAction:(NSNotification *)noti{
    
    NSDictionary  *dic = (NSDictionary *)[noti object];
    self.redID    = [NSString stringWithFormat:@"%@",dic[@"id"]];
    //NSLog(@"红包---%@",dic);
    self.currentRedEnavalDic = dic;
    
    

    //份数
    NSInteger count = [self.makeOrderView.orderCountTextField.text integerValue];
    //订单金额
    NSString *orderMon = [NSString stringWithFormat:@"%ld",(long)biuPriceCount*count];
    self.makeOrderView.orderMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderMon floatValue]];
    float order = [orderMon floatValue];
    //优惠金额
    float pre = 0;
    
    NSString *condition = self.currentRedEnavalDic[@"condition"];
    NSString *preferMon = self.currentRedEnavalDic[@"value"];
    NSInteger condi = [condition integerValue];
    if (order>=condi) {
        self.makeOrderView.preferentialMoneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",[preferMon floatValue]];
        //优惠金额
        pre = [preferMon floatValue];
        
        
        NSInteger preInt = [preferMon integerValue];
        if (pre>preInt) {
            //self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld元减%.2f元",(long)condi,pre];
            self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld元减%.2f元",(long)condi,[preferMon floatValue]];
        }else{
            self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld元减%ld元",(long)condi,(long)pre];
        }

        
        
    }else{
        self.makeOrderView.preferentialMoneyLabel.text = @"0.00";
        pre = 0;
        self.makeOrderView.redMoneyLabel.text          = @"无可用红包";
        self.redID = nil;
    }
    
   
    //合计付款
    float commitmon = order-pre;
    
    //NSLog(@"%f",order);
    //NSLog(@"%f",pre);
    //NSLog(@"%f",commitmon);
    
    NSString *commitStr = [NSString stringWithFormat:@"%f",commitmon];
    self.makeOrderView.combinedMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[commitStr floatValue]];
    //Biu
    self.makeOrderView.biuMoneyLabel.text = [NSString stringWithFormat:@"送价值￥%.2f的Biu币",[commitStr floatValue]];
    actualMoneyCount = commitmon;
    //实付款
    self.makeOrderView.actualMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",[commitStr floatValue]];
    
    //NSLog(@"ID%@",self.redID);
}


#pragma mark - 收回键盘
- (void)takeBackKeyBord{
    [self.makeOrderView.orderCountTextField resignFirstResponder];
    NSLog(@"%@",self.makeOrderView.orderCountTextField.text);
    if ([self.makeOrderView.orderCountTextField.text integerValue]<1) {
        self.makeOrderView.orderCountTextField.text =@"1";
        [self calculateOriderDetailFunction];
    }
}



#pragma mark - 减加
//-
- (void)leftCountButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"0");
    NSInteger orderCount = [self.makeOrderView.orderCountTextField.text integerValue];
    
    if (orderCount==1) {
        self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
        [self stopCount];
    }else{
        orderCount--;
        self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    }
    [self stopCount];
    
    [self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];
}

//start
- (void)leftCountButtonDidStartAction:(UIButton *)sender{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeBack) userInfo:nil repeats:YES];
}

-(void)timeBack{
    NSInteger orderCount = [self.makeOrderView.orderCountTextField.text integerValue];
    if (orderCount==1) {
        [self stopCount];
    }else{
        orderCount--;
        NSLog(@"orderCount --- %ld",(long)orderCount);
        self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    }
    
    [self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];
}



//+
- (void)rightCountButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"1");
    NSInteger orderCount = [self.makeOrderView.orderCountTextField.text integerValue];
    orderCount++;
    self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    [self stopCount];
    
    [self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];
}

//start
- (void)rightCountButtonDidStartAction:(UIButton *)sender{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
}

//
-(void)timeGo{
    NSInteger orderCount = [self.makeOrderView.orderCountTextField.text integerValue];
    orderCount++;
    NSLog(@"orderCount --- %ld",(long)orderCount);
    self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    [self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];
}
//
- (void)stopCount{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = nil;
}



- (void)rightCountButtonDidOutAction:(UIButton *)sender{
    NSLog(@"out");
}



#pragma mrak - 档位
- (void)gearButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"%ld",(long)sender.tag);
    switch (sender.tag) {
        case 890:
            [self setOne:YES Two:NO Three:NO Four:NO];
            break;
        case 891:
            [self setOne:NO Two:YES Three:NO Four:NO];
            break;
        case 892:
            [self setOne:NO Two:NO Three:YES Four:NO];
            break;
        case 893:
            [self setOne:NO Two:NO Three:NO Four:YES];
            break;
        default:
            [self setOne:NO Two:NO Three:NO Four:NO];
            break;
    }
}

#pragma mark - 优选红包
- (void)selectedRedEnv{

//    self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%@-%@元",self.redmoneyArray[0][@"condition"],self.redmoneyArray[0][@"value"]];
//    self.redID = [NSString stringWithFormat:@"%@",self.redmoneyArray[0][@"id"]];
}



#pragma mark - 计算订单金额
- (void)calculateOriderDetailFunction{
    
    self.nowRedArray = [NSMutableArray array];
    self.nowIntArray = [NSMutableArray array];
    //份数
    //NSInteger count = [self.makeOrderView.orderCountTextField.text integerValue];
    
    NSInteger count = [self.orderCount integerValue];
    
    if (count>limitCount) {
        count = limitCount;
        //self.makeOrderView.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)count];
        //self.makeOrderView.willBuyCountLabel.text   = @"还可购买0人次";
        if (count>0) {
            //[self showProgress:[NSString stringWithFormat:@"最多购买%ld人次",(long)limitCount]];
        }
        //[self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];//bug
    }
    
    
    //订单金额
    //NSString *orderMon = [NSString stringWithFormat:@"%ld",(long)biuPriceCount*count];
    
    NSString *orderMon = [NSString stringWithFormat:@"%@",self.totalPriceCountStr];
    
    self.makeOrderView.orderMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[orderMon floatValue]];
    float order = [orderMon floatValue];
    
    orderMoneyCount = order;
    //优惠金额
    float pre = 0;

    //满足的红包
    for (NSDictionary *redDic in self.redmoneyArray) {
        NSString *condition = redDic[@"condition"];
        NSInteger condi = [condition integerValue];
        if (order>=condi) {
            [self.nowRedArray addObject:redDic];
        }
    }
    
    /*
     排序BUG
     */
    
    //NSLog(@"排序前---%@",self.nowRedArray);
    //for (NSDictionary *dic in self.nowRedArray) {
        //NSLog(@"%@",dic);
    //}
    
    if (self.nowRedArray.count>1) {
        for (int i=0; i<self.nowRedArray.count-1; i++) {
            for (int j=0; j<self.nowRedArray.count-1-i; j++) {
                NSDictionary *jDic     = self.nowRedArray[j];
                NSDictionary *jAddDic  = self.nowRedArray[j+1];
                
                NSString     *jCond    = jDic[@"condition"];
                NSString     *jAddCond = jAddDic[@"condition"];
                
                NSInteger    jInteger  = [jCond integerValue];
                NSInteger    jAddInteg = [jAddCond integerValue];
                
                if (jInteger<jAddInteg) {
                    NSDictionary *tempDic = self.nowRedArray[j];
                    self.nowRedArray[j]   = self.nowRedArray[j+1];
                    self.nowRedArray[j+1] = tempDic;
                }
            }
        }
    }

    
    
    //NSLog(@"排序后---%@",self.nowRedArray);
    //for (NSDictionary *dic in self.nowRedArray) {
        //NSLog(@"%@",dic);
    //}
    
    
    
    
    
    
    
    
    for (NSDictionary *reDi in self.nowRedArray) {
        NSString *cutValue = reDi[@"value"];
        [self.nowIntArray addObject:cutValue];
    }
    
    //排序
    int i,j;
    NSInteger nowcount = self.nowIntArray.count;
    for (i = 0; i < nowcount; i++) {
        for (j = i+1; j<nowcount; j++) {
            int a = [[self.nowIntArray objectAtIndex:i] intValue];
            int b = [[self.nowIntArray objectAtIndex:j] intValue];
            if (a<b) {
                [self.nowIntArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",b]];
                [self.nowIntArray replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d",a]];
            }
        }
    }
    
    NSLog(@"排序CUT --- %ld",(unsigned long)self.nowIntArray.count);
    for (int i=0; i<self.nowIntArray.count; i++) {
        NSLog(@"---%@",self.nowIntArray[i]);
    }
    
    
    if (self.nowIntArray.count>0) {
        for (NSDictionary *redDic in self.redmoneyArray) {
            NSString *bigCutVale = redDic[@"value"];
            if ([self.nowIntArray[0] integerValue]==[bigCutVale integerValue]) {
                NSString *condition = redDic[@"condition"];
                NSString *preferMon = redDic[@"value"];
                NSInteger condi = [condition integerValue];
                if (order>=condi) {
                    
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OnSwitch]) {
                        pre = [preferMon floatValue];
                        self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld减%.2f元",(long)condi,pre];
                        self.makeOrderView.preferentialMoneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",[preferMon floatValue]];
                        
                    }else{
                        self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"%ld张可用",(unsigned long)self.nowIntArray.count];
                        self.makeOrderView.preferentialMoneyLabel.text = @"-￥0.00";
                        pre = 0;
                    }
                    
                    self.redID = redDic[@"id"];;
                }else{
                    self.makeOrderView.preferentialMoneyLabel.text = @"￥0.00";
                    pre = 0;
                    self.makeOrderView.redMoneyLabel.text          = @"无可用红包";
                    self.redID = nil;
                }
            }
        }
    }else{
        self.makeOrderView.preferentialMoneyLabel.text = @"￥0.00";
        pre = 0;
        self.makeOrderView.redMoneyLabel.text          = @"无可用红包";
        self.redID = nil;
    }
    
    //self.makeOrderView.redMoneyLabel.backgroundColor = [UIColor redColor];
    //NSLog(@"满足条件的红包个数 --- %ld",(unsigned long)self.nowIntArray.count);
    
    //循环找出优惠金额
    for (NSDictionary *redDic in self.redmoneyArray) {
        
        NSString *red_id = redDic[@"id"];
        if ([self.redID integerValue]==[red_id integerValue]) {
            NSLog(@"选中红包 --- %@",redDic);
            NSString *condition = redDic[@"condition"];
            NSString *preferMon = redDic[@"value"];
            NSInteger condi = [condition integerValue];
            if (order>=condi) {
                
                
                if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_OnSwitch]) {
                    //self.isOnSwitch.on = NO;
                    pre = [preferMon floatValue];
                    
                    NSInteger preInt = [preferMon integerValue];
                    if (pre>preInt) {
                        self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld元减%.2f元",(long)condi,pre];
                    }else{
                        self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"满%ld元减%ld元",(long)condi,(long)pre];
                    }
                   
                    self.makeOrderView.preferentialMoneyLabel.text = [NSString stringWithFormat:@"-￥%.2f",[preferMon floatValue]];
                }else{
                    //self.isOnSwitch.on = YES;
                    self.makeOrderView.redMoneyLabel.text = [NSString stringWithFormat:@"%ld张可用",(unsigned long)self.nowIntArray.count];
                    self.makeOrderView.preferentialMoneyLabel.text = @"-￥0.00";
                    
                    pre = 0;
                }
                self.currentRedEnavalDic = redDic;
            }else{
                self.makeOrderView.preferentialMoneyLabel.text = @"￥0.00";
                pre = 0;
                self.makeOrderView.redMoneyLabel.text          = @"无可用红包";
                self.redID = nil;
            }
        }
    }
    
    
    //合计付款
    float commitmon = order-pre;
    
    //NSString *commitStr = [NSString stringWithFormat:@"%ld",(long)commitmon];
    
    NSLog(@"%f",commitmon);
    //NSLog(@"%@",commitStr);
    self.makeOrderView.combinedMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f", commitmon];
    //Biu
    self.makeOrderView.biuMoneyLabel.text = [NSString stringWithFormat:@"送价值￥%.2f的Biu币",commitmon];
    actualMoneyCount = commitmon;
    //实付款
    self.makeOrderView.actualMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",commitmon];
    
    NSLog(@"ID%@",self.redID);
    //NSLog(@"%@",self.redmoneyArray);
    //NSLog(@"参数 --- %ld--%ld--%ld--%ld",order,pre,commitmon,actualMoneyCount);
    
}




#pragma mark - 选择红包
- (void)edenvelopeGRTapAction:(UITapGestureRecognizer *)sender{
    
    NSLog(@"当前使用红包 --- %@",self.currentRedEnavalDic);
    NSString *redID = [NSString stringWithFormat:@"%@",_currentRedEnavalDic[@"id"]];
    NSLog(@"红包ID --- %@",redID);
    
    
    BFSelectedRedEnvelopeViewController *redEnvelopeVC = [[BFSelectedRedEnvelopeViewController alloc] init];
    redEnvelopeVC.isOrderBool = YES;
    redEnvelopeVC.redDic = self.currentRedEnavalDic;
    redEnvelopeVC.orderMoCount = orderMoneyCount;
    [self.navigationController pushViewController:redEnvelopeVC animated:YES];
}

#pragma mark - 付款方式
- (void)wechatTapAction:(UITapGestureRecognizer *)sender{
    self.isAliPay = NO;
    self.makeOrderView.wechatTypeImageView.image = [UIImage imageNamed:@"choose"];
    self.makeOrderView.aliTypeImageView.image    = [UIImage imageNamed:@"stay"];
}

- (void)aliTapAction:(UITapGestureRecognizer *)sender{
    self.isAliPay = YES;
    self.makeOrderView.wechatTypeImageView.image = [UIImage imageNamed:@"stay"];
    self.makeOrderView.aliTypeImageView.image    = [UIImage imageNamed:@"choose"];
}

#pragma mark - 结算
- (void)settlementButtonDidClickedAction:(UIButton *)sender{
    
    
    isBack = NO;
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick event:@"PaymentPageCheckClick"];
    
    
    
    NSURL *myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        
        
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.HUD = [[MBProgressHUD alloc] initWithView:keyWindow];
    [keyWindow addSubview:self.HUD];
    [self.HUD show:YES];
    
    
    /*
     //NSLog(@"结算");
     //NSLog(@"订单金额 --- %@",self.makeOrderView.orderMoneyLabel.text);
     //NSLog(@"优惠金额 --- %@",self.makeOrderView.preferentialMoneyLabel.text);
     //NSLog(@"合计付款 --- %@",self.makeOrderView.combinedMoneyLabel.text);
     //NSLog(@"实际付款 --- %@",self.makeOrderView.actualMoneyLabel.text);
     //NSLog(@"FangID --- %@",self.fang_id);
     //NSLog(@"红包ID  --- %@",self.redID);
     //NSLog(@"订单份数 --- %@",self.makeOrderView.orderCountTextField.text);
     //NSLog(@"actualMoneyCount --- %ld",(long)actualMoneyCount);
     */
    self.makeOrderView.settlementButton.userInteractionEnabled = NO;
    
    //NSLog(@"实付款 --- %f",actualMoneyCount);
    NSString *actualMoneyCountStr = [NSString stringWithFormat:@"%.2f",actualMoneyCount];
    //NSLog(@"实付款 --- %@",actualMoneyCountStr);
    
    
    if (_isAliPay) {
        [[AliPayManager sharedManager] aliPayGateway:@"alipay" fangID:self.fang_id finalPrice:actualMoneyCountStr discountID:self.redID quantity:_orderCount];
    }else{
        [self wechatPayAcFangId:self.fang_id finalPrice:actualMoneyCountStr discountID:self.redID quantity:_orderCount];
    }
}



#pragma mark - WECHAT PAY
- (void)wechatPayAcFangId:(NSString *)fang_Id finalPrice:(NSString *)finalPrice discountID:(NSString *)redID quantity:(NSString *)quantity{
    
    [WXApi registerApp:payWechatAppID withDescription:@"newbiufang"];
    
    
    NSDictionary *parameter;
    if (redID==nil||redID==NULL) {
        parameter = @{@"gateway":@"wechat",
                      @"fang_id":fang_Id,
                      @"final_price":finalPrice,
                      @"quantity":quantity};
    }else{
        parameter = @{@"gateway":@"wechat",
                      @"fang_id":fang_Id,
                      @"final_price":finalPrice,
                      @"discount_id":redID,
                      @"quantity":quantity};
    }
    
    
    //NSLog(@"pram --- %@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/trade/pre-pay",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        
        //NSLog(@"wechat pay order --- %@",object);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            
            NSString *gateway = [NSString stringWithFormat:@"%@",object[@"data"][@"gateway"]];
            if ([gateway isEqualToString:@"biupay"]) {
                
                //check
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wapOrderSnBool"];
                //0 pay successful
                [[NSNotificationCenter defaultCenter] postNotificationName:@"aliPaySuccessful" object:nil];
            }else{
                
                //check
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"wapOrderSnBool"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",object[@"data"][@"order_sn"]] forKey:@"wapOrderSn"];
                
                NSDictionary *payload = [NSDictionary dictionaryWithDictionary:object[@"data"][@"payload"]];
                //NSLog(@"%@",payload);
                [[WXApiManager sharedManager] wechatPayParameter:payload];
            }
            
            
            
        }else{
            [self.HUD setHidden:YES];
            [self showProgress:object[@"status"][@"message"]];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        
    }];
}



//BUG
- (void)returnUseEnableSettleAc{

    [self.HUD hide:YES];
    self.makeOrderView.settlementButton.userInteractionEnabled = YES;
}


#pragma mark - 预先弹出失败弹窗
- (void)advanceFailedPopupAc{

    //NSLog(@"%@",[[AlipaySDK defaultService] currentVersion]);
    
    NSURL *myURL_APP_A = [NSURL URLWithString:@"alipay:"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [self performSelector:@selector(advanceFailedPop) withObject:nil afterDelay:2.0];
        return;
    }
}

- (void)advanceFailedPop{
    [self.HUD hide:YES];
    if (!_isPaySuccessfulBool) {
        //BUG
        self.payFailedView.delegate = self;
        [self.payFailedView showPayFailed];
    }
    
}


#pragma mark - Ali支付结果
//successful
- (void)aliPaySuccessfulAc{
    
    [self.HUD hide:YES];
    self.makeOrderView.settlementButton.userInteractionEnabled = YES;
    //BUG
    [self.payFailedView hiddenPayFailed];
    _isPaySuccessfulBool = YES;
    //successful
    [self showPaySuccessfulView];
    self.isRoot = YES;
}

//failed
- (void)aliPayFaliedAc{
    
    [self.HUD hide:YES];
    self.makeOrderView.settlementButton.userInteractionEnabled = YES;
    _isPaySuccessfulBool = NO;
    //fail
    self.payFailedView.delegate = self;
    [self.payFailedView showPayFailed];
}



#pragma mark - 支付失败弹窗Delegate
-(void)canclePay:(UIButton *)sender{

    NSLog(@"OK");
}
-(void)continuePay:(UIButton *)sender{
    NSLog(@"continue");
    
    //[self settlementButtonDidClickedAction:nil];
    //settlementButtonDidClickedAction:(UIButton *)sender
    
    [self settlementButtonDidClickedAction:nil];
    
    /*
     //BUG
     if (self.isAliPay) {
     NSString *actualMoneyCountStr = [NSString stringWithFormat:@"%ld",(long)actualMoneyCount];
     [[AliPayManager sharedManager] aliPayGateway:@"alipay" fangID:self.fang_id finalPrice:actualMoneyCountStr discountID:self.redID quantity:self.makeOrderView.orderCountTextField.text];
     }else{
     [self showProgress:@"稍后开通..."];
     }
     */
}

-(void)backAction{
    if (_isRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [UMSocialData setAppKey:UMAppKey];
        [MobClick endLogPageView:@"PaymentSuccessPage"];
    }else{

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - 获取用户信息
- (void)getUserInfoAction{
    
    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/info?fields=username,avatar&expand=real",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"realname"] forKey:REAL_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"id_num"] forKey:CARD_ID];
        }
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}




#pragma mark - 设置档位
- (void)gearInit:(NSArray *)array{

    if (array.count==4) {
        //init
        self.makeOrderView.orderCountTextField.text = @"1";
        [self.makeOrderView.oneGearButton setTitle:array[0] forState:UIControlStateNormal];
        [self.makeOrderView.towGearButton setTitle:array[1] forState:UIControlStateNormal];
        [self.makeOrderView.threeGearButton setTitle:array[2] forState:UIControlStateNormal];
        [self.makeOrderView.fourGearButton setTitle:array[3] forState:UIControlStateNormal];
        //初始档位状态
        [self orderCountTextFieldValueChaged:self.makeOrderView.orderCountTextField];
    }
}

#pragma mark - TextField 改变
- (void)orderCountTextFieldValueChaged:(UITextField *)sender{
    
    //NSLog(@"%@",sender.text);
    NSInteger senderInt = [self.makeOrderView.orderCountTextField.text integerValue];
    if (self.fixArray.count==4) {
        oneInt = [self.fixArray[0] integerValue];
        twoInt = [self.fixArray[1] integerValue];
        threeInt = [self.fixArray[2] integerValue];
        fourInt = [self.fixArray[3] integerValue];
    }
    if (senderInt==oneInt) {
        [self setOne:YES Two:NO Three:NO Four:NO];
    }else if (senderInt==twoInt){
        [self setOne:NO Two:YES Three:NO Four:NO];
    }else if (senderInt==threeInt){
        [self setOne:NO Two:NO Three:YES Four:NO];
    }else if (senderInt==fourInt){
        [self setOne:NO Two:NO Three:NO Four:YES];
    }else{
        [self setOne:NO Two:NO Three:NO Four:NO];
    }    
}



- (void)setOne:(BOOL)oneBool Two:(BOOL)twoBool Three:(BOOL)threeBool Four:(BOOL)fourBool{
    
    if (oneBool) {
        self.makeOrderView.orderCountTextField.text = self.fixArray[0];
        [self.makeOrderView.oneGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
        [self.makeOrderView.oneGearButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    }else{
        [self.makeOrderView.oneGearButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.makeOrderView.oneGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    }
    
    if (twoBool) {
        self.makeOrderView.orderCountTextField.text = self.fixArray[1];
        [self.makeOrderView.towGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
        [self.makeOrderView.towGearButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    }else{
        [self.makeOrderView.towGearButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.makeOrderView.towGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    }
    
    if (threeBool) {
        self.makeOrderView.orderCountTextField.text = self.fixArray[2];
        [self.makeOrderView.threeGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
        [self.makeOrderView.threeGearButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    }else{
        [self.makeOrderView.threeGearButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.makeOrderView.threeGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    }
    
    if (fourBool) {
        self.makeOrderView.orderCountTextField.text = self.fixArray[3];
        [self.makeOrderView.fourGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
        [self.makeOrderView.fourGearButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    }else{
        [self.makeOrderView.fourGearButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [self.makeOrderView.fourGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    }
    
    //订单计算
     [self calculateOriderDetailFunction];
    
}








#pragma mark - 付款成功
- (void)showPaySuccessfulView{
    
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"PaymentSuccessPage"];
    
    
    [MobClick event:@"PaymentSuccess"];
    
    self.title = @"支付状态";
    self.paySuccessfulView = [[BFPaySuccessfulView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view              = self.paySuccessfulView;
    self.paySuccessfulView.paySuccessfulTableView.delegate = self;
    self.paySuccessfulView.paySuccessfulTableView.dataSource = self;
    
    [self.paySuccessfulView.redmoneyButton addTarget:self action:@selector(redmoneyButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self leftButton];
}

- (void)leftButton {
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"close icon"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 15, 64, 40);
    [button addTarget:self action:@selector(disbackAction:) forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)disbackAction:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发红包
- (void)redmoneyButtonDidClickedAction:(UIButton *)sender{
    //NSLog(@"分享");
    self.shareView          = [[BFShareView alloc] initWithFrame:SCREEN_BOUNDS];
    self.shareView.delegate = self;
    [self.shareView shareShow];
}


#pragma mark - BFShareDelegate
-(void)shareViewDidSelectButWithBtnTag:(NSInteger)btnTag{
    //NSLog(@"%ld",(long)btnTag);
    switch (btnTag) {
        case 701:
            [[ShareManager defaulShaer] shareWechatSession:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            break;
        case 702:
            [[ShareManager defaulShaer] shareWechatTimeLine:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            break;
        case 703:
            
            if (![WeiboSDK isWeiboAppInstalled]){
                
                [self.shareView shareHide];
                [self showProgress:@"未安装微博客户端"];
                
            }else{
                
                [[ShareManager defaulShaer] shareWebo:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            }
            
            break;
        case 704:
            [[ShareManager defaulShaer] shareQQ:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            break;
        case 705:
            [[ShareManager defaulShaer] shareQQZone:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            break;
        case 706:
            [[ShareManager defaulShaer] shareSms:self type:@"GRE" sn:self.fang_sn token:biuPrice biuNumCount:@"0"];
            break;
        default:
            break;
    }
}

#pragma mark - 支付成功 TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //return 3;
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SCREEN_WIDTH/375*8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return SCREEN_WIDTH/375*146;
    }else{
        return SCREEN_WIDTH/375*44;
    }
    
    //else if(indexPath.section==1){
      //  return SCREEN_WIDTH/750*236;
    //}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        static NSString *celid = @"paySuccCell";
        BFPaySuccessfulTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celid];
        if (!cell) {
            cell = [[BFPaySuccessfulTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:celid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.rightLabel addTarget:self action:@selector(biuNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else{
        static NSString *cellIfire = @"userInfoCell";
        BFPayJumpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIfire];
        if (!cell) {
            cell = [[BFPayJumpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIfire];
            cell.leftLabel.text = @"完善领奖信息";
            
        }
        NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
        //NSLog(@"%@---%ld",realName,realName.length);
        if (realName.length==0) {
            cell.rightLabel.text = @"未填写";
            cell.rightLabel.textColor = [UIColor colorWithHex:@"4A90E2"];
        }else{
            cell.rightLabel.text = realName;
            cell.rightLabel.textColor = [UIColor colorWithHex:@"4A90E2"];
        }
        return cell;
    }
    
    
//    else if (indexPath.section==1){
//        static NSString *ceid = @"payCell";
//        BFPaySuRedMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ceid];
//        if (!cell) {
//            cell = [[BFPaySuRedMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ceid];
//        }
//        return cell;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        
    }else{
        BFPerfectAwardInfoViewController *perfectAwardVC = [[BFPerfectAwardInfoViewController alloc] init];
        [self.navigationController pushViewController:perfectAwardVC animated:YES];
    }
    
    
//    else if (indexPath.section==1){
//        //NSLog(@"赠送Biu房号码");
//        BFGivingBiuNumbersViewController *givingBiuNumbersVC = [[BFGivingBiuNumbersViewController alloc] init];
//        givingBiuNumbersVC.fang_ID = self.fang_id;
//        [self.navigationController pushViewController:givingBiuNumbersVC animated:YES];
//        
//    }
}


#pragma mark - 查看Biu房号码
- (void)biuNumberAction:(UIButton *)sender{
    BFBiuNumbersViewController *biuNumbersVC = [[BFBiuNumbersViewController alloc] init];
    biuNumbersVC.fangID = self.fang_id;
    [self.navigationController pushViewController:biuNumbersVC animated:YES];
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

-(UITableView *)badyTableView{
    
    if (_badyTableView == nil) {
        _badyTableView = [[UITableView alloc] init];
        _badyTableView.frame = CGRectMake(0, SCREEN_WIDTH/375*64, SCREEN_WIDTH, SCREEN_HEIGHT);
        _badyTableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        _badyTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _badyTableView.showsVerticalScrollIndicator = NO;
    }
    return _badyTableView;

}


-(BFPayFailedView *)payFailedView{

    if (_payFailedView==nil) {
        _payFailedView = [[BFPayFailedView alloc] initWithFrame:SCREEN_BOUNDS];
    }
    return _payFailedView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
