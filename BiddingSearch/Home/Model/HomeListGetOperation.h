//
//  HomeListGetOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/22.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"
#import "HomeListCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeListGetOperation : ASBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;
//返回总数
@property (nonatomic, strong) NSString *total;

- (NSMutableArray*)getResultList;
@end

NS_ASSUME_NONNULL_END
