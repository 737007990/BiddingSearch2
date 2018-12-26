//
//  MyOrderDetailOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/15.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDetailOperation : ASBaseModel
@property (nonatomic, strong) NSMutableDictionary *params;
//订单id
@property (nonatomic, strong) NSString *orderId;

//返回的订单信息
@property (nonatomic, strong) NSDictionary *orderInfo;
@end

NS_ASSUME_NONNULL_END
