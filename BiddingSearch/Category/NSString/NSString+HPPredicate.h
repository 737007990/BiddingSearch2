//
//  NSString+Predicate.h
//  iOS-Category
//
//  Created by 庄BB的MacBook on 16/7/20.
//  Copyright © 2016年 BBFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HPPredicate)

/**
 判断字符串是否为空
 */
- (BOOL)isBlankString;

/** 有效的电话号码 */
- (BOOL) isValidMobileNumber;

/** 有效的真实姓名 */
- (BOOL) isValidRealName;

/** 是否只有中文 */
- (BOOL) isOnlyChinese;

/** 有效的验证码(根据自家的验证码位数进行修改) */
- (BOOL) isValidVerifyCode;

/** 有效的银行卡号 */
- (BOOL) isValidBankCardNumber;

/** 有效的邮箱 */
- (BOOL) isValidEmail;

/** 有效的字母数字密码 */
- (BOOL) isValidAlphaNumberPassword;

/** 检测有效身份证 */
- (BOOL) isValidIdentify;

/** 验证数字 */
- (BOOL)isNumber;

/** 验证英文字母 */
- (BOOL)isEnglishWords;

/** 验证是否是汉字 */
- (BOOL)isChineseWords;
//是否含有中文
- (BOOL)isContainChinese;

/** 判断该字符串是不是一个有效的URL */
- (BOOL)isValidUrl;

@end