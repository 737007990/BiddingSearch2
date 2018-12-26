//
//  CollectionLabelHeader.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CollectionLabelHeader : UICollectionReusableView

@property (nonatomic, assign) BOOL haveDeleteBtn;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^deleteActionBlock)(NSIndexPath *indexPath);

@end
