//
//  ASRestPasswordModel.h
//  hxxdj
//
//  Created by aisino on 16/3/17.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASBaseModel.h"

@interface ASRestPasswordModel : ASBaseModel
@property (nonatomic, strong) NSString *password_orig;
@property (nonatomic, strong) NSString *password_new;

@property (nonatomic, strong) NSMutableDictionary *params;

@end
