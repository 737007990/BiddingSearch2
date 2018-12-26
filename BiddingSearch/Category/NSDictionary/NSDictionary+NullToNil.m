//
//  NSDictionary+NullToNil.m
//  hxxdj
//
//  Created by aisino on 16/4/6.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "NSDictionary+NullToNil.h"

@implementation NSDictionary (NullToNil)

- (id)noNullobjectForKey:(NSString *)key{
    //判断数据字符串是否为null,避免崩溃
    id dataStr = [self objectForKey:key];
    if ([dataStr isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return dataStr;
    }
}

- (id)nullToZeroObjectForKey:(NSString *)key{
    //用于用户行为记录，当无值时返回字符串0
    id dataStr = [self objectForKey:key];
    if ([dataStr isKindOfClass:[NSNull class]]||dataStr ==nil) {
        return @"0";
    } else {
        return dataStr;
    }
}

- (id)nullToBlankStringObjectForKey:(NSString *)key{
    //，当无值时返回字符串空,当为n数字返回数字字符
    id dataStr = [self objectForKey:key];
    if ([dataStr isKindOfClass:[NSNumber class]]){
        NSNumber *n = [self objectForKey:key];
        dataStr = [NSString stringWithFormat:@"%@",n];
         return dataStr;
    }else if ([dataStr isKindOfClass:[NSNull class]]||dataStr ==nil) {
        return @"";
    } else {
        return dataStr;
    }
}

@end
