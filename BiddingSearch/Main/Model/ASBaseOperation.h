//
//  ASBaseOperation.h
//  SheQuEJia
//
//  Created by aisino on 16/3/9.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJCHttpAPIManager.h"
#import "NSDictionary+NullToNil.h"

typedef void  (^succBlock)(id succDic);
typedef void (^errorBlock)(id error);

@interface ASBaseOperation : NSObject 
@property (nonatomic, strong) HJCHttpAPIManager *manager;


+ (ASBaseOperation *)shareInstance;

//post基础方法
- (id)operationWithRequest:(NSDictionary *)request
                       URL:(NSString *)URL
              showProgress:(BOOL)showProgress
                 showAlert:(BOOL)showAlert
                 onSuccess:(succBlock)onSuccess
                   onError:(errorBlock)onError;

//设置是否将方法名拼接在请求地址中
- (id)operationWithData:(id)data
         serviceAddress:(NSString *)serviceAddress
              porthPath:(NSString *)porthPath
       URLWithPorthPath:(BOOL)URLWithPorthPath
           showProgress:(BOOL)showProgress
              showAlert:(BOOL)showAlert
              onSuccess:(succBlock)onSuccess
                onError:(errorBlock)onError;

@end
