//
//  AliyunOSSManager.m
//  biufang
//
//  Created by 杜海龙 on 16/10/12.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "AliyunOSSManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>

//NSString * const AccessKey = @"************";
//NSString * const SecretKey = @"*********************";
//NSString * const multipartUploadKey = @"multipartUploadObject";
NSString  * const endPoint    = @"http://oss-cn-beijing.aliyuncs.com";
NSString  * const endPointSTS = @"http://oss-cn-beijing.aliyuncs.com";
OSSClient * client;
static dispatch_queue_t queue4demo;


@implementation AliyunOSSManager

- (void)initOSSClient{
     // Federation鉴权,建议通过访问远程业务服务器获取签名
     id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
     NSString *urlStr = [NSString stringWithFormat:@"%@/user/avatar-sts",API];
         
     //NSString *urlStr = @"http://api.brands500.cn/common/get-sts";
     //NSLog(@"sts -url -%@",urlStr);
     NSURL * url = [NSURL URLWithString:urlStr];
     NSURLRequest * request = [NSURLRequest requestWithURL:url];
         
     OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
     NSURLSession * session = [NSURLSession sharedSession];
     NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     if (error) {
     [tcs setError:error];
     return;
     }
     [tcs setResult:data];
     }];
     [sessionTask resume];
     [tcs.task waitUntilFinished];
     if (tcs.task.error) {
     NSLog(@"get token error: %@", tcs.task.error);
     return nil;
     } else {
     
     NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
     options:kNilOptions
     error:nil];
     NSLog(@"%@",object);
     OSSFederationToken * token = [OSSFederationToken new];
     token.tAccessKey = object[@"data"][@"AccessKeyId"];
     token.tSecretKey = object[@"data"][@"AccessKeySecret"];
     token.tToken = object[@"data"][@"SecurityToken"];
     token.expirationTimeInGMTFormat = object[@"data"][@"Expiration"];
     return token;
     }
     }];
     OSSClientConfiguration * conf = [OSSClientConfiguration new];
     //conf.maxRetryCount = 2;
     //conf.timeoutIntervalForRequest = 30;
     //conf.timeoutIntervalForResource = 24 * 60 * 60;
     client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential2 clientConfiguration:conf];
}


//upload headerImage
- (void)uploadObjectAsyncResister:(NSData *)imageData{
    NSString *filename = [NSString stringWithFormat:@"%@-%@",[self ret16bitString],[self timestamp]];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = AliBucket;
    put.objectKey = [NSString stringWithFormat:@"avatar/%@.png",filename];
    put.uploadingData = imageData;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"进度 --- %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    // 设置MD5校验，可选
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:@""]; // 如果是文件路径
    put.contentMd5 = [OSSUtil base64Md5ForData:imageData]; // 如果是二进制数据
    
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"success");
            //save file name
            [self changeUserHeaderImageUrl:[NSString stringWithFormat:@"%@.png",filename]];
        } else {
            NSLog(@"fail-error: %@", task.error);
        }
        return nil;
    }];
}

#pragma mark - 更改用户头像URL
- (void)changeUserHeaderImageUrl:(NSString *)filename{
    
    //NSString *avartFileName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"tempHeaderIamgeFile"]];
    if (filename.length > 16) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameter = @{@"avatar":filename};
        NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
        [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"%@",responseObject[@"status"][@"message"]);
            NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
            if ([stateStr isEqualToString:@"success"]){
                //更新用户昵称
                //nickname
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"nickname"] forKey:NICKNAME];
                //username
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"username"] forKey:USERNAME];
                //id
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id"] forKey:USER_ID];
                //avatar
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"avatar"] forKey:USER_AVATAR];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadHeaderImageSuccessful" object:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [CheckTokenManage chekcToken:error];
        }];
    }else{
        NSLog(@"不更新...");
    }
}

