//
//  BFSelectCityViewController.m
//  biufang
//
//  Created by 杜海龙 on 16/10/10.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFSelectCityViewController.h"
#import "BFSelectCityView.h"
#import "BFCityModle.h"
#import "BFSelectCityCell.h"

@interface BFSelectCityViewController () <UITableViewDelegate,
                                          UITableViewDataSource,
                                          CLLocationManagerDelegate,
                                          DZNEmptyDataSetSource,
                                          DZNEmptyDataSetDelegate>

@property (nonatomic, strong) BFSelectCityView  *selCityView;
@property (nonatomic, strong) NSMutableArray    *cityMutableArray;
@property (nonatomic, copy  ) NSString          *currentCity;

@property (nonatomic, strong) UIView            *titleView;
@property (nonatomic, strong) UILabel           *titleLable;
@property (nonatomic, strong) UIImageView       *loadingImage;
@property (nonatomic, strong) CABasicAnimation  *rotationAnimation;
@property (nonatomic, strong) BFNoNetView       *noNetView;     //无网络状态
@property (nonatomic, strong) MBProgressHUD     *hud;

@end

@implementation BFSelectCityViewController

- (void)loadView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selCityView = [[BFSelectCityView alloc] initWithFrame:SCREEN_BOUNDS];
    self.view        = self.selCityView;
    self.selCityView.selectCityTableView.delegate   = self;
    self.selCityView.selectCityTableView.dataSource = self;
    self.selCityView.selectCityTableView.emptyDataSetSource   = self;
    self.selCityView.selectCityTableView.emptyDataSetDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.titleView;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    _cityMutableArray = [[NSMutableArray alloc] init];
    [self.selCityView.selectCityTableView reloadData];
    
    //判断是否首次使用
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_First]) {
        
        //*** 首次运行程序 ***//
        [self requestCityAndLocation];
    } else {
        [self requestCity];
    }
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.removeFromSuperViewOnHide = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:IS_NetWork]) {
        
        if (_cityMutableArray.count == 0) {
            
            [self.selCityView.selectCityTableView addSubview:self.noNetView];
        }
    }else{
        [self.noNetView removeFromSuperview];
    }
}

- (void)refresh {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_First]) {

        [self requestCityAndLocation];
    } else {
        [self requestCity];
    }
}

