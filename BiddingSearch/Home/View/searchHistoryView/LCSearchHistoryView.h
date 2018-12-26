//
//  LCSearchHistoryView.h
//  learningCloud
//
//  Created by 卢希强 on 2017/3/27.
//  Copyright © 2017年 wxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSearchHistoryViewDelegate <NSObject>

@optional
- (void)searchHistory:(NSString *)searchStr;

- (void)historyViewScroll;

@end

@interface LCSearchHistoryView : UIView

@property (nonatomic, weak) id<LCSearchHistoryViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)reloadData:(NSMutableArray *)dataArray;

- (void)configViewsWith:(NSMutableArray *)labelArray andKey:(NSString *)key;

@end
