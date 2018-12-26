//
//  GetSearchConditionOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/23.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"
#import "SearchConditionViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetSearchConditionOperation : ASBaseModel
@property (nonatomic, strong) SearchConditionViewModel *searchConditionViewModel;

@end

NS_ASSUME_NONNULL_END
