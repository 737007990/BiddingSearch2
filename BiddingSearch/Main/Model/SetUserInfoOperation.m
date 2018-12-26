//
//  SetUserInfoOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "SetUserInfoOperation.h"
@interface SetUserInfoOperation()
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation SetUserInfoOperation

- (void)requestStart{
    [super requestStart];
    //先看看有没有赋值，没有就去用户信息里面去取原始值
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"28"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.userId ? self.userId:ASUSER_INFO_MODEL.userId forKey:@"id"];
    [self.params setNoNilObject:self.userName ? self.userName:ASUSER_INFO_MODEL.userName forKey:@"name"];
    [self.params setNoNilObject:self.userTel ? self.userTel:ASUSER_INFO_MODEL.telephone forKey:@"telephone"];
//    [self.params setNoNilObject:self.userPasW ? self.userPasW:@"" forKey:@"password"];
    [self.params setNoNilObject:self.userEmail ?self.userEmail:ASUSER_INFO_MODEL.email forKey:@"email"];
    [self.params setNoNilObject:self.userPushOn ? self.userPushOn:ASUSER_INFO_MODEL.pushOn forKey:@"pushOn"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    WeakSelf(self);
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [weakself configDataWithDic:dic];
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

- (void)configDataWithDic:(NSDictionary *)dic{
    [ASUSER_INFO_MODEL setUserInfoWithUserDic:dic];
    [MBProgressHUD showSuccess:@"修改成功" toView:[ASCommonFunction getCurrentViewController].view];
}


@end
