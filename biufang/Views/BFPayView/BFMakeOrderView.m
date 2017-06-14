//
//  BFMakeOrderView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/11.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMakeOrderView.h"

@interface BFMakeOrderView ()

//期号1
@property (nonatomic , strong) UIView *issueView;
//人次2
@property (nonatomic , strong) UIView *countView;


//LABEL
@property (nonatomic , strong) UILabel *payTypeLabel;



//2
//购买人次
@property (nonatomic , strong) UILabel *goumairenciLabel;

//-+
@property (nonatomic , strong) UIView *jianjiaView;
@property (nonatomic , strong) UIView *jianLine;
@property (nonatomic , strong) UIView *jiaLine;
//滑杆
@property (nonatomic , strong) UIImageView *gearImageView;
//立减
@property (nonatomic , strong) UIImageView *towGearImageView;
@property (nonatomic , strong) UIImageView *threeGearImageView;
@property (nonatomic , strong) UIImageView *fourGearImageView;

//3
//红包优惠 arrow image
@property (nonatomic , strong) UIImageView *redArrowImage;
@property (nonatomic , strong) UILabel *redTipLabel;

//4
//订单金额
@property (nonatomic , strong) UILabel *orderLabel;
//优惠金额
@property (nonatomic , strong) UILabel *preferentialLabel;
//合计付款
@property (nonatomic , strong) UILabel *combinedLabel;

//5

//wechat
@property (nonatomic , strong) UILabel *wechatTypeLabel;
@property (nonatomic , strong) UIImageView *wechatImageView;
//ali
@property (nonatomic , strong) UILabel *aliTypeLabel;
@property (nonatomic , strong) UIImageView *aliImageView;

//6
@property (nonatomic , strong) UILabel *actualLabel;
@end

