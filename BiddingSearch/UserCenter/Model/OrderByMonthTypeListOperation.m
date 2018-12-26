//
//  OrderByMonthTypeListOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "OrderByMonthTypeListOperation.h"
@interface OrderByMonthTypeListOperation()

@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableArray *resultArray;
@end

@implementation OrderByMonthTypeListOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"22"];
    self.params = [NSMutableDictionary dictionary];

    [self.params setNoNilObject:self.type forKey:@"type"];
     [self.dataDic setNoNilObject:self.params forKey:@"params"];
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [self configResultWithData:dic];
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

- (void)configResultWithData:(NSDictionary *)dic{
    self.resultArray = [NSMutableArray array];
    self.resultArray = [dic objectForKey:@"products"];
}


- (NSMutableArray*)getResultList{
    return self.resultArray;
}
@end
