//
//  LCNetReachability.m
//  learningCloud
//
//  Created by 卢希强 on 2017/1/3.
//  Copyright © 2017年 wxr. All rights reserved.
//

#import "HJCNetReachability.h"

@implementation HJCNetReachability

+ (instancetype)shareManager {
    static HJCNetReachability *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[HJCNetReachability alloc] init];
    });
    return shareInstance;
}

-(void)startListen{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                DMLog(@"未知=====");
                self.networkType = LCNetworkUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DMLog(@"没有网络=====");
                self.networkType = LCNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DMLog(@"3G|4G=====");
                self.networkType = LCNetworkReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DMLog(@"WiFi=====");
                self.networkType = LCNetworkReachableViaWiFi;
                break;
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkChange" object:nil];
    }];
}

@end
