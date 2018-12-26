//
//  MyMoneyInfoOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/10.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyMoneyInfoOperation.h"

@implementation MyMoneyInfoOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"20"];

    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [self configDataWithDic:dic];
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
    if([dic isKindOfClass:[NSDictionary class]]){
         self.money = [dic nullToBlankStringObjectForKey:@"balance"];
    }
}
@end
