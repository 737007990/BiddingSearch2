
//
//  ASRestPasswordModel.m
//  hxxdj
//
//  Created by aisino on 16/3/17.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASRestPasswordModel.h"

@implementation ASRestPasswordModel


- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"17"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.password_new forKey:@"password_new"];
    [self.params setNoNilObject:self.password_orig forKey:@"password_orig"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [wself configDataWithDic:dic];
                                                 if ([self.delegate respondsToSelector:@selector(request:successWithData:)]) {
                                                     [self.delegate request:wself successWithData:dic];
                                                 }
                                             }
                                               onError:^(id error){
                                                   if ([self.delegate respondsToSelector:@selector(request:failedWithError:)]) {
                                                       [self.delegate request:wself failedWithError:error];
                                                   }
                                               }];
}

- (void)configDataWithDic:(NSDictionary *)dic{
    [ASUSER_INFO_MODEL setUserInfoWithUserDic:dic];
}

@end


