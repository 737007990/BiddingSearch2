//
//  SearchConditionView.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/22.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseView.h"
#import "SearchConditionViewModel.h"


NS_ASSUME_NONNULL_BEGIN
//点击搜索
typedef void (^searchActionHandler)(void);

@interface SearchConditionView : ASBaseView
@property (nonatomic, copy) searchActionHandler searchHander;
@property (nonatomic, assign) BOOL isCustomization;//是否是定制的页面用


- (void)configWithSearchCondition:(SearchConditionViewModel *)model;

- (NSMutableDictionary *)getSelectedItem;

@end

NS_ASSUME_NONNULL_END
