//
//  ASBaseView.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  UIView的基类
//  功能描述：项目所使用到的UIView基类

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"
#import "NSMutableDictionary+NullToNil.h"



@interface ASBaseView : UIView

@property(nonatomic, strong) NSMutableDictionary *customObject;

@end
