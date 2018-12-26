//
//  OrderByMonthTypeListOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderByMonthTypeListOperation : ASBaseModel
//type 1时包月，2是单条
@property (nonatomic, strong) NSString *type;
- (NSMutableArray*)getResultList;


@end

NS_ASSUME_NONNULL_END
