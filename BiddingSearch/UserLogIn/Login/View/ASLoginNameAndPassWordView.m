//
//  ASLoginNameAndPassWordView.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/3.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASLoginNameAndPassWordView.h"

#import "UIButton+UIButton_egdeInset.h"


#define ITEM_H 50
@implementation ASLoginNameAndPassWordView
@synthesize userNameText;
@synthesize passwordText;
@synthesize loginButton;
@synthesize forgotPassWordButton;
@synthesize weiChatLogBtn;
@synthesize qqLogBtn;
@synthesize logType;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1)];
//        [lineV1 setBackgroundColor:ASLINE_VIEW_COLOR];
//        [self addSubview:lineV1];
        
        UILabel *tittleL1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ITEM_H, ITEM_H)];
        [tittleL1 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL1 setText:@"\U0000e60d"];
        [tittleL1 setTextColor:[UIColor whiteColor]];
        [tittleL1 setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tittleL1];
        
        userNameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL1.frame) + tittleL1.frame.origin.x, tittleL1.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL1.frame) - tittleL1.frame.origin.x-10, CGRectGetHeight(tittleL1.frame))];
        userNameText.clearButtonMode = UITextFieldViewModeAlways;
        [userNameText setKeyboardType:UIKeyboardTypeNumberPad];
        [userNameText setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:attrs]; // 初始化富文本占位字符串
        userNameText.attributedPlaceholder = attStr;
        userNameText.tintColor = [UIColor whiteColor];

        
        [self addSubview:userNameText];
        
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(userNameText.frame) + userNameText.frame.origin.y, CGRectGetWidth(frame)-20, 1)];
        [lineV2 setBackgroundColor:ASLINE_VIEW_COLOR];
        [self addSubview:lineV2];
        
        UILabel *tittleL2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lineV2.frame) + lineV2.frame.origin.y, ITEM_H, ITEM_H)];
        [tittleL2 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL2 setTextColor:[UIColor whiteColor]];
        [tittleL2 setText:@"\U0000e626"];
        [tittleL2 setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tittleL2];
        
        passwordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL2.frame) + tittleL2.frame.origin.x, tittleL2.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL2.frame) - tittleL2.frame.origin.x, CGRectGetHeight(tittleL2.frame))];
        passwordText.secureTextEntry = !passwordText.secureTextEntry;
        [passwordText setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs1[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attrs1]; // 初始化富文本占位字符串
        passwordText.attributedPlaceholder = attStr1;
        passwordText.tintColor = [UIColor whiteColor];
        
        [self addSubview:passwordText];
        
        UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(10,  CGRectGetHeight(passwordText.frame) + passwordText.frame.origin.y, CGRectGetWidth(lineV2.frame), 1)];
        [lineV3 setBackgroundColor:ASLINE_VIEW_COLOR];
        [self addSubview:lineV3];
        
        loginButton  = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(lineV3.frame) + lineV3.frame.origin.y + 40, CGRectGetWidth(frame) - 20, ITEM_H)];
        loginButton.layer.cornerRadius = 8;
        loginButton.clipsToBounds= YES;
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        loginButton.tag = ASLOG_TYPE_PASSWORD;
        [loginButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor hex:@"#D1E8F5"] size:CGSizeMake(CGRectGetWidth(frame), 50)] forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:loginButton];
        
        forgotPassWordButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(loginButton.frame) + loginButton.frame.origin.y +10, 100, 20)];
        [forgotPassWordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgotPassWordButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [forgotPassWordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [forgotPassWordButton addTarget:self action:@selector(forgotPassWordButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:forgotPassWordButton];
    
        [self addPasswordTextRightView];
    }
    return self;

}

- (void)confirmButtonAction:(UIButton *)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASLoginNameAndPassWordViewconfirmButtonAction:)]) {
        [self.delegate ASLoginNameAndPassWordViewconfirmButtonAction:sender];
    }
}

- (void)forgotPassWordButtonAction {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASLoginBottomViewForgetButtonAction)]) {
        [self.delegate ASLoginBottomViewForgetButtonAction];
    }
}

- (void)addPasswordTextRightView {
    passwordText.rightViewMode = UITextFieldViewModeAlways;
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 50, 60);
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [rightButton setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    [rightButton.titleLabel sizeToFit];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(toAccordingOrHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    [passwordText setRightView:rightButton];
}

- (void)toAccordingOrHidePassword:(UIButton *)btn{
    passwordText.secureTextEntry = !passwordText.secureTextEntry;
    if (passwordText.secureTextEntry) {
         [btn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    }else{
         [btn setTitle:@"\U0000e648" forState:UIControlStateNormal];
    }
}

@end
