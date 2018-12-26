//
//  MyTopUpViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyTopUpViewController.h"
#import "MyOrderSuccessController.h"
#import "TopUpOperation.h"
#import "CheckPayResultOperation.h"
#define BTN_H 50

@interface MyTopUpViewController ()<ASBaseModelDelegate>
//充值金额对象列表
@property (nonatomic, strong) NSMutableArray *topUpList;
//充值方式列表
@property (nonatomic, strong) NSMutableArray *payTypeList;
//充值金额组件容器
@property (nonatomic, strong) UIView *topUpMoneyBacView;
//显示当前支付方式标题标签
@property (nonatomic, strong) UILabel *payTypeL;
//支付方式容器
@property (nonatomic, strong) UIView *payTypeBacV;
//充值金额
@property (nonatomic,strong) NSString *payMoney;
//充值方式
@property (nonatomic, strong) NSString *payType;
//显示充值金额
@property (nonatomic, strong) UILabel *payMoneyL;
//确认按钮
@property (nonatomic, strong) UIButton *confirmBtn;
//获取支付密钥调起支付
@property (nonatomic, strong) TopUpOperation *topUpOperation;
//核对充值结果接口
@property (nonatomic, strong) CheckPayResultOperation *checkPayResultOperation;


@end

@implementation MyTopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.topUpMoneyBacView];
    [self.view addSubview:self.payTypeL];
    [self.view addSubview:self.payTypeBacV];
    [self.view addSubview:self.confirmBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     [self.currentNavigationController setTitleText:@"充值缴费" viewController:self];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.topUpOperation.delegate = nil;
}

#pragma mark selfMethod
- (void)topUpBtnClicked:(UIButton *)selectedBtn{
    for (UIButton *btn in self.topUpList) {
        if (btn == selectedBtn) {
            [btn setBackgroundImage:[UIImage imageNamed:@"topUp1"] forState:UIControlStateNormal];
        }
        else {
            [btn setBackgroundImage:[UIImage imageNamed:@"topUp"] forState:UIControlStateNormal];
        }
    }
    self.payMoney = [NSString stringWithFormat:@"%d",selectedBtn.tag*100];
    
    // 设置字体颜色NSForegroundColorAttributeName，取值为 UIColor对象，默认值为黑色
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"充值金额：%@元",[ASCommonFunction separatedFloatStrWithStr:self.payMoney]]];
    [textColor addAttribute:NSForegroundColorAttributeName
                      value:[UIColor orangeColor]
                      range:[[NSString stringWithFormat:@"充值金额：%@元",[ASCommonFunction separatedFloatStrWithStr:self.payMoney]] rangeOfString:[NSString stringWithFormat:@"%@",[ASCommonFunction separatedFloatStrWithStr:self.payMoney]]]];
    [_payMoneyL setAttributedText:textColor];
    DMLog(@"充值金额：%@元",self.payMoney);
    [self confirmBtnSetTitle];
}

- (void)payTypeClicked:(UITapGestureRecognizer *)tap{
    self.payType = [NSString stringWithFormat:@"%d",tap.view.tag -1];
    DMLog(@"支付方式%@",self.payType);
    for (UIView *v in self.payTypeList) {
        if(v == tap.view){
            for (id view in v.subviews ) {
                if([view isKindOfClass:[UIImageView class]]){
                    UIImageView *imagv= view;
                    if (imagv.tag == 1) {
                        [imagv setImage:[UIImage imageNamed:@"selected_big"]];
                    }
                }
            }
        }else{
            for (id view in v.subviews ) {
                if([view isKindOfClass:[UIImageView class]]){
                    UIImageView *imagv= view;
                    if (imagv.tag == 1) {
                        [imagv setImage:[UIImage imageNamed:@"unselected_big"]];
                    }
                }
            }
        }
    }
      [self confirmBtnSetTitle];
}

- (void)confirmBtnClicked{
    if(self.payType.integerValue==0){
        if(self.payMoney.integerValue>0){
            self.topUpOperation.money = self.payMoney;
            self.topUpOperation.pay_way = self.payType;
            [self.topUpOperation requestStart];
        }
    }else {
        [MBProgressHUD showSuccess:@"暂不支持该付款方式" toView:self.view];
    }
}

