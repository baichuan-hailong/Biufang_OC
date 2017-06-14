//
//  BFMyselfView.m
//  biufang
//
//  Created by 杜海龙 on 16/10/13.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFMyselfView.h"

@interface BFMyselfView ()

@property (nonatomic , strong) UIView *feedLine;
@property (nonatomic , strong) UIView *biuLine;

@property (nonatomic , strong) UILabel *lookPersonInfoLabel;
@property (nonatomic , strong) UIImageView *arrowImageView;
@property (nonatomic , strong) UIImageView *biuarrowImageView;
@property (nonatomic , strong) UIImageView *redarrowImageView;
@property (nonatomic , strong) UIImageView *stararrowImageView;
@property (nonatomic , strong) UIImageView *questionarrowImageView;
@property (nonatomic , strong) UIImageView *feedarrowImageView;
@property (nonatomic , strong) UIImageView *canclearrowImageView;

//person
@property (nonatomic , strong) UIImageView *biuImageView;
@property (nonatomic , strong) UILabel *biuLabel;

@property (nonatomic , strong) UIImageView *redImageView;
@property (nonatomic , strong) UILabel *redLabel;

//幸运记录
@property (nonatomic , strong) UIImageView *starImageView;
@property (nonatomic , strong) UILabel *starLabel;
@property (nonatomic , strong) UIView *starLine;

@property (nonatomic , strong) UIImageView *questionImageView;
@property (nonatomic , strong) UILabel *questionLabel;

@property (nonatomic , strong) UIImageView *feedImageView;
@property (nonatomic , strong) UILabel *feedLabel;

@property (nonatomic , strong) UIImageView *cancleImageView;
@property (nonatomic , strong) UILabel *cancleLabel;

@end

@implementation BFMyselfView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64-49+0.5);
    self.scrollEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    self.backgroundColor = [UIColor redColor];
    
    
    self.personViwe.backgroundColor = [UIColor whiteColor];
    self.biufangRecordViwe.backgroundColor = [UIColor whiteColor];
    self.redMoneyViwe.backgroundColor = [UIColor whiteColor];
    self.starViwe.backgroundColor     = [UIColor whiteColor];
    self.questionView.backgroundColor = [UIColor whiteColor];
    self.feedbackViwe.backgroundColor = [UIColor whiteColor];
    self.cancleViwe.backgroundColor = [UIColor whiteColor];
    
    self.biuLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    self.starLine.backgroundColor = [UIColor colorWithHex:@"DDDDDD"];
    self.feedLine.backgroundColor =[UIColor colorWithHex:@"DDDDDD"];
    
    [self.biufangRecordViwe addSubview:self.biuLine];
    [self.redMoneyViwe addSubview:self.starLine];
    [self.questionView addSubview:self.feedLine];
    
    [self addSubview:self.personViwe];
    [self addSubview:self.biufangRecordViwe];
    [self addSubview:self.redMoneyViwe];
    [self addSubview:self.starViwe];
    [self addSubview:self.questionView];
    [self addSubview:self.feedbackViwe];
    [self addSubview:self.cancleViwe];
    
    
    //person
    //self.headerImageViwe.backgroundColor = [UIColor lightGrayColor];
    self.headerImageViwe.layer.cornerRadius = SCREEN_WIDTH/375*50/2;
    self.headerImageViwe.layer.masksToBounds= YES;
    self.headerImageViwe.image = [UIImage imageNamed:@"placeHeaderImage"];
    [self.personViwe addSubview:self.headerImageViwe];
    

    self.nameLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.nameLabel.text = @"Biu用户";
    [self.personViwe addSubview:self.nameLabel];
    
    self.lookPersonInfoLabel.textColor = [UIColor colorWithHex:@"B8B8B8"];
    self.lookPersonInfoLabel.textAlignment = NSTextAlignmentLeft;
    self.lookPersonInfoLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.lookPersonInfoLabel.text = @"查看并编辑个人资料";
    [self.personViwe addSubview:self.lookPersonInfoLabel];
    
    //1
    self.arrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.personViwe addSubview:self.arrowImageView];
    
    //2
    self.biuarrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.biufangRecordViwe addSubview:self.biuarrowImageView];
    
    //3
    self.redarrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.redMoneyViwe addSubview:self.redarrowImageView];
    
    //4
    self.stararrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.starViwe addSubview:self.stararrowImageView];
    
    
    
    //5
    self.questionarrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.questionView addSubview:self.questionarrowImageView];
    
    //6
    self.feedarrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.feedbackViwe addSubview:self.feedarrowImageView];
    
    //7
    self.canclearrowImageView.image = [UIImage imageNamed:@"gonext"];
    [self.cancleViwe addSubview:self.canclearrowImageView];
 
    //person
    //self.biuImageView.backgroundColor = [UIColor lightGrayColor];
    self.biuImageView.image = [UIImage imageNamed:@"Unknown1"];
    [self.biufangRecordViwe addSubview:self.biuImageView];
    
    self.biuLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.biuLabel.textAlignment = NSTextAlignmentLeft;
    self.biuLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.biuLabel.text = @"我的biu房记录";
    [self.biufangRecordViwe addSubview:self.biuLabel];
    
    //红包
    self.redImageView.image = [UIImage imageNamed:@"Unknown2"];
    [self.redMoneyViwe addSubview:self.redImageView];
    
    self.redLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.redLabel.textAlignment = NSTextAlignmentLeft;
    self.redLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.redLabel.text = @"红包";
    [self.redMoneyViwe addSubview:self.redLabel];
    
    //幸运记录
    //starfourmyself
    self.starImageView.image = [UIImage imageNamed:@"starfourmyself"];
    [self.starViwe addSubview:self.starImageView];
    
    self.starLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.starLabel.textAlignment = NSTextAlignmentLeft;
    self.starLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.starLabel.text = @"我的幸运记录";
    [self.starViwe addSubview:self.starLabel];
    
    //self.questionImageView.backgroundColor = [UIColor lightGrayColor];
    self.questionImageView.image = [UIImage imageNamed:@"Unknown3"];
    [self.questionView addSubview:self.questionImageView];
    
    self.questionLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.questionLabel.textAlignment = NSTextAlignmentLeft;
    self.questionLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.questionLabel.text = @"常见问题";
    [self.questionView addSubview:self.questionLabel];
    
    //self.feedImageView.backgroundColor = [UIColor lightGrayColor];
    self.feedImageView.image = [UIImage imageNamed:@"Unknown4"];
    [self.feedbackViwe addSubview:self.feedImageView];
    
    //self.feedLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.feedLabel.textAlignment = NSTextAlignmentLeft;
    self.feedLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.feedLabel.text = @"反馈";
    [self.feedbackViwe addSubview:self.feedLabel];
    
    //self.cancleImageView.backgroundColor = [UIColor lightGrayColor];
    self.cancleImageView.image = [UIImage imageNamed:@"Unknown5"];
    [self.cancleViwe addSubview:self.cancleImageView];
    
    self.cancleLabel.textColor = [UIColor colorWithHex:@"000000"];
    self.cancleLabel.textAlignment = NSTextAlignmentLeft;
    self.cancleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.cancleLabel.text = @"注销";
    [self.cancleViwe addSubview:self.cancleLabel];
    
    //winningLabel
    self.winningLabel.image = [UIImage imageNamed:@"Group"];
    self.winningLabel.alpha = 0;
    [self.biufangRecordViwe addSubview:self.winningLabel];
}


