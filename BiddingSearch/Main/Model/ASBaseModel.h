//
//  ASBaseModel.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  model的基类
//  功能描述：项目内所使用到Model的基类

#import <Foundation/Foundation.h>
#import "ASBaseOperation.h"
#import "NSDictionary+NullToNil.h"
#import "NSMutableDictionary+NullToNil.h"
#import "ASCommonFunction.h"
#import "NSString.h"
#import "JSONKit.h"

@protocol ASBaseModelDelegate <NSObject>

- (void)request:(id)request successWithData:(id)data;
- (void)request:(id)request failedWithError:(id)error;

@end

@interface ASBaseModel : NSObject
//字典参数结构
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *porthName;
@property (nonatomic, strong) NSDictionary *successData;
@property (nonatomic, strong) NSDictionary *errorData;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, weak) id<ASBaseModelDelegate> delegate;

- (void)requestStart;


@end
