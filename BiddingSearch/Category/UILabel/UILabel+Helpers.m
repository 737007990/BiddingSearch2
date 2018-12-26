//
//  UILabel+Helpers.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/29.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "UILabel+Helpers.h"

@implementation UILabel (Helpers)
+ (UILabel *)labelWithRect:(CGRect)rect text:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize textAlignment:(NSTextAlignment)textAlignment {
    __autoreleasing UILabel *label = [[UILabel alloc]init];
    label.frame = rect;
    if (text) {
        label.text = text;
    }
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = textAlignment;
    return label;
}

+ (UILabel *)labelWithRect:(CGRect)rect text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    __autoreleasing UILabel *label = [[UILabel alloc]init];
    [label setFont:[UIFont fontWithName:@"iconfont" size:25]];
    label.textColor = textColor;
    label.frame = rect;
    if (text) {
        label.text = text;
    }
    label.textAlignment = textAlignment;
    return label;
}

//计算文字宽高
/**
 *  1.字体大小
 *  2.文字内容
 *  3.限制的高度 和 宽度(CGSize)
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

@end
