//
//  BFQuestionViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFQuestionViewController.h"

@interface BFQuestionViewController ()

@end

@implementation BFQuestionViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;[super viewDidLoad];
    
    self.title                = @"常见问题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.contentLable];
    
    self.mainScrollView.contentSize = CGSizeMake(0, self.contentLable.frame.size.height +20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - getter
- (UIScrollView *)mainScrollView {

    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    _mainScrollView.contentSize = CGSizeMake(0, SCREEN_HEIGHT*2);
    return _mainScrollView;
}


- (UILabel *)contentLable {

    if (_contentLable == nil) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.frame = CGRectMake(15, 15, self.mainScrollView.frame.size.width - 30, 0);
        _contentLable.textColor = [UIColor colorWithHex:@"696969"];
        _contentLable.numberOfLines = 0;
        
        UIFont *font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _contentLable.font = font;
        _contentLable.text = @"1、获赠的产品抵用券请登录太平洋保险生活广场 http://www.601601.com/，进入指定页面购买抵用（需先注册激活），此抵用券不兑换现金、抵用券部分不开发票，购买产生快递费用请自行承担，使用过程中如有任何问题，请致电主办方客服热线： 4006595500转6 （周一至周五 8:30-17:30）；\n2、车险免单奖品为4999元太平洋车险保单（私家车），可包括：机动车交通事故责任强制保险、车辆损失险（不计免赔），第三者责任险50万元（不计免赔）、车上人员责任险（1万元每座）、车辆涉水险等5项。其它投保险种/条款、保险金额的增加由中奖用户自理；\n3、车险免单中奖者需要在1年之内（即从中奖之日起）通过 www.10108888.com.cn 网上全流程购买1年相关车险；车险免单中奖者如未通过 www.10108888.com.cn 网上投保、提供资料不真实、不齐全等，则视为中奖者自动放弃该奖项；\n4、车险免单中奖者兑奖时需提供所购买的车险发票复印件、身份证复印件、保单复印件、行驶证（必须与注册时车型、车牌号、车辆购置年月一致）复印件、银行账户（银行账户户主名字须与中奖者姓名一致）；\n5、所有获奖名单将在 www.10108888.com.cn、官方微信【太平洋保险e服务】上公布，或将电话或邮件形式通知中奖者，敬请关注；\n6、凡参加活动者，即视为同意接受本活动规则及奖品领取规则的所有条款，如有任何舞弊、欺诈、用户信息不真实等情形，主办方有权取消参与者参加活动的资格，并保留不另行通 知或采取其他相应法律措施的权利。\n7、活动主办方有权依据相关法律法规或业务需要，中止或取消此次活动或者修改活动方案，经相关途径公告后生效；";
        
        
        CGSize size = CGSizeMake(self.mainScrollView.frame.size.width - 30, 0);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        CGSize actualSize = [_contentLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        _contentLable.frame = CGRectMake(15, 15, self.mainScrollView.frame.size.width - 30, actualSize.height);
        
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentLable.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:10];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentLable.text length])];
        _contentLable.attributedText = attributedString;
        [_contentLable sizeToFit];
    }
    return _contentLable;
}


@end
