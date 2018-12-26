//
//  TopUpOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/10.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopUpOperation : ASBaseModel
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *pay_way;

- (NSString *)getOrderId;
- (NSString *)getOrderString;

@end

NS_ASSUME_NONNULL_END
