//
//  MyOrderByPushController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyOrderByPushController.h"
#import "OrderByMonthTypeListOperation.h"
#import "OrderByMonthConfirmOperation.h"
#define BTN_H 80

#define CONTENT_H 300
@interface MyOrderByPushController ()<ASBaseModelDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *btnBacV;
@property (nonatomic, strong) NSMutableArray *btnArry;

@property (nonatomic,strong) UILabel *orderMonthTypeL;
@property (nonatomic, strong) NSString *orderMonthType;
@property (nonatomic,strong) NSString *price;
@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) OrderByMonthTypeListOperation *orderByMonthTypeListOperation;
@property (nonatomic, strong) OrderByMonthConfirmOperation *orderByMonthConfirmOperation;

@end

@implementation MyOrderByPushController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.scrollView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.currentNavigationController setTitleText:@"逐条推送" viewController:self];
    self.orderByMonthTypeListOperation.type = @"2";
    [self.orderByMonthTypeListOperation requestStart];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.orderByMonthTypeListOperation.delegate = nil;
    self.orderByMonthConfirmOperation.delegate = nil;
}

#pragma mark selfMethod
- (void)btnClicked:(UIButton *)selectedBtn{
    DMLog(@"选择了%ld",(long)selectedBtn.tag);
    for (UIImageView *b in self.btnArry) {
        if(b.tag == selectedBtn.tag){
            [b setImage:[UIImage imageNamed:@"payMonth1"]];
        }
        else{
            [b setImage:[UIImage imageNamed:@"payMonth"]];
        }
    }
    
    NSDictionary *defaultDic = [self.orderByMonthTypeListOperation.getResultList objectAtIndex:selectedBtn.tag-1];
    self.orderMonthType = [defaultDic nullToBlankStringObjectForKey:@"name"];
    self.price = [defaultDic nullToBlankStringObjectForKey:@"price"];
    self.orderID = [defaultDic nullToBlankStringObjectForKey:@"id"];
    
    // 设置字体颜色NSForegroundColorAttributeName，取值为 UIColor对象，默认值为黑色
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择套餐：%@¥%@元",self.orderMonthType,self.price]];
    [textColor addAttribute:NSForegroundColorAttributeName
                      value:[UIColor hex:@"#DA0064"]
                      range:[[NSString stringWithFormat:@"选择套餐：%@¥%@元",self.orderMonthType,self.price] rangeOfString:[NSString stringWithFormat:@"¥%@",self.price]]];
    [self.orderMonthTypeL setAttributedText:textColor];
    [self setTheConfirmBtn];
}

- (void)confirmBtnClicked{
    WeakSelf(self);
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"逐条套餐" message:[NSString stringWithFormat:@"购买套餐：%@¥%@元",self.orderMonthType,self.price] preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(weakself.orderID.length){
            weakself.orderByMonthConfirmOperation.product_id = self.orderID;
            [weakself.orderByMonthConfirmOperation requestStart];
            
        }
    }]];
    [self presentViewController:vc animated:YES completion:nil];
    
}
//设置确认键文字
- (void)setTheConfirmBtn{
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"确定开通%@",self.orderMonthType] forState:UIControlStateNormal];
}

- (void)delayMethod{
    [self toBack];
}
#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.orderByMonthTypeListOperation){
        [self.scrollView addSubview:self.btnBacV];
        [self.scrollView addSubview:self.confirmBtn];
    }
    else if (request == self.orderByMonthConfirmOperation){
        [MBProgressHUD showSuccess:@"订阅成功！" toView:self.view];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    //    if([error isKindOfClass:[NSString class]]){
    //        [MBProgressHUD showError:error toView:self.view];
    //    }
}

#pragma mark getter
- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT-NAVIGATION_H)];
        _scrollView.scrollEnabled= YES;
    }
    return _scrollView;
}

