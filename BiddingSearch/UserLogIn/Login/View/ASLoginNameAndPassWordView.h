//
//  ASLoginNameAndPassWordView.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/3.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASBaseView.h"
typedef NS_ENUM(NSInteger,ASLogType){
   ASLOG_TYPE_PASSWORD,
   ASLOG_TYPE_WEICHAT,
   ASLOG_TYPE_QQ,
};

@protocol ASLoginNameAndPassWordDelegate <NSObject>

@optional
- (void)ASLoginNameAndPassWordViewconfirmButtonAction:(UIButton *)sender;
- (void)ASLoginBottomViewForgetButtonAction;

@end

@interface ASLoginNameAndPassWordView : ASBaseView
@property (strong, nonatomic)  UITextField *userNameText;

@property (strong, nonatomic)  UITextField *passwordText;

@property (strong, nonatomic)  UIButton *loginButton;

@property (strong, nonatomic)  UIButton *forgotPassWordButton;
//微信登录
@property (strong, nonatomic) UIButton *weiChatLogBtn;
//qq登录
@property (strong, nonatomic) UIButton *qqLogBtn;
//登录方式
@property (assign, nonatomic) ASLogType logType;

@property (nonatomic, weak) id<ASLoginNameAndPassWordDelegate>delegate;


@end
