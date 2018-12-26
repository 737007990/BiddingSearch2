//
//  OrderByMonthConfirmOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "OrderByMonthConfirmOperation.h"
@interface OrderByMonthConfirmOperation()

@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation OrderByMonthConfirmOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"23"];
    
    self.params = [NSMutableDictionary dictionary];

    [self.params setNoNilObject:self.product_id forKey:@"product_id"];
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
