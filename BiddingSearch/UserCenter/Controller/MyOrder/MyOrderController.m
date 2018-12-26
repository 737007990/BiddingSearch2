//
//  MyOrderController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//
#define  BTN_H 80
#import "MyOrderController.h"
#import "MyTopUpViewController.h"
#import "MyOrderByMonthController.h"
#import "MyOrderListController.h"
#import "MyOrderByPushController.h"
#import "MyMoneyInfoOperation.h"
#import "MyConsumeListController.h"

@interface MyOrderController ()<ASBaseModelDelegate>
//各种容器视图
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *headBacView;
@property (nonatomic, strong) UIView *statusBacView;
@property (nonatomic, strong) UIView *functionBacView;
//我的余额
@property (nonatomic, strong) UILabel *myMoneyL;
//当前订单状态显示标签
@property (nonatomic, strong) UILabel *statusL;
//当前订单状态
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) MyMoneyInfoOperation *myMoneyInfoOperation;

@end

@implementation MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.headBacView];
    [self.view addSubview:self.statusBacView];
    [self.view addSubview:self.functionBacView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.myMoneyInfoOperation requestStart];
    [ASUSER_INFO_MODEL loginWithToken];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myMoneyInfoOperation.delegate = nil;
}

#pragma mark selfMethod
- (void)loginAndLogOut{
    if(ASUSER_INFO_MODEL.isLogin){
        //判定订单状态
        switch (ASUSER_INFO_MODEL.consumeModel.integerValue) {
            case 0:
                [self setTheStatus:@"暂无"];
                break;
            case 1:
                [self setTheStatus:[NSString stringWithFormat:@"包月  到期时间:%@",ASUSER_INFO_MODEL.expired]];
                break;
            case 2:
                [self setTheStatus:@"按条收费"];
                break;
            default:
                break;
        }
    }
}

- (void)toDetail{
    MyConsumeListController *vc = [[MyConsumeListController alloc] init];
    [self toNextWithViewController:vc];
}

- (void)setTheStatus:(NSString *)status{
    [self.statusL setText:[NSString stringWithFormat:@"当前订单方式为:%@",status]];
}

- (void)clickAtBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 1:{
            //充值界面
            MyTopUpViewController *vc = [[MyTopUpViewController alloc] init];
         [self toNextWithViewController:vc];
           }
            break;
        case 2:{
            //充值订单信息界面
            MyOrderListController *vc = [[MyOrderListController alloc] init];
           [self toNextWithViewController:vc];
        }
            break;
        case 3:
        {
            //包月
            MyOrderByMonthController *vc = [[MyOrderByMonthController alloc] init];
            [self toNextWithViewController:vc];
        }
            break;
        case 4:
        {
            //逐条
            MyOrderByPushController *vc =[[MyOrderByPushController alloc]init];
           [self toNextWithViewController:vc];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myMoneyInfoOperation){
        [_myMoneyL setText:[ASCommonFunction separatedFloatStrWithStr:[NSString stringWithFormat:@"%@",self.myMoneyInfoOperation.money]] ];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark getter
- (UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
        _headView.backgroundColor = [UIColor clearColor];
        _headView.userInteractionEnabled=YES;
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,iPhoneX ? 38 : 18, AS_SCREEN_WIDTH, 44)];
        [titleL setTextAlignment:NSTextAlignmentCenter];
        [titleL setText:@"我的账户"];
        [titleL setFont:[UIFont systemFontOfSize:24]];
        [titleL setTextColor:[UIColor whiteColor]];
        [_headView addSubview:titleL];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"icon_return_press"] forState:UIControlStateHighlighted];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
        [backBtn setFrame:CGRectMake(0, iPhoneX ? 38 : 18, 44, 44)];
        [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:backBtn];
        
        UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        detailBtn.frame = CGRectMake(AS_SCREEN_WIDTH-60, iPhoneX ? 42 : 22, 60, 34);
        [detailBtn setTitle:@"明细" forState:UIControlStateNormal];
        [detailBtn addTarget:self action:@selector(toDetail) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:detailBtn];
    }
    return _headView;
   
}

