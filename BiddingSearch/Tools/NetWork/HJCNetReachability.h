//
//  LCNetReachability.h
//  learningCloud
//
//  Created by 卢希强 on 2017/1/3.
//  Copyright © 2017年 wxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(int, LCNetworkType) {
    //未知
    LCNetworkUnknown = -1,
    //无网络
    LCNetworkNotReachable = 0,
    //3G,4G运营商网络
    LCNetworkReachableViaWWAN = 1,
    //WIFI
    LCNetworkReachableViaWiFi = 2,
};

@interface HJCNetReachability : NSObject <UIAlertViewDelegate>

@property (nonatomic, assign) LCNetworkType networkType;

- (void)startListen;

+ (instancetype)shareManager;

@end
