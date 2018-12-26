//
//  ASBaseOperation.m
//  SheQuEJia
//
//  Created by aisino on 16/3/9.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASBaseOperation.h"
#import "JSONKit.h"
#import "ASDesEncode.h"
#import "GTMBase64.h"
#import "ASCommonFunction.h"
//#import "JSON.h"

#define __BASE64( text )        [CommonFunc base64StringFromText:text]
#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@interface ASBaseOperation()

@end

@implementation ASBaseOperation
@synthesize manager;
static ASBaseOperation *sharedInstance = nil;

+ (ASBaseOperation *)shareInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (self = [super init]) {
       manager = [HJCHttpAPIManager manager];
    }
    return self;
}

//设置是否将方法名拼接在请求地址中
- (id)operationWithData:(id)data serviceAddress:(NSString *)serviceAddress porthPath:(NSString *)porthPath URLWithPorthPath:(BOOL)URLWithPorthPath showProgress:(BOOL)showProgress showAlert:(BOOL)showAlert onSuccess:(succBlock)onSuccess onError:(errorBlock)onError{
  
    NSMutableDictionary *requestValue = [NSMutableDictionary dictionary];
    if ([data isKindOfClass:[NSDictionary class]]){
        requestValue = data;
        if(ASUSER_INFO_MODEL.isLogin){//已登陆则附上登录token信息
            [requestValue setObject:ASUSER_INFO_MODEL.token forKey:@"token"];
        }
    }
    DMLog(@"已发送请求:\n%@",requestValue.JSONString);
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",serviceAddress,URLWithPorthPath? porthPath:@""];
    return [self operationWithRequest:requestValue URL:urlStr showProgress:showProgress showAlert:showAlert onSuccess:onSuccess onError:onError];
}

//post基础方法
- (id)operationWithRequest:(id)request URL:(NSString *)URL showProgress:(BOOL)showProgress showAlert:(BOOL)showAlert onSuccess:(succBlock)onSuccess onError:(errorBlock)onError{
    [[HJCHttpAPIManager manager] netPostRequestServerWithUrlstring:URL requestParamets:request showHud: showProgress  isToken:NO responseSuccess:^(NSURLSessionDataTask *task, id responseObject) {
             onSuccess(responseObject);
    } responseFaild:^(int faildResult, NSString *message) {
        if ([message isKindOfClass:[NSString class]]) {
            DMLog(@"返回失败信息：%@",message);
            UIViewController *vc = [ASCommonFunction getCurrentViewController];
            [MBProgressHUD showError:message toView:vc.view];
            onError(message);
        }
       
    } responseError:^(NSURLSessionDataTask *task, NSError *error) {
          onError(error);
    }];
    return manager;
}
@end
