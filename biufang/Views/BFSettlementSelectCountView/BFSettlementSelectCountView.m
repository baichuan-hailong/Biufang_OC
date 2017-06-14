//
//  BFSettlementSelectCountView.m
//  biufang
//
//  Created by 杜海龙 on 17/2/17.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFSettlementSelectCountView.h"

@interface BFSettlementSelectCountView ()<UITextFieldDelegate>
{
    NSInteger limitCount;
    NSInteger biuPriceCount;
    NSInteger totalAllPriceCount;
}
//bg view
@property(nonatomic,strong)UIView   *settlementView;
//immediately button
@property(nonatomic,strong)UIButton *immediatelyButton;
//line
@property(nonatomic,strong)UIView   *bottomLine;
//middle line
@property(nonatomic,strong)UIView   *middleLine;
//bottom label
@property(nonatomic,strong)UILabel  *bottomLabel;

//gear
@property(nonatomic,strong)UIButton *gearButton1;
@property(nonatomic,strong)UIButton *gearButton2;
@property(nonatomic,strong)UIButton *gearButton3;
@property(nonatomic,strong)UIButton *gearButton4;
@property(nonatomic,strong)UIButton *gearButton5;
@property(nonatomic,strong)UIButton *gearButton6;

//geararray
@property(nonatomic,strong)NSArray  *gearArray;

//count -
@property (nonatomic , strong) UIButton *leftCountButton;
//count +
@property (nonatomic , strong) UIButton *rightCountButton;
//order count
@property (nonatomic , strong) UITextField *orderCountTextField;
//-+
@property (nonatomic , strong) UIView *jianjiaView;
@property (nonatomic , strong) UIView *jianLine;
@property (nonatomic , strong) UIView *jiaLine;

//档位
@property (nonatomic , strong) NSArray *fixArray;
//NSTimer
@property (nonatomic,strong)NSTimer *valiCodeTimer;
@property (nonatomic,copy)NSString *online;
//标题
@property (nonatomic,copy)NSString *fang_title;
//期号
@property (nonatomic,copy)NSString *fang_sn;
//fang url
@property (nonatomic,copy)NSString *fang_url;

//红包
@property (nonatomic , strong)NSArray *redmoneyArray;

@property (nonatomic , strong) MBProgressHUD *HUD;
@end


@implementation BFSettlementSelectCountView

//init
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.5;
    }
    return self;
}

#pragma mark - 档位 剩余
- (void)requestData{

}


//settlement
- (void)settlementShow{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.HUD = [[MBProgressHUD alloc] initWithView:keyWindow];
    [keyWindow addSubview:self.HUD];
    [self.HUD show:YES];
    
    //NSLog(@"房id --- %@",self.fang_id);
    NSDictionary *parameter = @{@"fang_id":self.fang_id};
    NSString *urlStr        = [NSString stringWithFormat:@"%@/trade/pre-order",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        
        NSLog(@"Fang --- %@",object);
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            //标题
            self.fang_title = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"title"]];
            //期号
            self.fang_sn    = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"sn"]];
            //fang url
            self.fang_url   = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"cover"]];
            //is show wechat
            self.online = [NSString stringWithFormat:@"%@",object[@"data"][@"online"]];
            //当前红包
            self.redmoneyArray = [NSArray arrayWithArray:object[@"data"][@"discount"]];
            //初始化 计算金额
            self.settlementView.backgroundColor     = [UIColor whiteColor];
            self.settlementView.layer.masksToBounds = YES;
            
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:self];
            [keyWindow addSubview:self.settlementView];
            
            [UIView animateWithDuration:0.38 animations:^{
                self.settlementView.frame = CGRectMake(0,
                                                       SCREEN_HEIGHT-SCREEN_WIDTH/375*298,
                                                       SCREEN_WIDTH,
                                                       SCREEN_WIDTH/375*298);
            }];
            
            //单价
            NSString *biuPriceStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"biu_price"]];
            biuPriceCount = [biuPriceStr integerValue];
            
            //包尾
            NSString *limitStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"limit"]];
            NSString *stockStr = [NSString stringWithFormat:@"%@",object[@"data"][@"fang"][@"stock"]];
            if ([limitStr integerValue]<=[stockStr integerValue]) {
                limitCount = [limitStr integerValue];
            }else{
                limitCount = [stockStr integerValue];
            }
            
            //档位
            self.fixArray = [NSArray arrayWithArray:object[@"data"][@"fixed"]];
            [self createUIGear:self.fixArray];
        
        }else{
            [self showProgress:object[@"status"][@"message"]];
        }
        [self.HUD hide:YES];
    } withFailureBlock:^(NSError *error) {
        //NSLog(@"%@",error);
        [self.HUD hide:YES];
    } progress:^(float progress) {
        //NSLog(@"%f",progress);
    }];
}