////个人资料
//@property (nonatomic , strong) UIView *personViwe;

-(UIView *)personViwe{
    
    if (_personViwe==nil) {
        _personViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*13, SCREEN_WIDTH, SCREEN_WIDTH/375*70)];
    }
    return _personViwe;
}

//
////Biu
//@property (nonatomic , strong) UIView *biufangRecordViwe;
-(UIView *)biufangRecordViwe{

    if (_biufangRecordViwe==nil) {
        _biufangRecordViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*96, SCREEN_WIDTH, SCREEN_WIDTH/375*50)];
    }
    
    return _biufangRecordViwe;
}

//@property (nonatomic , strong) UIView *biuLine;
-(UIView *)biuLine{

    if (_biuLine==nil) {
        _biuLine = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*49, SCREEN_WIDTH-29, 1)];
    }
    return _biuLine;
}

//@property (nonatomic , strong) UIView *redMoneyViwe;
-(UIView *)redMoneyViwe{

    if (_redMoneyViwe==nil) {
        _redMoneyViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(96+50), SCREEN_WIDTH, SCREEN_WIDTH/375*49)];
    }
    return _redMoneyViwe;
}


#pragma mark - 我的幸运记录
-(UIView *)starLine{
    if (_starLine==nil) {
        _starLine = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*49, SCREEN_WIDTH-29, 1)];
    }
    return _starLine;
}

//star
-(UIView *)starViwe{
    if (_starViwe==nil) {
        _starViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(96+50+50), SCREEN_WIDTH, SCREEN_WIDTH/375*49)];
    }
    return _starViwe;
}

-(UIImageView *)starImageView{
    
    if (_starImageView==nil) {
        _starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _starImageView;
}

-(UILabel *)starLabel{
    
    if (_starLabel==nil) {
        _starLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _starLabel;
}


-(UIImageView *)stararrowImageView{
    
    if (_stararrowImageView==nil) {
        _stararrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _stararrowImageView;
}





//@property (nonatomic , strong) UIView *questionView;
-(UIView *)questionView{

    if (_questionView==nil) {
        _questionView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(96+50+50+49+13), SCREEN_WIDTH, SCREEN_WIDTH/375*50)];
    }
    return _questionView;
}
//@property (nonatomic , strong) UIView *feedLine;
-(UIView *)feedLine{

    if (_feedLine==nil) {
        _feedLine = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*49, SCREEN_WIDTH, 1)];
    }
    return _feedLine;
}

//@property (nonatomic , strong) UIView *feedbackViwe;
-(UIView *)feedbackViwe{

    if (_feedbackViwe==nil) {
        _feedbackViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(96+50+50+49+13+50), SCREEN_WIDTH, SCREEN_WIDTH/375*49)];
    }
    return _feedbackViwe;
}