@implementation BFMakeOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.issueView.backgroundColor = [UIColor whiteColor];
    self.countView.backgroundColor = [UIColor whiteColor];
    self.redenvelopeView.backgroundColor = [UIColor whiteColor];
    self.orderView.backgroundColor = [UIColor whiteColor];
    
    self.payTypeLabel.font = [UIFont systemFontOfSize:14];
    self.payTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.payTypeLabel.textColor = [UIColor blackColor];
    self.payTypeLabel.text = @"付款方式";
    //[self addSubview:self.payTypeLabel];
    
    self.payTypeView.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];
    self.sureView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.issueView];
    //[self addSubview:self.countView];
    [self addSubview:self.redenvelopeView];
    [self addSubview:self.orderView];
    [self addSubview:self.payTypeView];
    //[self addSubview:self.sureView];
    
    
    //1
    //self.fangImagaView.backgroundColor = [UIColor lightGrayColor];
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [self.issueView addSubview:self.fangImagaView];
    
    
    self.communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.communityNameLabel.text = @"--- ---";
    self.communityNameLabel.textColor = [UIColor blackColor];
    self.communityNameLabel.numberOfLines = 0;
    self.communityNameLabel.textAlignment = NSTextAlignmentLeft;
    //self.communityNameLabel.backgroundColor = [UIColor redColor];
    [self.issueView addSubview:self.communityNameLabel];
    
    self.issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.issueNumberLabel.text = @"期号：---";
    self.issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.issueView addSubview:self.issueNumberLabel];
    
    //
    //
    //    //还可购买次数
    //    @property (nonatomic , strong) UILabel *willBuyCountLabel;
    
    
    //2
    self.jianLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    [self.jianjiaView addSubview:self.jianLine];
    
    self.jiaLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    [self.jianjiaView addSubview:self.jiaLine];
    
    self.jianjiaView.layer.borderColor = [UIColor colorWithHex:@"EEEEEE"].CGColor;
    self.jianjiaView.layer.borderWidth = 1;
    [self.countView addSubview:self.jianjiaView];
    
    
    [self.leftCountButton setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
    //self.leftCountButton.backgroundColor = [UIColor redColor];
    [self.jianjiaView addSubview:self.leftCountButton];
    
    [self.rightCountButton setImage:[UIImage imageNamed:@"Increase"] forState:UIControlStateNormal];
    //self.rightCountButton.backgroundColor = [UIColor redColor];
    [self.jianjiaView addSubview:self.rightCountButton];
    
    self.orderCountTextField.textColor = [UIColor colorWithHex:RED_COLOR];
    self.orderCountTextField.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.orderCountTextField.textAlignment = NSTextAlignmentCenter;
    //self.orderCountTextField.text = @"3";
    self.orderCountTextField.keyboardType = UIKeyboardTypeNumberPad;
    //self.orderCountTextField.returnKeyType=UIReturnKeyDefault;
    self.orderCountTextField.tintColor = [UIColor colorWithHex:RED_COLOR];
    [self.jianjiaView addSubview:self.orderCountTextField];
    
    //购买人次
    self.goumairenciLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.goumairenciLabel.textAlignment = NSTextAlignmentLeft;
    self.goumairenciLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.goumairenciLabel.text = @"购买人次";
    [self.countView addSubview:self.goumairenciLabel];
    
    self.renciLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.renciLabel.textAlignment = NSTextAlignmentRight;
    self.renciLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    //self.renciLabel.text = @"¥100/人次";
    self.renciLabel.text = @"¥--/人次";
    [self.countView addSubview:self.renciLabel];
    
    self.willBuyCountLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.willBuyCountLabel.textAlignment = NSTextAlignmentLeft;
    self.willBuyCountLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    //self.willBuyCountLabel.text = @"还可购买900人次";
    self.willBuyCountLabel.text = @"还可购买--人次";
    [self.countView addSubview:self.willBuyCountLabel];
    
    //滑杆
    self.gearImageView.image = [UIImage imageNamed:@"newCombinedShape"];
    self.gearImageView.userInteractionEnabled = YES;
    [self.countView addSubview:self.gearImageView];
    
    
    [self.oneGearButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
    [self.oneGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    //[self.oneGearButton setTitle:@"10" forState:UIControlStateNormal];
    [self.oneGearButton setTitle:@"-" forState:UIControlStateNormal];
    self.oneGearButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.oneGearButton.tag = 890;
    [self.gearImageView addSubview:self.oneGearButton];
    
    //[self.towGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
    [self.towGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    //[self.towGearButton setTitle:@"30" forState:UIControlStateNormal];
    [self.towGearButton setTitle:@"-" forState:UIControlStateNormal];
    self.towGearButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.towGearButton.tag = 891;
    [self.gearImageView addSubview:self.towGearButton];
    
    //[self.threeGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
    [self.threeGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    //[self.threeGearButton setTitle:@"50" forState:UIControlStateNormal];
    [self.threeGearButton setTitle:@"-" forState:UIControlStateNormal];
    self.threeGearButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.threeGearButton.tag = 892;
    [self.gearImageView addSubview:self.threeGearButton];
    
    //[self.fourGearButton setBackgroundImage:[UIImage imageNamed:@"gearBtnImage"] forState:UIControlStateNormal];
    [self.fourGearButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
    //[self.fourGearButton setTitle:@"200" forState:UIControlStateNormal];
    [self.fourGearButton setTitle:@"-" forState:UIControlStateNormal];
    self.fourGearButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.fourGearButton.tag = 893;
    [self.gearImageView addSubview:self.fourGearButton];
    
    
    //    //红包优惠
    //    @property (nonatomic , strong) UILabel *redMoneyLabel;
    //
    
    //3
    self.redMoneyLabel.textColor = [UIColor colorWithHex:@"999999"];
    self.redMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.redMoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.redMoneyLabel.text = @"满- - -元";
    [self.redenvelopeView addSubview:self.redMoneyLabel];
    
    self.redArrowImage.image = [UIImage imageNamed:@"gonext"];
    [self.redenvelopeView addSubview:self.redArrowImage];
    
    self.redTipLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.redTipLabel.textAlignment = NSTextAlignmentLeft;
    self.redTipLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.redTipLabel.text = @"红包优惠";
    [self.redenvelopeView addSubview:self.redTipLabel];
    
    
    
    //4
    //    //订单金额
    //    @property (nonatomic , strong) UILabel *orderMoneyLabel;
    //    //优惠金额
    //    @property (nonatomic , strong) UILabel *preferentialMoneyLabel;
    //    //合计付款
    //    @property (nonatomic , strong) UILabel *combinedMoneyLabel;
    
    self.orderLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.orderLabel.textAlignment = NSTextAlignmentRight;
    self.orderLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.orderLabel.text = @"订单金额:";
    //self.orderLabel.backgroundColor = [UIColor redColor];
    [self.orderView addSubview:self.orderLabel];
    
    self.orderMoneyLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.orderMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.orderMoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    self.orderMoneyLabel.text = @"¥--.--";
    [self.orderView addSubview:self.orderMoneyLabel];
    
    self.preferentialLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.preferentialLabel.textAlignment = NSTextAlignmentRight;
    self.preferentialLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.preferentialLabel.text = @"红包金额:";
    //self.preferentialLabel.backgroundColor = [UIColor redColor];
    [self.orderView addSubview:self.preferentialLabel];
    
    self.preferentialMoneyLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.preferentialMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.preferentialMoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    self.preferentialMoneyLabel.text = @"-￥--.--";
    [self.orderView addSubview:self.preferentialMoneyLabel];
    
    
    self.combinedLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.combinedLabel.textAlignment = NSTextAlignmentRight;
    self.combinedLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.combinedLabel.text = @"实付款:";
    //self.combinedLabel.backgroundColor = [UIColor redColor];
    [self.orderView addSubview:self.combinedLabel];
    
    self.combinedMoneyLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.combinedMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.combinedMoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*13];
    self.combinedMoneyLabel.text = @"￥--.--";
    [self.orderView addSubview:self.combinedMoneyLabel];
    
    self.biuMoneyLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.biuMoneyLabel.textAlignment = NSTextAlignmentRight;
    self.biuMoneyLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.biuMoneyLabel.text = @"送价值¥--.--的Biu币";
    [self.orderView addSubview:self.biuMoneyLabel];
    
    
    //5
    self.payLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    [self.payTypeView addSubview:self.payLine];
    
    //wechat
    [self.payTypeView addSubview:self.wechatTypeView];
    self.wechatTypeImageView.image = [UIImage imageNamed:@"stay"];
    [self.wechatTypeView addSubview:self.wechatTypeImageView];
    
    self.wechatTypeLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.wechatTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.wechatTypeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.wechatTypeLabel.text = @"微信支付";
    [self.wechatTypeView addSubview:self.wechatTypeLabel];
    
    self.wechatImageView.image = [UIImage imageNamed:@"wechat"];
    [self.wechatTypeView addSubview:self.wechatImageView];
    
    
    //ali
    [self.payTypeView addSubview:self.aliTypeView];
    self.aliTypeImageView.image = [UIImage imageNamed:@"choose"];
    [self.aliTypeView addSubview:self.aliTypeImageView];
    
    self.aliImageView.image = [UIImage imageNamed:@"zhifubao"];
    [self.aliTypeView addSubview:self.aliImageView];
    
    self.aliTypeLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.aliTypeLabel.textAlignment = NSTextAlignmentLeft;
    self.aliTypeLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.aliTypeLabel.text = @"支付宝";
    [self.aliTypeView addSubview:self.aliTypeLabel];
    
    
    
    //6
    //    //结算
    //    //实付款
    //    @property (nonatomic , strong) UILabel *actualMoneyLabel;
    //    @property (nonatomic , strong) UIButton *settlementButton;
    //
    
    self.actualLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.actualLabel.textAlignment = NSTextAlignmentLeft;
    self.actualLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.actualLabel.text = @"实付款:";
    [self.sureView addSubview:self.actualLabel];
    
    self.actualMoneyLabel.textColor = [UIColor colorWithHex:@"FC2F23"];
    self.actualMoneyLabel.textAlignment = NSTextAlignmentLeft;
    
    self.actualMoneyLabel.font = [UIFont fontWithName:@"Futura-MediumItalic" size:SCREEN_WIDTH/375*16];
    self.actualMoneyLabel.text = @"￥--.--";
    [self.sureView addSubview:self.actualMoneyLabel];
    
    //[self.settlementButton setTitle:@"结算" forState:UIControlStateNormal];
    //[self.settlementButton setImage:[UIImage imageNamed:@"Group 4-1"] forState:UIControlStateNormal];
    [self.settlementButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:RED_COLOR] size:self.settlementButton.frame.size] forState:UIControlStateNormal];
    [self.settlementButton setTitle:@"结算" forState:UIControlStateNormal];
    [self.settlementButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.settlementButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.settlementButton.alpha = 0.6;
    //[self.settlementButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    //self.settlementButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.sureView addSubview:self.settlementButton];
    
    
    UIView *sureLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*1)];
    sureLine.backgroundColor = [UIColor colorWithHex:@"EEEEEE"];
    [self.sureView addSubview:sureLine];
}


//lazy
//1
-(UILabel *)communityNameLabel{
    
    if (_communityNameLabel==nil) {
        _communityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*34)];
    }
    return _communityNameLabel;
}