//upload third header image
- (void)uploadThirdHeaderImage:(NSData *)imageData type:(NSString *)type{
    NSString *filename = [NSString stringWithFormat:@"%@-%@",[self ret16bitString],[self timestamp]];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = AliBucket;
    put.objectKey = [NSString stringWithFormat:@"avatar/%@.png",filename];
    put.uploadingData = imageData;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"进度 --- %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    // 设置MD5校验，可选
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:@""]; // 如果是文件路径
    put.contentMd5 = [OSSUtil base64Md5ForData:imageData]; // 如果是二进制数据
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"success");
            //save file name
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@.png",filename] forKey:@"bindThirdUserHeaderImage"];
            [self updateUserInfoThirdLogin:YES type:type];
        } else {
            NSLog(@"fail-error: %@", task.error);
        }
        return nil;
    }];
}


#pragma mark - 三方登录 tel新用户 更新用户信息
- (void)updateUserInfoThirdLogin:(BOOL)isCreatUser type:(NSString *)type{
    
    NSString *nickName       = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserName"];
    NSString *bindUserToken  = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserOpenid"];
    NSString *bindUnionToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindUserUnionid"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@.png",filename] forKey:@"bindThirdUserHeaderImage"];
    NSString *userHeaderFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bindThirdUserHeaderImage"];
    NSDictionary *parameter      = nil;
    if ([type isEqualToString:@"qq"]) {
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"qq",
                          @"social_token":bindUserToken};
        }else{
            parameter = @{
                          @"social_source":@"qq",
                          @"social_token":bindUserToken};
        }
    }else if ([type isEqualToString:@"weibo"]){
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"weibo",
                          @"social_token":bindUserToken};
        }else{
            parameter = @{
                          @"social_source":@"weibo",
                          @"social_token":bindUserToken};
        }
    }else{
        if (isCreatUser) {
            parameter = @{@"nickname":nickName,
                          @"avatar":userHeaderFileName,
                          @"social_source":@"wechat",
                          @"social_token":bindUserToken,
                          @"union_token":bindUnionToken};
        }else{
            parameter = @{
                          @"social_source":@"wechat",
                          @"social_token":bindUserToken,
                          @"union_token":bindUnionToken};
        }
    }
    NSLog(@"%@",parameter);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] objectForKey:TOKEN]] forHTTPHeaderField:@"Authorization"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/update",API];
    [manager PUT:urlStr parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]){
            //nickname
            [[NSUserDefaults standardUserDefaults] setObject:nickName forKey:NICKNAME];
            //avatar
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"avatar"] forKey:USER_AVATAR];
            //username
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"username"] forKey:USERNAME];
            //id
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"id"] forKey:USER_ID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"crearUserSuccessful" object:nil];
        }else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error];
    }];
}













- (void)runDemo {
    
    // 打开调试log
    [OSSLog enableLog];
    
    // 在本地生成一些文件用来演示
    [self initLocalFile];
    
    // 初始化sdk
    //[self initOSSClient];
    
    
    /*************** 以下每个方法调用代表一个功能的演示，取消注释即可运行 ***************/
    
    // 罗列Bucket中的Object
    // [self listObjectsInBucket];
    
    // 异步上传文件
    [self uploadObjectAsync];
    
    // 同步上传文件
    // [self uploadObjectSync];
    
    // 异步下载文件
    // [self downloadObjectAsync];
    
    // 同步下载文件
    // [self downloadObjectSync];
    
    // 复制文件
    // [self copyObjectAsync];
    
    // 签名Obejct的URL以授权第三方访问
    // [self signAccessObjectURL];
    
    // 分块上传的完整流程
    // [self multipartUpload];
    
    // 只获取Object的Meta信息
    // [self headObject];
    
    // 罗列已经上传的分块
    // [self listParts];
    
    // 自行管理UploadId的分块上传
    // [self resumableUpload];
}


