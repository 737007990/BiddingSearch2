//
//  ASAppInfo.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/27.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ASAppInfo : NSObject


@property (nonatomic, retain) NSString *pushAppKey;          //极光推送appKey
@property (nonatomic, retain) NSString *pushChannelID;      //极光推送channelid
@property (nonatomic, strong) NSString *jpushId;           //极光推送id
@property (nonatomic, assign) BOOL jpushIdDidUpLoad;       //极光推送id已上传服务器

@property (nonatomic, strong) NSString *weixinAppId; //微信appid
@property (nonatomic, strong) NSString *weixinAppSecret;

@property (nonatomic, strong) NSString *qqAPPID; //qq的appid
@property (nonatomic, strong) NSString *qqAPPKEY; //qq的appkey

@property (nonatomic, strong) NSData *deviceToken;        //推送设备token原始数据
@property (nonatomic, strong) NSString *deviceTokenSring;//token 字符串
@property (nonatomic, retain) NSString *appVersion;     //app版本

+ (ASAppInfo *)shareAppInfo;

//上传极光推送id
- (void)uploadJPUSHRegistId;
@end
