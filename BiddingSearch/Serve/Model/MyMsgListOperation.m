//
//  MyMsgListOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/14.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyMsgListOperation.h"

@interface MyMsgListOperation()
@property (nonatomic, strong) NSMutableDictionary *page;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation MyMsgListOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"25"];
    self.page = [NSMutableDictionary dictionary];
    if(self.page){
        [self.page setNoNilObject:@(self.index) forKey:@"index"];
        [self.page setNoNilObject:@(self.size) forKey:@"size"];
    }
    self.params = [NSMutableDictionary dictionary];
    [self.params setNoNilObject:self.type forKey:@"type"];
    
    [self.dataDic setNoNilObject:self.page forKey:@"page"];
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
    self.resultArray = [dic objectForKey:@"message_list"];
    NSNumber *n = [dic objectForKey:@"total"];
    self.total = [NSString stringWithFormat:@"%@",n];
}

- (NSMutableArray*)getResultList{
    return self.resultArray;
}
@end
