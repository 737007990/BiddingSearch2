//
//  ASRestPasswordViewController.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/3.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASForgetPasswordViewController.h"
#import "ASNavigationController.h"
#import "ASForgetPassWordModel.h"
#import "ASMessageConfirmModel.h"
#import "ASCheckPhoneNModel.h"

#define ITEM_H 50
#define LOGO_H 100

@interface ASForgetPasswordViewController ()<ASBaseModelDelegate>
@property (nonatomic, strong) ASForgetPassWordModel *forgetPassWordModel;
@property (nonatomic, strong) ASCheckPhoneNModel *checkPhoneNModel;
@property (nonatomic, strong) ASMessageConfirmModel *messageConfirmModel;
@property (nonatomic, strong) UIView *logoView;

@end

@implementation ASForgetPasswordViewController
@synthesize theConfirmNewPasswordText;
@synthesize theNewPassWordText;
@synthesize phoneNumberText;
@synthesize confirmButton;
@synthesize verificationText;
@synthesize getVerificationButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated{
     self.forgetPassWordModel.delegate = nil;
     self.messageConfirmModel.delegate = nil;
    [super viewWillDisappear:YES];
}

- (void)setupContentView{
    CAGradientLayer *Layer = [ASCommonFunction setGradualChangingColor:self.view fromColor:[UIColor hex:@"#4D00FD"] toColor:[UIColor hex:@"#1C92FF"]];
    [self.view.layer insertSublayer:Layer atIndex:0];
    [self addHeadView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:[self getContentViewWith:CGRectMake(40, CGRectGetMaxY(self.logoView.frame), AS_SCREEN_WIDTH-80,AS_SCREEN_HEIGHT-CGRectGetMaxY(self.logoView.frame))]];
}

