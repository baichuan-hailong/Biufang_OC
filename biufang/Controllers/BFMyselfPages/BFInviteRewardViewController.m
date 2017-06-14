//
//  BFInviteRewardViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/12/31.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFInviteRewardViewController.h"

@interface BFInviteRewardViewController ()<BFShareViewDelegate>

@property (nonatomic , strong)UIScrollView      *bodyView;
@property (nonatomic , strong)UIImageView *bannerImageView;
@property (nonatomic , strong)UIImageView *downBodyImageView;
@property (nonatomic , strong)UIButton    *inviteButton;

//Border
@property (nonatomic , strong)UIImageView *borderImageView;
@property (nonatomic , strong)UIImageView *emailImageView;
@property (nonatomic , strong)UIImageView *arrowImageView;
@property (nonatomic , strong)UIImageView *biuImageView;
@property (nonatomic , strong)UILabel     *inviteLabel;



//shareaView
@property (nonatomic , strong) BFShareView *shareView;

@end

@implementation BFInviteRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title                = @"邀请奖励";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.bodyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.bodyView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64+SCREEN_WIDTH/375*0.5);
    self.bodyView.backgroundColor = [UIColor colorWithHex:@"CF1313"];
    [self.view addSubview:self.bodyView];
    
    self.bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*10, SCREEN_WIDTH/375*10, SCREEN_WIDTH-SCREEN_WIDTH/375*20, (SCREEN_WIDTH-SCREEN_WIDTH/375*20)/710*242)];
    self.bannerImageView.image = [UIImage imageNamed:@"inviteRewardbanner"];
    self.bannerImageView.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.bannerImageView];
    
    
    
    
    
    
    self.borderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*23, CGRectGetMaxY(self.bannerImageView.frame)+SCREEN_WIDTH/375*23, SCREEN_WIDTH-SCREEN_WIDTH/375*46, (SCREEN_WIDTH-SCREEN_WIDTH/375*46)/330*252)];
    self.borderImageView.image = [UIImage imageNamed:@"inviteRewardBlackBorder"];
    self.borderImageView.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.borderImageView];
    
    
    //eamil
    self.emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*48, SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*77, SCREEN_WIDTH/375*78)];
    self.emailImageView.image = [UIImage imageNamed:@"inviteRewardEmail"];
    [self.borderImageView addSubview:self.emailImageView];
    
    
    //biu
    self.biuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*46-SCREEN_WIDTH/375*48-SCREEN_WIDTH/375*72, SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*72, SCREEN_WIDTH/375*72)];
    self.biuImageView.image = [UIImage imageNamed:@"inviteRewardBiu"];
    [self.borderImageView addSubview:self.biuImageView];
    
    //arrow
    self.arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*46-SCREEN_WIDTH/375*18)/2, SCREEN_WIDTH/375*57, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*15)];
    self.arrowImageView.image = [UIImage imageNamed:@"inviteRewardArrow"];
    [self.borderImageView addSubview:self.arrowImageView];
    
    //label
    self.inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*120, SCREEN_WIDTH-SCREEN_WIDTH/375*46-SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*30)];
    self.inviteLabel.text = @"邀请新朋友加入,各得一次免费下单机会";
    self.inviteLabel.textColor = [UIColor colorWithHex:@"FFFFFF"];
    self.inviteLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.inviteLabel.textAlignment = NSTextAlignmentCenter;
    self.inviteLabel.backgroundColor = [UIColor colorWithHex:@"000000"];
    self.inviteLabel.layer.cornerRadius = SCREEN_WIDTH/375*15;
    self.inviteLabel.layer.masksToBounds= YES;
    self.inviteLabel.alpha = 0.8;
    [self.borderImageView addSubview:self.inviteLabel];
    
    
    
    
    self.downBodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*0, SCREEN_HEIGHT-64-SCREEN_WIDTH/750*564, SCREEN_WIDTH, SCREEN_WIDTH/750*564)];
    self.downBodyImageView.image = [UIImage imageNamed:@"inviteRewardDownBody"];
    self.downBodyImageView.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.downBodyImageView];
    
    
    self.inviteButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*218)/2, SCREEN_WIDTH/375*5, SCREEN_WIDTH/375*218, SCREEN_WIDTH/375*40)];
    //self.inviteButton.backgroundColor = [UIColor yellowColor];
    [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"inviteRewardButton"] forState:UIControlStateNormal];
    [self.downBodyImageView addSubview:self.inviteButton];
    
    [self.inviteButton addTarget:self action:@selector(inviteButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //tip
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*23, SCREEN_WIDTH/750*564-SCREEN_WIDTH/375*198-SCREEN_WIDTH/375*23, SCREEN_WIDTH-SCREEN_WIDTH/375*46, SCREEN_WIDTH/375*198)];
    tipLabel.text = @"活动规则：\n1.活动期间，邀请好友下单各得1张无限制优惠券\n2.被邀请人需要下载APP注册后，邀请人才算邀请成功获得1张无限制优惠券\n3.同一账户，同一手机号，同一终端设备号，同一支付账户，同一收货地址或其他合理显示同一用户的信息，均视为同一用户，仅可领取一次免单优惠券\n4.如任何不正当获取奖励，Biu房有权限取消订单\n5.本活动最终解释权归Biu房所有";
    tipLabel.textColor = [UIColor colorWithHex:@"FFFFFF"];
    tipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    //tipLabel.backgroundColor = [UIColor redColor];
    tipLabel.numberOfLines = 0;
    
    
    
    //Line spacing
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:tipLabel.text];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle   setLineSpacing:SCREEN_WIDTH/375*5];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tipLabel.text length])];
    tipLabel.attributedText                     = attributedString;
    [self.downBodyImageView addSubview:tipLabel];

}


#pragma mark - Invite Friend
- (void)inviteButtonDidClickedAction:(UIButton *)sender{

    //NSLog(@"Invite");
    self.shareView = [[BFShareView alloc] initWithFrame:SCREEN_BOUNDS];
    self.shareView.delegate = self;
    [self.shareView shareShow];
}


#pragma mark - BFShareDelegate
-(void)shareViewDidSelectButWithBtnTag:(NSInteger)btnTag{
    
    //NSLog(@"%ld",(long)btnTag);
    
    
     switch (btnTag) {
     case 701:
     [[ShareManager defaulShaer] shareWechatSession:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     break;
     case 702:
     [[ShareManager defaulShaer] shareWechatTimeLine:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     break;
     case 703:
     
     if (![WeiboSDK isWeiboAppInstalled]){
         
         [self.shareView shareHide];
         [self showProgress:@"未安装微博客户端"];
         
     }else{
         [[ShareManager defaulShaer] shareWebo:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     }
     
     break;
     case 704:
     [[ShareManager defaulShaer] shareQQ:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     break;
     case 705:
     [[ShareManager defaulShaer] shareQQZone:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     break;
     case 706:
     [[ShareManager defaulShaer] shareSms:self type:@"INF" sn:nil token:nil biuNumCount:nil];
     break;
     
     default:
     break;
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



@end
