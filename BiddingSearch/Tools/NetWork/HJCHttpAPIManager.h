//
//  LCHttpAPIManger.h
//  learningCloud
//
//  Created by luxiqiang on 16/9/29.
//  Copyright © 2016年 wxr. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"

@interface HJCHttpAPIManager : AFHTTPSessionManager


//get
- (void)fetchDataWithURLString:(NSString *)urlStr
                    parameters:(id)params
                       success:(void (^)(id data))success
                       failure:(void (^)(NSError *error))failure;

//get
- (void)netGetRequestServerWithUrlstring:(NSString *)urlString
                         requestParamets:(id)paramets
                                   isHud:(BOOL)hud
                                 isToken:(BOOL)isToken
                         responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                           responseFaild:(void (^) (int faildResult, NSString *message))faild
                           responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error;

//post
- (void)netPostRequestServerWithUrlstring:(NSString *)urlString
                          requestParamets:(id)paramets
                                  showHud:(BOOL)hud
                                  isToken:(BOOL)isToken
                          responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                            responseFaild:(void (^) (int faildResult, NSString *message))faild
                            responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error;

//delete
- (void)netDeleteDataRequestServerWithUrlstring:(NSString *)urlString
                                requestParamets:(id)paramets
                                        isToken:(BOOL)isToken
                                responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                                  responseFaild:(void (^) (int faildResult, NSString *message))faild
                                  responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error;

//put
- (void)netPutRequestServerWithUrlstring:(NSString *)urlString
                         requestParamets:(id)paramets
                                   isHud:(BOOL)hud
                                   isToken:(BOOL)isToken
                         responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                           responseFaild:(void (^) (int faildResult, NSString *message))faild
                           responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error;

//upload
- (void)updateImageWithUrlStr:(NSString *)url
                        image:(UIImage *)image
              requestParamets:(id)paramets
                      showHud:(BOOL)hud
                      isToken:(BOOL)isToken
              responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                responseFaild:(void (^) (int faildResult, NSString *message))faild
                responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error;


@end
