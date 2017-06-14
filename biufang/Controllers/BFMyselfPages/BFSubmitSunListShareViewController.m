//
//  BFSubmitSunListShareViewController.m
//  biufang
//
//  Created by 杜海龙 on 17/3/7.
//  Copyright © 2017年 biufang. All rights reserved.
//

#import "BFSubmitSunListShareViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BFSubmitImageCollectionViewCell.h"

@interface BFSubmitSunListShareViewController ()<UITextViewDelegate,UIActionSheetDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
}
@property (nonatomic,strong)TZImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView      *shareCollectionView;
//期号1
@property (nonatomic , strong) UIView      *issueView;
//commun
@property (nonatomic , strong) UILabel     *communityNameLabel;
//issue number
@property (nonatomic , strong) UILabel     *issueNumberLabel;
//fang image
@property (nonatomic , strong) UIImageView *fangImagaView;
//2
@property (nonatomic , strong) UIView      *shareView;
//反馈
@property(nonatomic,strong)UITextView      *suggestTextView;
//反馈占位Label
@property(nonatomic,strong)UILabel         *suggestPlaceHolderLabel;
//submit 
@property (nonatomic , strong) UIButton    *sendButton;

//add image
@property (nonatomic , strong) UIButton    *addImageBtn;
//camer
@property(nonatomic,strong)UIActionSheet   *camerSheet;
@property(nonatomic,strong)AliyunOSSManager *ossManager;
@property (nonatomic , strong) MBProgressHUD *HUD;
@end

@implementation BFSubmitSunListShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"晒单分享";
    //init
    _selectedPhotos = [NSMutableArray array];
    //_selectedAssets = [NSMutableArray array];
    UIImage *addImage = [UIImage imageNamed:@"submitListShareAdd"];
    [_selectedPhotos addObject:addImage];
    self.shareCollectionView.delegate      = self;
    self.shareCollectionView.dataSource    = self;
    [self setUI];
    
    
    
    //submit success
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSubmitSuccessful) name:@"shareSubmitSuccessful" object:nil];
    //submit fail
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSubmitFailed) name:@"shareSubmitFailed" object:nil];

}


- (void)setUI{
    
    self.view.backgroundColor      = [UIColor colorWithHex:BACK_COLOR];
    self.issueView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.issueView];
    //1
    self.fangImagaView.image = [UIImage imageNamed:@"赠送biu房号"];
    [self.fangImagaView sd_setImageWithURL:[NSURL URLWithString:self.fang_cover]];
    self.fangImagaView.layer.cornerRadius = SCREEN_WIDTH/376*4;
    self.fangImagaView.layer.masksToBounds= YES;
    self.fangImagaView.contentMode = UIViewContentModeScaleAspectFill;
    [self.issueView addSubview:self.fangImagaView];
    
    self.communityNameLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*14];
    self.communityNameLabel.text = @"--- ---";
    self.communityNameLabel.text = self.fang_title;
    self.communityNameLabel.textColor = [UIColor blackColor];
    self.communityNameLabel.numberOfLines = 0;
    self.communityNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.issueView addSubview:self.communityNameLabel];
    
    self.issueNumberLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*12];
    self.issueNumberLabel.text = @"期号：---";
    self.issueNumberLabel.text = [NSString stringWithFormat:@"期号：%@",_fang_sn];
    self.issueNumberLabel.textColor = [UIColor colorWithHex:@"979797"];
    self.issueNumberLabel.textAlignment = NSTextAlignmentLeft;
    [self.issueView addSubview:self.issueNumberLabel];
    
    //2
    self.shareView.backgroundColor      = [UIColor whiteColor];
    [self.view addSubview:self.shareView];
    
    self.suggestTextView.font            = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.suggestTextView.textColor       = [UIColor colorWithHex:@"353846"];
    self.suggestTextView.delegate        = self;
    //self.suggestTextView.backgroundColor = [UIColor whiteColor];
    [self.shareView addSubview:self.suggestTextView];
    
    
    self.suggestPlaceHolderLabel.font      = [UIFont fontWithName:@"Helvetica" size:14.f];
    self.suggestPlaceHolderLabel.text      = @"分享你的幸运秘诀…";
    self.suggestPlaceHolderLabel.textColor = [UIColor colorWithHex:@"979797"];
    //self.suggestPlaceHolderLabel.backgroundColor = [UIColor orangeColor];
    [self.suggestTextView addSubview:self.suggestPlaceHolderLabel];
    
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"fnishbutton"] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor colorWithHex:@"FFFFFF"] forState:UIControlStateNormal];
    [self.sendButton setTitle:@"提交" forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:SCREEN_WIDTH/375*16];
    self.sendButton.alpha = 0.6;
    self.sendButton.userInteractionEnabled = NO;
    [self.view addSubview:self.sendButton];
    
    //add btn
    //[self.addImageBtn setBackgroundImage:[UIImage imageNamed:@"submitListShareAdd"] forState:UIControlStateNormal];
    //[self.shareView addSubview:self.addImageBtn];
    //action
    //[self.addImageBtn addTarget:self action:@selector(addImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //action
    [self.sendButton addTarget:self action:@selector(sendButtonDidClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *viewTapGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(wiewTapGRAction)];
    [self.view addGestureRecognizer:viewTapGR];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wiewTapGRAction)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
    self.shareView.userInteractionEnabled = YES;
    [self.shareView addSubview:self.shareCollectionView];
}

