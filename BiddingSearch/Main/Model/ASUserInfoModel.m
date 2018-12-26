//
//  ASUserInfoDto.m
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/14.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASUserInfoModel.h"
#import "MBProgressHUD.h"
#import "ASLogInModel.h"
#import "ASUserLogoutModel.h"
#import "OpenUDID.h"
#import "NSString.h"
#import "ASCommonFunction.h"
#import "JSONKit.h"
#import "ASTokenLoginOperation.h"


#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>

@interface ASUserInfoModel()<ASBaseModelDelegate>
@property (nonatomic, strong) ASLogInModel *logInModel;
@property (nonatomic, strong) ASTokenLoginOperation *tokenLoginOperation;

@property (nonatomic, strong) ASUserLogoutModel *userLogOutModel;


@end

@implementation ASUserInfoModel
@synthesize isLogin;

@synthesize delegate;

@synthesize deviceId;
@synthesize ipAddress;

+ (ASUserInfoModel *)shareUserInfo {
    static ASUserInfoModel * userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[ASUserInfoModel alloc] init];
    });
    return userInfo;
}

- (id)init {
    self = [super init];
    if (self) {
        self.appInfo = [ASAppInfo shareAppInfo];
         self.deviceId = [OpenUDID value];
    }
    return self;
}

#pragma mark selfmethod
- (NSString *)ipAddress{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    DMLog(@"本机的ip地址为：%@",localIP);
    return localIP;
}

- (void)logInActionWithUserName:(NSString *)userName passWord:(NSString *)passWord{
    self.logInModel.telephone = userName;
    self.logInModel.password = passWord;
   
    [self.logInModel requestStart];
}

- (void)loginWithToken{
    [self.tokenLoginOperation requestStart];
}

//读取用户信息到本地
- (BOOL)isHaveuserDicCacle{
    NSString *dataKeyName = @"usersInfo";
    NSDictionary *userDic =  [NSKeyedUnarchiver unarchiveObjectWithData:[ASDATA_BASE getDataAtSqliteFromDataKeyName:dataKeyName]];
    if (userDic) {
        [self setUserInfoWithUserDic:userDic];
        return YES;
    }else {
        return NO;
    }
}
//单项修改用户信息
- (void)changeValeForKey:(NSString *)key withValue:(id)newValue{
    NSString *dataKeyName = @"usersInfo";
    NSMutableDictionary *userDic =  [NSKeyedUnarchiver unarchiveObjectWithData:[ASDATA_BASE getDataAtSqliteFromDataKeyName:dataKeyName]];
    [userDic setObject:newValue forKey:key];
    [ASDATA_BASE updateDataToSqlite:dataKeyName data:userDic];
    [self setUserInfoWithUserDic:userDic];
}
//保存用户信息到本地
- (void)saveUserInfoToLocalWithDic:(NSDictionary *)dic{
     NSString *dataKeyName = @"usersInfo";
    if (self.isHaveuserDicCacle) {
        [ASDATA_BASE updateDataToSqlite:dataKeyName data:dic];
    }
    else {
        [ASDATA_BASE saveDataToSqlite:dataKeyName data:dic];
    }
}

//配置当前应用相关信息状态,并决定了登录成功
- (void)setUserInfoWithUserDic:(NSDictionary *)userData {
    //给userDic赋值
    self.userId = [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"id"];
    self.telephone = [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"telephone"];
    self.userName = [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"name"];
    self.email =  [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"email"];
    self.pushOn =  [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"pushOn"];
    self.token = [userData nullToBlankStringObjectForKey:@"token"];
    NSDictionary *consumeDic = [[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"consumeModel"];
    
    if([consumeDic isKindOfClass:[NSDictionary class]]){
        self.expired =[[[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"consumeModel"] nullToBlankStringObjectForKey:@"expired"];
        self.consumeModel =[[[userData nullToBlankStringObjectForKey:@"user_info"] nullToBlankStringObjectForKey:@"consumeModel"] nullToBlankStringObjectForKey:@"model"];
    }
    self.isLogin = YES;
    [ASAPP_INFO uploadJPUSHRegistId];
    //创建登录成功通知中心
    NSNotification *notification =[NSNotification notificationWithName:ASLOCATOR_MODEL.loginNotistr object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)exit {
    self.telephone = nil;
    self.email = nil;
    self.token = nil;
    self.userName = nil;
    self.userId = nil;
    
    self.pushOn = nil;
    self.userLogName  = nil;
    self.dlmm = nil;
    self.userImage = nil;
    self.userImageUrl = nil;
    self.isLogin = NO;
    NSString *dataKeyName = @"usersInfo";
    [ASDATA_BASE deleteDataAtSqlite:dataKeyName];
}

- (void)exitAndLogOut{
    [self.userLogOutModel requestStart];
}


- (NSDictionary *)dicIsHasNilObject:(NSDictionary *)dic {
    //判断字典中是否有nil或者null的对象，避免崩溃
    for (NSString * key in dic.allKeys) {
        [dic setValue:[ASCommonFunction isNull:[dic noNullobjectForKey:key]] forKey:key];
    }
    return dic;
}


#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.logInModel||request == self.tokenLoginOperation){
        if([data isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data];
            [self saveUserInfoToLocalWithDic:dic];
            [self setUserInfoWithUserDic:dic];
            if ([delegate respondsToSelector:@selector(userLoginSuccess:)]) {
                [delegate userLoginSuccess:dic];
            }
        }
        else{
            DMLog(@"服务器抽风了！");
        }
    }
    else if (request == self.userLogOutModel){
        ASAPP_INFO.jpushIdDidUpLoad = NO;
        [self exit];
        //创建通知中心
        NSNotification *notification =[NSNotification notificationWithName:ASLOCATOR_MODEL.loginNotistr object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [MBProgressHUD showSuccess:@"退出成功" toView:[ASCommonFunction getCurrentViewController].view];
       
    }
}

- (void)request:(id)request failedWithError:(id)error{
        if (request == self.logInModel||request == self.tokenLoginOperation) {
            if (ASLOCATOR_MODEL.networkIsOk) {
                [self exit];
               ASAPP_INFO.jpushIdDidUpLoad = NO;
            }
            if ([delegate respondsToSelector:@selector(userloginfailed:)]) {
                [delegate userloginfailed:error];
            }
        }
        else if (request == self.userLogOutModel){

        }
}
#pragma mark getter
- (ASTokenLoginOperation *)tokenLoginOperation{
    if(!_tokenLoginOperation){
        _tokenLoginOperation = [[ASTokenLoginOperation alloc] init];
    }
    _tokenLoginOperation.delegate = self;
    return _tokenLoginOperation;
}

- (ASLogInModel *)logInModel{
    if(!_logInModel){
        _logInModel = [[ASLogInModel alloc] init];
    }
     _logInModel.delegate = self;
    return _logInModel;
}

- (ASUserLogoutModel *)userLogOutModel{
    if(!_userLogOutModel){
        _userLogOutModel = [[ASUserLogoutModel alloc] init];
    }
     _userLogOutModel.delegate = self;
    return _userLogOutModel;
}



@end