//首次实用程序，先定位比对
- (void)requestCityAndLocation{
    
    
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    self.titleLable.font = font;
    self.titleLable.text     = @"正在定位您的城市";
    CGSize size = CGSizeMake(0, 40);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualSize = [self.titleLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.titleLable.frame = CGRectMake((self.titleView.frame.size.width - actualSize.width)/2,
                                        0,
                                        actualSize.width,
                                        40);
    [self loadingImage];
    self.loadingImage.hidden = YES;
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@/fang/city-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        [self.noNetView removeFromSuperview];
        _cityMutableArray = object[@"data"][@"cities"];
        
        NSLog(@"~~%@",object);
        
        __block BOOL isOnece = YES;
        [GpsManager getGps:^(double lat, double lng, NSString *city) {
            
            if (isOnece) {
                isOnece = NO;
                [GpsManager stop];
                
                
                self.titleLable.text = @"选择城市";
                if (lat == 0 && lng == 0 && city == nil) {
                    
                    //*** 定位失败 ***//
                    [_hud hide:YES];
                    [self.selCityView.selectCityTableView reloadData];
                    [[NSUserDefaults standardUserDefaults] setObject:@"全国" forKey:CITY];
                    NSDictionary *cityDic = @{@"name":@"全国"};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelectedCity" object:nil userInfo:cityDic];

                    self.loadingImage.hidden = YES;
                    
                    //暂定，定位失败直接返回首页
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } else {

                    _currentCity = [city substringToIndex:city.length - 1];
                    NSLog(@"lat lng (%f, %f)  %@", lat, lng, _currentCity);
                    
                    if ([_cityMutableArray containsObject:_currentCity]) {
                        
                        //*** 城市在列表中,返回当前定位城市 ***//
                        [_hud hide:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:_currentCity forKey:CITY];
                        NSDictionary *cityDic = @{@"name":_currentCity};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelectedCity" object:nil userInfo:cityDic];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        self.loadingImage.hidden = YES;
                        
                    } else {
                        
                        [_hud hide:YES];
                        //*** 城市不在列表中,返回全国 ***//
                        [self.selCityView.selectCityTableView reloadData];
                        [[NSUserDefaults standardUserDefaults] setObject:@"全国" forKey:CITY];
                        NSDictionary *cityDic = @{@"name":@"全国"};
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelectedCity" object:nil userInfo:cityDic];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        self.loadingImage.hidden = YES;
                    }
                }
            }
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
     
    } withFailureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        //*** 网络请求失败，返回全国 ***//
        self.titleLable.text     = @"选择城市";
        self.loadingImage.hidden = YES;
        [_hud hide:YES];
        
        [self.selCityView.selectCityTableView addSubview:self.noNetView];
        [self.selCityView.selectCityTableView reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:@"全国" forKey:CITY];
        NSDictionary *cityDic = @{@"name":@"全国"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelectedCity" object:nil userInfo:cityDic];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IS_First];
        
        //暂定，列表请求失败直接返回首页
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } progress:^(float progress) {}];
}

- (void)requestCity {

    UIFont *font = [UIFont boldSystemFontOfSize:17];
    self.titleLable.font = font;
    self.titleLable.text = @"选择城市";
    CGSize size = CGSizeMake(0, 40);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize actualSize = [self.titleLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    self.titleLable.frame = CGRectMake((self.titleView.frame.size.width - actualSize.width)/2,
                                       0,
                                       actualSize.width,
                                       40);
    [self loadingImage];
    self.loadingImage.hidden = YES;
    
    
    
    NSString *urlStr = [[NSString stringWithFormat:@"%@/fang/city-list",API] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [BFAFNManage requestWithType:HttpRequestTypeGet withUrlString:urlStr withParaments:nil withSuccessBlock:^(NSDictionary *object) {
        
        [_hud hide:YES];
        [self.noNetView removeFromSuperview];
        self.loadingImage.hidden = YES;
        _cityMutableArray = object[@"data"][@"cities"];
        NSLog(@"%@",_cityMutableArray);
        [self.selCityView.selectCityTableView reloadData];
        
    } withFailureBlock:^(NSError *error) {
        [_hud hide:YES];
        NSLog(@"%@",error);
        self.loadingImage.hidden = YES;
        [self.selCityView.selectCityTableView addSubview:self.noNetView];
        
    } progress:^(float progress) {}];
}





#pragma mark -Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cityMutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString  *cellIndentifire = @"cityCell";
    BFSelectCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    
    if (!cell) {
        cell = [[BFSelectCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    cell.cityNameLabel.text = [NSString stringWithFormat:@"%@",[_cityMutableArray objectAt:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[_cityMutableArray objectAt:indexPath.row]] forKey:CITY];
    NSDictionary *cityDic = @{@"name":[_cityMutableArray objectAt:indexPath.row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haveSelectedCity" object:nil userInfo:cityDic];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - DZNEmptyDataSetDelegate 列表空视图
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {

    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_First]) {
        
        //*** 首次运行程序 ***//
        UIView *emptyView = [[UIView alloc] init];
        emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        UIImage *img = [UIImage imageNamed:@"locationing"];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake((emptyView.frame.size.width - img.size.width)/2, -100, img.size.width, img.size.height);
        [emptyView addSubview:imgView];
        
        return emptyView;
        
    } else {
        
        return [[UIView alloc] init];
    }
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - navBarTitleView
- (UIView *)titleView {

    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 20, 200, 40)];

        [_titleView addSubview:self.titleLable];
        [_titleView addSubview:self.loadingImage];
    }
    return _titleView;
}

- (UILabel *)titleLable {

    if (_titleLable == nil) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake((self.titleView.frame.size.width - 150)/2, 0, 150, 40)];
        _titleLable.font = [UIFont boldSystemFontOfSize:17];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}


- (UIImageView *)loadingImage {

    if (_loadingImage == nil) {
        _loadingImage = [[UIImageView alloc] init];
        _loadingImage.image = [UIImage imageNamed:@"loadingImage"];
        _loadingImage.hidden = NO;
        
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        _rotationAnimation.duration = 1.5;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.removedOnCompletion = NO;
        _rotationAnimation.repeatCount = NSNotFound;
        [_loadingImage.layer addAnimation:_rotationAnimation forKey:@"rotationAnimation0"];
    }
    _loadingImage.frame = CGRectMake(CGRectGetMinX(self.titleLable.frame) - 20, 12, 16, 16);
    return _loadingImage;
}



- (BFNoNetView *)noNetView {

    if (_noNetView == nil) {
        _noNetView = [[BFNoNetView alloc] initWithFrame:SCREEN_BOUNDS];
        [_noNetView.updateButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noNetView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
