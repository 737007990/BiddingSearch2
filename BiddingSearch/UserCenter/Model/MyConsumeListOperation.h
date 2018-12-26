//
//  MyConsumeListOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyConsumeListOperation : ASBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;
//d返回总数
@property (nonatomic, strong) NSString *total;
- (NSMutableArray*)getResultList;
@end

NS_ASSUME_NONNULL_END
