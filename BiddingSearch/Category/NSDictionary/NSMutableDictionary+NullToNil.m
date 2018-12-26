//
//  NSMutableDictionary+NullToNil.m
//  hxxdj
//
//  Created by aisino on 16/9/29.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "NSMutableDictionary+NullToNil.h"

@implementation NSMutableDictionary (NullToNil)

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
    //用于用户行为记录，当无值时返回字符串空
    id dataStr = [self objectForKey:key];
    if ([dataStr isKindOfClass:[NSNull class]]||dataStr ==nil) {
        return @"";
    } else {
        return dataStr;
    }
}

- (void)setNoNilObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject == nil) {
        anObject = @"";
    }
    [self setObject:anObject forKey:aKey];
}

@end
