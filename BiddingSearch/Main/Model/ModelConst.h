//
//  ModelConst.h
//  BiddingSearch
//
//  Created by 于风 on 2018/11/20.
//  Copyright © 2018 于风. All rights reserved.
//
#import "ASLocatorModel.h"
#define KTestModel [ASLocatorModel sharedInstance].testModel
#define KrequestLogOut [ASLocatorModel sharedInstance].requestLogOut

//一般通用url
#define kBaseURL ( KTestModel ?  @"http://192.168.96.157:8080" : @"http://27.17.20.242:8750")

#define USER_MUST_KNOWN @""
//应用更新地址
#define CHECK_UPDATE @"http://fghb.fubangnet.com/hjms/download/ios/update.json"
