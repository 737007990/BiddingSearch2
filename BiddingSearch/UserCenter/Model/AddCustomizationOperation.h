//
//  AddCustomizationOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/4.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCustomizationOperation : ASBaseModel

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *name;//标题

@end

NS_ASSUME_NONNULL_END
