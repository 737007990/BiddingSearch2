
//
//  MyInvoiceAddOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyInvoiceAddOperation.h"

@implementation MyInvoiceAddOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"29"];
    self.params = [NSMutableDictionary dictionary];
    
    [self.params setNoNilObject:self.rechargeId forKey:@"rechargeId"];
    [self.params setNoNilObject:self.type forKey:@"type"];
    [self.params setNoNilObject:self.invoiceTitle forKey:@"invoiceTitle"];
    [self.params setNoNilObject:self.taxNumber forKey:@"taxNumber"];
    [self.params setNoNilObject:self.content forKey:@"content"];
    [self.params setNoNilObject:self.amount forKey:@"amount"];
    [self.params setNoNilObject:self.address forKey:@"address"];
    
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
