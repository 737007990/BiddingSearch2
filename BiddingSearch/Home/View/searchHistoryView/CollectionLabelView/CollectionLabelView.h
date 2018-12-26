//
//  CollectionLabelView.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionLabelViewModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectedHandler)(NSIndexPath *indexPath,CollectionLabelViewModel *titleItems);

@interface CollectionLabelView : UIView
@property (nonatomic, assign) BOOL selectMark;  // 选中标记
@property (nonatomic, assign) BOOL mutiSelectMark; //多选选中标记

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                 sectionTitle:(NSArray *)sectionTitle
            showSectionTitles:(BOOL)showSection
           selectedHandler:(selectedHandler)handler;

- (void)reloadAllWithTitles:(NSArray *)titles;
   
@end

NS_ASSUME_NONNULL_END
