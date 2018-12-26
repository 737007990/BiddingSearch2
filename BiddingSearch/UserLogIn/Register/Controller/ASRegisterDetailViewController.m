//
//  ASRegisterDetailViewController.m
//  SheQuEJia
//
//  Created by 航天信息 on 16/1/25.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASRegisterDetailViewController.h"
#import "ASRegisterNameAndPassword.h"
#import "ASRegisterModel.h"
#import "ASMessageConfirmModel.h"
#import "ASCheckPhoneNModel.h"
#import "ASRegisterPromiseDetailViewController.h"

#define LOGO_H 100


@interface ASRegisterDetailViewController ()<ASRegisterNameAndPasswordDelegate, ASBaseModelDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    
}

@property (nonatomic, strong) ASRegisterModel *registerModel;
@property (nonatomic, strong) ASRegisterNameAndPassword *nameAndPassword;
@property (nonatomic, strong) ASMessageConfirmModel *messageConfirmModel;
@property (nonatomic, strong) ASCheckPhoneNModel *checkPhoneNModel;

@property (nonatomic, strong) UIView *logoView;

@end

@implementation ASRegisterDetailViewController
@synthesize nameAndPassword;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    self.registerModel.delegate = nil;
    self.messageConfirmModel.delegate = nil;
    self.checkPhoneNModel.delegate = nil;
    [super viewWillDisappear:YES];
}

- (void)setupContentView{
    [self.currentNavigationController setTitleText:@"注册" viewController:self];
    CAGradientLayer *Layer = [ASCommonFunction setGradualChangingColor:self.view fromColor:[UIColor hex:@"#4D00FD"] toColor:[UIColor hex:@"#1C92FF"]];
    [self.view.layer insertSublayer:Layer atIndex:0];
    [self addHeadView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.nameAndPassword];
}


#pragma mark ASRegisterNameAndPasswordDelegate
- (void)ASRegisterNameAndPasswordConfirmButtonAction{
    if (self.nameAndPassword.phoneNumberText.text.length >0&self.nameAndPassword.passwordText.text.length>0&self.nameAndPassword.verificationText.text.length >0&[self.nameAndPassword.passwordComfirm.text isEqualToString:self.nameAndPassword.passwordText.text]) {
        self.registerModel.telephone = self.nameAndPassword.phoneNumberText.text;
        self.registerModel.password = self.nameAndPassword.passwordText.text.md5WithString;
        self.registerModel.code = self.nameAndPassword.verificationText.text;
       
        [self.registerModel requestStart];
    }
    else {
        if(![self.nameAndPassword.passwordComfirm.text isEqualToString:self.nameAndPassword.passwordText.text]){
             [MBProgressHUD showError:@"登录密码不一致！"toView:self.view];
        }else{
              [MBProgressHUD showError:@"请填写完整信息"toView:self.view];
        }
    }
}

- (void)ASRegisterNameAndPasswordGetVerificationButtonAction{
    self.checkPhoneNModel.telephone = self.nameAndPassword.phoneNumberText.text;
    [self.checkPhoneNModel requestStart];
}

- (void)ASRegisterNameAndPasswordPromiseSelectButtonAction{
    
}

- (void)ASRegisterNameAndPasswordToPromiseSelectButtonAction{
    ASRegisterPromiseDetailViewController *vc = [[ASRegisterPromiseDetailViewController alloc] init];
    vc.webURL = USER_MUST_KNOWN;
    [self toNextWithViewController:vc];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.nameAndPassword.phoneNumberText]) {
        if ([ASCommonFunction isValidateMobile:self.nameAndPassword.phoneNumberText.text]) {
            
        }
        else{
            if (textField.text.length ) {
                [MBProgressHUD showError:@"请输入正确的手机号!"toView:self.view];
            }
        }
    }
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if ([request isKindOfClass:[ASMessageConfirmModel class]]) {
        [self.nameAndPassword startTime];
        //短信验证码的返回
    }
    else if ([request isKindOfClass:[ASRegisterModel class]]){
        //注册的返回
        [ASUSER_INFO_MODEL setUserInfoWithUserDic:data];
        [MBProgressHUD showSuccess:@"注册成功"toView:self.view];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
    else if (request == self.checkPhoneNModel){
        if(!self.checkPhoneNModel.is_register){
            self.messageConfirmModel.telephone = self.nameAndPassword.phoneNumberText.text;
            [self.messageConfirmModel requestStart];
        }else{
            [MBProgressHUD showError:@"该用户已注册，请登录！"toView:self.view];
        }
        

    }
}

- (void)request:(id)request failedWithError:(id)error{
    if (request ==self.messageConfirmModel) {
        [MBProgressHUD showError:@"发送验证码失败！请检查网络或重新获取"toView:self.view];
    }
}

#pragma mark getter
- (ASRegisterNameAndPassword *)nameAndPassword{
 if (!nameAndPassword) {
    nameAndPassword = [[ASRegisterNameAndPassword alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.logoView.frame), AS_SCREEN_WIDTH-80,AS_SCREEN_HEIGHT-CGRectGetMaxY(self.logoView.frame))]; ;
    nameAndPassword.delegate = self;
    nameAndPassword.phoneNumberText.delegate = self;
  }
    return nameAndPassword;
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
        [logoL setText:@"注册新账号"];
        [_logoView addSubview:logoL];
    }
    return _logoView;
}

- (void)addHeadView {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
    //    [headView setImage:[UIImage imageNamed:@"nav_bar"]];
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
    if (!_messageConfirmModel) {
        _messageConfirmModel = [[ASMessageConfirmModel alloc] init];
    }
     _messageConfirmModel.delegate = self;
    return _messageConfirmModel;
}

- (ASRegisterModel *)registerModel{
    if (!_registerModel) {
        _registerModel = [[ASRegisterModel alloc] init];
    }
      _registerModel.delegate = self;
    return _registerModel;
}

- (ASCheckPhoneNModel *)checkPhoneNModel{
    if (!_checkPhoneNModel) {
        _checkPhoneNModel = [[ASCheckPhoneNModel alloc] init];
    }
     _checkPhoneNModel.delegate = self;
    return _checkPhoneNModel;
}

#pragma mark selfMethod
- (void)delayMethod{
    [self.currentNavigationController toRoot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
