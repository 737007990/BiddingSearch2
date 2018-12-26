//
//  XDAutoresizeLabelFlow.h
//  XDAutoresizeLabelFlow
//
//  Created by Celia on 2018/4/11.
//  Copyright © 2018年 HP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDAutoresizeLabelTitleModel.h"


@class XDAutoresizeLabelFlow;
typedef void(^selectedHandler)(NSIndexPath *indexPath,NSMutableArray *titleItems);
typedef void (^deleteActionHandler)(NSIndexPath *indexPath);
//点击输入自定义值
typedef void (^footerActionHandler)(NSInteger section,NSMutableDictionary *dataDic);
//d点击重置或搜索
typedef void (^footerBtnActionHandler)(NSInteger index);



@interface XDAutoresizeLabelFlow : UIView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                sectionTitle:(NSArray *)sectionTitle
            showSectionTitles:(BOOL)showSection
            alwaysShowSection:(BOOL)awaysShow
              isCustomization:(BOOL)isCustomization
              selectedHandler:(selectedHandler)handler;

- (void)insertLabelWithTitle:(XDAutoresizeLabelTitleModel *)titleItem
                     atIndex:(NSUInteger)index inSection:(NSUInteger)section
                    animated:(BOOL)animated;

- (void)insertLabelsWithTitles:(NSArray *)titles
                     atIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section
                      animated:(BOOL)animated;

- (void)deleteLabelAtIndex:(NSUInteger)index inSection:(NSUInteger)section
                  animated:(BOOL)animated;

- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section
                     animated:(BOOL)animated;

- (void)reloadAllWithTitles:(NSArray *)titles;
- (void)reloadData;

- (CGSize)getContentSize;

@property (nonatomic, assign) BOOL selectMark;  // 选中标记
@property (nonatomic, assign) BOOL mutiSelectMark; //多选选中标记
@property (nonatomic, copy) deleteActionHandler deleteHandler;//删除block，也可作为展开收起按钮用

@property (nonatomic ,copy) footerActionHandler footerHandler;//尾部视图点击
@property (nonatomic ,copy) footerBtnActionHandler footerBtnHandler; //点击重置或搜索
@property (nonatomic, strong) NSMutableArray *selectedItems; //已选的项目
@property (nonatomic, assign) BOOL isHide;//隐藏未选项目
@property (nonatomic, assign) BOOL isCustomization; //是否是定制界面



@end




