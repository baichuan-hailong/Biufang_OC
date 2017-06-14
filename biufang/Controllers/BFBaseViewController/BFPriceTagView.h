//
//  BFPriceTagView.h
//  biufang
//
//  Created by 娄耀文 on 16/10/14.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BFPriceTagView : UIView

@property (nonatomic, strong) UIView  *priceView;
@property (nonatomic, strong) UILabel *aLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *bLable;

@property (nonatomic, assign) CGFloat  fontSize;
@property (nonatomic, assign) CGRect   newFrame;
@property (nonatomic, copy  ) NSString *price;
@property (nonatomic, copy  ) NSString *colorStr;

- (id)initWithFontSize:(CGFloat)fontSize
           colorStr:(NSString *)colorStr;

@end
