//
//  HJCVersionModel.h
//  HJCodification
//
//  Created by 卢希强 on 2018/1/3.
//  Copyright © 2018年 卢希强. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJCVersionModel : NSObject

/**
 强制更新版本号
 */
@property (nonatomic, strong) NSString *min_version_code;

/**
 更新地址
 */
@property (nonatomic, strong) NSString *update_url;

/**
 版本code
 */
@property (nonatomic, strong) NSString *version_code;

/**
 更新信息
 */
@property (nonatomic, strong) NSString *version_info;

/**
 最新版本号
 */
@property (nonatomic, strong) NSString *version_name;

/**
 返回结果
 */
@property (nonatomic, strong) NSString *result;

@end