#pragma mark -  Add Image
- (void)addImageBtn:(UIButton *)sender{
    //NSLog(@"button");
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
            NSLog(@"camer");
        }
    }else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            self.imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(4-_selectedPhotos.count+1) columnNumber:4 delegate:self pushPhotoPickerVc:YES];
            self.imagePickerVc.allowTakePicture                = NO;
            self.imagePickerVc.allowPickingVideo               = NO;
            self.imagePickerVc.allowPickingImage               = YES;
            self.imagePickerVc.allowPickingOriginalPhoto       = NO;
            self.imagePickerVc.allowPickingGif                 = NO;
            self.imagePickerVc.sortAscendingByModificationDate = YES;
            self.imagePickerVc.showSelectBtn                   = NO;
            self.imagePickerVc.allowCrop                       = NO;
            self.imagePickerVc.needCircleCrop                  = NO;
            self.imagePickerVc.circleCropRadius                = 100;
            [_imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            }];
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
            
            NSLog(@"library");
        }
    }
}


#pragma mark - Delegate
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    
    for (int i=0; i<photos.count; i++) {
        [_selectedPhotos insertObject:photos[i] atIndex:0];
    }
    [self.shareCollectionView reloadData];
    
    //change
    self.sendButton.alpha = 1;
    self.sendButton.userInteractionEnabled = YES;
}


#pragma mark - 图片处理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *headerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //save
    UIImageWriteToSavedPhotosAlbum(headerImage, nil, nil, nil);
    [_selectedPhotos insertObject:headerImage atIndex:0];
    
    [self.shareCollectionView reloadData];
    
    //change
    self.sendButton.alpha = 1;
    self.sendButton.userInteractionEnabled = YES;
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Tap&Submit
- (void)sendButtonDidClickedAction:(UIButton *)sender{
    
    
    //NSLog(@"%@",self.suggestTextView.text);
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    [self.HUD show:YES];
    
    self.ossManager = [AliyunOSSManager new];
    [self.ossManager initSTS];
    
    
    for (int i=0; i<_selectedPhotos.count-1; i++) {
        UIImage *image = _selectedPhotos[i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        //uploading
        [self.ossManager uploadShareImage:imageData sn:self.fang_sn content:self.suggestTextView.text count:(_selectedPhotos.count-1) fangID:self.fang_id];
    }
}

#pragma mark - Submit Result
- (void)shareSubmitSuccessful{
    [self.HUD hide:YES];
    //NSLog(@"1");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareSubmitFailed{
    [self.HUD hide:YES];
    //NSLog(@"0");
}

- (void)wiewTapGRAction{
    [self.view endEditing:YES];
}






#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_selectedPhotos.count<5) {
        return _selectedPhotos.count;
    }else{
        return _selectedPhotos.count-1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BFSubmitImageCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"submitImageCollectionViewCell" forIndexPath:indexPath];
    cell.bodyImageView.image = (UIImage *)_selectedPhotos[indexPath.row];
    
    cell.deleteImageView.tag = 8282+indexPath.row;
    [cell.deleteImageView addTarget:self action:@selector(deleteImageViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_selectedPhotos.count<5) {
        if (indexPath.row==_selectedPhotos.count-1) {
           cell.deleteImageView.alpha = 0;
        }else{
            cell.deleteImageView.alpha = 1;
        }
    }else{
        cell.deleteImageView.alpha = 1;
    }
    return cell;
}


