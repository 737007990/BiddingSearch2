//
//  MyMsgListOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/14.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyMsgListOperation : ASBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;
//当请求1是业务信息，2是系统信息
@property (nonatomic, strong) NSString *type;
//d返回总数
@property (nonatomic, strong) NSString *total;
- (NSMutableArray*)getResultList;
@end

NS_ASSUME_NONNULL_END
