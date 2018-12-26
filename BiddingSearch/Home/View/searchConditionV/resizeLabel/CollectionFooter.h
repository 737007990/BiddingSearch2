//
//  CollectionFooter.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/26.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define STARTTEXT_TAG (50)
#define ENDTEXT_TAG (51)

@protocol CollectionFooterDelegate <NSObject>


@end

@interface CollectionFooter : UICollectionReusableView
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CollectionFooterDelegate> delegate;
@property (nonatomic, strong) UITextField *startTF;
@property (nonatomic, strong) UITextField *endTF;


- (void)setStringtoStart:(NSString *)startStr endString:(NSString *)endString;

@end

NS_ASSUME_NONNULL_END
