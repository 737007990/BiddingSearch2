//
//  LCHttpAPIManger.m
//  learningCloud
//
//  Created by luxiqiang on 16/9/29.
//  Copyright © 2016年 wxr. All rights reserved.
//

#import "HJCHttpAPIManager.h"
#import "AFNetworking.h"


#define  PENetworkError_Invalid_AccessToken  100001
@implementation HJCHttpAPIManager

static HJCHttpAPIManager *sharedInstance = nil;

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
//        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/javascript", @"text/plain", @"multipart/form-data", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        self.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        // 设置超时时间
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = 30.f;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

- (void)fetchDataWithURLString:(NSString *)urlStr
                    parameters:(id)params
                       success:(void (^)(id data))success
                       failure:(void (^)(NSError *error))failure
{
    //字典转json
    [self GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error&&failure) {
            failure(error);
        }
    }];
}

- (void)netPostRequestServerWithUrlstring:(NSString *)urlString
                          requestParamets:(id)paramets
                                  showHud:(BOOL)hud
                                  isToken:(BOOL)isToken
                          responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                            responseFaild:(void (^) (int faildResult, NSString *message))faild
                            responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error {
    if (ASUSER_INFO_MODEL.isLogin) {
        DMLog(@"上传请求头加入token和id标记用");
        [self.requestSerializer setValue:ASUSER_INFO_MODEL.token forHTTPHeaderField:@"token"];
        [self.requestSerializer setValue:ASUSER_INFO_MODEL.userId forHTTPHeaderField:@"userId"];
    }
    [self POST:urlString parameters:paramets progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                [MBProgressHUD showMessage:NSLocalizedString(@"加载中...", nil)];
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
        if(KrequestLogOut){
              [self lc_logURLRequest:task parameters:paramets responseObject:responseObject];
        }
        int result = [responseObject[@"result"] intValue];
        if (!responseObject[@"result"]) {
            result = [responseObject[@"code"] intValue];
        }
        if (result != 0) {
            NSString *errorCodeString = [self description4ErroCode:result];
            if(result == PENetworkError_Invalid_AccessToken){
                
            }
            else{
                DMLog(@"%@",errorCodeString);
            }
            if(faild)
            {
                id message = NULL_TO_NIL(responseObject[@"message"]);
                faild(result, message ? message : @"请求异常");
            }
            return ;
        }
        success(task,[responseObject objectForKey:@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:nil];
#endif
        if(error) error(task,error1);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response == nil) {
            DMLog(@"network_unavilable");
            return ;
        }
    }];
}

- (void)netDeleteDataRequestServerWithUrlstring:(NSString *)urlString
                             requestParamets:(id)paramets
                                     isToken:(BOOL)isToken
                             responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                               responseFaild:(void (^) (int faildResult, NSString *message))faild
                               responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error {
    [self DELETE:urlString parameters:paramets success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:responseObject];
#endif
        int result = [responseObject[@"result"] intValue];
        if (!responseObject[@"result"]) {
            result = [responseObject[@"code"] intValue];
        }
        if (result != 200) {
            NSString *errorCodeString = [self description4ErroCode:result];
            if(result == PENetworkError_Invalid_AccessToken){
                
            }
            else{
                DMLog(@"%@",errorCodeString);
            }
            if(faild)
            {
                id message = NULL_TO_NIL(responseObject[@"message"]);
                faild(result, message ? message : @"请求异常");
            }
            return ;
        }
        success(task,[responseObject objectForKey:@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:nil];
#endif
        if(error) error(task,error1);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response == nil) {
            DMLog(@"network_unavilable");
            return ;
        }
    }];
}

