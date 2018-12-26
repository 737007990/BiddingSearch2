//
//  ASCommonFunction.m
//  hxxdj
//
//  Created by aisino on 16/4/1.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASCommonFunction.h"

#define UILABEL_LINE_SPACE 6
#define HEIGHT [ [ UIScreen mainScreen ] bounds ].size.height

@implementation ASCommonFunction

+ (NSString*)dicToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 //Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        DMLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//       jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        
    }
    return jsonString;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        DMLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)stringToUFT8:(NSString *)str{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

+ (id)isNull:(id)dataStr {
    //判断数据字符串是否为null,避免崩溃
    if ([dataStr isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return dataStr;
    }
}

+ (NSString *)getJSONWith:(NSMutableArray *)strArray{
    NSMutableString *jsonStr = [[NSMutableString alloc]init]  ;
    [jsonStr appendString:@"{"];
    for (NSInteger i = 0; i < strArray.count; i++) {
        NSArray *subArray = [[strArray objectAtIndex:i] componentsSeparatedByString:@"&"];
        if(subArray.count ==2){
            [jsonStr appendFormat:@"\"%@\":\"%@\"",[subArray objectAtIndex:0],[subArray objectAtIndex:1]];
        }
        
        if(i < strArray.count-1){
            [jsonStr appendString:@","];
        }
    }
    [jsonStr appendString:@"}"];
    return [NSString stringWithFormat:@"%@",jsonStr];
}

+ (NSString *)getPureJsonString:(NSString *)str{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\""])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}


//手机号码的正则表达式
+ (BOOL)isValidateMobile:(NSString *)mobile{
    //手机号以13、15、18开头，八个\d数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//身份证号
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

////判断日期是今天，昨天还是明天
//-(NSString *)compareDate:(NSDate *)date{
//    
//    NSTimeInterval secondsPerDay = 24 * 60 * 60;
//    NSDate *today = [[NSDate alloc] init];
//    NSDate *tomorrow, *yesterday, *dayBeforYesterday;
//    
//    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
//    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
//    dayBeforYesterday = [today dateByAddingTimeInterval: -2 *secondsPerDay];
//    
//    // 10 first characters of description is the calendar date:
//    NSString * todayString = [[today description] substringToIndex:10];
//    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
//    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
//    NSString * dayBeforYesterdayString = [[tomorrow description] substringFromIndex:10];
//    
//    NSString * dateString = [[date description] substringToIndex:10];
//    
//    if ([dateString isEqualToString:todayString])
//    {
//        return @"今天";
//    } else if ([dateString isEqualToString:yesterdayString])
//    {
//        return @"昨天";
//    }else if ([dateString isEqualToString:tomorrowString])
//    {
//        return @"明天";
//    }else if ([dateString isEqualToString:dayBeforYesterdayString]) {
//        return @"前天";
//    }else
//    {
//        return dateString;
//    }
//}

/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        }else if(time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy/MM/dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
    
}


//时间格式转换
+ (NSString *)NSDateToNSString:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSString2:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}
+ (NSString *)NSDateToNSString3:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSString4:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHMS:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHM:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSDateToNSStringWithHM2:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString* strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSString *)NSStringToDateIntegerWithFormatter:(NSString *)formatterType dateString :(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterType];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp ;
}


+ (NSString *)NSStringWithDateString:(NSString *)dateString dateStringFormatter:(NSString *)dateStringFormatter toFormatter:(NSString *)toFormatter{
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:dateStringFormatter];
    //NSString转NSDate
    NSDate*date=[formatter dateFromString:dateString];
    [formatter setDateFormat:toFormatter];
    
    return [formatter stringFromDate:date];
}

// 千位符函数
+ (NSString *)separatedStrWithStr:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [formatter stringFromNumber:@(value)];
}

