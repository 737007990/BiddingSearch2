//
//  MyOrderSuccessController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyOrderSuccessController.h"
#import "MyInvoiceInfoController.h"
#define BTN_H 80

#define CONTENT_H 250
@interface MyOrderSuccessController ()
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UILabel *infoL;
@property (nonatomic, assign) BOOL pushOn;

@end

@implementation MyOrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.currentNavigationController setTitleText:@"充值成功" viewController:self];
}

- (void)setupContentView{
    [self.view addSubview:self.contentV];
    [self.view addSubview:self.confirmBtn];
}

#pragma mark selfMethod
- (void)confirmBtnClicked{
    MyInvoiceInfoController *vc =[[MyInvoiceInfoController alloc]init];
    vc.orderId = self.orderId;
    [self toNextWithViewController:vc];
}

#pragma mark getter
- (UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.contentV.frame)+40, AS_SCREEN_WIDTH-40, 50)];
        [_confirmBtn setBackgroundColor:AS_MAIN_COLOR];
        [_confirmBtn setTitle:@"申请开票" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked)];
    }
    return _confirmBtn;
}

- (UIView *)contentV{
    if(!_contentV){
        _contentV = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, CONTENT_H)];
      
        UIImageView *successImgV = [[UIImageView alloc] initWithFrame:CGRectMake(AS_SCREEN_WIDTH/2-40, 40, 80, 80)];
        [successImgV setImage:[UIImage imageNamed:@"success"]];
        [_contentV addSubview:successImgV];
        
        UILabel *tittleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImgV.frame)+10, AS_SCREEN_WIDTH, 40)];
        [tittleL setTextAlignment:NSTextAlignmentCenter];
        [tittleL setFont:[UIFont systemFontOfSize:20]];
        [tittleL setText:@"恭喜您！充值成功！"];
        [_contentV addSubview:tittleL];
        
//        _infoL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tittleL.frame)+10, AS_SCREEN_WIDTH, 40)];
//        [_infoL setTextAlignment:NSTextAlignmentCenter];
//        [_infoL setTextColor:[UIColor grayColor]];
//        [_infoL setFont:[UIFont systemFontOfSize:17]];
//        [_infoL setText:[NSString stringWithFormat:@"您已成功充值%@元",self.invoiceInfo]];
//        [_contentV addSubview:_infoL];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, CONTENT_H - 1, AS_SCREEN_WIDTH - 20, 1)];
        lineV.backgroundColor = ASLINE_VIEW_COLOR;
        [_contentV addSubview:lineV];
    }
    return _contentV;
}

@end
