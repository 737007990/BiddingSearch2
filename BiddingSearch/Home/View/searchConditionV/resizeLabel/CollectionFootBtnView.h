//
//  CollectionFootBtnView.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/26.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionFootBtnView : UICollectionReusableView
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
