//
//  BFMyselfViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/9/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfViewController.h"
#import "BFMyselfView.h"

#import "BFNewMyselView.h"
#import "BFMyselfPersonTableViewCell.h"
#import "BFMyselfDetailTableViewCell.h"

#import "BFBiuRecordViewController.h"
#import "BFRedEnvelopeViewController.h"
#import "BFMyselfLuckyRecordViewController.h"
#import "BFUserInfViewController.h"
#import "BFQuestionViewController.h"
#import "BFFeedBackViewController.h"
#import "BFInviteRewardViewController.h"

#import "UILogRegViewController.h"
#import "BFNewGuideViewController.h"


@interface BFMyselfViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) BFNewMyselView *myselfView;

@property (nonatomic, strong) UIView              *navBarView;
@property (nonatomic, strong) UILabel             *titleLable;

@property (nonatomic, strong) NSArray             *twoArray;
@property (nonatomic, strong) NSArray             *threeArray;
@property (nonatomic, strong) NSArray             *fourArray;
@property (nonatomic, assign) BOOL                isCanSideBack;  //右滑返回允许状态
@property (nonatomic, strong) NSDictionary        *personDid;

@end

@implementation BFMyselfViewController


- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myselfView    = [[BFNewMyselView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.myselfView;
    self.myselfView.newMyselTableView.delegate   = self;
    self.myselfView.newMyselTableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    self.twoArray = @[@{@"tipIm":@"Unknown1",@"tipStr":@"我的Biu记录"},
                      @{@"tipIm":@"starfourmyself",@"tipStr":@"我的幸运记录"},
                      @{@"tipIm":@"Unknown2",@"tipStr":@"红包"}];
    
    self.threeArray = @[@{@"tipIm":@"Unknown3",@"tipStr":@"活动规则"},
                      @{@"tipIm":@"Unknown4",@"tipStr":@"反馈"},
                        @{@"tipIm":@"myelfInviteImage",@"tipStr":@"邀请奖励"}];
    
    self.fourArray = @[@{@"tipIm":@"Unknown5",@"tipStr":@"注销"}];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
        //NSLog(@"nick --- %@",nickName);
        if (nickName.length==0) {
            nickName = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
        }
        NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR];
        if (avatar.length==0) {
            //avatar = @"placeHeaderImage";
        }
        //self.personDid = @{@"nick":nickName,@"headerImage":avatar,@"ishid":@"1"};
    }else{
        //self.personDid = @{@"nick":@"请登录",@"headerImage":@"",@"ishid":@"0"};
    }
    
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationController.interactivePopGestureRecognizer.enabled  = YES;
    //self.navigationController.navigationBar.tintColor   = [UIColor whiteColor];
    //self.navigationController.navigationBar.translucent = NO;   //导航栏不透明
    
    
    [self.view       addSubview:self.navBarView];
    [self.navBarView addSubview:self.titleLable];
    
    
    //finishlogin
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishloginAction) name:@"finishlogin" object:nil];
    
    
    //myself
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenFailureLoginAction) name:@"tokenFailureLoginAction" object:nil];
}

- (void)tokenFailureLoginAction{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //first page
    //[self.tabBarController setSelectedIndex:0];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.myselfView.newMyselTableView reloadData];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        [self.tabBarController setSelectedIndex:0];
        
        //UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        //loginRegVC.entranceType = @"MySelf";
        //UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        //[self.tabBarController presentViewController:loginRegNC animated:YES completion:nil];
    }
    

    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        [[UMManager sharedManager] accountStatistics];
    }
    
    
    //UM analytics
    [[UMManager sharedManager] loadingAnalytics];
    [UMSocialData setAppKey:UMAppKey];
    [MobClick beginLogPageView:@"MyPage"];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMSocialData setAppKey:UMAppKey];
    [MobClick endLogPageView:@"MyPage"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self resetSideBack];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self forbiddenSideBack];
}


#pragma mark - 完成登录
- (void)finishloginAction{

    
    [self.myselfView.newMyselTableView reloadData];
    
    //更新用户信息
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
    //NSLog(@"nick --- %@",nickName);
    if (nickName.length==0) {
        //self.myselfView.nameLabel.text = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
    }else{
        //self.myselfView.nameLabel.text = nickName;
    }
    //[self.myselfView.headerImageViwe sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
    
}





- (BOOL)isLoginAc{

    if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN]) {
        return YES;
    }else{
        UILogRegViewController *loginRegVC = [[UILogRegViewController alloc] init];
        UINavigationController *loginRegNC = [[UINavigationController alloc] initWithRootViewController:loginRegVC];
        [self presentViewController:loginRegNC animated:YES completion:nil];
        return NO;
    }
}





