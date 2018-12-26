//
//  DeleteCustomizationOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/5.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeleteCustomizationOperation : ASBaseModel
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *deleteId;

@end

NS_ASSUME_NONNULL_END
