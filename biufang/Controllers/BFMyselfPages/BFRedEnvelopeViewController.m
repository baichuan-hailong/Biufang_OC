//
//  BFRedEnvelopeViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFRedEnvelopeViewController.h"
#import "BFRedEnvelopeView.h"
#import "WTReTextField.h"
#import "BFRedEnvelopeTableViewCell.h"
#import "BFRedEnavleModle.h"

//UIGestureRecognizerDelegate

@interface BFRedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    NSInteger rowCount;
}
@property (nonatomic , strong) BFRedEnvelopeView *redEnvelopView;

@property (nonatomic , strong) UIView *redEnvelHeaderView;
//兑换码
@property (nonatomic , strong) WTReTextField *conversionTextField;
@property (nonatomic , strong) UIView *conversionView;
@property (nonatomic , strong) UIView *converLine;
//兑换
@property (nonatomic , strong) UIButton *conversionButton;

@property (nonatomic , strong) NSMutableArray    *redEnvelArray;

@end

@implementation BFRedEnvelopeViewController

- (void)loadView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.redEnvelopView = [[BFRedEnvelopeView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.redEnvelopView;
    self.redEnvelopView.redEnvelopeTableView.delegate   = self;
    self.redEnvelopView.redEnvelopeTableView.dataSource = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isOrderBool) {
        self.title                = @"选择红包";
    }else{
        self.title                = @"红包";
    }
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self setHeaderViewAc];
    self.redEnvelopView.redEnvelopeTableView.tableHeaderView =self.redEnvelHeaderView;
    
    
    UITapGestureRecognizer *viewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction:)];
    //viewTapGR.delegate = self;
    [self.view addGestureRecognizer:viewTapGR];
    
    
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - 请求数据
- (void)requestData{
    
    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/trade/valid-discount",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"红包 --- %@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            self.redEnvelArray = [NSMutableArray arrayWithArray:object[@"data"]];
            rowCount = self.redEnvelArray.count;
        }
        [self.redEnvelopView.redEnvelopeTableView reloadData];
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


#pragma mark - tap
- (void)wiewTapGRAction:(UITapGestureRecognizer *)sender{
    
    [self.conversionTextField resignFirstResponder];
}

#pragma mark - GR代理
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    [self.conversionTextField resignFirstResponder];
//    //NSLog(@"%@",NSStringFromClass([touch.view class]));
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}


- (void)setHeaderViewAc{
    //color
    //self.redEnvelHeaderView.backgroundColor = [UIColor redColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*6, SCREEN_WIDTH, SCREEN_WIDTH/375*79)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.redEnvelHeaderView addSubview:headerView];
    self.redEnvelHeaderView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.conversionTextField.textColor = [UIColor colorWithHex:@"000000"];
    self.conversionTextField.tintColor = [UIColor colorWithHex:@"B2B2B2"];
    self.conversionTextField.textAlignment = NSTextAlignmentLeft;
    //self.conversionTextField.backgroundColor = [UIColor redColor];
    self.conversionTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.conversionTextField.placeholder = @"输入兑换码";
    
    
    self.conversionView.layer.borderColor = [UIColor colorWithHex:RED_COLOR].CGColor;
    self.conversionView.layer.borderWidth = SCREEN_WIDTH/375*2;
    [headerView addSubview:self.conversionView];
    
    [self.conversionView addSubview:self.conversionTextField];
    
    [self.conversionButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.conversionButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.conversionButton setTitle:@"兑换" forState:UIControlStateNormal];
    self.conversionButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    //self.conversionButton.alpha = 0.6;
    //self.conversionButton.userInteractionEnabled = NO;
    [headerView addSubview:self.conversionButton];
    
    
    [self.conversionTextField addTarget:self action:@selector(conversionTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.conversionButton addTarget:self action:@selector(conversionButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.redEnvelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_WIDTH/375*124;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (rowCount==0) {
        return (SCREEN_HEIGHT-SCREEN_WIDTH/375*80-SCREEN_WIDTH/375*64);
    }else{
        return SCREEN_WIDTH/375*15;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView *footerView = [[UIView alloc] init];
    if (rowCount==0) {
        footerView.backgroundColor = [UIColor whiteColor];
    }else{
        footerView.backgroundColor = [UIColor whiteColor];
    }
    return footerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *modelDic = self.redEnvelArray[indexPath.row];
    static NSString *cellIndentifire = @"redEnCell";
    BFRedEnvelopeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    if (!cell) {
        cell = [[BFRedEnvelopeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setValueWithRedEnavle:modelDic];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_isOrderBool) {
        NSDictionary *modelDic = self.redEnvelArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelecdRedEnvelNotifa" object:modelDic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 输入框
- (void)conversionTextFieldDidChange:(WTReTextField *)sender{
    if (self.conversionTextField.text.length!=0) {
        self.conversionButton.alpha = 1;
        self.conversionButton.userInteractionEnabled = YES;
    }else{
        //self.conversionButton.alpha = 0.6;
        //self.conversionButton.userInteractionEnabled = NO;
    }
}

#pragma mark - 兑换
- (void)conversionButtonDidClickedAction:(UIButton *)sender{

    NSLog(@"%@",self.conversionTextField.text);
    
    //NSLog(@"login");
    if (self.conversionTextField.text.length>0) {
        
        //verify moble
        NSDictionary *parameter = @{@"symbol":self.conversionTextField.text};
        NSString *urlStr = [NSString stringWithFormat:@"%@/common/voucher-redeem",API];
        [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
            //NSLog(@"%@",object);
            self.conversionTextField.text = @"";
            
            [self.conversionTextField resignFirstResponder];
            
            NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]) {
                [self.redEnvelArray addObjectsFromArray:object[@"data"]];
                rowCount = self.redEnvelArray.count;
                [self showProgress:@"兑换成功"];
                [self.redEnvelopView.redEnvelopeTableView reloadData];
            }else{
                [self showProgress:object[@"status"][@"message"]];
            }
        } withFailureBlock:^(NSError *error) {
            self.conversionTextField.text = @"";
            NSLog(@"%@",error.localizedDescription);
        } progress:^(float progress) {
            NSLog(@"%f",progress);
        }];
        
    }else{
        [self showProgress:@"请输入兑换码"];
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
        _redEnvelHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*95)];
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


@end
