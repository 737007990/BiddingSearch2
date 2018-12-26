//
//  MyInvoiceAddOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyInvoiceAddOperation : ASBaseModel
@property (nonatomic, strong) NSMutableDictionary *params;
//订单id
@property (nonatomic, strong) NSString *rechargeId;
//发票类型
@property (nonatomic, strong) NSString *type;
//发票抬头
@property (nonatomic, strong) NSString *invoiceTitle;
//税号
@property (nonatomic, strong) NSString *taxNumber;
//商品内容
@property (nonatomic, strong) NSString *content;
//金额
@property (nonatomic, strong) NSString *amount;
//邮寄地址
@property (nonatomic, strong) NSString *address;


@end

NS_ASSUME_NONNULL_END
