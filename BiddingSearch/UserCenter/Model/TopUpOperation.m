//
//  TopUpOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/10.
//  Copyright © 2018 于风. All rights reserved.
//

#import "TopUpOperation.h"
@interface TopUpOperation()
//订单id
@property (nonatomic, strong) NSString *orderId;
//支付宝支付加密串
@property (nonatomic, strong) NSString *orderString;
@end

@implementation TopUpOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"19"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.money forKey:@"money"];
    [self.params setNoNilObject:self.pay_way forKey:@"pay_way"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [wself setTheOrderId:dic];
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

- (void)setTheOrderId:(NSDictionary *)dic{
    self.orderId =  [dic nullToBlankStringObjectForKey:@"rechargeId"];
    self.orderString = [dic nullToBlankStringObjectForKey:@"orderString"];
}

- (NSString *)getOrderId{
    return self.orderId;
}
- (NSString *)getOrderString{
     return self.orderString;
}

@end
