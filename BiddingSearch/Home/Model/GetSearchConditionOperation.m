//
//  GetSearchConditionOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/23.
//  Copyright © 2018 于风. All rights reserved.
//

#import "GetSearchConditionOperation.h"

@implementation GetSearchConditionOperation

- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"04"];
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 if ([self.delegate respondsToSelector:@selector(request:successWithData:)]) {
                                                     [self configModelWithData:dic];
                                                     [self.delegate request:wself successWithData:dic];
                                                 }
                                             }
                                               onError:^(id error){
                                                   if ([self.delegate respondsToSelector:@selector(request:failedWithError:)]) {
                                                       [self.delegate request:wself failedWithError:error];
                                                   }
                                               }];
    
}

-(void)configModelWithData:(NSDictionary *)dic{
    self.searchConditionViewModel = [SearchConditionViewModel yy_modelWithDictionary:dic];
}

@end
