//
//  HomeLisCellModel.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/20.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeListCellModel : ASBaseViewModel
@property (nonatomic, strong) NSString *pname;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) NSString *detailsurl;
@property (nonatomic, strong) NSString *work;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *date;
//详情id
@property (nonatomic, strong) NSString *guid;

@end

NS_ASSUME_NONNULL_END
