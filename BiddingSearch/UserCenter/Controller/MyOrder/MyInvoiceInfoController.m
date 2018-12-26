//
//  MyInvoiceInfoController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//
#define ITEM_H 50
#import "MyInvoiceInfoController.h"
#import "MyOrderDetailOperation.h"
#import "MyInvoiceAddOperation.h"

@interface MyInvoiceInfoController ()<UITextFieldDelegate,ASBaseModelDelegate>
//发票信息相关
@property (nonatomic,strong) UILabel *invoiceInfoL;
@property (nonatomic, strong) UIView *invoiceInfoV;
//收货地址相关
@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIView *addressV;
@property (nonatomic, strong) UIView *addressBacV;
//当前发票类型
@property (nonatomic, strong) NSString *invoiceType;
//发票类型list
@property (nonatomic, strong) NSMutableArray *invoiceTypeBtnAry;
//各种填写的发票信息
@property (nonatomic, strong) UITextField *invoiceTitleTf;
@property (nonatomic, strong) UITextField *taxCodeTf;
@property (nonatomic, strong) UITextField *addressTf;
//发票内容
@property (nonatomic, strong) UITextField *invoiceContent;
//发票金额
@property (nonatomic, strong) UITextField *invoicePrice;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) MyOrderDetailOperation *myOrderDetailOperation;
@property (nonatomic, strong) MyInvoiceAddOperation *myInvoiceAddOperation;

@end

@implementation MyInvoiceInfoController
- (void)confirmBtnClicked{
    BOOL invoiceYes = YES;
    if(!self.invoiceTitleTf.text.isBlankString&&!self.addressTf.text.isBlankString){
        self.myInvoiceAddOperation.rechargeId = self.orderId;
          self.myInvoiceAddOperation.type = self.invoiceType;
        //用户填写
          self.myInvoiceAddOperation.invoiceTitle = self.invoiceTitleTf.text;
          self.myInvoiceAddOperation.address = self.addressTf.text;
        //系统已知
        self.myInvoiceAddOperation.content = self.invoiceContent.text;
        self.myInvoiceAddOperation.amount = self.invoicePrice.text;
        
        if([self.invoiceType isEqualToString:@"1"]){
            if(!self.taxCodeTf.text.isBlankString){
                //用户填写
                self.myInvoiceAddOperation.taxNumber = self.taxCodeTf.text;
            }
            else{
                invoiceYes = NO;
                [MBProgressHUD showError:@"增值税发票请填写税号！" toView:self.view];
            }
        }
    }else{
        invoiceYes = NO;
         [MBProgressHUD showError:@"请填写发票抬头和邮寄地址！" toView:self.view];
    }
    if(invoiceYes){
        [self.myInvoiceAddOperation requestStart];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupContentView{
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.currentNavigationController setTitleText:@"开具发票" viewController:self];
    self.myOrderDetailOperation.orderId = self.orderId;
    [self.myOrderDetailOperation requestStart];
}

#pragma mark UITextFeildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark selfmethod
-(void)invoiceTypeBtnClicked:(UIButton *)btn{
    for (UIButton *b in self.invoiceTypeBtnAry) {
        if(b.tag == btn.tag){
             [b setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        }
        else{
             [b setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
        }
    }
    self.invoiceType = [NSString stringWithFormat:@"%ld",(long)btn.tag];
}


#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myOrderDetailOperation){
        [self.view addSubview:self.invoiceInfoL];
        [self.view addSubview:self.invoiceInfoV];
        [self.view addSubview:self.addressBacV];
    }
    else if (request == self.myInvoiceAddOperation){
        [MBProgressHUD showError:@"发票申请成功！" toView:self.view];
    }
}

- (void)request:(id)request failedWithError:(id)error{
   
}

#pragma mark getter
- (UILabel *)invoiceInfoL{
    if(!_invoiceInfoL){
        _invoiceInfoL = [[UILabel alloc] initWithFrame:CGRectMake(20, NAVIGATION_H, AS_SCREEN_WIDTH-40, ITEM_H)];
        [_invoiceInfoL setText:@"发票详情"];
        [_invoiceInfoL setTextColor:[UIColor grayColor]];
    }
    return _invoiceInfoL;
}

- (UIView *)invoiceInfoV{
    if(!_invoiceInfoV){
        _invoiceInfoV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.invoiceInfoL.frame), AS_SCREEN_WIDTH, 5*ITEM_H)];
        [_invoiceInfoV setBackgroundColor:[UIColor whiteColor]];
        
        NSInteger total = 5;
        for (int n =0; n<total; n++) {
            UIView *itemBacv = [[UIView alloc] initWithFrame:CGRectMake(0, n*ITEM_H, AS_SCREEN_WIDTH, ITEM_H)];
            
            UILabel *tittleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ITEM_H*2, ITEM_H)];
            [tittleL setFont:[UIFont systemFontOfSize:15]];
            [tittleL setTextAlignment:NSTextAlignmentCenter];
            [itemBacv addSubview:tittleL];
            UITextField *contentTf =nil;
            if(n==0){
                NSInteger btnTotal =2;
                for (int m =0; m<btnTotal; m++) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tittleL.frame)+m*(AS_SCREEN_WIDTH - CGRectGetWidth(tittleL.frame) -20)/2, 0, (AS_SCREEN_WIDTH - CGRectGetWidth(tittleL.frame) -20)/2, ITEM_H)];
                     [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                     [btn layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleLeft imageTitleSpace:10];
                    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
                    if(m==0){
                        [btn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                        [btn setTitle:@"增值税发票" forState:UIControlStateNormal];
                    }else{
                          [btn setImage:[UIImage imageNamed:@"unselected"] forState:UIControlStateNormal];
                        [btn setTitle:@"普通发票" forState:UIControlStateNormal];
                    }
                    [btn addTarget:self tag:m+1 action:@selector(invoiceTypeBtnClicked:)];
                    [self.invoiceTypeBtnAry addObject:btn];
                    [itemBacv addSubview:btn];
                }
            }
            else {
             contentTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tittleL.frame) , 0, AS_SCREEN_WIDTH - CGRectGetWidth(tittleL.frame) -20, CGRectGetHeight(tittleL.frame))];
