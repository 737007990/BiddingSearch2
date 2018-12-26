//
//  NSMutableDictionary+NullToNil.h
//  hxxdj
//
//  Created by aisino on 16/9/29.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NullToNil)
//替换原有方法，防止null值崩溃
- (id)noNullobjectForKey:(NSString *)key;

- (id)nullToZeroObjectForKey:(NSString *)key;

- (void)setNoNilObject:(id)anObject forKey:(id<NSCopying>)aKey;

- (id)nullToBlankStringObjectForKey:(NSString *)key;
@end