- (void)netPutRequestServerWithUrlstring:(NSString *)urlString
                         requestParamets:(id)paramets
                                   isHud:(BOOL)hud
                                 isToken:(BOOL)isToken
                         responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                           responseFaild:(void (^) (int faildResult, NSString *message))faild
                           responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error {
    [self PUT:urlString parameters:paramets success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        #if defined(DEBUG)||defined(_DEBUG)
                [self lc_logURLRequest:task parameters:paramets responseObject:responseObject];
        #endif
                int result = [responseObject[@"result"] intValue];
                if (!responseObject[@"result"]) {
                    result = [responseObject[@"code"] intValue];
                }
                if (result != 200) {
                    NSString *errorCodeString = [self description4ErroCode:result];
                    if(result == PENetworkError_Invalid_AccessToken){
        
                    }
                    else{
                        DMLog(@"%@",errorCodeString);
                    }
                    if(faild)
                    {
                        id message = NULL_TO_NIL(responseObject[@"message"]);
                        faild(result, message ? message : @"请求异常");
                    }
                    return ;
                }
                success(task,[responseObject objectForKey:@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
        #if defined(DEBUG)||defined(_DEBUG)
                [self lc_logURLRequest:task parameters:paramets responseObject:nil];
        #endif
                if(error) error(task,error1);
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                if (response == nil) {
                    DMLog(@"network_unavilable");
                    return ;
                }
    }];
}

- (void)netGetRequestServerWithUrlstring:(NSString *)urlString
                          requestParamets:(id)paramets
                                   isHud:(BOOL)hud
                                 isToken:(BOOL)isToken
                          responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                            responseFaild:(void (^) (int faildResult, NSString *message))faild
                            responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error {
    [self GET:urlString parameters:paramets progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                [MBProgressHUD showMessage:NSLocalizedString(@"加载中...", nil)];
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:responseObject];
#endif
        int result = [responseObject[@"result"] intValue];
        if (!responseObject[@"result"]) {
            result = [responseObject[@"code"] intValue];
        }
        if (result != 200) {
            NSString *errorCodeString = [self description4ErroCode:result];
            if(result == PENetworkError_Invalid_AccessToken){
                
            }
            else{
                DMLog(@"%@",errorCodeString);
            }
            if(faild)
            {
                id message = NULL_TO_NIL(responseObject[@"message"]);
                faild(result, message ? message : @"请求异常");
            }
            return ;
        }
        success(task,[responseObject objectForKey:@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:nil];
#endif
        if(error) error(task,error1);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response == nil) {
            DMLog(@"network_unavilable");
            return ;
        }
    }];
}

- (void)updateImageWithUrlStr:(NSString *)url
                        image:(UIImage *)image
              requestParamets:(id)paramets
                      showHud:(BOOL)hud
                      isToken:(BOOL)isToken
              responseSuccess:(void (^) (NSURLSessionDataTask *task, id responseObject))success
                responseFaild:(void (^) (int faildResult, NSString *message))faild
                responseError:(void (^) (NSURLSessionDataTask *task, NSError *error))error {
    NSData *imageData = [UIImage scaleImage:image toKb:1024];
    [self POST:url parameters:paramets constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image_file2.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                [MBProgressHUD showMessage:@"上传中..."];
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:responseObject];
#endif
        int result = [responseObject[@"result"] intValue];
        if (!responseObject[@"result"]) {
            result = [responseObject[@"code"] intValue];
        }
        if (result != 200) {
            NSString *errorCodeString = [self description4ErroCode:result];
            if(result == PENetworkError_Invalid_AccessToken){
                
            }
            else{
                DMLog(@"%@",errorCodeString);
            }
            if(faild)
            {
                id message = NULL_TO_NIL(responseObject[@"message"]);
                faild(result, message ? message : @"请求异常");
            }
            return ;
        }
        success(task,[responseObject objectForKey:@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:nil animated:YES];
        });
#if defined(DEBUG)||defined(_DEBUG)
        [self lc_logURLRequest:task parameters:paramets responseObject:nil];
#endif
        if(error) error(task,error1);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response == nil) {
            DMLog(@"network_unavilable");
            return ;
        }
        
    }];
}

-(void)lc_logURLRequest:(NSURLSessionTask *)task parameters:(NSDictionary *)parms responseObject:(NSDictionary *)responseObject {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    DMLog(@"\nrequestURL: %@\nstatusCode:%zd\n\nresponse:%@",response.URL.absoluteString,response.statusCode,responseObject);
}


-(NSString *)description4ErroCode:(NSInteger )errorCode
{
    NSString *key = @(errorCode).stringValue;
    NSString *errorString =  NSLocalizedStringFromTable(key, @"PDErrorCode", nil);
    if (errorString == nil || errorString.length == 0) {
        errorString = [NSString stringWithFormat:@"unKnown errro code: %zd",errorCode];
    }
    return errorString;
}

@end
