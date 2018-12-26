//
//  ASTabBarView.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/28.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASTabBarView;
@protocol ASTabBarViewDelegate <NSObject>

@optional
//tabbarItem的点击，将索引传出去
- (void)tabBar:(ASTabBarView *)tabBar didClickBtn:(NSInteger)index;

@end

@interface ASTabBarView : UIView


@property (nonatomic, weak)id<ASTabBarViewDelegate> delegate;

- (void)addTabBarButtonWithTitles:(NSArray *)titles  ImageTexts:(NSArray *)imageTexts fillImageTexts:(NSArray *)fillImageTexts;

@end
