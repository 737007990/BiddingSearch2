//
//  SearchConditionViewModel.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/23.
//  Copyright © 2018 于风. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchConditionViewModel : NSObject
//地区
@property (nonatomic, strong) NSMutableArray *region;
//标段分类
@property (nonatomic, strong) NSMutableArray *section_class;
//行业
@property (nonatomic, strong) NSMutableArray *sector;
//公告发布时间
@property (nonatomic, strong) NSMutableArray *nt_starttime;
////开标时间
//@property (nonatomic, strong) NSMutableArray *bid_open_time;
//是否允许联合投标
@property (nonatomic, strong) NSMutableArray *is_partner;
//标段内容
@property (nonatomic, strong) NSMutableArray *tag;
//标段金额估价
@property (nonatomic, strong) NSMutableArray *price;



@end

NS_ASSUME_NONNULL_END
