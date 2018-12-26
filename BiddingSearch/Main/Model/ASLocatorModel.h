//
//  ASLocatorModel.h
//  SheQuEJia
//
//  Created by aisino on 16/3/9.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NullToNil.h"
#import "AFNetworking.h"

@interface ASLocatorModel : NSObject
@property (nonatomic, unsafe_unretained) BOOL testModel;//测试或正式环境
@property (nonatomic, unsafe_unretained) BOOL requestLogOut;//是否打印出服务器网络请求信息
//网络相关
@property (nonatomic, strong)  AFNetworkReachabilityManager *manager;
@property (nonatomic, assign) BOOL networkIsOk; //判断网络是否连接

//本地通知相关
@property (nonatomic, strong) NSString *loginNotistr; //登录通知key
@property (nonatomic, strong) NSString *DidRecevieMsg; //收到推送
@property (nonatomic, strong) NSString *clearUnRead; //清除未读提示
@property (nonatomic, strong) NSString *bageAction;//监测到有未清除的bage（如直接点击icon进入）

@property (nonatomic, assign) BOOL toBeACoolApp;



+ (ASLocatorModel *)sharedInstance;
//配置请求接口相关
- (NSString *)getURLConfigInfoWithMethod:(NSString *)methodCode;

@end