//create UI
- (void)createUIGear:(NSArray *)gearArray{
    
    self.immediatelyButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*11,
                                                                        SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*41-SCREEN_WIDTH/375*7,
                                                                        SCREEN_WIDTH-SCREEN_WIDTH/375*22,
                                                                        SCREEN_WIDTH/375*41)];
    [self.immediatelyButton setBackgroundImage:[myToolsClass imageWithColor:[UIColor colorWithHex:@"FF4668"] size:self.immediatelyButton.frame.size] forState:UIControlStateNormal];
    [self.immediatelyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.immediatelyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.immediatelyButton.titleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*16];
    self.immediatelyButton.layer.cornerRadius = SCREEN_WIDTH/375*4;
    self.immediatelyButton.layer.masksToBounds= YES;
    [self.settlementView addSubview:self.immediatelyButton];
    
    [self.immediatelyButton addTarget:self action:@selector(immediatelyButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //line
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*48-SCREEN_WIDTH/375*10,
                                                               SCREEN_WIDTH,
                                                               SCREEN_WIDTH/375*0.5)];
    self.bottomLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    self.bottomLine.alpha = 0.6;
    [self.settlementView addSubview:self.bottomLine];
    
    //middle line
    self.middleLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36,
                                                               SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*102,
                                                               SCREEN_WIDTH-SCREEN_WIDTH/375*72,
                                                               SCREEN_WIDTH/375*0.5)];
    self.middleLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    self.middleLine.alpha = 0.6;
    [self.settlementView addSubview:self.middleLine];
    
    
    //bottom label
    self.bottomLabel.font          = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.textColor     = [UIColor colorWithHex:@"FF4668"];
    [self.settlementView addSubview:self.bottomLabel];
    
    //gear array
    self.gearArray = [NSArray arrayWithObjects:self.gearButton1,self.gearButton2,self.gearButton3,self.gearButton4,self.gearButton5,self.gearButton6, nil];
    for (int i=0; i<self.gearArray.count; i++) {
        UIButton *gearbutton = self.gearArray[i];
        gearbutton.titleLabel.font    = [UIFont boldSystemFontOfSize:SCREEN_WIDTH/375*12];
        gearbutton.layer.borderColor  = [UIColor colorWithHex:@"DDDDDD"].CGColor;
        gearbutton.layer.borderWidth  = SCREEN_WIDTH/375*1;
        gearbutton.layer.cornerRadius = SCREEN_WIDTH/375*1;
        gearbutton.layer.masksToBounds= YES;
        [self.settlementView addSubview:gearbutton];
        gearbutton.tag = 1314+i;
        [gearbutton addTarget:self action:@selector(gearButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (gearArray.count==4) {
        [self.gearButton1 setTitle:[NSString stringWithFormat:@"%@",gearArray[0]] forState:UIControlStateNormal];
        [self.gearButton2 setTitle:[NSString stringWithFormat:@"%@",gearArray[1]] forState:UIControlStateNormal];
        [self.gearButton3 setTitle:[NSString stringWithFormat:@"%@",gearArray[2]] forState:UIControlStateNormal];
        [self.gearButton4 setTitle:[NSString stringWithFormat:@"%@",gearArray[3]] forState:UIControlStateNormal];
    }
    //1
    [self.gearButton1 setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    //2
    [self.gearButton2 setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    //3
    [self.gearButton3 setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    //4
    [self.gearButton4 setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
    //5
    [self.gearButton5 setTitle:@"包尾" forState:UIControlStateNormal];
    [self.gearButton5 setTitleColor:[UIColor colorWithHex:@"FF4668"] forState:UIControlStateNormal];
    //6
    [self.gearButton6 setTitle:@"其他份数" forState:UIControlStateNormal];
    [self.gearButton6 setTitleColor:[UIColor colorWithHex:@"999999"] forState:UIControlStateNormal];

    
    self.jianjiaView.layer.borderColor = [UIColor colorWithHex:@"DDDDDD"].CGColor;
    self.jianjiaView.layer.borderWidth = SCREEN_WIDTH/375*1;
    [self.settlementView addSubview:self.jianjiaView];
    
    self.jianLine.backgroundColor      = [UIColor colorWithHex:@"DDDDDD"];
    self.jiaLine.backgroundColor       = [UIColor colorWithHex:@"DDDDDD"];
    
    [self.jianjiaView addSubview:self.jiaLine];
    [self.jianjiaView addSubview:self.jianLine];
    
    
    [self.leftCountButton setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
    [self.jianjiaView addSubview:self.leftCountButton];
    
    [self.rightCountButton setImage:[UIImage imageNamed:@"Increase"] forState:UIControlStateNormal];
    [self.jianjiaView addSubview:self.rightCountButton];
    
    
    //-
    [self.leftCountButton addTarget:self action:@selector(leftCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    //+
    [self.rightCountButton addTarget:self action:@selector(rightCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //-Action
    [self.leftCountButton addTarget:self action:@selector(leftCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    //UIControlEventTouchDown  //start
    [self.leftCountButton addTarget:self action:@selector(leftCountButtonDidStartAction:) forControlEvents:UIControlEventTouchDown];
    
    //+Action  //stop
    [self.rightCountButton addTarget:self action:@selector(rightCountButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    //UIControlEventTouchDown  //start
    [self.rightCountButton addTarget:self action:@selector(rightCountButtonDidStartAction:) forControlEvents:UIControlEventTouchDown];
    
    
    
    self.orderCountTextField.textColor       = [UIColor colorWithHex:@"FF3F56"];
    self.orderCountTextField.tintColor       = [UIColor colorWithHex:@"FF3F56"];
    self.orderCountTextField.font            = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.orderCountTextField.textAlignment   = NSTextAlignmentCenter;
    self.orderCountTextField.keyboardType    = UIKeyboardTypeNumberPad;
    self.orderCountTextField.delegate        = self;
    self.orderCountTextField.text            = @"1";
    [self.jianjiaView addSubview:self.orderCountTextField];
    //listen TF
    [self.orderCountTextField addTarget:self action:@selector(orderCountTextFieldValueChaged:) forControlEvents:UIControlEventEditingChanged];
    
    
    //total price
    [self calculateTotalPrice];
    
    
    NSString *firstGear =  [NSString stringWithFormat:@"%@",gearArray[0]];
    if ([firstGear integerValue]==1) {
        UIButton *gearbutton = self.gearArray[0];
        gearbutton.layer.borderColor  = [UIColor colorWithHex:@"DDDDDD"].CGColor;
        gearbutton.layer.cornerRadius = SCREEN_WIDTH/375*1;
        gearbutton.layer.borderWidth  = SCREEN_WIDTH/375*0;
        gearbutton.backgroundColor = [UIColor colorWithHex:@"FF4668"];
        [gearbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 减加
//-
- (void)leftCountButtonDidClickedAction:(UIButton *)sender{
    NSInteger orderCount = [self.orderCountTextField.text integerValue];
    if (orderCount==1) {
        self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
        [self stopCount];
    }else{
        orderCount--;
        self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    }
    [self stopCount];
}

//start
- (void)leftCountButtonDidStartAction:(UIButton *)sender{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeBack) userInfo:nil repeats:YES];
}

-(void)timeBack{
    NSInteger orderCount = [self.orderCountTextField.text integerValue];
    if (orderCount==1) {
        [self stopCount];
    }else{
        orderCount--;
        NSLog(@"orderCount --- %ld",(long)orderCount);
        self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    }
    [self orderCountTextFieldValueChaged:self.orderCountTextField];
}



//+
- (void)rightCountButtonDidClickedAction:(UIButton *)sender{
    
    NSInteger orderCount = [self.orderCountTextField.text integerValue];
    orderCount++;
    self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    [self stopCount];
    
    [self orderCountTextFieldValueChaged:self.orderCountTextField];
}

//start
- (void)rightCountButtonDidStartAction:(UIButton *)sender{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
}

-(void)timeGo{
    NSInteger orderCount = [self.orderCountTextField.text integerValue];
    orderCount++;
    NSLog(@"orderCount --- %ld",(long)orderCount);
    self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)orderCount];
    [self orderCountTextFieldValueChaged:self.orderCountTextField];
}

- (void)stopCount{
    [self.valiCodeTimer invalidate];
    self.valiCodeTimer = nil;
}


//touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch            = [touches anyObject];
    CGPoint currentPosition   = [touch locationInView:self];
    CGFloat currentY          = currentPosition.y;
    
    if (currentY<(SCREEN_HEIGHT-SCREEN_WIDTH/375*298)){
        [UIView animateWithDuration:0.28 animations:^{
            self.settlementView.frame = CGRectMake(0,
                                                   SCREEN_HEIGHT+SCREEN_WIDTH/375*298,
                                                   SCREEN_WIDTH,
                                                   SCREEN_WIDTH/375*298);
        } completion:^(BOOL finished) {
            [self.settlementView removeFromSuperview];
        }];
        [self.orderCountTextField resignFirstResponder];
        [self removeFromSuperview];
    }
}

#pragma mark - 立即购买
- (void)immediatelyButtonDidClickedAction:(UIButton *)sender{

    //NSLog(@"buying");
    //NSLog(@"%@ --- %@ --- %ld --- %@---%@ --- %@ --- %@ --- %@",self.fang_id,self.orderCountTextField.text,(long)totalAllPriceCount,self.online,self.redmoneyArray,self.fang_title,self.fang_sn,self.fang_url);
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(settlementHaveSelectOrderCount:totalPrice:onWech:redArray:title:sn:url:)]) {
        [self.delegate settlementHaveSelectOrderCount:self.orderCountTextField.text totalPrice:totalAllPriceCount onWech:self.online redArray:self.redmoneyArray title:self.fang_title sn:self.fang_sn url:self.fang_url];
        
        
        [UIView animateWithDuration:0.28 animations:^{
            self.settlementView.frame = CGRectMake(0,
                                                   SCREEN_HEIGHT+SCREEN_WIDTH/375*298,
                                                   SCREEN_WIDTH,
                                                   SCREEN_WIDTH/375*298);
        } completion:^(BOOL finished) {
            [self.settlementView removeFromSuperview];
        }];
        [self.orderCountTextField resignFirstResponder];
        [self removeFromSuperview];
    }
}

#pragma mark - TextView Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self bounceKeyboard];
    return YES;
}
#pragma mark - TextField 改变
- (void)orderCountTextFieldValueChaged:(UITextField *)sender{
    
    [self calculateTotalPrice];
}

#pragma mark - gear
- (void)gearButtonDidClick:(UIButton *)sender{

    if (sender.tag == 1314) {
        self.orderCountTextField.text = [NSString stringWithFormat:@"%@",self.fixArray[0]];
        [self textCountAnimation];
    }else if (sender.tag == 1315){
        self.orderCountTextField.text = [NSString stringWithFormat:@"%@",self.fixArray[1]];
        [self textCountAnimation];
    }else if (sender.tag == 1316){
        self.orderCountTextField.text = [NSString stringWithFormat:@"%@",self.fixArray[2]];
        [self textCountAnimation];
    }else if (sender.tag == 1317){
        self.orderCountTextField.text = [NSString stringWithFormat:@"%@",self.fixArray[3]];
        [self textCountAnimation];
    }else if (sender.tag == 1318){
        self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)limitCount];
        [self textCountAnimation];
    }else{
        [self.orderCountTextField becomeFirstResponder];
    }
    
    [self changeBackGroundColor:(sender.tag-1314)];
    
    [self calculateTotalPrice];
}

#pragma mark - 计算总价
- (void)calculateTotalPrice{
    NSInteger totalCount = [self.orderCountTextField.text integerValue];
    NSInteger totalPrice = totalCount*biuPriceCount;
    //NSLog(@"数量 --- %ld 单价 --- %ld",(long)totalCount,(long)biuPriceCount);
    //NSLog(@"总价 --- %ld",(long)totalPrice);
    
    if (totalCount>limitCount) {
        self.orderCountTextField.text = [NSString stringWithFormat:@"%ld",(long)limitCount];
        [self showProgress:[NSString stringWithFormat:@"最多购买%ld人次",(long)limitCount]];
        totalPrice = limitCount*biuPriceCount;
        
    }
    totalAllPriceCount = totalPrice;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共 %ld元",(long)totalPrice]];
    NSRange redRange                   = NSMakeRange(0, 1);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"999999"] range:redRange];
    self.bottomLabel.attributedText    = noteStr;
    
}

#pragma mark - 键盘弹起动画
- (void)bounceKeyboard{
    [UIView animateWithDuration:0.28 animations:^{
        if (iPhone5) {
            self.settlementView.frame = CGRectMake(0,
                                                   SCREEN_HEIGHT-SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*250,
                                                   SCREEN_WIDTH,
                                                   SCREEN_WIDTH/375*298);
        }else if (iPhone6){
            self.settlementView.frame = CGRectMake(0,
                                                   SCREEN_HEIGHT-SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*210,
                                                   SCREEN_WIDTH,
                                                   SCREEN_WIDTH/375*298);
        }else{
            self.settlementView.frame = CGRectMake(0,
                                                   SCREEN_HEIGHT-SCREEN_WIDTH/375*298-SCREEN_WIDTH/375*200,
                                                   SCREEN_WIDTH,
                                                   SCREEN_WIDTH/375*298);
        }
    } completion:nil];
}


#pragma mark - 数字动画效果
- (void)textCountAnimation{
    
    [UIView animateWithDuration:0.18 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self.orderCountTextField setTransform:transform];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.18 animations:^{
            CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self.orderCountTextField setTransform:transform];
        } completion:nil];
    }];
}

- (void)changeBackGroundColor:(NSInteger)index{
    //NSLog(@"%ld",(long)index);
    for (int i=0; i<self.gearArray.count; i++) {
        if (i==index) {
            UIButton *gearbutton = self.gearArray[index];
            gearbutton.layer.borderColor  = [UIColor colorWithHex:@"DDDDDD"].CGColor;
            gearbutton.layer.cornerRadius = SCREEN_WIDTH/375*1;
            gearbutton.layer.borderWidth  = SCREEN_WIDTH/375*0;
            gearbutton.backgroundColor = [UIColor colorWithHex:@"FF4668"];
            [gearbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            UIButton *gearbutton = self.gearArray[i];
            gearbutton.layer.borderColor  = [UIColor colorWithHex:@"DDDDDD"].CGColor;
            gearbutton.layer.cornerRadius = SCREEN_WIDTH/375*1;
            gearbutton.layer.borderWidth  = SCREEN_WIDTH/375*1;
            gearbutton.backgroundColor = [UIColor whiteColor];
            if (i==4) {
                [gearbutton setTitleColor:[UIColor colorWithHex:@"FF4668"] forState:UIControlStateNormal];
            }else{
                [gearbutton setTitleColor:[UIColor colorWithHex:@"353846"] forState:UIControlStateNormal];
            }
            
        }
   }
}


//tip MBProgress
- (void)showProgress:(NSString *)tipStr{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    //只显示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tipStr;
    hud.margin = 20.f;
    //hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

-(UIView *)settlementView{
    if (_settlementView==nil) {
        _settlementView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                  SCREEN_HEIGHT+SCREEN_WIDTH/375*298,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_WIDTH/375*298)];
    }
    return _settlementView;
}
//lazy
-(UILabel *)bottomLabel{

    if (_bottomLabel==nil) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 SCREEN_WIDTH/375*207.6,
                                                                 SCREEN_WIDTH,
                                                                 SCREEN_WIDTH/375*17)];
    }
    return _bottomLabel;
}