//
////注销
//@property (nonatomic , strong) UIView *cancleViwe;
-(UIView *)cancleViwe{

    if (_cancleViwe==nil) {
        _cancleViwe = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(96+50+50+49+13+50+49+13), SCREEN_WIDTH, SCREEN_WIDTH/375*50)];
    }
    
    return _cancleViwe;
}

//person
- (UIImageView *)headerImageViwe{

    if (_headerImageViwe==nil) {
        _headerImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(21, SCREEN_WIDTH/375*11, SCREEN_WIDTH/375*50, SCREEN_WIDTH/375*50)];
    }
    return _headerImageViwe;
}

-(UILabel *)nameLabel{

    if (_nameLabel==nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(21+SCREEN_WIDTH/375*50+14, SCREEN_WIDTH/375*15, 200, SCREEN_WIDTH/375*19)];

    }
    return _nameLabel;
}

-(UILabel *)lookPersonInfoLabel{

    if (_lookPersonInfoLabel==nil) {
        _lookPersonInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(21+SCREEN_WIDTH/375*50+14, SCREEN_WIDTH/375*39, 200, SCREEN_WIDTH/375*14)];
    }
    return _lookPersonInfoLabel;
}



-(UIImageView *)arrowImageView{

    if (_arrowImageView==nil) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*28, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _arrowImageView;
}

//@property (nonatomic , strong) UIImageView *biuarrowImageView;
-(UIImageView *)biuarrowImageView{
    
    if (_biuarrowImageView==nil) {
        _biuarrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _biuarrowImageView;
}

-(UIImageView *)winningLabel{
    
    if (_winningLabel==nil) {
        _winningLabel = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH/375*45-SCREEN_WIDTH/375*40, SCREEN_WIDTH/375*15.5, SCREEN_WIDTH/375*40, SCREEN_WIDTH/375*18)];
    }
    return _winningLabel;
}

//@property (nonatomic , strong) UIImageView *redarrowImageView;
-(UIImageView *)redarrowImageView{
    
    if (_redarrowImageView==nil) {
        _redarrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _redarrowImageView;
}
//@property (nonatomic , strong) UIImageView *questionarrowImageView;
-(UIImageView *)questionarrowImageView{
    
    if (_questionarrowImageView==nil) {
        _questionarrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _questionarrowImageView;
}
//@property (nonatomic , strong) UIImageView *feedarrowImageView;
-(UIImageView *)feedarrowImageView{
    
    if (_feedarrowImageView==nil) {
        _feedarrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _feedarrowImageView;
}
//@property (nonatomic , strong) UIImageView *canclearrowImageView;
-(UIImageView *)canclearrowImageView{
    
    if (_canclearrowImageView==nil) {
        _canclearrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-27-SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*18, SCREEN_WIDTH/375*8, SCREEN_WIDTH/375*13)];
    }
    return _canclearrowImageView;
}

//person
//@property (nonatomic , strong) UIImageView *biuImageView;
//@property (nonatomic , strong) UILabel *biuLabel;
-(UIImageView *)biuImageView{

    if (_biuImageView==nil) {
        _biuImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _biuImageView;
}

-(UILabel *)biuLabel{

    if (_biuLabel==nil) {
        _biuLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _biuLabel;
}
//@property (nonatomic , strong) UIImageView *redImageView;
//@property (nonatomic , strong) UILabel *redLabel;
-(UIImageView *)redImageView{
    
    if (_redImageView==nil) {
        _redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _redImageView;
}

-(UILabel *)redLabel{
    
    if (_redLabel==nil) {
        _redLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _redLabel;
}
//@property (nonatomic , strong) UIImageView *questionImageView;
//@property (nonatomic , strong) UILabel *questionLabel;
-(UIImageView *)questionImageView{
    
    if (_questionImageView==nil) {
        _questionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _questionImageView;
}

-(UILabel *)questionLabel{
    
    if (_questionLabel==nil) {
        _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _questionLabel;
}
//@property (nonatomic , strong) UIImageView *feedImageView;
//@property (nonatomic , strong) UILabel *feedLabel;
-(UIImageView *)feedImageView{
    
    if (_feedImageView==nil) {
        _feedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _feedImageView;
}

-(UILabel *)feedLabel{
    
    if (_feedLabel==nil) {
        _feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _feedLabel;
}
//@property (nonatomic , strong) UIImageView *cancleImageView;
//@property (nonatomic , strong) UILabel *cancleLabel;
-(UIImageView *)cancleImageView{
    
    if (_cancleImageView==nil) {
        _cancleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, SCREEN_WIDTH/375*16, SCREEN_WIDTH/375*22, SCREEN_WIDTH/375*22)];
    }
    return _cancleImageView;
}

-(UILabel *)cancleLabel{
    
    if (_cancleLabel==nil) {
        _cancleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, SCREEN_WIDTH/375*16.5, 150, SCREEN_WIDTH/375*19)];
    }
    return _cancleLabel;
}
@end
