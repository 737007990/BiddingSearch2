//
//  CustomizationItemCell.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/4.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CustomizationItemCellDelegate <NSObject>

- (void)deletBtnClickWithItemId:(NSString *)itemId;

@end

@interface CustomizationItemCell : ASTableViewCell
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, assign) id<CustomizationItemCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
