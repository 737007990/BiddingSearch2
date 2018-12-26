//
//  SearchOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/22.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"
#import "HomeListCellModel.h"

@interface SearchOperation : ASBaseModel
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger size;

//返回总数
@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSString *keyWord;



- (NSMutableArray*)getResultList;

@end
