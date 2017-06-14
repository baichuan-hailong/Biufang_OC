//
//  BFSubmitImageCollectionViewCell.m
//  biufang
//
//  Created by 杜海龙 on 17/3/8.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFSubmitImageCollectionViewCell.h"

@implementation BFSubmitImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor                 = [UIColor whiteColor];
        //self.bodyImageView.backgroundColor   = [UIColor blueColor];
        //self.deleteImageView.backgroundColor = [UIColor redColor];
        
        //[self.deleteImageView setBackgroundImage:[UIImage imageNamed:@"submitListShareDelete"] forState:UIControlStateNormal];
        [self.deleteImageView setImage:[UIImage imageNamed:@"submitListShareDelete"] forState:UIControlStateNormal];
        
        self.bodyImageView.userInteractionEnabled   = YES;
        self.deleteImageView.userInteractionEnabled = YES;
        [self addSubview:self.bodyImageView];
        [self addSubview:self.deleteImageView];
        
    }
    return self;
}

//80x80

//lazy
-(UIImageView *)bodyImageView{
    if (_bodyImageView==nil) {
        _bodyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*10, (SCREEN_WIDTH-SCREEN_WIDTH/375*56)/4-SCREEN_WIDTH/375*15, (SCREEN_WIDTH-SCREEN_WIDTH/375*56)/4-SCREEN_WIDTH/375*15)];
    }
    return _bodyImageView;
}
-(UIButton *)deleteImageView{
    if (_deleteImageView==nil) {
        _deleteImageView = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/375*56)/4-SCREEN_WIDTH/375*25, SCREEN_WIDTH/375*0, SCREEN_WIDTH/375*26, SCREEN_WIDTH/375*26)];
    }
    return _deleteImageView;
}
@end
