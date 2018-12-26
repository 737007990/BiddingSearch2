//
//  XDAutoresizeLabelFlowLayout.h
//  XDAutoresizeLabelFlow
//
//  Created by Celia on 2018/4/11.
//  Copyright © 2018年 HP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDAutoresizeLabelFlowLayoutDataSource <NSObject>

- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XDAutoresizeLabelFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id <XDAutoresizeLabelFlowLayoutDataSource> dataSource;
@property (nonatomic, assign) BOOL headVDefault; //拥有默认的section头部样式
@property (nonatomic, assign) BOOL alwaysShowHeadDefault;//当rows=0时仍然显示headv；

@property (nonatomic, assign) BOOL show_nt_starttime;//s显示发布时间输入视图
@property (nonatomic, assign) BOOL show_price;//显示标段金额估价
@end
