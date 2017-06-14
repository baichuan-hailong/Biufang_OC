//
//  AliyunOSSManager.h
//  biufang
//
//  Created by 杜海龙 on 16/10/12.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliyunOSSManager : NSObject
@property (nonatomic,strong)NSMutableArray *fileImagesArray;

//init
- (void)initOSSClient;

//upload headerImage
- (void)uploadObjectAsyncResister:(NSData *)imageData;
//upload third header image
- (void)uploadThirdHeaderImage:(NSData *)imageData type:(NSString *)type;



////////////////////////////////////////////////晒单分享
- (void)initSTS;
- (void)uploadShareImage:(NSData *)imageData sn:(NSString *)fang_sn content:(NSString *)content count:(NSInteger)imageCout fangID:(NSString *)fangID;

@end
