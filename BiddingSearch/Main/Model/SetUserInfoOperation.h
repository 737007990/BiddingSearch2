//
//  SetUserInfoOperation.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetUserInfoOperation : ASBaseModel
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userTel;
//@property (nonatomic, strong) NSString *userPasW;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPushOn;

@end

NS_ASSUME_NONNULL_END
