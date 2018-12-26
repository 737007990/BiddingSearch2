//
//  ResetPassWordController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//
#define ITEM_H 50
#import "ResetPassWordController.h"
#import "ASRestPasswordModel.h"

@interface ResetPassWordController ()<ASBaseModelDelegate>

@property (nonatomic, strong) UITextField *theOldPassWordText;
@property (strong, nonatomic)  UITextField *theNewPassWordText;
@property (strong, nonatomic)  UITextField *theConfirmNewPasswordText;
@property (strong, nonatomic)  UIButton *confirmButton;
@property (nonatomic, strong) NSString *phoneN;
@property (nonatomic, strong) ASRestPasswordModel *restPasswordModel;


@end

@implementation ResetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    self.restPasswordModel.delegate = nil;
    [super viewWillDisappear:YES];
    
}

- (void)setupContentView{
    [self.currentNavigationController setTitleText:@"修改密码" viewController:self];
    
    _theOldPassWordText = [[UITextField alloc] initWithFrame:CGRectMake(30,NAVIGATION_H, AS_SCREEN_WIDTH - 60, ITEM_H)];
    _theOldPassWordText.clearButtonMode = UITextFieldViewModeAlways;
    _theOldPassWordText.secureTextEntry = !_theOldPassWordText.secureTextEntry;
    [_theOldPassWordText setFont:[UIFont systemFontOfSize:15]];
    [_theOldPassWordText setPlaceholder:@"请输入原密码"];
    [self.view addSubview:_theOldPassWordText];
    
    UIView *lineV1 = [[UIView alloc] initWithFrame:CGRectMake(_theOldPassWordText.frame.origin.x, CGRectGetHeight(_theOldPassWordText.frame) + _theOldPassWordText.frame.origin.y, CGRectGetWidth(_theOldPassWordText.frame), 1)];
    [lineV1 setBackgroundColor:ASLINE_VIEW_COLOR];
    [self.view addSubview:lineV1];
    
    _theNewPassWordText = [[UITextField alloc] initWithFrame:CGRectMake(_theOldPassWordText.frame.origin.x,CGRectGetMaxY(lineV1.frame), CGRectGetWidth(_theOldPassWordText.frame), CGRectGetHeight(_theOldPassWordText.frame))];
     _theNewPassWordText.secureTextEntry = !_theNewPassWordText.secureTextEntry;
    _theNewPassWordText.clearButtonMode = UITextFieldViewModeAlways;
    [_theNewPassWordText setFont:[UIFont systemFontOfSize:15]];
    [_theNewPassWordText setPlaceholder:@"请输入新密码"];
    [self.view addSubview:_theNewPassWordText];
    
    UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(_theNewPassWordText.frame.origin.x, CGRectGetHeight(_theNewPassWordText.frame) + _theNewPassWordText.frame.origin.y, CGRectGetWidth(_theNewPassWordText.frame), 1)];
    [lineV2 setBackgroundColor:ASLINE_VIEW_COLOR];
    [self.view addSubview:lineV2];
    
    _theConfirmNewPasswordText = [[UITextField alloc] initWithFrame:CGRectMake(_theNewPassWordText.frame.origin.x, CGRectGetMaxY(lineV2.frame), CGRectGetWidth(_theNewPassWordText.frame), CGRectGetHeight(_theNewPassWordText.frame))];
      _theConfirmNewPasswordText.secureTextEntry = !_theConfirmNewPasswordText.secureTextEntry;
     _theConfirmNewPasswordText.clearButtonMode = UITextFieldViewModeAlways;
    [_theConfirmNewPasswordText setFont:[UIFont systemFontOfSize:15]];
    [_theConfirmNewPasswordText setPlaceholder:@"确认新密码"];
    
    [self.view addSubview:_theConfirmNewPasswordText];
    
    UIView *lineV3 = [[UIView alloc] initWithFrame:CGRectMake(_theNewPassWordText.frame.origin.x,  CGRectGetHeight(_theConfirmNewPasswordText.frame) + _theConfirmNewPasswordText.frame.origin.y,  CGRectGetWidth(_theConfirmNewPasswordText.frame), 1)];
    [lineV3 setBackgroundColor:ASLINE_VIEW_COLOR];
    [self.view addSubview:lineV3];
    
    _confirmButton  = [[UIButton alloc] initWithFrame:CGRectMake(_theNewPassWordText.frame.origin.x, CGRectGetHeight(lineV3.frame) + lineV3.frame.origin.y + 20,CGRectGetWidth(_theConfirmNewPasswordText.frame), ITEM_H)];
    _confirmButton.layer.cornerRadius = ITEM_H/2;
    _confirmButton.clipsToBounds= YES;
    [_confirmButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:AS_MAIN_COLOR size:CGSizeMake(AS_SCREEN_WIDTH, 50)] forState:UIControlStateNormal];
    [self.view addSubview:_confirmButton];
}

- (void)confirmButtonAction {
    if ([_theNewPassWordText.text isEqualToString:_theConfirmNewPasswordText.text] & (_theConfirmNewPasswordText.text.length >0)) {
        self.restPasswordModel.password_new = _theConfirmNewPasswordText.text.md5WithString;
        self.restPasswordModel.password_orig = _theOldPassWordText.text.md5WithString;
        [self.restPasswordModel requestStart];
    }
    else {
        [MBProgressHUD showError:@"新密码不一致！" toView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.restPasswordModel) {
        [MBProgressHUD showSuccess:@"修改成功!" toView:self.view];
        [self performSelector:@selector(delayMethodToback) withObject:nil afterDelay:1.0f];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

- (void)delayMethodToback{
    [self.currentNavigationController popToRootViewControllerAnimated:YES];
}


#pragma mark getter

- (ASRestPasswordModel *)restPasswordModel{
    if(!_restPasswordModel){
        _restPasswordModel = [[ASRestPasswordModel alloc] init];
    }
     _restPasswordModel.delegate = self;
    return _restPasswordModel;
}

@end