// get local file dir which is readwrite able
- (NSString *)getDocumentDirectory {
    NSString * path = NSHomeDirectory();
    NSLog(@"NSHomeDirectory:%@",path);
    NSString * userName = NSUserName();
    NSString * rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

// create some random file for demo cases
- (void)initLocalFile {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * mainDir = [self getDocumentDirectory];
    
    NSArray * fileNameArray = @[@"file1k", @"file10k", @"file100k", @"file1m", @"file10m", @"fileDirA/", @"fileDirB/"];
    NSArray * fileSizeArray = @[@1024, @10240, @102400, @1024000, @10240000, @1024, @1024];
    
    NSMutableData * basePart = [NSMutableData dataWithCapacity:1024];
    for (int i = 0; i < 1024/4; i++) {
        u_int32_t randomBit = arc4random();
        [basePart appendBytes:(void*)&randomBit length:4];
    }
    
    for (int i = 0; i < [fileNameArray count]; i++) {
        NSString * name = [fileNameArray objectAtIndex:i];
        long size = [[fileSizeArray objectAtIndex:i] longValue];
        NSString * newFilePath = [mainDir stringByAppendingPathComponent:name];
        if ([fm fileExistsAtPath:newFilePath]) {
            [fm removeItemAtPath:newFilePath error:nil];
        }
        [fm createFileAtPath:newFilePath contents:nil attributes:nil];
        NSFileHandle * f = [NSFileHandle fileHandleForWritingAtPath:newFilePath];
        for (int k = 0; k < size/1024; k++) {
            [f writeData:basePart];
        }
        [f closeFile];
    }
    NSLog(@"main bundle: %@", mainDir);
}



#pragma mark work with normal interface
- (void)createBucket {
    OSSCreateBucketRequest * create = [OSSCreateBucketRequest new];
    create.bucketName = @"<bucketName>";
    create.xOssACL = @"public-read";
    create.location = @"oss-cn-hangzhou";
    
    OSSTask * createTask = [client createBucket:create];
    
    [createTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"create bucket success!");
        } else {
            NSLog(@"create bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)deleteBucket {
    OSSDeleteBucketRequest * delete = [OSSDeleteBucketRequest new];
    delete.bucketName = @"<bucketName>";
    
    OSSTask * deleteTask = [client deleteBucket:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete bucket success!");
        } else {
            NSLog(@"delete bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

- (void)listObjectsInBucket {
    OSSGetBucketRequest * getBucket = [OSSGetBucketRequest new];
    getBucket.bucketName = @"android-test";
    getBucket.delimiter = @"";
    getBucket.prefix = @"";
    
    
    OSSTask * getBucketTask = [client getBucket:getBucket];
    
    [getBucketTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSGetBucketResult * result = task.result;
            NSLog(@"get bucket success!");
            for (NSDictionary * objectInfo in result.contents) {
                NSLog(@"list object: %@", objectInfo);
            }
        } else {
            NSLog(@"get bucket failed, error: %@", task.error);
        }
        return nil;
    }];
}

// 异步上传
- (void)uploadObjectAsync {
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = @"android-test";
    put.objectKey = @"file1m";
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 同步上传
- (void)uploadObjectSync {
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    // required fields
    put.bucketName = @"android-test";
    put.objectKey = @"file1m";
    NSString * docDir = [self getDocumentDirectory];
    put.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask waitUntilFinished]; // 阻塞直到上传完成
    
    if (!putTask.error) {
        NSLog(@"upload object success!");
    } else {
        NSLog(@"upload object failed, error: %@" , putTask.error);
    }
}

// 追加上传

- (void)appendObject {
    OSSAppendObjectRequest * append = [OSSAppendObjectRequest new];
    
    // 必填字段
    append.bucketName = @"android-test";
    append.objectKey = @"file1m";
    append.appendPosition = 0; // 指定从何处进行追加
    NSString * docDir = [self getDocumentDirectory];
    append.uploadingFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"file1m"]];
    
    // 可选字段
    append.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    // append.contentType = @"";
    // append.contentMd5 = @"";
    // append.contentEncoding = @"";
    // append.contentDisposition = @"";
    
    OSSTask * appendTask = [client appendObject:append];
    
    [appendTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", append.objectKey);
        if (!task.error) {
            NSLog(@"append object success!");
            OSSAppendObjectResult * result = task.result;
            NSString * etag = result.eTag;
            long nextPosition = result.xOssNextAppendPosition;
            NSLog(@"etag: %@, nextPosition: %ld", etag, nextPosition);
        } else {
            NSLog(@"append object failed, error: %@" , task.error);
        }
        return nil;
    }];
}

