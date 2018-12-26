//
//  CollectionLabelViewCell.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionLabelViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionLabelViewCell : UICollectionViewCell
/** 是否选中 */
@property (nonatomic, assign) BOOL beSelected;

- (void)configCellWithTitle:(CollectionLabelViewModel *)titleModel;
@end

NS_ASSUME_NONNULL_END
