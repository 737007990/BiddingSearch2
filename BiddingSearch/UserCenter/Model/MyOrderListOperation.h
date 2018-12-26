//
//  MyOrderListOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListOperation : ASBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;
//当请求invoice_state为0时返回0和2的混合列表，为1则只返回1列表
@property (nonatomic, strong) NSString *invoice_state;
//d返回总数
@property (nonatomic, strong) NSString *total;
- (NSMutableArray*)getResultList;

@end

NS_ASSUME_NONNULL_END