// 异步下载
- (void)downloadObjectAsync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
            NSLog(@"download dota length: %lu", [getResult.downloadedData length]);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

// 同步下载
- (void)downloadObjectSync {
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    // required
    request.bucketName = @"android-test";
    request.objectKey = @"file1m";
    
    //optional
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // NSString * docDir = [self getDocumentDirectory];
    // request.downloadToFileURL = [NSURL fileURLWithPath:[docDir stringByAppendingPathComponent:@"downloadfile"]];
    
    OSSTask * getTask = [client getObject:request];
    
    [getTask waitUntilFinished];
    
    if (!getTask.error) {
        OSSGetObjectResult * result = getTask.result;
        NSLog(@"download data length: %lu", [result.downloadedData length]);
    } else {
        NSLog(@"download data error: %@", getTask.error);
    }
}

// 获取meta
- (void)headObject {
    OSSHeadObjectRequest * head = [OSSHeadObjectRequest new];
    head.bucketName = @"android-test";
    head.objectKey = @"file1m";
    
    OSSTask * headTask = [client headObject:head];
    
    [headTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            OSSHeadObjectResult * headResult = task.result;
            NSLog(@"all response header: %@", headResult.httpResponseHeaderFields);
            
            // some object properties include the 'x-oss-meta-*'s
            NSLog(@"head object result: %@", headResult.objectMeta);
        } else {
            NSLog(@"head object error: %@", task.error);
        }
        return nil;
    }];
}

// 删除Object
- (void)deleteObject {
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = @"android-test";
    delete.objectKey = @"file1m";
    
    OSSTask * deleteTask = [client deleteObject:delete];
    
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"delete success !");
        } else {
            NSLog(@"delete erorr, error: %@", task.error);
        }
        return nil;
    }];
}

// 复制Object
- (void)copyObjectAsync {
    OSSCopyObjectRequest * copy = [OSSCopyObjectRequest new];
    copy.bucketName = @"android-test"; // 复制到哪个bucket
    copy.objectKey = @"file_copy_to"; // 复制为哪个object
    copy.sourceCopyFrom = [NSString stringWithFormat:@"/%@/%@", @"android-test", @"file1m"]; // 从哪里复制
    
    OSSTask * copyTask = [client copyObject:copy];
    
    [copyTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"copy success!");
        } else {
            NSLog(@"copy error, error: %@", task.error);
        }
        return nil;
    }];
}

// 签名URL授予第三方访问
- (void)signAccessObjectURL {
    NSString * constrainURL = nil;
    NSString * publicURL = nil;
    
    // sign constrain url
    OSSTask * task = [client presignConstrainURLWithBucketName:@"<bucket name>"
                                                 withObjectKey:@"<object key>"
                                        withExpirationInterval:60 * 30];
    if (!task.error) {
        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }
    
    // sign public url
    task = [client presignPublicURLWithBucketName:@"<bucket name>"
                                    withObjectKey:@"<object key>"];
    if (!task.error) {
        publicURL = task.result;
    } else {
        NSLog(@"sign url error: %@", task.error);
    }
}