- (void)confirmBtnSetTitle{
    NSString *btnStr = [NSString stringWithFormat:@"确认%@支付:¥%@元",self.payType.integerValue ==0? @"支付宝":@"微信",self.payMoney];
    [_confirmBtn setTitle:btnStr forState:UIControlStateNormal];
}
//重写支付成功
- (void)paySuccess{
    self.checkPayResultOperation.outTradeNo =[self.topUpOperation getOrderId];
    [self.checkPayResultOperation requestStart];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.topUpOperation){
        //支付宝
        if([self.topUpOperation.pay_way isEqualToString:@"0"]){
           [self alipayWithOrderString:self.topUpOperation.getOrderString];
        }
    }
    else if(request == self.checkPayResultOperation){
        if(self.checkPayResultOperation.isSuccess){
            MyOrderSuccessController *vc = [[MyOrderSuccessController alloc] init];
            vc.invoiceInfo = self.topUpOperation.money;
            vc.orderId =[self.topUpOperation getOrderId];
            [self toNextWithViewController:vc];
        }
        else{
            [MBProgressHUD showError:@"支付核对失败！请联系我们确认支付结果！" toView:self.view];
        }
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark getter
- (NSMutableArray *)topUpList{
    if(!_topUpList){
        _topUpList = [NSMutableArray array];
    }
    return _topUpList;
}
- (NSMutableArray *)payTypeList{
    if(!_payTypeList){
        _payTypeList = [NSMutableArray array];
    }
    return _payTypeList;
}


- (UIView *)topUpMoneyBacView{
    if(!_topUpMoneyBacView){
        _topUpMoneyBacView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, 220)];
        [_topUpMoneyBacView setBackgroundColor:[UIColor whiteColor]];
        CGFloat btnWidth= (AS_SCREEN_WIDTH-80)/3;
        NSInteger total = 5;
        for(int n=0; n<total;n++){
            UIButton *btn = [[UIButton alloc] init];
            if(n<3){
                [btn setFrame:CGRectMake(20 +n%3*(20+btnWidth), 30, btnWidth, BTN_H)];
            }else{
                [btn setFrame:CGRectMake(20 +n%3*(20+btnWidth), BTN_H+30+20, btnWidth, BTN_H)];
            }
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"topUp"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%d元",(n+1)*100] forState:UIControlStateNormal];
           
            [btn addTarget:self tag:n+1 action:@selector(topUpBtnClicked:)];
            [self.topUpList addObject:btn];
            [_topUpMoneyBacView addSubview:btn];
        }
        
        _payMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(_topUpMoneyBacView.frame)-60, AS_SCREEN_WIDTH-40, 50)];
        [_payMoneyL setText:[NSString stringWithFormat:@"充值金额：%@元",self.payMoney]];
        [_topUpMoneyBacView addSubview:_payMoneyL];
    }
    return _topUpMoneyBacView;
}

- (UIView *)payTypeBacV {
    if(!_payTypeBacV){
        _payTypeBacV = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payTypeL.frame), AS_SCREEN_WIDTH, 160)];
        [_payTypeBacV setBackgroundColor:[UIColor whiteColor]];
          NSInteger total = 2;
        for(int n=0; n<total;n++){
            UIView *btnV = [[UIView alloc] initWithFrame:CGRectMake(0, n*80, AS_SCREEN_WIDTH, 80)];
            btnV.tag = n+1;
            UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
            [imgV1 setContentMode:UIViewContentModeCenter];
            [btnV addSubview:imgV1];
            UILabel *tittleL =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+20, 10, AS_SCREEN_WIDTH-40-(CGRectGetMaxX(imgV1.frame)+20)-CGRectGetHeight(imgV1.frame)/2, CGRectGetHeight(btnV.frame)/3)];
              [btnV addSubview:tittleL];
            UILabel*subL =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV1.frame)+20, CGRectGetMaxY(tittleL.frame), CGRectGetWidth(tittleL.frame), CGRectGetHeight(btnV.frame)/3)];
            [subL setFont:[UIFont systemFontOfSize:12]];
            [subL setTextColor:[UIColor lightGrayColor]];
             [btnV addSubview:subL];
            switch(n) {
                case 0:
                    [imgV1 setImage:[UIImage imageNamed:@"zhifubao"]];
                    [tittleL setText:@"支付宝支付"];
                    [subL setText:@"全球领先，超4.5亿用户的选择"];
                    break;
                case 1:
                      [imgV1 setImage:[UIImage imageNamed:@"weixin"]];
                    [tittleL setText:@"微信支付"];
                     [subL setText:@"推荐微信4.2版本以上使用"];
                    break;
                    
                default:
                    break;
            }
            
            UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tittleL.frame), imgV1.frame.origin.y+CGRectGetHeight(imgV1.frame)/4, CGRectGetHeight(imgV1.frame)/2, CGRectGetHeight(imgV1.frame)/2)];
//            [imgV2 setContentMode:];
            if (n ==0) {
                 [imgV2 setImage:[UIImage imageNamed:@"selected_big"]];
            }else{
                 [imgV2 setImage:[UIImage imageNamed:@"unselected_big"]];
            }
           
            imgV2.tag = 1;
            [btnV addSubview:imgV2];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payTypeClicked:)];
            [btnV addGestureRecognizer:tap];
           
            [self.payTypeList addObject:btnV];
            [_payTypeBacV addSubview:btnV];
        }
     
    }
    return _payTypeBacV;
}

- (NSString *)payMoney{
    if(!_payMoney){
        _payMoney = [NSString stringWithFormat:@"0"];
    }
    return _payMoney;
}

- (NSString *)payType{
    if(!_payType){
        _payType = [NSString stringWithFormat:@"0"];
    }
    return _payType;
}

- (UILabel *)payTypeL{
    if(!_payTypeL){
        _payTypeL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.topUpMoneyBacView.frame), AS_SCREEN_WIDTH-40, BTN_H)];
        [_payTypeL setText:@"选择支付方式"];
        [_payTypeL setTextColor:[UIColor lightGrayColor]];
    }
    return _payTypeL;
}

- (UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.payTypeBacV.frame)+20, AS_SCREEN_WIDTH-40, 50)];
        [_confirmBtn setBackgroundColor:AS_MAIN_COLOR];
        [_confirmBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked)];
    }
    return _confirmBtn;
}

- (TopUpOperation *)topUpOperation{
    if(!_topUpOperation){
        _topUpOperation = [[TopUpOperation alloc] init];
    }
      _topUpOperation.delegate = self;
    return _topUpOperation;
}
- (CheckPayResultOperation *)checkPayResultOperation{
    if(!_checkPayResultOperation){
        _checkPayResultOperation = [[CheckPayResultOperation alloc] init];
    }
    _checkPayResultOperation.delegate = self;
    return _checkPayResultOperation;
}

@end
