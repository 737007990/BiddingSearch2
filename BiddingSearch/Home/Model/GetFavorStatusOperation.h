//
//  GetFavorStatusOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetFavorStatusOperation : ASBaseModel
@property (nonatomic, strong) NSString *favorId;
@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, assign) BOOL isFavor;
@end

NS_ASSUME_NONNULL_END
