//
//  BFPriceTagView.m
//  biufang
//
//  Created by 娄耀文 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFPriceTagView.h"

@implementation BFPriceTagView

/*
  价格标签
*/

- (id)initWithFontSize:(CGFloat)fontSize colorStr:(NSString *)colorStr{
    
    _fontSize = fontSize;
    _colorStr = colorStr;
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setPrice:(NSString *)newPrice{
    
    _price = newPrice;
    [self setUp];
}

- (void)setNewFrame:(CGRect)newFrame {

    _newFrame = newFrame;
    self.frame = _newFrame;
}

- (void)setUp{

    
    [self addSubview:self.aLable];
    [self addSubview:self.priceLable];
    [self addSubview:self.bLable];
    
    CGPoint pointSet;
    if (_newFrame.size.width == 0) {
        //居左
         pointSet = CGPointMake(0, _newFrame.origin.y);
    } else {
        //居中
         pointSet = CGPointMake((_newFrame.size.width - (self.aLable.frame.size.width + self.priceLable.frame.size.width + self.bLable.frame.size.width))/2, _newFrame.origin.y);
    }
    
    self.frame = CGRectMake(pointSet.x,
                            pointSet.y,
                            self.aLable.frame.size.width + self.priceLable.frame.size.width + self.bLable.frame.size.width,
                            _fontSize);
}

- (UILabel *)aLable {

    if (_aLable == nil) {
        _aLable = [[UILabel alloc] init];
        _aLable.textColor = [UIColor colorWithHex:_colorStr];
        _aLable.font = [UIFont systemFontOfSize:_fontSize/2];
        _aLable.text = @"¥";
    }
    _aLable.frame = CGRectMake(0, _fontSize/2, _fontSize/2, _fontSize/2);
    return _aLable;
}

- (UILabel *)priceLable {

    if (_priceLable == nil) {
        _priceLable = [[UILabel alloc] init];
        _priceLable.frame = CGRectMake(0, 0, 0, 0);
        _priceLable.textColor = [UIColor colorWithHex:_colorStr];
        _priceLable.textAlignment = NSTextAlignmentCenter;
        
    }
    UIFont *font = [UIFont fontWithName:@"futura" size:_fontSize];
    _priceLable.font = font;
    
    float price = [[NSString stringWithFormat:@"%@",_price] floatValue];
    
    if (price == 0) {
        
        _priceLable.text = [NSString stringWithFormat:@"0"];
    } else {
    
        if (price >= 100000 ) {

            NSString *subStr = [NSString stringWithFormat:@"%lf",price/10000];
            _priceLable.text = [NSString stringWithFormat:@"%@",@(subStr.floatValue)];
        } else {

            NSString *sepStr = [NSString stringWithFormat:@"%.2lf",price];
            _priceLable.text = [NSString stringWithFormat:@"%@",sepStr];
        }
    }

    CGSize size = CGSizeMake(0, _fontSize);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualSize = [_priceLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    _priceLable.frame = CGRectMake(CGRectGetMaxX(self.aLable.frame), 0, actualSize.width, _fontSize);
    
    return _priceLable;
}

- (UILabel *)bLable {

    if (_bLable == nil) {
        _bLable = [[UILabel alloc] init];
        _bLable.textColor = [UIColor colorWithHex:_colorStr];
        _bLable.font = [UIFont systemFontOfSize:_fontSize/2 - 2];
        _bLable.text = @"万";
    }
    
    float price = [[NSString stringWithFormat:@"%@",_price] floatValue];
    
    if (price > 0 && price <= 100000 ) {
        
        _bLable.frame = CGRectMake(CGRectGetMaxX(self.priceLable.frame) + 5, _fontSize/2, 0, _fontSize/2);
    } else {
        
        _bLable.frame = CGRectMake(CGRectGetMaxX(self.priceLable.frame) + 5, _fontSize/2, _fontSize/2 + 5, _fontSize/2);
    }
    
    return _bLable;
}






@end
