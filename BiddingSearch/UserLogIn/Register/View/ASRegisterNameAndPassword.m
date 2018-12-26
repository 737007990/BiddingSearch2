//
//  ASRegisterNameAndPassword.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/6.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASRegisterNameAndPassword.h"

#define ITEM_H 50

@implementation ASRegisterNameAndPassword
@synthesize delegate;
@synthesize phoneNumberText;
@synthesize verificationText;
@synthesize getVerificationButton;
@synthesize passwordText;
@synthesize passwordComfirm;
@synthesize confirmButton;
@synthesize promiseSelectButton;
@synthesize toPromiseButton;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        UILabel *tittleL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ITEM_H, ITEM_H)];
        [tittleL1 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL1 setText:@"\U0000e60d"];
        [tittleL1 setTextColor:[UIColor whiteColor]];
        [tittleL1 setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:tittleL1];
        
        
        phoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL1.frame) + tittleL1.frame.origin.x, tittleL1.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL1.frame) - tittleL1.frame.origin.x, CGRectGetHeight(tittleL1.frame))];
        phoneNumberText.clearButtonMode = UITextFieldViewModeAlways;
        [phoneNumberText setKeyboardType:UIKeyboardTypeNumberPad];
        [phoneNumberText setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:attrs]; // 初始化富文本占位字符串
        phoneNumberText.attributedPlaceholder = attStr;
        phoneNumberText.tintColor = [UIColor whiteColor];
        [self addSubview:phoneNumberText];
        
        
        UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(phoneNumberText.frame) + phoneNumberText.frame.origin.y, CGRectGetWidth(frame), 1)];
        [lineV2 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:lineV2];
        
        UILabel *tittleL2 = [[UILabel alloc] initWithFrame:CGRectMake(lineV2.frame.origin.x, CGRectGetHeight(lineV2.frame) + lineV2.frame.origin.y, ITEM_H, ITEM_H)];
        [tittleL2 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL2 setText:@"\U0000e615"];
        [tittleL2 setTextColor:[UIColor whiteColor]];
        [tittleL2 setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tittleL2];
        
        verificationText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL2.frame) + tittleL2.frame.origin.x, tittleL2.frame.origin.y, (CGRectGetWidth(frame) - CGRectGetWidth(tittleL2.frame) - tittleL2.frame.origin.x)/2, CGRectGetHeight(tittleL2.frame))];
        [verificationText setKeyboardType:UIKeyboardTypeNumberPad];
        [verificationText setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs1[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attrs1]; // 初始化富文本占位字符串
        verificationText.attributedPlaceholder = attStr1;
        verificationText.tintColor = [UIColor whiteColor];
        [self addSubview:verificationText];
        
        getVerificationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) -100, verificationText.frame.origin.y+10, 100, CGRectGetHeight(verificationText.frame)-20)];
        [getVerificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        getVerificationButton.layer.borderWidth= 1;
        getVerificationButton.layer.borderColor = [UIColor whiteColor].CGColor;
        getVerificationButton.layer.cornerRadius = 2;
        [getVerificationButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [getVerificationButton setBackgroundColor:[UIColor clearColor]];
        getVerificationButton.clipsToBounds= YES;
        [self.getVerificationButton addTarget:self action:@selector(getVerificationButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:getVerificationButton];
        
        UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(verificationText.frame) + verificationText.frame.origin.y, CGRectGetWidth(frame), 1)];
        [lineV3 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:lineV3];
        
        UILabel *tittleL3 = [[UILabel alloc] initWithFrame:CGRectMake(lineV3.frame.origin.x, CGRectGetHeight(lineV3.frame) + lineV3.frame.origin.y, ITEM_H, ITEM_H)];
        [tittleL3 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL3 setText:@"\U0000e626"];
        [tittleL3 setTextColor:[UIColor whiteColor]];
        [tittleL3 setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tittleL3];
        
        
        passwordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL3.frame) + tittleL3.frame.origin.x, tittleL3.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL3.frame) - tittleL3.frame.origin.x, CGRectGetHeight(tittleL3.frame))];
        passwordText.secureTextEntry = !passwordText.secureTextEntry;
        [passwordText setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs3 = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs3[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr3 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attrs3]; // 初始化富文本占位字符串
        passwordText.attributedPlaceholder = attStr3;
        passwordText.tintColor = [UIColor whiteColor];
        [self addSubview:passwordText];
        [self addTextRightView:passwordText];
        
        UIView *lineV4 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(passwordText.frame) + passwordText.frame.origin.y, CGRectGetWidth(frame), 1)];
        [lineV4 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:lineV4];
        
        UILabel *tittleL4 = [[UILabel alloc] initWithFrame:CGRectMake(lineV4.frame.origin.x, CGRectGetHeight(lineV4.frame) + lineV4.frame.origin.y, ITEM_H, ITEM_H)];
        [tittleL4 setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [tittleL4 setText:@"\U0000e626"];
        [tittleL4 setTextColor:[UIColor whiteColor]];
        [tittleL4 setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:tittleL4];
        
        
        passwordComfirm = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL4.frame) + tittleL4.frame.origin.x, tittleL4.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL4.frame) - tittleL4.frame.origin.x, CGRectGetHeight(tittleL4.frame))];
        passwordComfirm.secureTextEntry = !passwordComfirm.secureTextEntry;
        [passwordComfirm setTextColor:[UIColor whiteColor]];
        NSMutableDictionary *attrs4 = [NSMutableDictionary dictionary]; // 创建属性字典
        attrs4[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
        NSAttributedString *attStr4 = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:attrs4]; // 初始化富文本占位字符串
        passwordComfirm.attributedPlaceholder = attStr4;
        passwordComfirm.tintColor = [UIColor whiteColor];
        [self addSubview:passwordComfirm];
          [self addTextRightView:passwordComfirm];
        
        UIView *lineV5 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(passwordComfirm.frame) + passwordComfirm.frame.origin.y, CGRectGetWidth(frame), 1)];
        [lineV5 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:lineV5];
        
        
        
        confirmButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lineV5.frame) + lineV5.frame.origin.y + 20, CGRectGetWidth(frame) , ITEM_H)];
        confirmButton.layer.cornerRadius = 8;
        confirmButton.clipsToBounds= YES;
        [confirmButton setTitle:@"立即注册" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor hex:@"#D1E8F5"] size:CGSizeMake(CGRectGetWidth(frame), 50)] forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:confirmButton];
        
        
        promiseSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(confirmButton.frame.origin.x, CGRectGetHeight(confirmButton.frame) + confirmButton.frame.origin.y +10, ITEM_H-10, ITEM_H-10)];
        [promiseSelectButton addTarget:self action:@selector(promiseSelectButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        promiseSelectButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:20];
        [promiseSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         [promiseSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [promiseSelectButton setTitle:@"\U0000e6d5" forState:UIControlStateNormal];
        [promiseSelectButton setTitle:@"\U0000e6d6" forState:UIControlStateSelected];
        [self addSubview:promiseSelectButton];
        
        UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(promiseSelectButton.frame.origin.x + CGRectGetWidth(promiseSelectButton.frame) , promiseSelectButton.frame.origin.y, 110, CGRectGetHeight(promiseSelectButton.frame))];
        [infoL setText:@"我已阅读并同意"];
        [infoL setTextColor:[UIColor whiteColor]];
        [infoL setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:infoL];
        
        toPromiseButton = [[UIButton alloc] initWithFrame:CGRectMake(infoL.frame.origin.x + CGRectGetWidth(infoL.frame), infoL.frame.origin.y, 100, CGRectGetHeight(infoL.frame))];
        NSMutableAttributedString *toPromiseButtonAttrStr = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"
                                                                                                   attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:1]}];
     
        [toPromiseButton setAttributedTitle:toPromiseButtonAttrStr forState:UIControlStateNormal];
        [toPromiseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [toPromiseButton addTarget:self action:@selector(toPromiseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [toPromiseButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:toPromiseButton];
        
    }
    return self;
}

#pragma mark selfMethod
- (void)addTextRightView:(UITextField *)TextField  {
    TextField.rightViewMode = UITextFieldViewModeAlways;
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 50, 60);
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [rightButton setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    [rightButton.titleLabel sizeToFit];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (TextField == passwordText) {
        rightButton.tag =1;
    }
    else if (TextField == passwordComfirm){
         rightButton.tag =2;
    }
    [rightButton addTarget:self action:@selector(toAccordingOrHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    [TextField setRightView:rightButton];
}

- (void)toAccordingOrHidePassword:(UIButton *)btn {
    UITextField *textFeild = nil;
    if (btn.tag ==1) {
        textFeild =passwordText;
    }
    else if (btn.tag ==2){
        textFeild =passwordComfirm;
    }
    textFeild.secureTextEntry = !textFeild.secureTextEntry;
    if (textFeild.secureTextEntry) {
        [btn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"\U0000e648" forState:UIControlStateNormal];
    }
}

- (void)confirmButtonAction {
    if(self.promiseSelectButton.selected){
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASRegisterNameAndPasswordConfirmButtonAction)]) {
            [self.delegate ASRegisterNameAndPasswordConfirmButtonAction];
        }
    }
    else {
        [MBProgressHUD showError:@"未同意用户协议！" toView:self.superview];
    }
}

- (void)getVerificationButtonAction {
    //在获取验证码成功后启动计时
    if (phoneNumberText.text.length > 0) {
//        [self startTime];
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASRegisterNameAndPasswordGetVerificationButtonAction)]) {
            [self.delegate ASRegisterNameAndPasswordGetVerificationButtonAction];
        }
    } else {
        [MBProgressHUD showError:@"请先填入您的手机号！"toView:self.superview];
    }
}

- (void)promiseSelectButtonAction {
    //反选
    self.promiseSelectButton.selected = !self.promiseSelectButton.selected;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASRegisterNameAndPasswordPromiseSelectButtonAction)]) {
        [self.delegate ASRegisterNameAndPasswordPromiseSelectButtonAction];
    }
}

- (void)toPromiseButtonClicked:(id)sender{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(ASRegisterNameAndPasswordToPromiseSelectButtonAction)]) {
        [self.delegate ASRegisterNameAndPasswordToPromiseSelectButtonAction];
    }
}

-(void)startTime{
    self.getVerificationButton.userInteractionEnabled = NO;
    __block int timeout = 99; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
              
                [self.getVerificationButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.getVerificationButton.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 101;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerificationButton setTitle:[NSString stringWithFormat:@"重新获取 (%@)",strTime] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
