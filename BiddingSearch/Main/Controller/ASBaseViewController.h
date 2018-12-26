//
//  ASBaseViewController.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  ViewController的基类
//  功能描述：定义ViewController的通用函数和成员变量

#import <UIKit/UIKit.h>
#import "ASCommonFunction.h"
#import "NSDictionary+NullToNil.h"





@class ASNavigationController;

@interface ASBaseViewController : UIViewController

#pragma mark - LifeCycle

/******************************************************
 * 函数名称：-(void)setupNavigationBar
 * 函数描述：设置导航栏的内容，需要子类实现
 * 输入参数：N/A
 * 输出参数：N/A
 * 返回值：N/A
 ******************************************************/
-(void)setupNavigationBar;

/******************************************************
 函数名称：-(void)setupContentView
 函数描述：设置view的内容，需要子类实现
 输入参数：N/A
 输出参数：N/A
 返回值：N/A
 ******************************************************/
-(void)setupContentView;

/******************************************************
 函数名称：-(void)setupOtherConfig
 函数描述：设置网络请求配置和其他逻辑配置的内容，需要子类实现
 输入参数：N/A
 输出参数：N/A
 返回值：N/A
 ******************************************************/

- (void)setupOtherConfig;

#pragma mark - Navigations

/******************************************************
 函数名称：-(void)toBack
 函数描述：返回上一层Controller
 输入参数：N/A
 输出参数：N/A
 返回值：N/A
******************************************************/
-(void)toBack;

/******************************************************
 函数名称：-(void)toRoot
 函数描述：返回根层Controller
 输入参数：N/A
 输出参数：N/A
 返回值：N/A
******************************************************/
-(void)toRoot;

/******************************************************
 函数名称：-(void)toNextWithViewController:(UIViewController *)viewController
 函数描述：跳转到指定的下一层Controller
 输入参数：(UIViewController *)viewController：指定的Controller
 输出参数：N/A
 返回值：N/A
 ******************************************************/
-(void)toNextWithViewController:(UIViewController *)viewController;

#pragma mark - TabBar

-(void)HideTabBar;

-(void)ShowTabBar;

#pragma mark - Getter

/******************************************************
 函数名称：-(ASNavigationController *)currentNavigationController
 函数描述：获取当前导航控制器
 输入参数：N/A
 输出参数：N/A
 返回值：（ASNavigationController ＊）：导航控制器
 ******************************************************/
-(ASNavigationController *)currentNavigationController;

#pragma mark selfMethod
//登录
- (void)toLogin;
//登出
-(void)logOut;
//接收登录c登出消息
- (void)loginAndLogOut;

//支付宝
- (void)alipayWithOrderString:(NSString *)orderString;
//支付宝回调解析
- (void)alipayResultMethod:(NSDictionary *)dic;

- (void)paySuccess;
- (void)payError;
@end