#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }else if (section==1){
    
        return 3;
    }else if (section==2){
        
        return 3;
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return SCREEN_WIDTH/375*13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        
        return SCREEN_WIDTH/375*70;
    }else{
    
        return SCREEN_WIDTH/375*50;
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    static NSString *cellIndentifire = @"myselfPersonCell";
    static NSString *cellIndfdes     = @"myselfDesfilCell";
    
    if (indexPath.section==0) {
        BFMyselfPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFMyselfPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //self.personDid = @{@"nick":@"请登录",@"headerImage":@"",@"ishid":@"0"};
        [cell setPersonCell];
        return cell;
        
    }else{
    
        BFMyselfDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndfdes];
        if (!cell) {
            cell = [[BFMyselfDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndfdes];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.section==1) {
            NSDictionary *dic = self.twoArray[indexPath.row];
            [cell setDetaillCell:dic];
            if (indexPath.row==2) {
                cell.biuLine.alpha = 0;
            }
        }else if (indexPath.section==2){
            NSDictionary *dic = self.threeArray[indexPath.row];
            [cell setDetaillCell:dic];
            if (indexPath.row==24) {
                cell.biuLine.alpha = 0;
            }
        
        }else if (indexPath.section==3){
            NSDictionary *dic = self.fourArray[indexPath.row];
            cell.biuLine.alpha = 0;
            [cell setDetaillCell:dic];
        }
        
        return cell;
    }
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section==0) {
        
        if ([self isLoginAc]) {
            BFUserInfViewController *userInfoVC = [[BFUserInfViewController alloc] init];
            [userInfoVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }else if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            
            if ([self isLoginAc]) {
                [UMSocialData setAppKey:UMAppKey];
                [MobClick event:@"MyPageMyBiuRecordClick"];
                BFBiuRecordViewController *biuRecordVC = [[BFBiuRecordViewController alloc] init];
                [biuRecordVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:biuRecordVC animated:YES];
            }
        }else if (indexPath.row==1){
        
            if ([self isLoginAc]) {
                BFMyselfLuckyRecordViewController *myselfLuckeVC = [[BFMyselfLuckyRecordViewController alloc] init];
                [myselfLuckeVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:myselfLuckeVC animated:YES];
            }
        }else if (indexPath.row==2){
            if ([self isLoginAc]) {
                BFRedEnvelopeViewController *redEnvelopeVC = [[BFRedEnvelopeViewController alloc] init];
                [redEnvelopeVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:redEnvelopeVC animated:YES];
            }
        }
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            if ([self isLoginAc]) {
//                BFQuestionViewController *questionVC = [[BFQuestionViewController alloc] init];
//                [questionVC setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:questionVC animated:YES];
                
                //新手指南
                BFNewGuideViewController *guideView = [[BFNewGuideViewController alloc] init];
                guideView.webUrl = [NSString stringWithFormat:@"%@",activityUrl];
                [guideView setHidesBottomBarWhenPushed:YES];
                guideView.titleStr = @"活动规则";
                [self.navigationController pushViewController:guideView animated:YES];
            }
        }else if (indexPath.row==1){
            if ([self isLoginAc]) {
                BFFeedBackViewController *feedBackVC = [[BFFeedBackViewController alloc] init];
                [feedBackVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:feedBackVC animated:YES];
            }
        }else if (indexPath.row==2){
        
            if ([self isLoginAc]) {
                //NSLog(@"邀请好友");
                BFInviteRewardViewController *inviteRewardVC = [[BFInviteRewardViewController alloc] init];
                [inviteRewardVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:inviteRewardVC animated:YES];
            }
        }
        
    }else if (indexPath.section==3) {
        
        UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:nil message:@"确认退出登录吗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //*** 上传DEVICE_TOKEN ***//
            if ([[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN] && [[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]) {
                NSString     *urlStr = [NSString stringWithFormat:@"%@/user/push",API];
                NSDictionary *param  = @{@"device_token":@"",
                                         @"device_os":@"ios",
                                         @"badge":@(0)};
                [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:param withSuccessBlock:^(NSDictionary *object) {
                    //NSLog(@"  userPush : %@",object);
                } withFailureBlock:^(NSError *error) {
                    NSLog(@"%@",error);
                } progress:^(float progress) {}];
            }
            
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_ID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_AVATAR];
            [[NSUserDefaults standardUserDefaults] setBool:NO    forKey:IS_LOGIN];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:NICKNAME];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CARD_ID];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:REAL_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:VERIFYKEY];
            
            /*
             记录登陆时间
             */
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:LoginTimeStamp];
            
            
            
            
            
            //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
            //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_NetWork];
            
            //first page
            [self.tabBarController setSelectedIndex:0];
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertDialog addAction:cancle];
        [alertDialog addAction:okAction];
        [self presentViewController:alertDialog animated:YES completion:nil];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _titleLable.text = @"我的";
    }
    return _titleLable;
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