// 分块上传
- (void)multipartUpload {
    
    __block NSString * uploadId = nil;
    __block NSMutableArray * partInfos = [NSMutableArray new];
    
    NSString * uploadToBucket = @"android-test";
    NSString * uploadObjectkey = @"file20m";
    
    OSSInitMultipartUploadRequest * init = [OSSInitMultipartUploadRequest new];
    init.bucketName = uploadToBucket;
    init.objectKey = uploadObjectkey;
    init.contentType = @"application/octet-stream";
    init.objectMeta = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"value1", @"x-oss-meta-name1", nil];
    
    OSSTask * initTask = [client multipartUploadInit:init];
    
    [initTask waitUntilFinished];
    
    if (!initTask.error) {
        OSSInitMultipartUploadResult * result = initTask.result;
        uploadId = result.uploadId;
        NSLog(@"init multipart upload success: %@", result.uploadId);
    } else {
        NSLog(@"multipart upload failed, error: %@", initTask.error);
        return;
    }
    
    for (int i = 1; i <= 20; i++) {
        @autoreleasepool {
            OSSUploadPartRequest * uploadPart = [OSSUploadPartRequest new];
            uploadPart.bucketName = uploadToBucket;
            uploadPart.objectkey = uploadObjectkey;
            uploadPart.uploadId = uploadId;
            uploadPart.partNumber = i; // part number start from 1
            
            NSString * docDir = [self getDocumentDirectory];
            // uploadPart.uploadPartFileURL = [NSURL URLWithString:[docDir stringByAppendingPathComponent:@"file1m"]];
            uploadPart.uploadPartData = [NSData dataWithContentsOfFile:[docDir stringByAppendingPathComponent:@"file1m"]];
            
            OSSTask * uploadPartTask = [client uploadPart:uploadPart];
            
            [uploadPartTask waitUntilFinished];
            
            if (!uploadPartTask.error) {
                OSSUploadPartResult * result = uploadPartTask.result;
                uint64_t fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:uploadPart.uploadPartFileURL.absoluteString error:nil] fileSize];
                [partInfos addObject:[OSSPartInfo partInfoWithPartNum:i eTag:result.eTag size:fileSize]];
            } else {
                NSLog(@"upload part error: %@", uploadPartTask.error);
                return;
            }
        }
    }
    
    OSSCompleteMultipartUploadRequest * complete = [OSSCompleteMultipartUploadRequest new];
    complete.bucketName = uploadToBucket;
    complete.objectKey = uploadObjectkey;
    complete.uploadId = uploadId;
    complete.partInfos = partInfos;
    
    OSSTask * completeTask = [client completeMultipartUpload:complete];
    
    [completeTask waitUntilFinished];
    
    if (!completeTask.error) {
        NSLog(@"multipart upload success!");
    } else {
        NSLog(@"multipart upload failed, error: %@", completeTask.error);
        return;
    }
}

// 罗列分块
- (void)listParts {
    OSSListPartsRequest * listParts = [OSSListPartsRequest new];
    listParts.bucketName = @"android-test";
    listParts.objectKey = @"file3m";
    listParts.uploadId = @"265B84D863B64C80BA552959B8B207F0";
    
    OSSTask * listPartTask = [client listParts:listParts];
    
    [listPartTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"list part result success!");
            OSSListPartsResult * listPartResult = task.result;
            for (NSDictionary * partInfo in listPartResult.parts) {
                NSLog(@"each part: %@", partInfo);
            }
        } else {
            NSLog(@"list part result error: %@", task.error);
        }
        return nil;
    }];
}

