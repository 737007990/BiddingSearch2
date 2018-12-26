//
//  SetPushIDOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/14.
//  Copyright © 2018 于风. All rights reserved.
//

#import "SetPushIDOperation.h"
@interface SetPushIDOperation()
@property (nonatomic, strong) NSMutableDictionary *params;

@end
@implementation SetPushIDOperation

- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"26"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.regist_id forKey:@"regist_id"];
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
