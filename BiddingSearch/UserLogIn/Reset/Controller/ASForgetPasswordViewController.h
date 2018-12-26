//
//  ASRestPasswordViewController.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/3.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASForgetPasswordViewController : ASBaseViewController
@property (strong, nonatomic)  UITextField *theNewPassWordText;
@property (strong, nonatomic)  UITextField *theConfirmNewPasswordText;
@property (strong, nonatomic)  UIButton *confirmButton;
@property (nonatomic, strong) UITextField *phoneNumberText;
//输入验证码
@property (strong, nonatomic)  UITextField *verificationText;
//获取验证码
@property (strong, nonatomic)  UIButton *getVerificationButton;


@end
