//
//  MyOrderListCell.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MyOrderListCellDelegate <NSObject>

- (void)invoiceGetBtnClicked:(NSIndexPath *)indexPath;

@end

@interface MyOrderListCell : ASTableViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *OrderId;
@property (nonatomic, assign) id<MyOrderListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