// 断点续传
- (void)resumableUpload {
    __block NSString * recordKey;
    
    NSString * docDir = [self getDocumentDirectory];
    NSString * filePath = [docDir stringByAppendingPathComponent:@"file10m"];
    NSString * bucketName = @"android-test";
    NSString * objectKey = @"uploadKey";
    
    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
        // 为该文件构造一个唯一的记录键
        NSURL * fileURL = [NSURL fileURLWithPath:filePath];
        NSDate * lastModified;
        NSError * error;
        [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
        if (error) {
            return [OSSTask taskWithError:error];
        }
        recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
        // 通过记录键查看本地是否保存有未完成的UploadId
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        if (!task.result) {
            // 如果本地尚无记录，调用初始化UploadId接口获取
            OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
            initMultipart.bucketName = bucketName;
            initMultipart.objectKey = objectKey;
            initMultipart.contentType = @"application/octet-stream";
            return [client multipartUploadInit:initMultipart];
        }
        OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
        return task;
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        NSString * uploadId = nil;
        
        if (task.error) {
            return task;
        }
        
        if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
            uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
        } else {
            uploadId = task.result;
        }
        
        if (!uploadId) {
            return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
                                                              code:OSSClientErrorCodeNilUploadid
                                                          userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
        }
        // 将“记录键：UploadId”持久化到本地存储
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:uploadId forKey:recordKey];
        [userDefault synchronize];
        return [OSSTask taskWithResult:uploadId];
    }] continueWithSuccessBlock:^id(OSSTask *task) {
        // 持有UploadId上传文件
        OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
        resumableUpload.bucketName = bucketName;
        resumableUpload.objectKey = objectKey;
        resumableUpload.uploadId = task.result;
        resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        };
        return [client resumableUpload:resumableUpload];
    }] continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
                // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
            }
        } else {
            NSLog(@"upload completed!");
            // 上传成功，删除本地保存的UploadId
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
        }
        return nil;
    }];
}







////////////////////////////////////////////////////////////////////////晒单分享
- (void)initSTS{
    
    self.fileImagesArray = [NSMutableArray array];
    
    /*
     NSString *urlStr = [NSString stringWithFormat:@"%@/common/get-sts?prefix=attachments",API];
     [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
     NSLog(@"sts -- %@",object);
     
     id<OSSCredentialProvider> credentialSTS = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:object[@"data"][@"AccessKeyId"] secretKey:object[@"data"][@"AccessKeySecret"]];
     //OSSClientConfiguration * conf = [OSSClientConfiguration new];
     client                        = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credentialSTS];
     
     
     NSLog(@"%@---%@",object[@"data"][@"AccessKeyId"],object[@"data"][@"AccessKeySecret"]);
     
     //NSLog(@"data%@",imageData);
     NSString *filename = [NSString stringWithFormat:@"%@-%@",[self ret16bitString],[self timestamp]];
     OSSPutObjectRequest * put = [OSSPutObjectRequest new];
     // required fields
     put.bucketName     = AliBucket;
     put.objectKey      = [NSString stringWithFormat:@"show/%@.png",filename];
     put.uploadingData  = imageData;
     // optional fields
     put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
     NSLog(@"进度 --- %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
     };
     put.contentType = @"";
     put.contentMd5 = @"";
     // 设置MD5校验，可选
     put.contentMd5 = [OSSUtil base64Md5ForFilePath:@""]; // 如果是文件路径
     put.contentMd5 = [OSSUtil base64Md5ForData:imageData]; // 如果是二进制数据
     
     put.contentEncoding = @"";
     put.contentDisposition = @"";
     
     OSSTask * putTask = [client putObject:put];
     [putTask continueWithBlock:^id(OSSTask *task) {
     NSLog(@"objectKey: %@", put.objectKey);
     if (!task.error) {
     NSLog(@"success");
     } else {
     NSLog(@"fail-error: %@", task.error);
     }
     return nil;
     }];
     
     } withFailureBlock:^(NSError *error) {
     NSLog(@"%@",error);
     } progress:^(float progress) {
     NSLog(@"%f",progress);
     }];
     */
    
     id<OSSCredentialProvider> credentialSTS = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
     NSString *urlStr               = [NSString stringWithFormat:@"%@/common/get-sts?prefix=attachments",API];
     NSLog(@"sts -url -%@",urlStr);
     NSURL * url                    = [NSURL URLWithString:urlStr];
     NSURLRequest * request         = [NSURLRequest requestWithURL:url];
     
     OSSTaskCompletionSource * tcs  = [OSSTaskCompletionSource taskCompletionSource];
     NSURLSession * session         = [NSURLSession sharedSession];
     NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
     if (error) {
     [tcs setError:error];
     return;
     }
     [tcs setResult:data];
     }];
     [sessionTask resume];
     [tcs.task waitUntilFinished];
     
     if (tcs.task.error) {
     NSLog(@"get token error: %@", tcs.task.error);
     return nil;
     }else{
     NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
     options:kNilOptions
     error:nil];
     NSLog(@"%@",object);
     OSSFederationToken * token      = [OSSFederationToken new];
     token.tAccessKey                = object[@"data"][@"AccessKeyId"];
     token.tSecretKey                = object[@"data"][@"AccessKeySecret"];
     token.tToken                    = object[@"data"][@"SecurityToken"];
     token.expirationTimeInGMTFormat = object[@"data"][@"Expiration"];
     return token;
     }
     }];
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    client                        = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credentialSTS clientConfiguration:conf];
    
}