- (UILabel *)issueNumberLabel{
    
    if (_issueNumberLabel==nil) {
        _issueNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*97, SCREEN_WIDTH/375*63, SCREEN_WIDTH-SCREEN_WIDTH/375*(97+12), SCREEN_WIDTH/375*14)];
    }
    return _issueNumberLabel;
}

-(UIImageView *)fangImagaView{

    if (_fangImagaView==nil) {
        _fangImagaView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    }
    return _fangImagaView;
}



//2
////-+
//@property (nonatomic , strong) UIView *jianjiaView;
//@property (nonatomic , strong) UIView *jianLine;
//@property (nonatomic , strong) UIView *jianJia;
-(UIView *)jianjiaView{
    
    if (_jianjiaView==nil) {
        _jianjiaView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*34, SCREEN_WIDTH/375*80, SCREEN_WIDTH-SCREEN_WIDTH/375*68, SCREEN_WIDTH/375*36)];
    }
    return _jianjiaView;
}
-(UIView *)jianLine{
    
    if (_jianLine==nil) {
        _jianLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*(36-2))];
    }
    return _jianLine;
}

-(UIView *)jiaLine{
    
    if (_jiaLine==nil) {
        _jiaLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*68-SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*1, SCREEN_WIDTH/375*(36-2))];
    }
    return _jiaLine;
}

