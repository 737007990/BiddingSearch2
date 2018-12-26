//
//  ASCheckPhoneNModel.h
//  hxxdj
//
//  Created by aisino on 16/3/17.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASBaseModel.h"

@interface ASCheckPhoneNModel : ASBaseModel
@property (nonatomic, strong) NSString *telephone;
//是否已注册，
@property (nonatomic, assign) BOOL is_register;

@end
