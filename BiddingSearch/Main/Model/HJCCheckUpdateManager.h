//
//  HJCCheckUpdateManager.h
//  HJCodification
//
//  Created by 卢希强 on 2018/1/3.
//  Copyright © 2018年 卢希强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCCheckUpdateManager : NSObject

+ (instancetype)shareInstance;

/**
 检测版本更新
 */
- (void)checkUpdate;

- (void)checkUpdateBySelf;

- (BOOL)isNewVersion;

//获取后续的参数，用于坚定用户设备、系统类型
- (NSString *)getViewUrlLastStr;

@end
