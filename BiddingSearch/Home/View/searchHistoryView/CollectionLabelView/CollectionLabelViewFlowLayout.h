//
//  CollectionLabelViewFlowLayout.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CollectionLabelViewFlowLayoutDataSource <NSObject>

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface CollectionLabelViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <CollectionLabelViewFlowLayoutDataSource> dataSource;
@property (nonatomic, assign) BOOL headVDefault; //拥有默认的section头部样式
@property (nonatomic, assign) BOOL alwaysShowHeadDefault;//当rows=0时仍然显示headv；


NS_ASSUME_NONNULL_END

@end