- (void)uploadShareImage:(NSData *)imageData sn:(NSString *)fang_sn content:(NSString *)content count:(NSInteger)imageCout fangID:(NSString *)fangID{
    
    NSString *filename = [NSString stringWithFormat:@"%@-%@",[self ret16bitString],[self timestamp]];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // required fields
    put.bucketName = AliBucket;
    put.objectKey = [NSString stringWithFormat:@"attachments/show/%@.png",filename];
    put.uploadingData = imageData;
    // optional fields
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"进度 --- %lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    put.contentType = @"";
    put.contentMd5 = @"";
    // 设置MD5校验，可选
    put.contentMd5 = [OSSUtil base64Md5ForFilePath:@""];   // 如果是文件路径
    put.contentMd5 = [OSSUtil base64Md5ForData:imageData]; // 如果是二进制数据
    
    put.contentEncoding = @"";
    put.contentDisposition = @"";
    
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"success");
            //save file name
            NSString *fileName = [NSString stringWithFormat:@"%@.png",filename];
            [self.fileImagesArray addObject:fileName];
            if (self.fileImagesArray.count==imageCout) {
                NSLog(@"sharecommit");
                [self commitShare:fang_sn content:content attachment:self.fileImagesArray fangID:fangID];
            }
            
        } else {
            NSLog(@"fail-error: %@", task.error);
        }
        return nil;
    }];
    //NSLog(@"data%@",imageData);
}

#pragma mark - Share Commit
- (void)commitShare:(NSString *)fang_sn content:(NSString *)content attachment:(NSArray *)attachmentArray fangID:(NSString *)fangId{
    NSDictionary *parameter = @{@"fang_sn":fang_sn,
                                @"content":content,
                                @"attachment":attachmentArray};
    NSLog(@"传参 --- %@",parameter);
    NSString *urlStr = [NSString stringWithFormat:@"%@/fang/commit-show",API];
    [BFAFNManage requestWithType:HttpRequestTypePost withUrlString:urlStr withParaments:parameter withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"order --- %@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareSubmitSuccessful" object:nil];
            //refresh lucky list
            NSDictionary *notiParam = @{@"fangId":fangId};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareSubmitSuccessfulRefresh" object:notiParam];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shareSubmitFailed" object:nil];
        }
    } withFailureBlock:^(NSError *error) {
        //NSLog(@"%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shareSubmitFailed" object:nil];
    } progress:^(float progress) {
        NSLog(@"%f",progress);
    }];
}



//custem
//随机16为字符
-(NSString *)ret16bitString{
    char data[16];
    for (int x=0;x<16;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
}

//获取系统当前的时间戳
- (NSString *)timestamp{
    NSTimeInterval a=[[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];//转为字符型
    return timeString;
}


@end
