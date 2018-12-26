//
//  SearchOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/22.
//  Copyright © 2018 于风. All rights reserved.
//

#import "SearchOperation.h"
@interface SearchOperation ()
@property (nonatomic, strong) NSMutableArray *resultArray;

@end

@implementation SearchOperation
- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"03"];
    
    if(self.params){
     [self.params setNoNilObject:self.keyWord forKey:@"keyword"];
    }
   
    NSMutableDictionary *page = [NSMutableDictionary dictionary];
    [page setNoNilObject:@(self.index) forKey:@"index"];
    [page setNoNilObject:@(self.size) forKey:@"size"];
    
    [self.dataDic setNoNilObject:self.params forKey:@"params"];
    [self.dataDic setNoNilObject:page forKey:@"page"];
    
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
    NSArray *ary = [dic objectForKey:@"items"];
    self.total = [dic noNullobjectForKey:@"total"];
    for (NSDictionary *dataDic in ary) {
        HomeListCellModel *model = [HomeListCellModel yy_modelWithDictionary:dataDic];
        [self.resultArray addObject:model];
    }
}

- (NSMutableArray*)getResultList{
    return self.resultArray;
}


@end
