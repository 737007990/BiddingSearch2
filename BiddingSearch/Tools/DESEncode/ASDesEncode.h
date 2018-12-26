//
//  ASDesEncode.h
//  SheQuEJia
//
//  Created by aisino on 16/3/10.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASDesEncode : NSObject
//文本先进行DES加密。然后再转成base64
+ (NSString *)base64StringFromText:(NSString *)text withKey:(NSString*)key;

//先把base64转为文本。然后再DES解密
+ (NSString *)textFromBase64String:(NSString *)base64 withKey:(NSString*)key;


+ (NSData *)dataWithBase64EncodedString:(NSString *)string;





@end