- (UIView*)btnBacV{
    if(!_btnBacV){
        NSInteger total = self.orderByMonthTypeListOperation.getResultList.count;
        _btnBacV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, BTN_H*total+150)];
        [_btnBacV setBackgroundColor:[UIColor whiteColor]];
        
        for(int n=0; n<total;n++){
            NSDictionary *infoDic = [self.orderByMonthTypeListOperation.getResultList objectAtIndex:n];
            // 背景图
            UIImageView *btnV = [[UIImageView alloc] initWithFrame:CGRectMake(20, (n+1)*20+n*BTN_H, AS_SCREEN_WIDTH-40, BTN_H)];
            btnV.tag = n+1;
            btnV.userInteractionEnabled = YES;
            btnV.layer.borderWidth=0.5;
            btnV.layer.borderColor=ASLINE_VIEW_COLOR.CGColor;
            btnV.layer.cornerRadius=4;
            btnV.clipsToBounds =YES;
            //数字标签
            UILabel *numberL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BTN_H, BTN_H)];
            [numberL setFont:[UIFont systemFontOfSize:22]];
            [numberL setTextColor:[UIColor whiteColor]];
            [numberL setTextAlignment:NSTextAlignmentCenter];
            UIBezierPath *maskPath1=[UIBezierPath bezierPathWithRoundedRect:numberL.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
            CAShapeLayer *maskLayer1=[[CAShapeLayer alloc]init];
            maskLayer1.frame=numberL.bounds;
            maskLayer1.path=maskPath1.CGPath;
            numberL.layer.mask=maskLayer1;
            //这玩意用于构造背景色图片用，，，
            UIView *colorV = [[UIView alloc] initWithFrame:numberL.frame];
            CAGradientLayer *Layer = [ASCommonFunction setVerticalGradualChangingColor:colorV fromColor:[UIColor hex:@"#73B6EE"] toColor:[UIColor hex:@"#3778DB"]];
            [colorV.layer insertSublayer:Layer atIndex:0];
            UIImage *img = [ASCommonFunction convertViewToImage:colorV];
            //设置数字标签背景色为渐变色
            [numberL setBackgroundColor:[UIColor colorWithPatternImage:img]];
            [btnV addSubview:numberL];
            //主标题
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberL.frame)+10, 0,IS_IPHONE5? 80:120, BTN_H)];
            titleL.numberOfLines=0;
            [titleL setLineBreakMode:NSLineBreakByCharWrapping];
            [titleL setFont:[UIFont systemFontOfSize:17]];
            [btnV addSubview:titleL];
            //副标题
            UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleL.frame), 0, CGRectGetWidth(btnV.frame)-CGRectGetMaxX(titleL.frame), BTN_H)];
            [subL setFont:[UIFont systemFontOfSize:15]];
            [subL setTextColor:[UIColor grayColor]];
            subL.numberOfLines=0;
            [subL setLineBreakMode:NSLineBreakByCharWrapping];
            [btnV addSubview:subL];
            //遮罩按钮
            UIButton *maskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(btnV.frame), CGRectGetHeight(btnV.frame))];
            [maskBtn addTarget:self tag:btnV.tag  action:@selector(btnClicked:)];
            [btnV addSubview:maskBtn];
            if (n==0) {
                [btnV setImage:[UIImage imageNamed:@"payMonth1"]];
            }else{
                [btnV setImage:[UIImage imageNamed:@"payMonth"]];
            }
            //加入到组件列表
            [self.btnArry addObject:btnV];
            NSString *days = [infoDic nullToBlankStringObjectForKey:@"duration"];
            NSString *name = [infoDic nullToBlankStringObjectForKey:@"name"];
            NSString *price = [infoDic nullToBlankStringObjectForKey:@"price"];
            NSString *subName =  [infoDic nullToBlankStringObjectForKey:@"isLimitAmount"];
            
            [numberL setText:days];
            [titleL setText:name];
            // 设置字体颜色NSForegroundColorAttributeName，取值为 UIColor对象，默认值为黑色
            NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ￥%@",subName,price]];
            [textColor addAttribute:NSForegroundColorAttributeName
                              value:[UIColor hex:@"#DA0064"]
                              range:[[NSString stringWithFormat:@"%@   ￥%@",subName,price] rangeOfString:[NSString stringWithFormat:@"￥%@",price]]];
            [subL setAttributedText:textColor];
            //容器视图添加子视图
            [_btnBacV addSubview:btnV];
        }
        //设置默认项为返回数据的第一个
        NSDictionary *defaultDic = [self.orderByMonthTypeListOperation.getResultList objectAtIndex:0];
        self.orderMonthType = [defaultDic nullToBlankStringObjectForKey:@"name"];
        self.price = [defaultDic nullToBlankStringObjectForKey:@"price"];
        self.orderID = [defaultDic nullToBlankStringObjectForKey:@"id"];
        
        _orderMonthTypeL =[[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(self.btnBacV.frame)-50, AS_SCREEN_WIDTH-60, 50)];
        // 设置字体颜色NSForegroundColorAttributeName，取值为 UIColor对象，默认值为黑色
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"选择套餐：%@¥%@元",self.orderMonthType,self.price]];
        [textColor addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hex:@"#DA0064"]
                          range:[[NSString stringWithFormat:@"选择套餐：%@¥%@元",self.orderMonthType,self.price] rangeOfString:[NSString stringWithFormat:@"¥%@",self.price]]];
        [_orderMonthTypeL setAttributedText:textColor];
        [_btnBacV addSubview:_orderMonthTypeL];
        [self setTheConfirmBtn];
    }
    return _btnBacV;
}

- (NSMutableArray *)btnArry{
    if(!_btnArry){
        _btnArry = [NSMutableArray  array];
    }
    return _btnArry;
}

- (NSString*)orderMonthType{
    if(!_orderMonthType){
        _orderMonthType = [NSString string];
    }
    return _orderMonthType;
}

- (NSString *)price{
    if(!_price){
        _price = [NSString string];
    }
    return _price;
}

- (NSString *)orderID{
    if(!_orderID){
        _orderID = [NSString string];
    }
    return _orderID;
}

- (UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.btnBacV.frame)+20, AS_SCREEN_WIDTH-40, 50)];
        [_confirmBtn setBackgroundColor:AS_MAIN_COLOR];
        [_confirmBtn setTitle:@"确定支付" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5;
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked)];
        [self.scrollView setContentSize:CGSizeMake(AS_SCREEN_WIDTH, CGRectGetMaxY(_confirmBtn.frame)+100)];
    }
    return _confirmBtn;
}

- (OrderByMonthTypeListOperation *)orderByMonthTypeListOperation{
    if(!_orderByMonthTypeListOperation){
        _orderByMonthTypeListOperation = [[OrderByMonthTypeListOperation alloc] init];
    }
    _orderByMonthTypeListOperation.delegate=self;
    return _orderByMonthTypeListOperation;
}

- (OrderByMonthConfirmOperation *)orderByMonthConfirmOperation{
    if(!_orderByMonthConfirmOperation){
        _orderByMonthConfirmOperation = [[OrderByMonthConfirmOperation alloc] init];
    }
    _orderByMonthConfirmOperation.delegate=self;
    return _orderByMonthConfirmOperation;
}

@end
