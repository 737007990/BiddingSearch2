//
//  NSObject+Property.m
//  gongchengbang
//
//  Created by YAS-Macmini2 on 15/9/9.
//  Copyright (c) 2015年 RaymondNi. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

+(NSArray *)getPropertyList {
    u_int count;
    objc_property_t * properties  = class_copyPropertyList([self class], &count);
    NSMutableArray * propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t property = properties[i];
        
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString * propertyType = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        ///过滤只读属性
        if ([propertyType rangeOfString:@",R,"].length > 0 || [propertyType hasSuffix:@",R"])
        {
            NSString* firstWord = [[propertyName substringToIndex:1] uppercaseString];
            NSString* otherWord = [propertyName substringFromIndex:1];
            NSString* setMethodString = [NSString stringWithFormat:@"set%@%@:",firstWord,otherWord];
            SEL setSEL = NSSelectorFromString(setMethodString);
            ///有set方法就不过滤了
            if([[self class] instancesRespondToSelector:setSEL] == NO)
            {
                continue;
            }
        }
        [propertyArray addObject: propertyName];
    }
    
    free(properties);
    
    return propertyArray;
}

-(NSString *)className {
    return NSStringFromClass([self class]);
}

@end
