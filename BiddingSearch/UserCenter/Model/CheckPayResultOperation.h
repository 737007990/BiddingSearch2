//
//  CheckPayResultOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/24.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CheckPayResultOperation : ASBaseModel

//订单id
@property (nonatomic, strong) NSString *outTradeNo;

//返回结果
@property (nonatomic, assign) BOOL isSuccess;
@end

NS_ASSUME_NONNULL_END
