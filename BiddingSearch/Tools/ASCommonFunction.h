//
//  ASCommonFunction.h
//  hxxdj
//
//  Created by aisino on 16/4/1.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASCommonFunction : NSObject
//json的转换
+ (NSString *)dicToJsonString:(id)object;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)stringToUFT8:(NSString *)str;
+ (id)isNull:(id)dataStr;

+ (NSString *)getPureJsonString:(NSString *)str;

+ (NSString *)getJSONWith:(NSMutableArray *)strArray;
//字符串的常用正则判断
+ (BOOL)isValidateMobile:(NSString *)mobile;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard;

//时间转换
+ (NSString *)NSDateToNSString:(NSDate *)date;
+ (NSString *)NSDateToNSString2:(NSDate *)date;
+ (NSString *)NSDateToNSString3:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHM:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHM2:(NSDate *)date;
+ (NSString *)NSDateToNSStringWithHMS:(NSDate *)date ;
+ (NSString *)NSDateToNSString4:(NSDate *)date;
+ (NSString *)NSStringToDateIntegerWithFormatter:(NSString *)formatterType dateString :(NSString *)dateString;
+ (NSString *)NSStringWithDateString:(NSString *)dateString dateStringFormatter:(NSString *)dateStringFormatter toFormatter:(NSString *)toFormatter;

//钱的千位符转换
+ (NSString *)separatedStrWithStr:(NSString *)string;
//带小数点的数字字符转换
+ (NSString *)separatedFloatStrWithStr:(NSString *)string;
+ (NSString *)deleteZeroWithString:(NSString *)str;

//plist文件转换对象
+ (NSArray *)getPlistArrayByplistName:(NSString *)plistName;
//获得一个随机字符串，位数自己定
+ (NSString *)getRandomString;
//获取一个随机数字，位数自己定
+ (NSString *)getRandomNumberWithCount:(NSInteger)countNumber;

//四舍五入，取小数点后几位
+(double)roundUp:(double)number afterPoint:(int)position;
// 从小数点后第三位四舍五入，取小数点后两位
+(double)roundUp:(double)number;

//取小数点后几位，不四舍五入
+(double)notRounding:(double)price afterPoint:(int)position;


//给UILabel设置行间距和字间距
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font;
//计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
+ (CAGradientLayer *)setVerticalGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;
//将uiview输出为图片
+ (UIImage*)convertViewToImage:(UIView*)view;


//获取当前视图控制器，用于在任意地方弹出警告窗等
+ (UIViewController *)getCurrentViewController;
@end