-(UIButton *)leftCountButton{
    
    if (_leftCountButton==nil) {
        _leftCountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _leftCountButton;
}

-(UIButton *)rightCountButton{
    
    if (_rightCountButton==nil) {
        _rightCountButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*68-SCREEN_WIDTH/375*36, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _rightCountButton;
}

-(UITextField *)orderCountTextField{
    
    if (_orderCountTextField==nil) {
        _orderCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37, 0, SCREEN_WIDTH-SCREEN_WIDTH/375*68-SCREEN_WIDTH/375*72, SCREEN_WIDTH/375*36)];
    }
    return _orderCountTextField;
    
}


//购买人次
//@property (nonatomic , strong) UILabel *goumairenciLabel;
//100/人次
//@property (nonatomic , strong) UILabel *renciLabel;

-(UILabel *)goumairenciLabel{
    
    if (_goumairenciLabel==nil) {
        _goumairenciLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*19, SCREEN_WIDTH/375*20, 200, SCREEN_WIDTH/375*19)];
    }
    return _goumairenciLabel;
}

-(UILabel *)renciLabel{
    
    if (_renciLabel==nil) {
        _renciLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*19-200, SCREEN_WIDTH/375*71/71*24, 200, SCREEN_WIDTH/375*71/71*17)];
    }
    return _renciLabel;
}

-(UILabel *)willBuyCountLabel{
    
    if (_willBuyCountLabel==nil) {
        _willBuyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*71/71*48, 200, SCREEN_WIDTH/375*71/71*14)];
    }
    return _willBuyCountLabel;
}

//滑杆
//@property (nonatomic , strong) UIImageView *gearImageView;
-(UIImageView *)gearImageView{
    
    if (_gearImageView==nil) {
        _gearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*133, SCREEN_WIDTH-SCREEN_WIDTH/375*72, SCREEN_WIDTH/375*36)];
    }
    return _gearImageView;
}
//@property (nonatomic , strong) UIButton *oneGearButton;
-(UIButton *)oneGearButton{
    
    if (_oneGearButton==nil) {
        _oneGearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _oneGearButton;
}
//@property (nonatomic , strong) UIButton *towGearButton;
-(UIButton *)towGearButton{
    
    if (_towGearButton==nil) {
        _towGearButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*90, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _towGearButton;
}
//@property (nonatomic , strong) UIButton *threeGearButton;  98-8=90
-(UIButton *)threeGearButton{
    
    if (_threeGearButton==nil) {
        _threeGearButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*72-SCREEN_WIDTH/375*90-SCREEN_WIDTH/375*36, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _threeGearButton;
}
//@property (nonatomic , strong) UIButton *fourGearButton;
-(UIButton *)fourGearButton{
    
    if (_fourGearButton==nil) {
        _fourGearButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*72-SCREEN_WIDTH/375*36, 0, SCREEN_WIDTH/375*36, SCREEN_WIDTH/375*36)];
    }
    return _fourGearButton;
}
//立减
//@property (nonatomic , strong) UIImageView *towGearImageView;

//@property (nonatomic , strong) UIImageView *threeGearImageView;
//@property (nonatomic , strong) UIImageView *fourGearImageView;


//3
-(UILabel *)redMoneyLabel{
    
    if (_redMoneyLabel==nil) {
        _redMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-150, SCREEN_WIDTH/375*71/71*14, 150, SCREEN_WIDTH/375*71/71*16)];
    }
    return _redMoneyLabel;
}

