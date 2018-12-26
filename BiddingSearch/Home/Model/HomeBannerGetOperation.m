//
//  HomeBannerGetOperation.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/20.
//  Copyright © 2018 于风. All rights reserved.
//

#import "HomeBannerGetOperation.h"
@interface HomeBannerGetOperation ()
@property (nonatomic, strong) NSMutableArray *resultArray;

@end
@implementation HomeBannerGetOperation

- (void)requestStart{
    [super requestStart];
    self.porthName = [ASLOCATOR_MODEL getURLConfigInfoWithMethod:@"01"];
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
       NSArray *ary = [dic noNullobjectForKey:@"images"];
    for (NSDictionary *dataDic in ary) {
        HJCBannerModel *model = [HJCBannerModel yy_modelWithDictionary:dataDic];
        [self.resultArray addObject:model];
    }
}

- (NSMutableArray*)getResultList{
    return self.resultArray;
}

@end