#pragma mark getter
- (UIView *)getContentViewWith:(CGRect)frame{
    UIView *contentV = [[UIView alloc] initWithFrame:frame];
    UILabel *tittleL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ITEM_H, ITEM_H)];
    [tittleL1 setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [tittleL1 setText:@"\U0000e60d"];
    [tittleL1 setTextColor:[UIColor whiteColor]];
    [tittleL1 setTextAlignment:NSTextAlignmentCenter];
    [contentV addSubview:tittleL1];
    
    phoneNumberText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL1.frame) + tittleL1.frame.origin.x, tittleL1.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL1.frame) - tittleL1.frame.origin.x, CGRectGetHeight(tittleL1.frame))];
    phoneNumberText.clearButtonMode = UITextFieldViewModeAlways;
    [phoneNumberText setKeyboardType:UIKeyboardTypeNumberPad];
    [phoneNumberText setTextColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:attrs]; // 初始化富文本占位字符串
    phoneNumberText.attributedPlaceholder = attStr;
    phoneNumberText.tintColor = [UIColor whiteColor];
    [contentV addSubview:phoneNumberText];
    
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(phoneNumberText.frame) + phoneNumberText.frame.origin.y, CGRectGetWidth(frame), 1)];
    [lineV2 setBackgroundColor:[UIColor whiteColor]];
    [contentV addSubview:lineV2];
    
    UILabel *tittleL2 = [[UILabel alloc] initWithFrame:CGRectMake(lineV2.frame.origin.x, CGRectGetHeight(lineV2.frame) + lineV2.frame.origin.y, ITEM_H, ITEM_H)];
    [tittleL2 setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [tittleL2 setText:@"\U0000e615"];
    [tittleL2 setTextColor:[UIColor whiteColor]];
    [tittleL2 setTextAlignment:NSTextAlignmentCenter];
    
    [contentV addSubview:tittleL2];
    
    verificationText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL2.frame) + tittleL2.frame.origin.x, tittleL2.frame.origin.y, (CGRectGetWidth(frame) - CGRectGetWidth(tittleL2.frame) - tittleL2.frame.origin.x)/2, CGRectGetHeight(tittleL2.frame))];
    [verificationText setKeyboardType:UIKeyboardTypeNumberPad];
    [verificationText setTextColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs1[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
    NSAttributedString *attStr1 = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attrs1]; // 初始化富文本占位字符串
    verificationText.attributedPlaceholder = attStr1;
    verificationText.tintColor = [UIColor whiteColor];
    [contentV addSubview:verificationText];
    
    getVerificationButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) -100, verificationText.frame.origin.y+10, 100, CGRectGetHeight(verificationText.frame)-20)];
    [getVerificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    getVerificationButton.layer.borderWidth= 1;
    getVerificationButton.layer.borderColor = [UIColor whiteColor].CGColor;
    getVerificationButton.layer.cornerRadius = 2;
    [getVerificationButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [getVerificationButton setBackgroundColor:[UIColor clearColor]];
    getVerificationButton.clipsToBounds= YES;
    [self.getVerificationButton addTarget:self action:@selector(getVcode:) forControlEvents:UIControlEventTouchUpInside];
    [contentV addSubview:getVerificationButton];
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(verificationText.frame) + verificationText.frame.origin.y, CGRectGetWidth(frame), 1)];
    [lineV3 setBackgroundColor:[UIColor whiteColor]];
    [contentV addSubview:lineV3];
    
    UILabel *tittleL3 = [[UILabel alloc] initWithFrame:CGRectMake(lineV3.frame.origin.x, CGRectGetHeight(lineV3.frame) + lineV3.frame.origin.y, ITEM_H, ITEM_H)];
    [tittleL3 setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [tittleL3 setText:@"\U0000e626"];
    [tittleL3 setTextColor:[UIColor whiteColor]];
    [tittleL3 setTextAlignment:NSTextAlignmentCenter];
    [contentV addSubview:tittleL3];
    
    theNewPassWordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL3.frame) + tittleL3.frame.origin.x, tittleL3.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL3.frame) - tittleL3.frame.origin.x, CGRectGetHeight(tittleL3.frame))];
    theNewPassWordText.secureTextEntry = !theNewPassWordText.secureTextEntry;
    [theNewPassWordText setTextColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs3 = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs3[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
    NSAttributedString *attStr3 = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:attrs3]; // 初始化富文本占位字符串
    theNewPassWordText.attributedPlaceholder = attStr3;
    theNewPassWordText.tintColor = [UIColor whiteColor];
    [contentV addSubview:theNewPassWordText];
    [self addTextRightView:theNewPassWordText];
    
    UIView *lineV4 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(theNewPassWordText.frame) + theNewPassWordText.frame.origin.y, CGRectGetWidth(frame), 1)];
    [lineV4 setBackgroundColor:[UIColor whiteColor]];
    [contentV addSubview:lineV4];
    
    UILabel *tittleL4 = [[UILabel alloc] initWithFrame:CGRectMake(lineV4.frame.origin.x, CGRectGetHeight(lineV4.frame) + lineV4.frame.origin.y, ITEM_H, ITEM_H)];
    [tittleL4 setFont:[UIFont fontWithName:@"iconfont" size:24]];
    [tittleL4 setText:@"\U0000e626"];
    [tittleL4 setTextColor:[UIColor whiteColor]];
    [tittleL4 setTextAlignment:NSTextAlignmentCenter];
    [contentV addSubview:tittleL4];
    
    theConfirmNewPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(tittleL4.frame) + tittleL4.frame.origin.x, tittleL4.frame.origin.y, CGRectGetWidth(frame) - CGRectGetWidth(tittleL4.frame) - tittleL4.frame.origin.x, CGRectGetHeight(tittleL4.frame))];
    theConfirmNewPasswordText.secureTextEntry = !theConfirmNewPasswordText.secureTextEntry;
    [theConfirmNewPasswordText setTextColor:[UIColor whiteColor]];
    NSMutableDictionary *attrs4 = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs4[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1 alpha:0.5]; // 设置颜色
    NSAttributedString *attStr4 = [[NSAttributedString alloc] initWithString:@"请再次输入密码" attributes:attrs4]; // 初始化富文本占位字符串
    theConfirmNewPasswordText.attributedPlaceholder = attStr4;
    theConfirmNewPasswordText.tintColor = [UIColor whiteColor];
    [contentV addSubview:theConfirmNewPasswordText];
    [self addTextRightView:theConfirmNewPasswordText];
    
    UIView *lineV5 = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetHeight(theConfirmNewPasswordText.frame) + theConfirmNewPasswordText.frame.origin.y, CGRectGetWidth(frame), 1)];
    [lineV5 setBackgroundColor:[UIColor whiteColor]];
    [contentV addSubview:lineV5];
    
    confirmButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(lineV5.frame) + lineV5.frame.origin.y + 20, CGRectGetWidth(frame) , ITEM_H)];
    confirmButton.layer.cornerRadius = 8;
    confirmButton.clipsToBounds= YES;
    [confirmButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor hex:@"#D1E8F5"] size:CGSizeMake(CGRectGetWidth(frame), 50)] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [contentV addSubview:confirmButton];
    return contentV;
}

