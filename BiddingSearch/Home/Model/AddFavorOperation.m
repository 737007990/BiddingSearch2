//
//  AddFavorOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//

#import "AddFavorOperation.h"

@implementation AddFavorOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"15"];
    self.params = [NSMutableDictionary dictionary];
    
    [self.params setNoNilObject:self.favorId forKey:@"tender_info_id"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
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
    NSString *n = [dic noNullobjectForKey:@"status"];
    self.isFavor =  n.integerValue==1 ? YES:NO;
}

@end
