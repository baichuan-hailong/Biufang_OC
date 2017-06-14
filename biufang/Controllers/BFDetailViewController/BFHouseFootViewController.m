//
//  BFHouseFootViewController.m
//  biufang
//
//  Created by 娄耀文 on 16/10/17.
//  Copyright © 2016年 biufang. All rights reserved.
//

#import "BFHouseFootViewController.h"

@interface BFHouseFootViewController () <UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UITableView   *mytableView;
@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) UIView        *backTipsView;
@property (nonatomic, strong) UILabel       *tipsLable;

@end

@implementation BFHouseFootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    
    _mytableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    _mytableView.delegate   = self;
    _mytableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_HEIGHT/11.5 - 64);
    _mytableView.dataSource = self;
    _mytableView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
    _mytableView.showsVerticalScrollIndicator = NO;
    
    _mytableView.mj_header=[MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    [self.view addSubview:self.webView];
    
    
    _webUrl = [_webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIndentifire = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifire];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifire];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void)headRefresh
{
    _headRefReshBlock();
    //[_mytableView.mj_header endRefreshing];
}


#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"开始加载");
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.userInteractionEnabled = NO;
    _hud.removeFromSuperViewOnHide = YES;
    
}
//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"结束");
    [_hud hide:YES];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        CGFloat y = _webView.scrollView.contentOffset.y;
        
        if (y <= -100) {
            [self headRefresh];
        }
        
        
        NSLog(@"%lf",y);
        if (y <= 0) {
            
            self.backTipsView.alpha = y*(-1) / 100;
        }
    }
}


#pragma maek - getter
- (UIWebView *)webView {
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - SCREEN_HEIGHT/11.5);
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithHex:BACK_COLOR];
        [_webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [_webView addSubview:self.backTipsView];
    }
    return _webView;
}


- (UIView *)backTipsView {

    if (_backTipsView == nil) {
        _backTipsView = [[UIView alloc] init];
        _backTipsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _backTipsView.alpha = 0;
        
        [_backTipsView addSubview:self.tipsLable];
    }
    return _backTipsView;
}

- (UILabel *)tipsLable {

    if (_tipsLable == nil) {
        _tipsLable = [[UILabel alloc] init];
        _tipsLable.frame = CGRectMake(0, (self.backTipsView.frame.size.height - SCREEN_WIDTH/31.25)/2, SCREEN_WIDTH, SCREEN_WIDTH/31.25);
        _tipsLable.text=@"继续拖动,返回商品详情";
        _tipsLable.textColor = [UIColor colorWithHex:@"313131"];
        _tipsLable.font = [UIFont systemFontOfSize:SCREEN_WIDTH/31.25];
        _tipsLable.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLable;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
