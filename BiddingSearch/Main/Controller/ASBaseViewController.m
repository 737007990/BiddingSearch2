//
//  ASBaseViewController.m
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASNavigationController.h"
#import "ASLoginViewController.h"

@interface ASBaseViewController ()<UIGestureRecognizerDelegate,ASUserInfoModelDelegate,WXApiManagerDelegate>
@property (nonatomic, strong) UILabel * messageNumsLabel;

@end

@implementation ASBaseViewController
@synthesize messageNumsLabel;

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginAndLogOut) name:ASLOCATOR_MODEL.loginNotistr object:nil];
    
    //重启侧滑手势返回
    if (self.navigationController.viewControllers.count >1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.view.backgroundColor = AS_CONTROLLER_BACKGROUND_COLOR;
    //其他配置
    [self setupOtherConfig];
    //配置子视图
    [self setupContentView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASLOCATOR_MODEL.loginNotistr object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    ASUSER_INFO_MODEL.delegate = nil;
    [super viewWillDisappear:YES];
}

-(void)setupContentView {
    
}

- (void)setupOtherConfig{
    
}

#pragma mark - Navigations
//ios9以后的新方法，修改status的颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setupNavigationBar {
    
}

-(void)toBack {
    if (self.currentNavigationController != nil) {
        if (ASLOCATOR_MODEL.toBeACoolApp) {
             [self.currentNavigationController toBackWithAnimatedType:[self coolest] animatedSubtype:kCATransitionFromLeft];
        }
        else{
              [self.currentNavigationController toBack];
        }
    }
}

-(void)toRoot {
    if (self.currentNavigationController != nil) {
        [self.currentNavigationController toRoot];
    }
}

-(void)toNextWithViewController:(ASBaseViewController *)viewController {
    if (self.currentNavigationController != nil) {
        if (ASLOCATOR_MODEL.toBeACoolApp) {
            [self.currentNavigationController pushViewController:viewController animatedType:[self coolest]  animatedSubtype:kCATransitionFromRight];
        }
        else{
            [self.currentNavigationController toNext:viewController];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1 ? YES : NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - TabBar
-(void)HideTabBar {
    self.tabBarController.tabBar.hidden = YES;
}

-(void)ShowTabBar {
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Getter
-(ASNavigationController *)currentNavigationController {
    if (self.navigationController != nil && [self.navigationController isKindOfClass:[ASNavigationController class]]) {
        ASNavigationController * tempController = (ASNavigationController *)self.navigationController;
        return tempController;
    } else {
        return nil;
    }
}

#pragma mark ASUserInfoModelDelegate
//登录结果
- (void)userLoginSuccess:(id)successData{
    [self viewWillAppear:NO];
}

- (void)userloginfailed:(id)failedData{
    
}

#pragma mark selfMethod
- (void)toLogin{
    ASLoginViewController *vc = [[ASLoginViewController alloc] init];
    [self.currentNavigationController pushViewController:vc animatedType:[self coolest] animatedSubtype:kCATransitionFromTop];
}
-(void)logOut{
    [ASUSER_INFO_MODEL exitAndLogOut];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}
-(void)delayMethod{
    [self toRoot];
}
//登录注销通知回调
- (void)loginAndLogOut{
    
}

//    1.pageCurl   向上翻一页
//    2.pageUnCurl 向下翻一页
//    3.rippleEffect 滴水效果
//    4.suckEffect 收缩效果，如一块布被抽走
//    5.cube 立方体效果
//    6.oglFlip 上下翻转效果
//    可怜你帅不过坂本大佬
- (NSString *)coolest{
    NSArray *ary = @[@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip",];
     int value = arc4random() % ary.count;
    return [ary objectAtIndex:value];
}

#pragma mark 支付宝支付
- (void)alipayWithOrderString:(NSString *)orderString{
    if (orderString.length >0) {
        NSString *appScheme = @"aliPayBiddingSearch";
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            [self performSelector:@selector(alipayResultMethod:) withObject:resultDic afterDelay:1.0f];
        }];
    }
    else {
        [MBProgressHUD showError:@"获取信息失败！请重试！" toView:self.view];
    }
}

- (void)alipayResultMethod:(NSDictionary *)dic{
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    NSInteger n = [dic[@"resultStatus"] integerValue];
    NSString *payInfo;
    switch (n) {
        case 9000:
            payInfo = @"订单支付成功!";
            break;
        case 8000 :
            payInfo = @"正在处理中!";
            break;
        case 4000:
            payInfo = @"订单支付失败!";
            break;
        case 6001:
            payInfo = @"用户中途取消!";
            break;
        case 6002:
            payInfo = @"网络连接出错!";
            break;
        default:
            break;
    }
    if(n==9000){
//        [MBProgressHUD showSuccess:payInfo toView:self.view];
        [self paySuccess];
    }else{
        [MBProgressHUD showError:payInfo toView:self.view];
        [self payError];
    }
}

#pragma mark 微信支付
//微信支付方法
- (void)weiXinPayWithPrepayid:(NSString *)prepayid sign:(NSString *)sign nonceStr:(NSString *)nonceStr timeStamp:(int)timeStamp partnerId:(NSString *)partnerId  packgevalue:(NSString *)packgevalue appId:(NSString *)appid{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = partnerId;
        req.prepayId            = prepayid;
        req.nonceStr            = nonceStr;
        req.timeStamp           = timeStamp;
        req.package             = packgevalue;
        req.sign                = sign;
        [WXApiManager sharedManager].delegate = self;
        [WXApi sendReq:req];
    }
    else{
        [MBProgressHUD showSuccess:@"请先安装微信客户端！"toView:self.view];
    }
}

#pragma mark WXApiManagerDelegate
- (void)managerDidRecvPayRespones:(PayResp *)response{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    if([response isKindOfClass:[PayResp class]]){
        switch (response.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                break;
            case WXErrCodeUserCancel:
                strMsg = @"用户点击取消！";
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败！";
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败！";
                break;
            default:
                strMsg = @"微信不支持！";
                break;
        }
        if(response.errCode==WXSuccess){
//            [MBProgressHUD showSuccess:strMsg toView:self.view];
            [self paySuccess];
        }else{
            [MBProgressHUD showError:strMsg toView:self.view];
            [self payError];
        }
    }
}

#pragma mark 支付回调
- (void)paySuccess{
}

- (void)payError{
}
@end
