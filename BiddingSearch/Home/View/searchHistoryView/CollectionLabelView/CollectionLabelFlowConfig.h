//
//  CollectionLabelFlowConfig.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface CollectionLabelFlowConfig : NSObject

+ (CollectionLabelFlowConfig *)  shareConfig;

@property (nonatomic) UIEdgeInsets  contentInsets;
@property (nonatomic) CGFloat       textMargin;
@property (nonatomic) CGFloat       lineSpace;
@property (nonatomic) CGFloat       sectionHeight;
@property (nonatomic) CGFloat       itemHeight;
@property (nonatomic) CGFloat       itemSpace;
@property (nonatomic) CGFloat       itemCornerRaius;
@property (nonatomic) UIColor       *itemColor;
@property (nonatomic) UIColor       *itemSelectedColor;
@property (nonatomic) UIColor       *textColor;
@property (nonatomic) UIColor       *textSelectedColor;
@property (nonatomic) UIFont        *textFont;
@property (nonatomic) UIColor       *backgroundColor;
NS_ASSUME_NONNULL_END
@end
