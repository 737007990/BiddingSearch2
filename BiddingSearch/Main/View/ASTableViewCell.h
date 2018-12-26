//
//  ASTableViewCell.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  TableViewCell基类
//  功能描述：项目内使用到TableViewCell的基类

#import <UIKit/UIKit.h>
#import "NSDictionary+NullToNil.h"
#import "UIImageView+WebCache.h"
#import "ASImageView.h"
#import "NSDate+Category.h"



/**************************************************************************************************/
/** ASTableViewCell *******************************************************************************/

@protocol ASTableViewCellParseDelegate;

@interface ASTableViewCell : UITableViewCell
@property(nonatomic, strong) NSObject * customObject;
@property(nonatomic, strong) id cellData;

- (void)configCellWIthData:(id)data;

+ (NSString *)cellIdentifier;
+ (CGFloat)getCellH;


@end
