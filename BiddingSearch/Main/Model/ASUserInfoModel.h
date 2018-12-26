//
//  ASUserInfoDto.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/14.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  用户信息类
//  功能描述：定义用户的模型

#import <Foundation/Foundation.h>
#import "ASAppInfo.h"


@protocol ASUserInfoModelDelegate <NSObject>


@optional
//登录结果
- (void)userLoginSuccess:(id)successData;

- (void)userloginfailed:(id)failedData;

@end

@interface ASUserInfoModel : NSObject

@property (nonatomic, assign) BOOL isHasBeenSynchronized;//用于判断是否已经同步过
@property (nonatomic, strong) NSString * synchro;



@property (nonatomic, strong) NSString * userLogName; //登录名
@property (nonatomic, strong) UIImage  * userImage; //用户头像
@property (nonatomic, strong) NSString * dlmm; //登录密码


//设备id
@property (nonatomic, strong) NSString *deviceId;
//设备ip地址
@property (nonatomic, strong) NSString *ipAddress;

@property (nonatomic, strong) NSArray *homePicArray;
@property (nonatomic, strong) NSString *messageN;//未读消息条数，（暂时没用）
@property (nonatomic, strong) ASAppInfo *appInfo;

@property (nonatomic, assign) id<ASUserInfoModelDelegate> delegate;

@property (nonatomic, strong) NSString *userName;  //用户昵称
@property (nonatomic, strong) NSString *userId;    //用户id
@property (nonatomic, strong) NSString *token;  //用户token
@property (nonatomic, strong) NSString *email;  //邮箱
@property (nonatomic, strong) NSString *qq; //用户qq
@property (nonatomic, strong) NSString *telephone; //电话
@property (nonatomic, strong) NSString *userImageUrl;//用户头像网络地址
@property (nonatomic, assign) BOOL isLogin;  //是否已登录

@property (nonatomic, strong) NSString *money; //账户的钱
@property (nonatomic, strong) NSString *expired;//包月套餐到期日
@property (nonatomic, strong) NSString *consumeModel;//消费模式 1是包月，0是啥也没有， 2是逐条

//推送相关
@property (nonatomic, strong) NSString *pushOn;

//别看了，登录、用户信息状态等所有逻辑都在这里
+ (ASUserInfoModel *)shareUserInfo;

#pragma mark 用户信息操作
//判断用户是否存在本地用户信息
- (BOOL)isHaveuserDicCacle;

//登录后给userInfo属性赋值，也用于修改用户信息后给用户信息赋值（部分值为拼凑原值），
- (void)setUserInfoWithUserDic:(NSDictionary *)userDic;

//用来修改key对应的value值
- (void)changeValeForKey:(NSString *)key withValue:(id)newValue;

#pragma mark 用户登陆方法
//用户登录方法
- (void)logInActionWithUserName:(NSString *)userName passWord:(NSString *)passWord;
- (void)loginWithToken;
//用户退出登录方法
- (void)exit;
- (void)exitAndLogOut;


@end
