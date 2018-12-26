//
//  ASRegisterNameAndPassword.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/6.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASBaseView.h"

@protocol ASRegisterNameAndPasswordDelegate <NSObject>

@optional

- (void)ASRegisterNameAndPasswordConfirmButtonAction;

- (void)ASRegisterNameAndPasswordGetVerificationButtonAction;

- (void)ASRegisterNameAndPasswordPromiseSelectButtonAction;

- (void)ASRegisterNameAndPasswordToPromiseSelectButtonAction;


@end

@interface ASRegisterNameAndPassword : ASBaseView
//输入注册手机号
@property (strong, nonatomic)  UITextField *phoneNumberText;
//输入验证码
@property (strong, nonatomic)  UITextField *verificationText;
//获取验证码
@property (strong, nonatomic)  UIButton *getVerificationButton;
//输入注册密码
@property (strong, nonatomic)  UITextField *passwordText;
//确认密码
@property (strong, nonatomic)  UITextField *passwordComfirm;
//注册按钮
@property (strong, nonatomic)  UIButton *confirmButton;
//同意注册协议按钮
@property (strong, nonatomic)  UIButton *promiseSelectButton;
//阅读用户注册协议
@property (strong, nonatomic)  UIButton *toPromiseButton;

@property (nonatomic, assign) id<ASRegisterNameAndPasswordDelegate> delegate;

//倒计时
-(void)startTime;





@end
