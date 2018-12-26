//
//  HomeBannerGetOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/20.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"
#import "HJCBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerGetOperation : ASBaseModel

- (NSMutableArray*)getResultList;
@end

NS_ASSUME_NONNULL_END