-(UIImageView *)redArrowImage{
    
    if (_redArrowImage==nil) {
        _redArrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-SCREEN_WIDTH/375*71/71*8, SCREEN_WIDTH/375*71/71*14, SCREEN_WIDTH/375*71/71*8, SCREEN_WIDTH/375*71/71*13)];
    }
    return _redArrowImage;
}

-(UILabel *)redTipLabel{
    
    if (_redTipLabel==nil) {
        _redTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, SCREEN_WIDTH/375*71/71*13, 150, SCREEN_WIDTH/375*71/71*19)];
    }
    return _redTipLabel;
}

//4
////订单金额
//@property (nonatomic , strong) UILabel *orderLabel;
////优惠金额
//@property (nonatomic , strong) UILabel *preferentialLabel;
////合计付款
//@property (nonatomic , strong) UILabel *combinedLabel;

-(UILabel *)orderLabel{
    
    if (_orderLabel==nil) {
        _orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*71/71*15, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*71/71*17)];
    }
    return _orderLabel;
}

-(UILabel *)orderMoneyLabel{
    
    if (_orderMoneyLabel==nil) {
        _orderMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-150, SCREEN_WIDTH/375*71/71*17, 150, SCREEN_WIDTH/375*71/71*16)];
    }
    return _orderMoneyLabel;
}

-(UILabel *)preferentialLabel{
    
    if (_preferentialLabel==nil) {
        _preferentialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*71/71*49, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*71/71*17)];
    }
    return _preferentialLabel;
}

-(UILabel *)preferentialMoneyLabel{
    
    if (_preferentialMoneyLabel==nil) {
        _preferentialMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-150, SCREEN_WIDTH/375*71/71*50, 150, SCREEN_WIDTH/375*71/71*16)];
    }
    return _preferentialMoneyLabel;
}

-(UILabel *)combinedLabel{
    
    if (_combinedLabel==nil) {
        _combinedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*71/71*83, SCREEN_WIDTH/375*80, SCREEN_WIDTH/375*71/71*17)];
    }
    return _combinedLabel;
}

-(UILabel *)combinedMoneyLabel{
    
    if (_combinedMoneyLabel==nil) {
        _combinedMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-150, SCREEN_WIDTH/375*71/71*83, 150, SCREEN_WIDTH/375*71/71*16)];
    }
    return _combinedMoneyLabel;
}
//送价值¥240.00的Biu币
-(UILabel *)biuMoneyLabel{
    
    if (_biuMoneyLabel==nil) {
        _biuMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-17-200, SCREEN_WIDTH/375*71/71*108, 200, SCREEN_WIDTH/375*71/71*14)];
    }
    return _biuMoneyLabel;
}

