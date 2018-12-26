//
//  ASLogInModel.m
//  SheQuEJia
//
//  Created by aisino on 16/3/9.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASLogInModel.h"
@interface ASLogInModel()
@property (nonatomic, strong) NSMutableDictionary *params;

@end
@implementation ASLogInModel

- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"07"];
    self.params = [NSMutableDictionary dictionary];
    
    [self.params setNoNilObject:self.telephone forKey:@"telephone"];
    
    [self.params setNoNilObject:self.password forKey:@"password"];
    
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    WeakSelf(self);
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 if ([self.delegate respondsToSelector:@selector(request:successWithData:)]) {
                                                     [self.delegate request:weakself successWithData:dic];
                                                 }
                                             }
                                               onError:^(id error){
                                                   if ([self.delegate respondsToSelector:@selector(request:failedWithError:)]) {
                                                       [self.delegate request:weakself failedWithError:error];
                                                   }
                                               }];
}


@end
