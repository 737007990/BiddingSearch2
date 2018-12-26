//
//  MyConsumeListOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyConsumeListOperation.h"
@interface MyConsumeListOperation()
@property (nonatomic, strong) NSMutableDictionary *page;
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation MyConsumeListOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"24"];
    self.page = [NSMutableDictionary dictionary];
    if(self.page){
        [self.page setNoNilObject:@(self.index) forKey:@"index"];
        [self.page setNoNilObject:@(self.size) forKey:@"size"];
    }
    [self.dataDic setNoNilObject:self.page forKey:@"page"];
    
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
    self.resultArray = [dic objectForKey:@"consume_record"];
    self.total = [dic objectForKey:@"total"];
}


- (NSMutableArray*)getResultList{
    return self.resultArray;
}
@end
