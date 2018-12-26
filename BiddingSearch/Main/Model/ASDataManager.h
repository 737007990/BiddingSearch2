//
//  FMDatabaseFunctions.h
//  SandLife
//
//  Created by 郑苏宁 on 15/6/2.
//  Copyright (c) 2015年 linpeng. All rights reserved.
//

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NSDictionary+NullToNil.h"

#define ASDATA_BASE  [ASDataManager shareInstance]
@interface ASDataManager : NSObject
@property (strong, nonatomic) FMDatabase *db;

+ (id)shareInstance;
//数据库单表操作
- (void)saveDataToSqlite:(NSString *)dataKeyName data:(id)data;
- (void)updateDataToSqlite:(NSString *)dataKeyName data:(id)data;
- (void)deleteDataAtSqlite:(NSString *)dataKeyName;
- (id)getDataAtSqliteFromDataKeyName:(NSString *)dataKeyName;

//获取用户其它数据缓存地址
- (NSString *)getTmpPath;

@end
