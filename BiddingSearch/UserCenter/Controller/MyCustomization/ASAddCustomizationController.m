//
//  ASAddCustomizationController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/4.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASAddCustomizationController.h"
#import "GetSearchConditionOperation.h"
#import "SearchConditionView.h"
#import "AddCustomizationOperation.h"

#define HEAD_H 50

@interface ASAddCustomizationController ()<ASBaseModelDelegate,UITextFieldDelegate>
@property (nonatomic, strong) SearchConditionView *conditionView;
@property (nonatomic, strong) UIView *headView;//s输入定制名称
@property (nonatomic, strong) UITextField *nameTextFeild;
//获取搜索条件选项接口
@property (nonatomic, strong) GetSearchConditionOperation *getSearchConditionOperation;
@property (nonatomic, strong) AddCustomizationOperation *addCustomizationOperation;

@end

@implementation ASAddCustomizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.headView];
    [self.view addSubview:self.conditionView];
    [self.getSearchConditionOperation requestStart];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.currentNavigationController setTitleText:@"添加定制" viewController:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.getSearchConditionOperation.delegate=nil;
    self.addCustomizationOperation.delegate=nil;
}

#pragma mark selfMethod
- (void)delayMethod{
    [self.currentNavigationController toBack];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.getSearchConditionOperation){
        [self.conditionView configWithSearchCondition:self.getSearchConditionOperation.searchConditionViewModel];
    } else if(request == self.addCustomizationOperation){
        [MBProgressHUD showSuccess:@"添加成功！" toView:self.view];
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark UITextFeildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark getter
- (SearchConditionView *)conditionView{
    WeakSelf(self);
    if(!_conditionView){
        _conditionView = [[SearchConditionView alloc] initWithFrame:CGRectMake(0, HEAD_H+NAVIGATION_H, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) -HEAD_H-NAVIGATION_H)];
        _conditionView.isCustomization =YES;
        _conditionView.searchHander=^(){
            if (![weakself.nameTextFeild.text isBlankString]) {
                weakself.addCustomizationOperation.name = weakself.nameTextFeild.text;
                weakself.addCustomizationOperation.params = [weakself.conditionView getSelectedItem];
                [weakself.addCustomizationOperation requestStart];
            }
            else {
                [MBProgressHUD showError:@"请填写定制名称" toView:weakself.view];
            }
           
        };
    }
    return _conditionView;
}

- (UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, HEAD_H)];
        [_headView setBackgroundColor:[UIColor whiteColor]];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, HEAD_H)];
        [titleL setText:@"定制方案名称："];
        _nameTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame), 10, AS_SCREEN_WIDTH-CGRectGetWidth(titleL.frame)-20, HEAD_H-20)];
        _nameTextFeild.layer.borderWidth = 0.5;
        _nameTextFeild.layer.cornerRadius = (HEAD_H-20)/2;
        _nameTextFeild.layer.borderColor = [UIColor lightGrayColor].CGColor;
        UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(20,0,15,(HEAD_H-20))];
        leftView.backgroundColor = [UIColor clearColor];
        _nameTextFeild.leftView = leftView;
        _nameTextFeild.leftViewMode = UITextFieldViewModeAlways;
        _nameTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _nameTextFeild.placeholder= @"请输入定制名称";
        _nameTextFeild.delegate = self;
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, HEAD_H-1, AS_SCREEN_WIDTH, 1)];
        [lineV setBackgroundColor:ASLINE_VIEW_COLOR];
        
        [_headView addSubview:titleL];
        [_headView addSubview:_nameTextFeild];
        [_headView addSubview:lineV];
    }
    return _headView;
}

- (GetSearchConditionOperation *)getSearchConditionOperation{
    if(!_getSearchConditionOperation){
        _getSearchConditionOperation = [[GetSearchConditionOperation alloc] init];
    }
    _getSearchConditionOperation.delegate = self;
    return _getSearchConditionOperation;
}

- (AddCustomizationOperation *)addCustomizationOperation{
    if(!_addCustomizationOperation){
        _addCustomizationOperation = [[AddCustomizationOperation alloc] init];
    }
     _addCustomizationOperation.delegate = self;
    return _addCustomizationOperation;
}



@end
