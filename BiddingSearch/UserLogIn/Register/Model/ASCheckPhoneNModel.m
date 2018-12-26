//
//  ASCheckPhoneNModel.m
//  hxxdj
//
//  Created by aisino on 16/3/17.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASCheckPhoneNModel.h"
@interface ASCheckPhoneNModel()
@property (nonatomic, strong) NSMutableDictionary *params;


@end

@implementation ASCheckPhoneNModel


- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"08"];
    self.params = [NSMutableDictionary dictionary];
    
    [self.params setNoNilObject:self.telephone forKey:@"telephone"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [self setRegistStatus:dic];
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

- (void)setRegistStatus:(NSDictionary *)dic{
    NSString *n = [dic noNullobjectForKey:@"is_register"];
    self.is_register = n.integerValue==1? YES: NO;
}


@end