//1
-(UIButton *)gearButton1{
    if (_gearButton1==nil) {
        _gearButton1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36,
                                                                  SCREEN_WIDTH/375*105.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton1;
}
//2
-(UIButton *)gearButton2{
    if (_gearButton2==nil) {
        _gearButton2 = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*90)/2,
                                                                  SCREEN_WIDTH/375*105.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton2;
}
//3
-(UIButton *)gearButton3{
    if (_gearButton3==nil) {
        _gearButton3 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*90-SCREEN_WIDTH/375*36,
                                                                  SCREEN_WIDTH/375*105.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton3;
}
//4
-(UIButton *)gearButton4{
    if (_gearButton4==nil) {
        _gearButton4 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36,
                                                                  SCREEN_WIDTH/375*150.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton4;
}
//5
-(UIButton *)gearButton5{
    if (_gearButton5==nil) {
        _gearButton5 = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*90)/2,
                                                                  SCREEN_WIDTH/375*150.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton5;
}
//6
-(UIButton *)gearButton6{
    if (_gearButton6==nil) {
        _gearButton6 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*90-SCREEN_WIDTH/375*36,
                                                                  SCREEN_WIDTH/375*150.6,
                                                                  SCREEN_WIDTH/375*90,
                                                                  SCREEN_WIDTH/375*30)];
    }
    return _gearButton6;
}

//-+
-(UIView *)jianjiaView{

    if (_jianjiaView==nil) {
        _jianjiaView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*36,
                                                                SCREEN_WIDTH/375*49.6,
                                                                SCREEN_WIDTH-SCREEN_WIDTH/375*72,
                                                                SCREEN_WIDTH/375*36)];
    }
    return _jianjiaView;
}
-(UIView *)jianLine{
    if (_jianLine==nil) {
        _jianLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37,
                                                             SCREEN_WIDTH/375*0,
                                                             SCREEN_WIDTH/375*1,
                                                             SCREEN_WIDTH/375*36)];
    }
    return _jianLine;
}

