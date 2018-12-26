//
//  MyOrderListCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#define  CELL_H 146

#import "MyOrderListCell.h"
@interface MyOrderListCell ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UIButton *invoiceBtn;

@property (nonatomic, strong) UIImageView *titleImgV;


@end
@implementation MyOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
       
        _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        [_titleImgV setImage:[UIImage imageNamed:@"orderList"]];
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleImgV.frame)+10, 20, AS_SCREEN_WIDTH-CGRectGetMaxX(_titleImgV.frame)-20-60, 20)];
        [_titleL setFont:[UIFont systemFontOfSize:17]];
       
        _subL =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleL.frame), _titleL.frame.origin.y, 60, CGRectGetHeight(_titleL.frame))];
        [_subL setTextAlignment:NSTextAlignmentCenter];
        [_subL setTextColor:[UIColor lightGrayColor]];
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.frame.origin.x, CGRectGetMaxY(_titleL.frame),CGRectGetWidth(_titleL.frame)+CGRectGetWidth(_subL.frame), 40)];
        [_contentL setFont:[UIFont systemFontOfSize:14]];
        _contentL.numberOfLines = 0;
        [_contentL setLineBreakMode:NSLineBreakByCharWrapping];
        [_contentL setTextColor:[UIColor lightGrayColor]];
          _contentL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyId)];
        [_contentL addGestureRecognizer:tap];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(_contentL.frame.origin.x, CGRectGetMaxY(_contentL.frame), CGRectGetWidth(_contentL.frame), 16)];
        [_timeL setFont:[UIFont systemFontOfSize:14]];
        [_timeL setTextColor:[UIColor lightGrayColor]];
        
        _priceL= [[UILabel alloc] initWithFrame:CGRectMake(_timeL.frame.origin.x, CGRectGetMaxY(_timeL.frame), CGRectGetWidth(_titleL.frame), 40)];
        [_priceL setTextColor:AS_MAIN_COLOR];
        [_priceL setFont:[UIFont systemFontOfSize:17]];
        
        _invoiceBtn= [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_priceL.frame), CGRectGetMaxY(_timeL.frame)+5, CGRectGetWidth(_subL.frame), CGRectGetHeight(_priceL.frame)-10)];
        [_invoiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_invoiceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_invoiceBtn addTarget:self action:@selector(btnClicked)];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, CELL_H - 1, AS_SCREEN_WIDTH - 20, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];

        [self addSubview:_titleImgV];
        [self addSubview:_titleL];
        [self addSubview:_subL];
        [self addSubview:_contentL];
        [self addSubview:_timeL];
        [self addSubview:_priceL];
        [self addSubview:_invoiceBtn];
        [self addSubview:lineV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)data;
        [_titleL setText:[dic nullToBlankStringObjectForKey:@"name"]];
        [_subL setText:@"已完成"];
          self.OrderId = [dic nullToBlankStringObjectForKey:@"id"];
        [_contentL setText:[NSString stringWithFormat:@"点击复制订单号:%@",[dic nullToBlankStringObjectForKey:@"id"]]];
        [_timeL setText:[dic nullToBlankStringObjectForKey:@"regechargeTime"]];
        [_priceL setText:[NSString stringWithFormat:@"¥%@",[dic nullToBlankStringObjectForKey:@"money"]]];
        //获取开票状态。0未开票 1已开票 2已申请
        NSString *invoiceState = [dic nullToBlankStringObjectForKey:@"invoiceState"];
        if(invoiceState.integerValue ==0){
            _invoiceBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _invoiceBtn.layer.borderWidth = 0.5;
            _invoiceBtn.layer.cornerRadius = 4;
            [_invoiceBtn setTitle:@"申请发票" forState:UIControlStateNormal];
            _invoiceBtn.userInteractionEnabled = YES;
        }else{
            if(invoiceState.integerValue ==2){
                 [_invoiceBtn setTitle:@"已申请" forState:UIControlStateNormal];
            }
            else{
                 [_invoiceBtn setTitle:@"已开票" forState:UIControlStateNormal];
            }
            _invoiceBtn.layer.borderWidth = 0.0;
             _invoiceBtn.userInteractionEnabled = NO;
        }
    }
}

- (void)btnClicked{
    if ([self.delegate respondsToSelector:@selector(invoiceGetBtnClicked:)]) {
        [self.delegate invoiceGetBtnClicked:self.indexPath];
    }
}

- (void)copyId{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = self.OrderId;
    [MBProgressHUD showSuccess:@"复制订单号成功！" toView:self];
    DMLog(@"已复制订单号：\n%@", pb.string);
}

+ (NSString *)cellIdentifier{
    return @"MyOrderListCell";
}

+ (CGFloat)getCellH{
    return CELL_H;
}

@end
