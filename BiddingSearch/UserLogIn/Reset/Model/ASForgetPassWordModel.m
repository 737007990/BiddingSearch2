//
//  ASForgetPassWordModel.m
//  hxxdj
//
//  Created by aisino on 16/3/19.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASForgetPassWordModel.h"
@interface ASForgetPassWordModel()
@property (nonatomic, strong) NSMutableDictionary *params;

@end
@implementation ASForgetPassWordModel


- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"05"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.telephone forKey:@"telephone"];
    [self.params setNoNilObject:self.password forKey:@"password"];
    [self.params setNoNilObject:self.code forKey:@"code"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
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
@end