+ (NSString *)separatedFloatStrWithStr:(NSString *)string
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    double value = [string doubleValue];
    [formatter setPositiveFormat:@"###,##0.00;"];
    return [formatter stringFromNumber:@(value)];
}
// 删除末尾0
+ (NSString *)deleteZeroWithString:(NSString *)str
{
    NSMutableString *string = [[NSMutableString alloc]initWithFormat:@"%@",str];
    NSArray *array_1 = [string componentsSeparatedByString:@"."];
    if (array_1.count == 2) {
        for (int i =0; i <1000; i++)
        {
            DMLog(@"%ld",(unsigned long)string.length);
            DMLog(@"%@",[string substringWithRange:NSMakeRange(string.length -1, 1)]);
            if ([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"0"])
            {
                [string deleteCharactersInRange:NSMakeRange(string.length -1 , 1)];
            }
            else if([[string substringWithRange:NSMakeRange(string.length -1, 1)] isEqualToString:@"."])
            {
                [string deleteCharactersInRange:NSMakeRange(string.length -1, 1)];
                i= 10000;
            }
            else
            {
                i= 10000;
            }
        }
    }
    NSArray *array_2 = [string componentsSeparatedByString:@"."];
    if (array_2.count == 2) {
        NSString *intStr = [array_2 objectAtIndex:0];
        intStr = [self separatedStrWithStr:intStr];
        NSString *dotStr = [array_2 objectAtIndex:1];
        string = [[NSMutableString alloc]initWithFormat:@"%@.%@",intStr,dotStr];
    }else{
        string = [[NSMutableString alloc]initWithFormat:@"%@",[self separatedStrWithStr:string]];
    }
    return (NSString *)string;
}


+ (NSArray *)getPlistArrayByplistName:(NSString *)plistName{
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *array =[[NSArray alloc] initWithContentsOfFile:path];
    return array;
}


+ (NSString *)getRandomString{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < 25; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    DMLog(@"%@", string);
    return string;
}


/*
 通过arc4random() 获取0到x-1之间的整数的代码如下：
 int value = arc4random() % x;
 获取1到x之间的整数的代码如下:
 int value = (arc4random() % x) + 1;
 */

+ (NSString *)getRandomNumberWithCount:(NSInteger)countNumber{
    NSString *string = [[NSString alloc]init];
    for (int i = 0; i < countNumber; i++) {
        int figure = arc4random() % 10;
        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
        string = [string stringByAppendingString:tempString];
    }
    DMLog(@"%@", string);
    return string;
    
}

//NSRoundPlain,   // Round up on a tie ／／貌似取整
//
//NSRoundDown,    // Always down == truncate  ／／只舍不入
//
//NSRoundUp,      // Always up    ／／ 只入不舍
//
//NSRoundBankers  // on a tie round so last digit is even  貌似四舍五入


+(double)roundUp:(double)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return roundedOunces.doubleValue;
}

+(double)roundUp:(double)number{
    
    double n =[self notRounding:number afterPoint:3];
    
    return [self roundUp:n afterPoint:2];
}

+(double)notRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    
  
    return roundedOunces.doubleValue;
}


//给UILabel设置行间距和字间距
+(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (CAGradientLayer *)setVerticalGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}

+ (UIImage*)convertViewToImage:(UIView*)view{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



+(UIViewController *)getCurrentViewController{
   UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    //获取根控制器
     UIViewController* currentViewController = window.rootViewController;
     //获取当前页面控制器
     BOOL runLoopFind = YES;
     while (runLoopFind){
             if (currentViewController.presentedViewController){
               currentViewController = currentViewController.presentedViewController;
             }
             else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
              UINavigationController* navigationController = (UINavigationController* )currentViewController;
               currentViewController = [navigationController.childViewControllers lastObject];
             }
             else if ([currentViewController isKindOfClass:[UITabBarController class]]){
              UITabBarController* tabBarController = (UITabBarController* )currentViewController;
              currentViewController = tabBarController.selectedViewController;
             }
             else {
               NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
               if (childViewControllerCount > 0) {
                  currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
               }
               else {
                   return currentViewController;
               }
            }
     }
    return currentViewController;
}

@end