- (UIView *)headBacView{
    if(!_headBacView){
        _headBacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT*1/3)];
        CAGradientLayer *Layer = [ASCommonFunction setGradualChangingColor:_headBacView fromColor:[UIColor hex:@"#4D00FD"] toColor:[UIColor hex:@"#1C92FF"]];
        [_headBacView.layer insertSublayer:Layer atIndex:0];
        [_headBacView addSubview:self.headView];
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_headBacView.frame)/2, CGRectGetWidth(_headBacView.frame), 30)];
        [titleL setTextAlignment:NSTextAlignmentCenter];
        [titleL setText:@"账户余额(元)"];
        [titleL setFont:[UIFont systemFontOfSize:19]];
        [titleL setTextColor:[UIColor whiteColor]];
        [_headBacView addSubview:titleL];
        _myMoneyL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame), CGRectGetWidth(_headBacView.frame), CGRectGetHeight(_headBacView.frame)-CGRectGetMaxY(titleL.frame))];
        [_myMoneyL setTextAlignment:NSTextAlignmentCenter];
        [_myMoneyL setText:@"0.00"];
        [_myMoneyL setFont:[UIFont systemFontOfSize:42]];
        [_myMoneyL setTextColor:[UIColor whiteColor]];
        [_headBacView addSubview:_myMoneyL];
    }
    return _headBacView;
}

- (UIView *)statusBacView{
    if(!_statusBacView){
        _statusBacView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headBacView.frame), AS_SCREEN_WIDTH, 100)];
        [_statusBacView setBackgroundColor:[UIColor whiteColor]];
        UIView *blockV = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 10, 20)];
        [blockV setBackgroundColor:AS_MAIN_COLOR];
        [_statusBacView addSubview:blockV];
        
        _statusL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(blockV.frame)+20, blockV.frame.origin.y-10, AS_SCREEN_WIDTH-CGRectGetWidth(blockV.frame)-60, CGRectGetHeight(blockV.frame)+20)];
        [_statusL setNumberOfLines:0];
        [_statusL setLineBreakMode:NSLineBreakByCharWrapping];
        [_statusL setFont:[UIFont systemFontOfSize:14]];
      
        [_statusBacView addSubview:_statusL];
        UILabel *tipsL = [[UILabel alloc] initWithFrame:CGRectMake(blockV.frame.origin.x, CGRectGetMaxY(blockV.frame)+10, AS_SCREEN_WIDTH-40, 50)];
        [tipsL setText:@"若是包月订单：剩余三天时，提示需要续订；若是逐条订单：账户余额少于支付30条时提示。"];
        [tipsL setTextColor:[UIColor lightGrayColor]];
        [tipsL setLineBreakMode:NSLineBreakByCharWrapping];
        [tipsL setNumberOfLines:0];
        [tipsL setFont:[UIFont systemFontOfSize:13]];
        [_statusBacView addSubview:tipsL];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(_statusBacView.frame)-1, AS_SCREEN_WIDTH -40, 1)];
        [lineV setBackgroundColor:ASLINE_VIEW_COLOR];
        [_statusBacView addSubview:lineV];
    }
    return _statusBacView;
}

- (UIView *)functionBacView{
    if(!_functionBacView){
        _functionBacView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusBacView.frame), AS_SCREEN_WIDTH, 100)];
        [_functionBacView setBackgroundColor:[UIColor whiteColor]];
        CGFloat btnWidth = (AS_SCREEN_WIDTH-40)/4;
        for (int n = 0; n<4; n++) {
            UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(20+btnWidth*n, 0, btnWidth, BTN_H)];
            [itemBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pay%d",n+1]] forState:UIControlStateNormal];
            [itemBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            itemBtn.adjustsImageWhenHighlighted = NO;
            
            switch (n) {
                case 0:
                    [itemBtn setTitle:@"充值交费" forState:UIControlStateNormal];
                    break;
                case 1:
                      [itemBtn setTitle:@"充值记录" forState:UIControlStateNormal];
                    break;
                case 2:
                      [itemBtn setTitle:@"包月推送" forState:UIControlStateNormal];
                    break;
                case 3:
                      [itemBtn setTitle:@"逐条推送" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
             [itemBtn layoutButtonWithEdgeInsetsStyle:HPButtonEdgeInsetsStyleTop imageTitleSpace:15];
            [itemBtn addTarget:self tag:n+1 action:@selector(clickAtBtn:)];
            [_functionBacView addSubview:itemBtn];
        }
    }
    return _functionBacView;
}

- (MyMoneyInfoOperation *)myMoneyInfoOperation{
    if(!_myMoneyInfoOperation){
        _myMoneyInfoOperation = [[MyMoneyInfoOperation alloc] init];
    }
     _myMoneyInfoOperation.delegate = self;
    return _myMoneyInfoOperation;
}

@end
