//
//  ASLocatorModel.m
//  SheQuEJia
//
//  Created by aisino on 16/3/9.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASLocatorModel.h"

@interface ASLocatorModel()<ASUserInfoModelDelegate>
@property (nonatomic) BOOL netWorkChanged;

@end

@implementation ASLocatorModel
@synthesize testModel;
@synthesize netWorkChanged;


static ASLocatorModel *sharedInstance = nil;

+ (ASLocatorModel *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
       
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (self = [super init]) {
        self.loginNotistr = @"loginSuccess";
        self.clearUnRead = @"clearUnRead";
        self.DidRecevieMsg = @"DidRecevieMsg";
        self.bageAction = @"bageAction";
    }
    return self;
}



#pragma mark getter
- (AFNetworkReachabilityManager *)manager{
    if(!_manager){
         _manager = [AFNetworkReachabilityManager sharedManager];
         WeakSelf(self);
        [_manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown: {
                    DMLog(@"AFNetworkReachabilityStatusUnknown网络状态未知");
                    if (ASUSER_INFO_MODEL.isLogin&&!weakself.netWorkChanged) {
                        
                    }else {
//屏蔽了网络状态变化后重新登录的逻辑
//                        if (ASUSER_INFO_MODEL.isHaveuserDicCacle) {
//                            ASUSER_INFO_MODEL.delegate = weakself;
//                            [ASUSER_INFO_MODEL loginWithToken];
//                            weakself.netWorkChanged = NO;
//                        }
                    }
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable: {
                    weakself.netWorkChanged = YES;
                    DMLog(@"AFNetworkReachabilityStatusNotReachable,网络状态没网");
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    DMLog(@"AFNetworkReachabilityStatusReachableViaWWAN，网络状态移动手机网");
                    if (ASUSER_INFO_MODEL.isLogin&&!weakself.netWorkChanged) {
                        
                    }else {
//                        if (ASUSER_INFO_MODEL.isHaveuserDicCacle) {
//                            ASUSER_INFO_MODEL.delegate = weakself;
//                            [ASUSER_INFO_MODEL loginWithToken];
//                            weakself.netWorkChanged = NO;
//                        }
                    }
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    DMLog(@"AFNetworkReachabilityStatusReachableViaWiFi，网络状态wifi网");
                    if (ASUSER_INFO_MODEL.isLogin&&!weakself.netWorkChanged) {
                        
                    }else {
//                        if (ASUSER_INFO_MODEL.isHaveuserDicCacle) {
//                            ASUSER_INFO_MODEL.delegate = weakself;
//                            [ASUSER_INFO_MODEL loginWithToken];
//                            weakself.netWorkChanged = NO;
//                        }
                    }
                    break;
                }
                default: {
                    break;
                }
            }
        }];
    }
    return _manager;
}

- (BOOL)networkIsOk{
    BOOL b =self.manager.networkReachabilityStatus>0? YES:NO;
    if (b) {
        DMLog(@"\n\n\n\n网络好得很\n\n\n\n");
    }
    else {
        DMLog(@"\n\n\n\n没网怎么玩？\n\n\n\n");
    }
    return b;
}

/*
 01 首页轮播
 02 首页列表
 03 条件搜索
 04 获取搜索选择条件
 05 注册与找回密码公用
 06 验证码
 07 登录
 08 判断手机号是否已注册
 09 新建定制
 10 定制的列表
 11 token登录
 12 删除定制
 13 退出登录
 14 获取收藏状态
 15 收藏/取消收藏
 16 收藏列表
 17 修改密码
 18 阅读历史列表
 19 充值缴费
 20 获取账户余额
 21 订单充值列表
 22 按月套餐列表
 23 订阅月套餐
 24 消费历史列表
 25 消息列表
 26 用户绑定极光推送id
 27 充值详情
 28 用户信息修改
 29 添加用户发票申请
 30 支付宝支付结果查询
 */
- (NSString *)getURLConfigInfoWithMethod:(NSString *)methodCode{
    NSString *methodURL = @"";
    if ([methodCode isEqualToString:@"01"]) {
        methodURL = @"/home/banner.do";
    } else  if ([methodCode isEqualToString:@"02"]) {
        methodURL = @"/item/tender_list.do";
    } else if ([methodCode isEqualToString:@"03"]){
        methodURL = @"/item/tender_search.do";
    }  else if ([methodCode isEqualToString:@"04"]){
        methodURL = @"/dictory/search_dictory.do";
    } else if ([methodCode isEqualToString:@"05"]){
         methodURL = @"/user/register.do";
    } else if ([methodCode isEqualToString:@"06"]){
        methodURL = @"/user/verify.do";
    } else if ([methodCode isEqualToString:@"07"]){
        methodURL = @"/user/login.do";
    } else if ([methodCode isEqualToString:@"08"]){
        methodURL = @"/user/is_register.do";
    } else if ([methodCode isEqualToString:@"09"]){
        methodURL = @"/custom_service/add.do";
    } else if ([methodCode isEqualToString:@"10"]){
        methodURL = @"/custom_service/list.do";
    } else if ([methodCode isEqualToString:@"11"]){
        methodURL = @"/user/info.do";
    }else if ([methodCode isEqualToString:@"12"]){
        methodURL = @"/custom_service/delete.do";
    }else if ([methodCode isEqualToString:@"13"]){
        methodURL = @"/user/logout.do";
    }else if ([methodCode isEqualToString:@"14"]){
        methodURL = @"/collection/status.do";
    }else if ([methodCode isEqualToString:@"15"]){
        methodURL = @"/collection/add.do";
    }else if ([methodCode isEqualToString:@"16"]){
        methodURL = @"/collection/list.do";
    }else if ([methodCode isEqualToString:@"17"]){
        methodURL = @"/user/password_reset.do";
    }else if ([methodCode isEqualToString:@"18"]){
        methodURL = @"/browse/list.do";
    }else if ([methodCode isEqualToString:@"19"]){
        methodURL = @"/AliPay/pay.do";
    }else if ([methodCode isEqualToString:@"20"]){
        methodURL = @"/account/info.do";
    }else if ([methodCode isEqualToString:@"21"]){
        methodURL = @"/recharge/history.do";
    }else if ([methodCode isEqualToString:@"22"]){
        methodURL = @"/product/list.do";
    }else if ([methodCode isEqualToString:@"23"]){
        methodURL = @"/consume/add.do";
    }else if ([methodCode isEqualToString:@"24"]){
        methodURL = @"/consume/list.do";
    }else if ([methodCode isEqualToString:@"25"]){
        methodURL = @"/message/list.do";
    }else if ([methodCode isEqualToString:@"26"]){
        methodURL = @"/registid/bundle.do";
    }else if ([methodCode isEqualToString:@"27"]){
        methodURL = @"/recharge/detail.do";
    }else if ([methodCode isEqualToString:@"28"]){
        methodURL = @"/user/info_set.do";
    }else if ([methodCode isEqualToString:@"29"]){
        methodURL = @"/invoice/add.do";
    }else if ([methodCode isEqualToString:@"30"]){
        methodURL = @"/AliPay/query.do";
    }
    return methodURL;
}


@end