//5
//付款方式
//wechat
//@property (nonatomic , strong) UIView *wechatTypeView;
-(UIView *)wechatTypeView{
    
    if (_wechatTypeView==nil) {
        _wechatTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*52, SCREEN_WIDTH, SCREEN_WIDTH/375*71/71*51)];
    }
    return _wechatTypeView;
}
//@property (nonatomic , strong) UIImageView *wechatTypeImageView;
-(UIImageView *)wechatTypeImageView{
    
    if (_wechatTypeImageView==nil) {
        _wechatTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _wechatTypeImageView;
}
////ali
//@property (nonatomic , strong) UIView *aliTypeView;
-(UIView *)aliTypeView{
    
    if (_aliTypeView==nil) {
        _aliTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*71/71*51)];//CGRectMake(0, SCREEN_WIDTH/375*71/71*53, SCREEN_WIDTH, SCREEN_WIDTH/375*71/71*51)
    }
    return _aliTypeView;
}
//@property (nonatomic , strong) UIImageView *aliTypeImageView;
-(UIImageView *)aliTypeImageView{
    
    if (_aliTypeImageView==nil) {
        _aliTypeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-25-SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*15, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _aliTypeImageView;
}


//@property (nonatomic , strong) UIView *payLine;
-(UIView *)payLine{
    
    if (_payLine==nil) {
        _payLine = [[UIView alloc] initWithFrame:CGRectMake(28, SCREEN_WIDTH/375*71/71*52, SCREEN_WIDTH-28, SCREEN_WIDTH/375*71/71*0.5)];
    }
    return _payLine;
}
////wechat
//@property (nonatomic , strong) UILabel *wechatTypeLabel;
-(UILabel *)wechatTypeLabel{
    
    if (_wechatTypeLabel==nil) {
        _wechatTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, SCREEN_WIDTH/375*15, 100, SCREEN_WIDTH/375*22)];
    }
    return _wechatTypeLabel;
}
//@property (nonatomic , strong) UIImageView *wechatImageView;
-(UIImageView *)wechatImageView{
    
    if (_wechatImageView==nil) {
        _wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*25)];
    }
    return _wechatImageView;
}

////ali
//@property (nonatomic , strong) UILabel *aliTypeLabel;
-(UILabel *)aliTypeLabel{
    
    if (_aliTypeLabel==nil) {
        _aliTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, SCREEN_WIDTH/375*15, 100, SCREEN_WIDTH/375*22)];
    }
    return _aliTypeLabel;
}
//@property (nonatomic , strong) UIImageView *aliImageView;
-(UIImageView *)aliImageView{
    
    if (_aliImageView==nil) {
        _aliImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, SCREEN_WIDTH/375*14, SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*25)];
    }
    return _aliImageView;
}

//6
//实付款
//@property (nonatomic , strong) UILabel *actualMoneyLabel;
//@property (nonatomic , strong) UIButton *settlementButton;
-(UILabel *)actualLabel{
    
    if (_actualLabel==nil) {
        _actualLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, SCREEN_WIDTH/375*13, 100, SCREEN_WIDTH/375*24)];
    }
    return _actualLabel;
}


-(UILabel *)actualMoneyLabel{
    
    if (_actualMoneyLabel==nil) {
        _actualMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, SCREEN_WIDTH/375*13, 200, SCREEN_WIDTH/375*24)];
    }
    return _actualMoneyLabel;
}

-(UIButton *)settlementButton{
    
    if (_settlementButton==nil) {
        _settlementButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*114, 0, SCREEN_WIDTH/375*114, SCREEN_WIDTH/375*51)];
    }
    return _settlementButton;
}






//lazy
-(UIView *)issueView{
    
    if (_issueView==nil) {
        _issueView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    }
    return _issueView;
}

-(UIView *)countView{
    
    if (_countView==nil) {
        _countView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.issueView.frame)+7, SCREEN_WIDTH, SCREEN_WIDTH/375*195)];
    }
    _countView.backgroundColor = [UIColor yellowColor];
    return _countView;
}

-(UIView *)redenvelopeView{
    
    if (_redenvelopeView==nil) {
        _redenvelopeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.issueView.frame)+7, SCREEN_WIDTH, SCREEN_WIDTH/375*44)];
    }
    return _redenvelopeView;
}

-(UIView *)orderView{
    
    if (_orderView==nil) {
        _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.redenvelopeView.frame)+7, SCREEN_WIDTH, SCREEN_WIDTH/375*137)];
    }
    return _orderView;
}

-(UILabel *)payTypeLabel{
    
    if (_payTypeLabel==nil) {
        _payTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(self.orderView.frame)+10, 100, 17)];
    }
    return _payTypeLabel;
}

-(UIView *)payTypeView{
    
    if (_payTypeView==nil) {
        _payTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.orderView.frame)+9, SCREEN_WIDTH, SCREEN_WIDTH/375*104)];//orderView SCREEN_WIDTH/375*104
    }
    return _payTypeView;
}

-(UIView *)sureView{
    
    if (_sureView==nil) {
        _sureView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SCREEN_WIDTH/375*49, SCREEN_WIDTH, SCREEN_WIDTH/375*49)];
    }
    return _sureView;
}


@end