//                contentTf.clearButtonMode = UITextFieldViewModeAlways;
                [contentTf setFont:[UIFont systemFontOfSize:15]];
                contentTf.userInteractionEnabled =YES;
                contentTf.delegate = self;
                [itemBacv addSubview:contentTf];
            }

            UIView *lineV2 = [[UIView alloc] initWithFrame:CGRectMake(10,ITEM_H-1, AS_SCREEN_WIDTH, 1)];
            [lineV2 setBackgroundColor:ASLINE_VIEW_COLOR];
            [itemBacv addSubview:lineV2];
            
            switch (n) {
                case 0:
                    [tittleL setText:@"发票类型:"];
                    break;
                case 1:
                    [tittleL setText:@"发票抬头:"];
                    [contentTf setPlaceholder:@"请输入发票抬头"];
                    _invoiceTitleTf = contentTf;
                    break;
                case 2:
                    [tittleL setText:@"税号:"];
                    [contentTf setPlaceholder:@"请输入税号(普通发票可不填)"];
                    _taxCodeTf = contentTf;
                    break;
                case 3:
                    [tittleL setText:@"发票内容:"];
                    [contentTf setPlaceholder:@"发票内容"];
                    [contentTf setText:[self.myOrderDetailOperation.orderInfo nullToBlankStringObjectForKey:@"name"]];
                    contentTf.userInteractionEnabled =NO;
                    _invoiceContent = contentTf;
                    break;
                case 4:
                    [tittleL setText:@"发票金额:"];
                    [contentTf setPlaceholder:@"发票金额"];
                    [contentTf setText:[self.myOrderDetailOperation.orderInfo nullToBlankStringObjectForKey:@"money"]];
                    contentTf.userInteractionEnabled =NO;
                     _invoicePrice = contentTf;
                    break;
                    
                default:
                    break;
            }
            [_invoiceInfoV addSubview:itemBacv];
        }
    }
    return _invoiceInfoV;
}


- (NSString *)invoiceType{
    if(!_invoiceType){
        _invoiceType = [NSString stringWithFormat:@"1"];
    }
    return _invoiceType;
}
- (NSMutableArray *)invoiceTypeBtnAry{
    if(!_invoiceTypeBtnAry){
        _invoiceTypeBtnAry = [NSMutableArray array];
    }
    return _invoiceTypeBtnAry;
}

- (UIView *)addressBacV{
    if(!_addressBacV){
        _addressBacV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.invoiceInfoV.frame), AS_SCREEN_WIDTH,  170)];
        _addressL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, AS_SCREEN_WIDTH-40, ITEM_H)];
        [_addressL setText:@"接收方式"];
        [_addressL setTextColor:[UIColor grayColor]];
        [_addressBacV addSubview:_addressL];
        
        UIView *itemBacv = [[UIView alloc] initWithFrame:CGRectMake(0, ITEM_H, AS_SCREEN_WIDTH, ITEM_H)];
        [itemBacv setBackgroundColor:[UIColor whiteColor]];
        UILabel *tittleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, ITEM_H*2, ITEM_H)];
        [tittleL setFont:[UIFont systemFontOfSize:15]];
        [tittleL setTextAlignment:NSTextAlignmentCenter];
        [tittleL setText:@"接收地址:"];
        [itemBacv addSubview:tittleL];
        
        _addressTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tittleL.frame) , 0, AS_SCREEN_WIDTH - CGRectGetWidth(tittleL.frame) -20, CGRectGetHeight(tittleL.frame))];
        _addressTf.clearButtonMode = UITextFieldViewModeAlways;
        [_addressTf setFont:[UIFont systemFontOfSize:15]];
        _addressTf.userInteractionEnabled =YES;
          _addressTf.delegate = self;
        [_addressTf setPlaceholder:@"详细地址"];
        [itemBacv addSubview:_addressTf];
        [_addressBacV addSubview:itemBacv];
        
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(itemBacv.frame)+20, AS_SCREEN_WIDTH-40, 50)];
        [_confirmBtn setBackgroundColor:AS_MAIN_COLOR];
        [_confirmBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked)];
        
        [_addressBacV addSubview:_confirmBtn];
    }
    return _addressBacV;
}

- (MyOrderDetailOperation *)myOrderDetailOperation{
    if (!_myOrderDetailOperation) {
        _myOrderDetailOperation = [[MyOrderDetailOperation alloc] init];
    }
    _myOrderDetailOperation.delegate = self;
    return _myOrderDetailOperation;
}

- (MyInvoiceAddOperation *)myInvoiceAddOperation{
    if (!_myInvoiceAddOperation) {
        _myInvoiceAddOperation = [[MyInvoiceAddOperation alloc] init];
    }
    _myInvoiceAddOperation.delegate = self;
    return _myInvoiceAddOperation;
}

@end
