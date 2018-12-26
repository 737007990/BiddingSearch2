//
//  UITextField+Helper.h
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/29.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Helper)
+ (UITextField *)textFieldWithRect:(CGRect)rect text:(NSString *)text placeholder:(NSString *)placeholder textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment;
@end
