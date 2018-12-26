//
//  ASLoginViewController.m
//  SheQuBao
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASLoginViewController.h"
#import "ASNavigationController.h"
#import "ASRegisterDetailViewController.h"
#import "ASLoginNameAndPassWordView.h"

#import "ASForgetPasswordViewController.h"

#define USERNAMETEXT_TAG (50)
#define PASSWORDTEXT_TAG (51)

#define UP_H 330

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

@interface ASLoginViewController ()<ASLoginNameAndPassWordDelegate, UITextFieldDelegate, ASUserInfoModelDelegate>

@property (nonatomic, strong) ASLoginNameAndPassWordView * loginNameAndPassWordView;
@property (nonatomic, strong) UIView *logoView;
@end

@implementation ASLoginViewController

#pragma mark - LifeCycle
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    ASUSER_INFO_MODEL.delegate = nil;
    [super viewWillDisappear:YES];
}

- (void)setupContentView{
   CAGradientLayer *Layer = [ASCommonFunction setGradualChangingColor:self.view fromColor:[UIColor hex:@"#4D00FD"] toColor:[UIColor hex:@"#1C92FF"]];
    [self.view.layer insertSublayer:Layer atIndex:0];
    [self addHeadView];
    [self.view addSubview:self.logoView];
    [self.view addSubview:self.loginNameAndPassWordView];
   
}

#pragma mark - ASLoginNameAndPassWordDelegate
//登录操作按钮
- (void)ASLoginNameAndPassWordViewconfirmButtonAction:(UIButton *)sender {
    switch (sender.tag) {
        case ASLOG_TYPE_PASSWORD:
            //textField.text改变的时候，代理回调
            if(![ASCommonFunction isValidateMobile:self.loginNameAndPassWordView.userNameText.text])
            {
                [MBProgressHUD showError:@"请输入正确的手机号码！"toView:self.view];
                
            } else if(self.loginNameAndPassWordView.passwordText.text.length > 0 && self.loginNameAndPassWordView.passwordText.text.length > 16)
            {
                 [MBProgressHUD showError:@"请输入6-16位密码！"toView:self.view ];
            }
            
            [self.view endEditing:YES];
            ASUSER_INFO_MODEL.delegate = self;
            [ASUSER_INFO_MODEL logInActionWithUserName:self.loginNameAndPassWordView.userNameText.text passWord:self.loginNameAndPassWordView.passwordText.text.md5WithString];
         
            break;
        case ASLOG_TYPE_WEICHAT:
        {
         
        }
            break;
        case ASLOG_TYPE_QQ:
        {
          
        }
            break;
        default:
            break;
    }
}

- (void)ASLoginBottomViewForgetButtonAction {
    [self.view endEditing:YES];
    //进入找回密码界面
    ASForgetPasswordViewController * viewController = [[ASForgetPasswordViewController alloc] init];
    [self.currentNavigationController toNext:viewController];
}

#pragma mark - Navigations
- (void)toBack{
    [super toBack];
}

- (void)toRegisterViewController {
    [self.view endEditing:YES];
    ASRegisterDetailViewController * viewController = [[ASRegisterDetailViewController alloc] init];
    [self toNextWithViewController:viewController];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //textField结束编辑
    //textField.text改变的时候，代理回调
    if(textField.tag == USERNAMETEXT_TAG) {
        
        if(![ASCommonFunction isValidateMobile:textField.text])
        {
            [MBProgressHUD showError:@"请输入正确的手机号"toView:self.view];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.loginNameAndPassWordView.userNameText == textField) {
        self.loginNameAndPassWordView.userNameText.text = textField.text;
    } else if(self.loginNameAndPassWordView.passwordText == textField){
        self.loginNameAndPassWordView.passwordText.text = textField.text;
    }
    //textField.text改变的时候，代理回调
    NSString * newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == USERNAMETEXT_TAG) {
        if(newText.length > 0 && (newText.length > 11 || ![newText hasPrefix:@"1"]))
        {
            [MBProgressHUD showError:@"请输入正确的手机号"toView:self.view];
            return NO;
        }
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //点击go按钮的时候
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark ASUserInfoModelDelegate
- (void)userLoginSuccess:(id)successData{
    DMLog(@"登录成功successData = %@",successData);
    [MBProgressHUD showSuccess:@"登录成功"toView:self.view];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
}

- (void)userloginfailed:(id)failedData{
    if ([failedData isKindOfClass:[NSString class]]) {
         [MBProgressHUD showError:failedData toView:self.view];
    }
}

#pragma mark getter
- (ASLoginNameAndPassWordView *)loginNameAndPassWordView {
    if (_loginNameAndPassWordView == nil) {
        ASLoginNameAndPassWordView *loginNameAndPassWordView = [[ASLoginNameAndPassWordView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.logoView.frame), AS_SCREEN_WIDTH-80, UP_H)];
        loginNameAndPassWordView.delegate = self;
        _loginNameAndPassWordView = loginNameAndPassWordView;
        _loginNameAndPassWordView.userNameText.delegate = self;
        _loginNameAndPassWordView.userNameText.tag = USERNAMETEXT_TAG;
        _loginNameAndPassWordView.passwordText.delegate = self;
        _loginNameAndPassWordView.passwordText.tag = PASSWORDTEXT_TAG;
    }
    return _loginNameAndPassWordView;
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
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(AS_SCREEN_WIDTH-100, iPhoneX ? 42 : 22, 60, 34);
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.layer.borderWidth=1;
    registBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registBtn.layer.cornerRadius = 4;
    [registBtn addTarget:self action:@selector(toRegisterViewController) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:registBtn];
}

- (UIView *)logoView{
    if (!_logoView) {
        _logoView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT-NAVIGATION_H-UP_H)];
        [_logoView setBackgroundColor:[UIColor clearColor]];
        UILabel *logoL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_logoView.frame), CGRectGetHeight(_logoView.frame))];
        [logoL setBackgroundColor:[UIColor clearColor]];
        [logoL setTextColor:[UIColor whiteColor]];
        [logoL setTextAlignment:NSTextAlignmentCenter];
        [logoL setFont:[UIFont systemFontOfSize:20]];
        [logoL setText:@"欢迎登录招投标大数据系统"];
        [_logoView addSubview:logoL];
    }
    return _logoView;
}

#pragma mark - ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data {
    
}

- (void)request:(id)request failedWithError:(id)error {
    
}

#pragma mark selfMethod
//验证密码
- (BOOL)validatePassword:(NSString *)password {
    // 特殊字符包含`、-、=、\、[、]、;、'、,、.、/、~、!、@、#、$、%、^、&、*、(、)、_、+、|、?、>、<、"、:、{、}
    // 必须包含数字和字母，可以包含上述特殊字符。
    // 依次为（如果包含特殊字符）
    // 数字 字母 特殊
    // 字母 数字 特殊
    // 数字 特殊 字母
    // 字母 特殊 数字
    // 特殊 数字 字母
    // 特殊 字母 数字
    NSString *passWordRegex = @"(\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+\\d+)";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

- (void)delayMethod{
    [self.currentNavigationController toBack];
}



@end
