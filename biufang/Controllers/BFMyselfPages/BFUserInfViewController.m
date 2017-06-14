//
//  BFUserInfViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/9/29.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFUserInfViewController.h"
#import "BFUserInfView.h"

#import "BFUserInfoHeaderImageTableViewCell.h"
#import "BFUserInfoTableViewCell.h"

#import "BFNickNameViewController.h"
#import "BFPerfectAwardInfoViewController.h"
#import "BFCheckNewTelNumViewController.h"

@interface BFUserInfViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (nonatomic , strong) BFUserInfView *userInfView;

@property(nonatomic,strong)UIActionSheet *camerSheet;

@property(nonatomic,strong)UIAlertView * alert;
@end

@implementation BFUserInfViewController

- (void)loadView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.userInfView = [[BFUserInfView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.userInfView;
    self.userInfView.userInfoTableView.delegate   = self;
    self.userInfView.userInfoTableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    self.title                = @"个人资料";
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    [self getUserInfoAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadHeaderImageSuccessfulAction) name:@"uploadHeaderImageSuccessful" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUsernameAc) name:@"changeUsernameAc" object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userInfoVCIsShowProgress"]) {
        [self showProgress:@"保存成功"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userInfoVCIsShowProgress"];
        //更新
        [self.userInfView.userInfoTableView reloadData];
    }
}


//bug change tel - username
- (void)changeUsernameAc{

    [self.userInfView.userInfoTableView reloadData];
}


#pragma mark - 获取用户信息
- (void)getUserInfoAction{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //user info
    NSString *urlStr = [NSString stringWithFormat:@"%@/user/info?fields=username,avatar&expand=real",API];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        //NSLog(@"%@",object);
        NSString *stateStr = [NSString stringWithFormat:@"%@",object[@"status"][@"state"]];
        if ([stateStr isEqualToString:@"success"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"realname"] forKey:REAL_NAME];
            
            [[NSUserDefaults standardUserDefaults] setObject:object[@"data"][@"real"][@"id_num"] forKey:CARD_ID];
            
            [self.userInfView.userInfoTableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        [CheckTokenManage chekcToken:error type:@"login" viewController:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } progress:^(float progress) {
        NSLog(@"%f",progress);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}


#pragma mark -Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_WIDTH/375*13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/375*13)];
        view.backgroundColor = [UIColor clearColor];
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return SCREEN_WIDTH/375*70;
    }else{
        return SCREEN_WIDTH/375*50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        static NSString *cellIndentifire = @"headerImCell";
        BFUserInfoHeaderImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
        if (!cell) {
            cell = [[BFUserInfoHeaderImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
            
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:USER_AVATAR]] placeholderImage:[UIImage imageNamed:@"placeHeaderImage"]];
            cell.headerImageView.backgroundColor = [UIColor lightGrayColor];
        }
        return cell;
    }else{
        static NSString *cellIfire = @"userInfoCell";
        BFUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIfire];
        if (!cell) {
            cell = [[BFUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIfire];
        }
        if (indexPath.row==0) {
            cell.leftLabel.text = @"昵称";
            NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
            if (nickName.length==0) {
                cell.rightLabel.text = [NSString stringWithFormat:@"用户%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]];
            }else{
                cell.rightLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:NICKNAME];
            }
            
        }else if (indexPath.row==1) {
            cell.leftLabel.text = @"手机号";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@****%@",[[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] substringToIndex:3],[[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] substringFromIndex:7]];
        }else if (indexPath.row==2) {
            cell.leftLabel.text = @"领奖信息";
            NSString *realName = [[NSUserDefaults standardUserDefaults] objectForKey:REAL_NAME];
            NSLog(@"%@---%ld",realName,(unsigned long)realName.length);
            if (realName.length==0) {
                cell.rightLabel.text = @"未填写";
            }else{
                cell.rightLabel.text = realName;
            }
            cell.line.alpha = 0;
        }
        return cell;
    }

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            BFNickNameViewController *nickNameVC = [[BFNickNameViewController alloc] init];
            [self.navigationController pushViewController:nickNameVC animated:YES];
        }else if (indexPath.row==1) {
            //@"请输入手机号18610******的后六位数字"
            self.alert = [[UIAlertView alloc] initWithTitle:@"身份验证" message:[NSString stringWithFormat:@"\n请输入%@****%@中*代表的数字",[[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] substringToIndex:3],[[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] substringFromIndex:7]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *tf = [self.alert textFieldAtIndex:0];
            tf.keyboardType = UIKeyboardTypeNumberPad;
            self.alert.delegate = self;
            [self.alert show];
        }else if (indexPath.row==2) {
            BFPerfectAwardInfoViewController *perfectAwardInfoVC = [[BFPerfectAwardInfoViewController alloc] init];
            [self.navigationController pushViewController:perfectAwardInfoVC animated:YES];
        }
    }else{
        self.camerSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图片上传", nil];
        [self.camerSheet showInView:self.view];
    }
}

#pragma mark -UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"%ld",(long)buttonIndex);
    UITextField *alerTF=[alertView textFieldAtIndex:0];
    //NSLog(@"%@",alerTF.text);  //857012
    if (buttonIndex==0) {
        [self.alert resignFirstResponder];
    }else if (buttonIndex==1){
    
        NSString *telStr = [[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] substringWithRange:NSMakeRange(3, 4)];
        
        //NSLog(@"dele --- %@",telStr);
        
        if ([alerTF.text isEqualToString:telStr]) {
            
            BFCheckNewTelNumViewController *checkNewTelVC = [[BFCheckNewTelNumViewController alloc] init];
            [self.navigationController pushViewController:checkNewTelVC animated:YES];
        }else{
            [self showProgress:@"输入错误,请重新输入"];
        }
        
        
    }
}



#pragma mark - SheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.delegate = self;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            [imagePickerVC setModalPresentationStyle:UIModalPresentationFullScreen];
            imagePickerVC.delegate = self;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
    }
}


#pragma mark - 图片处理

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *headerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    BFUserInfoHeaderImageTableViewCell *cell = [self.userInfView.userInfoTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.headerImageView.image = headerImage;
    [self.userInfView.userInfoTableView reloadData];
    //NSLog(@"%@",headerImage);
    
    AliyunOSSManager *ossManager = [AliyunOSSManager new];
    
    NSData *imageData = UIImageJPEGRepresentation(headerImage, 0.5);
    [ossManager initOSSClient];
    //uploading
    [ossManager uploadObjectAsyncResister:imageData];
    
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 头像上传成功
- (void)uploadHeaderImageSuccessfulAction{

    [self showProgress:@"资料更新成功"];
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
