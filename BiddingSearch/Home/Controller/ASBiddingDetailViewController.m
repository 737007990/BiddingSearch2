//
//  ASBiddingDetailViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBiddingDetailViewController.h"
#import "GetFavorStatusOperation.h"
#import "AddFavorOperation.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface ASBiddingDetailViewController ()<ASBaseModelDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UIButton *favorBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) GetFavorStatusOperation *getFavorStatusOperation;
@property (nonatomic, strong) AddFavorOperation *addFavorOperation;


@end

@implementation ASBiddingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.webView];
    [self.view addSubview:self.barView];
    self.getFavorStatusOperation.favorId = self.itemId;
    [self.getFavorStatusOperation requestStart];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.currentNavigationController setTitleText:@"详情" viewController:self];
    NSString *url =[NSString stringWithFormat:@"%@/details.do?tenderInfoId=%@&token=%@",kBaseURL,self.itemId,ASUSER_INFO_MODEL.token];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    DMLog(@"请求详情地址%@",url);
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.getFavorStatusOperation.delegate=nil;
    self.addFavorOperation.delegate=nil;
}

#pragma mark UIWebViewDelegte
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.webView];
    [MBProgressHUD showError:@"加载失败，请稍后再试！" toView:self.webView];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.getFavorStatusOperation) {
        self.getFavorStatusOperation.isFavor? [_favorBtn setTitle:@"已收藏" forState:UIControlStateNormal]:[_favorBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    else if(request == self.addFavorOperation){
          self.addFavorOperation.isFavor? [_favorBtn setTitle:@"已收藏" forState:UIControlStateNormal]:[_favorBtn setTitle:@"收藏" forState:UIControlStateNormal];
        self.addFavorOperation.isFavor? [MBProgressHUD showSuccess:@"收藏成功！" toView:self.view]:[MBProgressHUD showSuccess:@"取消收藏成功！" toView:self.view];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
-(void)favorBtnClicked{
    self.addFavorOperation.favorId = self.itemId;
    [self.addFavorOperation requestStart];
}

- (void)shareBtnClicked{
     NSString *url =[NSString stringWithFormat:@"%@/details.do?tenderInfoId=%@&token=%@",kBaseURL,self.itemId,ASUSER_INFO_MODEL.token];
    NSArray* imageArray = @[[UIImage imageNamed:@"QRCode.png"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"招投标大数据"
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:@"招投标大数据"
                                           type:SSDKContentTypeAuto];
        //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
        [ShareSDK showShareActionSheet:nil
                           customItems:nil
                           shareParams:shareParams
                    sheetConfiguration:nil
                        onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                            switch (state) {
                                case SSDKResponseStateSuccess:
                                {
                                    [MBProgressHUD showSuccess:@"分享成功！" toView:self.view];
                                    break;
                                }
                                case SSDKResponseStateFail:
                                {
                                    [MBProgressHUD showSuccess:@"分享失败！" toView:self.view];
                                    break;
                                }
                                default:
                                    break;
                            }
                        }];
    }
}

#pragma mark getter

- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT-NAVIGATION_H-TABBAR_H)];
        _webView.delegate = self;
    }
    return _webView;
}

- (UIView *)barView{
    if (!_barView) {
        _barView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame), AS_SCREEN_WIDTH, TABBAR_H)];
        _favorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_barView.frame)/2, CGRectGetHeight(_barView.frame))];
        [_favorBtn setBackgroundColor:AS_MAIN_COLOR];
        [_favorBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
        [_favorBtn addTarget:self action:@selector(favorBtnClicked)];
        [_barView addSubview:_favorBtn];
        _shareBtn =[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_favorBtn.frame), 0, CGRectGetWidth(_barView.frame)-CGRectGetWidth(_favorBtn.frame), CGRectGetHeight(_barView.frame))];
        [_shareBtn setBackgroundColor:[UIColor clearColor]];
        [_shareBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [_shareBtn setTitle:@"\U0000e7ee分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareBtnClicked)];
        [_barView addSubview:_shareBtn];
    }
    return _barView;
}

- (GetFavorStatusOperation *)getFavorStatusOperation{
    if(!_getFavorStatusOperation){
        _getFavorStatusOperation = [[GetFavorStatusOperation alloc] init];
    }
      _getFavorStatusOperation.delegate = self;
    return _getFavorStatusOperation;
}

- (AddFavorOperation *)addFavorOperation{
    if(!_addFavorOperation){
        _addFavorOperation = [[AddFavorOperation alloc] init];
    }
      _addFavorOperation.delegate = self;
    return _addFavorOperation;
}

@end
