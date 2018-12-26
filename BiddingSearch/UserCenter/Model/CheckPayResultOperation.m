//
//  CheckPayResultOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/24.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CheckPayResultOperation.h"
@interface CheckPayResultOperation()
@property (nonatomic, strong) NSMutableDictionary *params;


@end

@implementation CheckPayResultOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"30"];
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.outTradeNo forKey:@"outTradeNo"];
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    
    __weak typeof(self) wself=self;
    [[ASBaseOperation shareInstance] operationWithData:self.dataDic
                                        serviceAddress:kBaseURL
                                             porthPath:self.porthName
                                      URLWithPorthPath:YES
                                          showProgress:NO
                                             showAlert:YES
                                             onSuccess:^(NSDictionary *dic){
                                                 [self configResultWithDic:dic];
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

- (void)configResultWithDic:(NSDictionary *)dic{
    if([[dic nullToBlankStringObjectForKey:@"state"] isEqualToString:@"1"]){
        self.isSuccess=YES;
    }
    else{
        self.isSuccess=YES;
    }
}

@end