-(UIView *)jiaLine{
    if (_jiaLine==nil) {
        _jiaLine = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*72-SCREEN_WIDTH/375*37),
                                                            SCREEN_WIDTH/375*0,
                                                            SCREEN_WIDTH/375*1,
                                                            SCREEN_WIDTH/375*36)];
    }
    return _jiaLine;
}

-(UIButton *)leftCountButton{
    if (_leftCountButton==nil) {
        _leftCountButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*0,
                                                                      SCREEN_WIDTH/375*0,
                                                                      SCREEN_WIDTH/375*37,
                                                                      SCREEN_WIDTH/375*37)];
    }
    return _leftCountButton;
}

-(UIButton *)rightCountButton{
    if (_rightCountButton==nil) {
        _rightCountButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*72-SCREEN_WIDTH/375*37),
                                                                       SCREEN_WIDTH/375*0,
                                                                       SCREEN_WIDTH/375*36,
                                                                       SCREEN_WIDTH/375*37)];
    }
    return _rightCountButton;
}

-(UITextField *)orderCountTextField{
    if (_orderCountTextField==nil) {
        _orderCountTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*37,
                                                                             SCREEN_WIDTH/375*1,
                                                                             SCREEN_WIDTH-SCREEN_WIDTH/375*145,
                                                                             SCREEN_WIDTH/375*35)];
    }
    return _orderCountTextField;
}



@end
