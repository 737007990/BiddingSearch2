//
//  FMDatabaseFunctions.m
//  SandLife
//
//  Created by 郑苏宁 on 15/6/2.
//  Copyright (c) 2015年 linpeng. All rights reserved.
//

#define SQLTABLENAME  [NSString stringWithFormat:@"ASTable"]

#import "ASDataManager.h"
static ASDataManager * instance = nil;

@implementation ASDataManager
@synthesize db;

+ (id)shareInstance
{
    if(instance == nil)
    {
        instance = [[super allocWithZone:nil]init];  //super 调用allocWithZone
    }
    return instance;
}

- (FMDatabase *)db{
    /*
     ASSQTable 这个table的对应信息
     keyName列表: messageList   通知消息列表 解压后为NSMutableArray
                 usersInfo  用户信息  解压后为NSMutableDictionary 保存用户相关信息，手势密码等
     */
    if (db == nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        //dbPath： 数据库路径，在Document中。
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"ASBData"];
        NSString *keyName = [NSString stringWithFormat:@"keyName"];
        NSString *dataOfKeyName = [NSString stringWithFormat:@"dataOfKeyName"];
       db = [FMDatabase databaseWithPath:dbPath];                //初始化数据库
        if([db open]){
            BOOL res =  [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (%@ text, %@ blob)",SQLTABLENAME,keyName, dataOfKeyName]];
            if (!res) {
                DMLog(@"error when insert db table");
            } else {
                DMLog(@"success to insert db table");
            }
           [db close];
        }
    }
    return db;
}

#pragma mark SQLiteFunctions
- (void)saveDataToSqlite:(NSString *)dataKeyName data:(id)data
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.db open]){
            NSData *dbData = [NSKeyedArchiver archivedDataWithRootObject:data];
            NSString *keyName = [NSString stringWithFormat:@"keyName"];
            NSString *dataOfKeyName = [NSString stringWithFormat:@"dataOfKeyName"];
            NSString *insertSql= [NSString stringWithFormat:
                                  @"INSERT INTO %@ (%@,%@) VALUES (?,?)",
                                  SQLTABLENAME, keyName,dataOfKeyName];
            BOOL res = [self.db executeUpdate:insertSql,dataKeyName,dbData];
            if (!res) {
                DMLog(@"error when insert db table");
            } else {
                DMLog(@"success to insert db table");
            }
            [self.db close];
        }
    });
}

- (void)updateDataToSqlite:(NSString *)dataKeyName data:(id)data
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.db open]) {
            NSData *dbData = [NSKeyedArchiver archivedDataWithRootObject:data];
            NSString *dataOfKeyName = [NSString stringWithFormat:@"dataOfKeyName"];
            NSString *keyName = [NSString stringWithFormat:@"keyName"];
            NSString *updateSql = [NSString stringWithFormat:
                                   @"UPDATE %@ SET %@ = ? WHERE %@ = ?",
                                   SQLTABLENAME,dataOfKeyName ,keyName];
            BOOL res = [self.db executeUpdate:updateSql,dbData, dataKeyName];
            if (!res) {
                DMLog(@"error when update db table");
            } else {
                DMLog(@"success to update db table");
            }
            [self.db close];
        }
    });
}

- (void)deleteDataAtSqlite:(NSString *)dataKeyName
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([self.db open]) {
            NSString *name = [NSString stringWithFormat:@"keyName"];
            NSString *deleteSql = [NSString stringWithFormat:
                                   @"delete from %@ where %@ = ?",
                                   SQLTABLENAME, name];
            BOOL res = [self.db executeUpdate:deleteSql,dataKeyName];
            if (!res) {
                DMLog(@"error when delete db table");
            } else {
                DMLog(@"success to delete db table");
            }
            [self.db close];
        }
    });
}

- (id)getDataAtSqliteFromDataKeyName:(NSString *)dataKeyName
{
    NSData *data = [NSData data];
    NSString *dataOfKeyName = [NSString stringWithFormat:@"dataOfKeyName"];
    NSString *keyName = [NSString stringWithFormat:@"keyName"];
    
    if ([self.db open]) {
        NSString *dbStr=[NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = ?",dataOfKeyName,SQLTABLENAME,keyName];
        data = [self.db dataForQuery:dbStr,dataKeyName];
        [self.db close];
    }
    return data;
}

#pragma mark userCachePath
- (NSString *)getTmpPath{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

@end