#pragma mark - Delete Image
- (void)deleteImageViewBtnAction:(UIButton *)sender{
    
    [_selectedPhotos removeObjectAtIndex:sender.tag-8282];
    //[self.shareCollectionView reloadData];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag-8282 inSection:1];
    [self.shareCollectionView reloadData];
    
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH-SCREEN_WIDTH/375*56)/4-SCREEN_WIDTH/375*15, (SCREEN_WIDTH-SCREEN_WIDTH/375*56)/4-SCREEN_WIDTH/375*15);
}
//margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    if (_selectedPhotos.count<5) {
        if (indexPath.row==_selectedPhotos.count-1) {
            self.camerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            [self.camerSheet showInView:self.view];
        }
    }
}


#pragma mark - TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.suggestTextView.text.length==0) {
        [self.suggestTextView addSubview:self.suggestPlaceHolderLabel];
    }else{
        [self.suggestPlaceHolderLabel removeFromSuperview];
    }
    
    NSString *textCodeString = [self.suggestTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textCodeString.length>0) {
        self.sendButton.alpha = 1;
        self.sendButton.userInteractionEnabled = YES;
    }else{
        self.sendButton.alpha = 0.6;
        self.sendButton.userInteractionEnabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //delete ch
        return YES;
    }
    else {
        if (textView.text.length - range.length + text.length > 255) {
            return NO;
        }
        else {
            return YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//lazy
-(UIView *)issueView{
    
    if (_issueView==nil) {
        _issueView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(64+7), SCREEN_WIDTH, SCREEN_WIDTH/375*91)];
    }
    return _issueView;
}
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

-(UIView *)shareView{
    if (_shareView==nil) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/375*(64+7+91+8), SCREEN_WIDTH, SCREEN_WIDTH/375*180)];
    }
    return _shareView;
}

-(UITextView *)suggestTextView{
    
    if (_suggestTextView==nil) {
        _suggestTextView=[[UITextView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*12, SCREEN_WIDTH/375*14, SCREEN_WIDTH-SCREEN_WIDTH/375*24, SCREEN_WIDTH/375*68)];
    }
    return _suggestTextView;
}

-(UILabel *)suggestPlaceHolderLabel{
    
    if (_suggestPlaceHolderLabel==nil) {
        _suggestPlaceHolderLabel =[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*5, SCREEN_WIDTH/375*7, self.suggestTextView.frame.size.width, SCREEN_WIDTH/375*17)];
    }
    return _suggestPlaceHolderLabel;
}

-(UIButton *)sendButton{
    
    if (_sendButton==nil) {
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*38, CGRectGetMaxY(self.shareView.frame)+SCREEN_WIDTH/375*92, SCREEN_WIDTH-SCREEN_WIDTH/375*76, SCREEN_WIDTH/375*40)];
    }
    return _sendButton;
}

-(UIButton *)addImageBtn{
    if (_addImageBtn==nil) {
        _addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*28, SCREEN_WIDTH/375*96, SCREEN_WIDTH/375*70, SCREEN_WIDTH/375*70)];
    }
    return _addImageBtn;
}

//collection

-(UICollectionView *)shareCollectionView{
    if (_shareCollectionView==nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing      = 0.0f; //上下
        layout.minimumInteritemSpacing = 0.0f; //左右
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        
        _shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/375*28, SCREEN_WIDTH/375*88, SCREEN_WIDTH-SCREEN_WIDTH/375*56, SCREEN_WIDTH/375*80) collectionViewLayout:layout];
        _shareCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 15);
        _shareCollectionView.alwaysBounceVertical = YES;
        _shareCollectionView.scrollEnabled = NO;
        _shareCollectionView.backgroundColor = [UIColor whiteColor];
        [_shareCollectionView registerClass:[BFSubmitImageCollectionViewCell class] forCellWithReuseIdentifier:@"submitImageCollectionViewCell"];
        
    }
    return _shareCollectionView;
}





@end