- (UIView *)logoView{
    if (!_logoView) {
        _logoView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, LOGO_H)];
        [_logoView setBackgroundColor:[UIColor clearColor]];
        UILabel *logoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_logoView.frame), CGRectGetHeight(_logoView.frame))];
        [logoL setBackgroundColor:[UIColor clearColor]];
        [logoL setTextColor:[UIColor whiteColor]];
        [logoL setTextAlignment:NSTextAlignmentCenter];
        [logoL setFont:[UIFont systemFontOfSize:20]];
        [logoL setText:@"找回密码"];
        [_logoView addSubview:logoL];
    }
    return _logoView;
}

- (void)addHeadView {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
    headView.backgroundColor = [UIColor clearColor];
    headView.userInteractionEnabled=YES;
    [self.view addSubview:headView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"icon_return_press"] forState:UIControlStateHighlighted];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [backBtn setFrame:CGRectMake(0, iPhoneX ? 38 : 18, 44, 44)];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
}

- (ASMessageConfirmModel *)messageConfirmModel{
    if(!_messageConfirmModel){
        _messageConfirmModel = [[ASMessageConfirmModel alloc] init];
    }
     _messageConfirmModel.delegate = self;
    return _messageConfirmModel;
}

- (ASForgetPassWordModel*)forgetPassWordModel{
    if (!_forgetPassWordModel) {
        _forgetPassWordModel = [[ASForgetPassWordModel alloc] init];
    }
      _forgetPassWordModel.delegate = self;
    return _forgetPassWordModel;
}

- (ASCheckPhoneNModel *)checkPhoneNModel{
    if(!_checkPhoneNModel){
        _checkPhoneNModel = [[ASCheckPhoneNModel alloc] init];
    }
     _checkPhoneNModel.delegate = self;
    return _checkPhoneNModel;
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
    if (TextField == theNewPassWordText) {
        rightButton.tag =1;
    }
    else if (TextField == theConfirmNewPasswordText){
        rightButton.tag =2;
    }
    [rightButton addTarget:self action:@selector(toAccordingOrHidePassword:) forControlEvents:UIControlEventTouchUpInside];
    [TextField setRightView:rightButton];
}

- (void)toAccordingOrHidePassword:(UIButton *)btn {
    UITextField *textFeild = nil;
    if (btn.tag ==1) {
        textFeild =theNewPassWordText;
    }
    else if (btn.tag ==2){
        textFeild =theConfirmNewPasswordText;
    }
    textFeild.secureTextEntry = !textFeild.secureTextEntry;
    if (textFeild.secureTextEntry) {
        [btn setTitle:@"\U0000e61e" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"\U0000e648" forState:UIControlStateNormal];
    }
}

- (void)confirmButtonAction {
    if (self.phoneNumberText.text.length >0&self.theNewPassWordText.text.length>0&self.verificationText.text.length >0&[self.theConfirmNewPasswordText.text isEqualToString:self.theNewPassWordText.text] ) {
        self.forgetPassWordModel.telephone = self.phoneNumberText.text;
        self.forgetPassWordModel.password = self.theNewPassWordText.text.md5WithString;
        self.forgetPassWordModel.code = self.verificationText.text;
        [self.forgetPassWordModel requestStart];
    }
    else {
        if(![self.theNewPassWordText.text isEqualToString:self.theConfirmNewPasswordText.text]){
            [MBProgressHUD showError:@"密码不一致！"toView:self.view];
        }else{
            [MBProgressHUD showError:@"请填写完整信息"toView:self.view];
        }
    }
}

- (void)getVcode:(id)sender{
    if ([ASCommonFunction isValidateMobile:phoneNumberText.text])  {
        self.checkPhoneNModel.telephone = phoneNumberText.text;
        [self.checkPhoneNModel requestStart];
    }
    else {
        [MBProgressHUD showError:@"请输入正确的手机号"toView:self.view];
    }
}

- (void)delayMethod{
    [self.currentNavigationController toBack];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.checkPhoneNModel) {
        if(self.checkPhoneNModel.is_register){
            self.messageConfirmModel.telephone = phoneNumberText.text;
            [self.messageConfirmModel requestStart];
            [self startTime];
        }
        else{
            [MBProgressHUD showError:@"该用户未注册！"toView:self.view];
        }
    }
    else if(request == self.forgetPassWordModel) {
        //获取用户信息后存入本地数据库
        [ASUSER_INFO_MODEL setUserInfoWithUserDic:data];
        [MBProgressHUD showSuccess:@"修改成功！" toView:self.view];
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
  
}

- (void)request:(id)request failedWithError:(id)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startTime{
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
                self.verificationText.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout % 101;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getVerificationButton setTitle:[NSString stringWithFormat:@"重新获取 (%@)",strTime] forState:UIControlStateNormal];
                self.getVerificationButton.userInteractionEnabled = NO;
                self.verificationText.userInteractionEnabled = YES;
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
