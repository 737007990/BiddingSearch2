//
//  ASAppInfo.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/27.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASAppInfo.h"
#import "SetPushIDOperation.h"
@interface ASAppInfo()<ASBaseModelDelegate>
@property (nonatomic, strong) SetPushIDOperation *setPushIDOperation;
@end

@implementation ASAppInfo

+ (ASAppInfo *)shareAppInfo {
    static ASAppInfo *appInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appInfo = [[ASAppInfo alloc] init];
    });
    return appInfo;
}

//配置app相关第三方账号信息
- (id)init {
    if (self = [super init]) {
        self.pushAppKey = @"ae3bba724c1e02428da5e730";
        self.pushChannelID = @"iosapp";
        
        self.weixinAppId = @"wx2247852d789ae057";
        self.weixinAppSecret = @"23d0e75a1e3e1bb1a4944e800d9289f1";
        
        self.qqAPPID = @"1108006966";
        self.qqAPPKEY = @"zkaTqxCo627ioPZb";
    }
    return self;
}

- (void)uploadJPUSHRegistId{
    if(ASUSER_INFO_MODEL.isLogin&&self.jpushId.length>0&&!self.jpushIdDidUpLoad){
        self.setPushIDOperation.regist_id = self.jpushId;
        [self.setPushIDOperation requestStart];
         self.jpushIdDidUpLoad = YES;
    }
}

- (NSString *)appVersion{
    if(!_appVersion){
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}
#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.setPushIDOperation){
        DMLog(@"极光推送id上传\n\n成功！");
       
    }
}

- (void)request:(id)request failedWithError:(id)error{
    if (request == self.setPushIDOperation){
        DMLog(@"极光推送id上传\n\n失败！");
        self.jpushIdDidUpLoad = NO;
    }
}

#pragma mark getter

- (SetPushIDOperation *)setPushIDOperation{
    if(!_setPushIDOperation){
        _setPushIDOperation = [[SetPushIDOperation alloc]init];
    }
    _setPushIDOperation.delegate = self;
    return _setPushIDOperation;
}
@end
