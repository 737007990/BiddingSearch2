//
//  CollectionLabelViewModel.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionLabelViewModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleId;
@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
