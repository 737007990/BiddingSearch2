//
//  XDAutoresizeLabelFlowConfig.m
//  XDAutoresizeLabelFlow
//
//  Created by Celia on 2018/4/11.
//  Copyright © 2018年 HP. All rights reserved.
//

#import "XDAutoresizeLabelFlowConfig.h"

@implementation XDAutoresizeLabelFlowConfig

+ (XDAutoresizeLabelFlowConfig *)shareConfig {
    static XDAutoresizeLabelFlowConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc]init];
    });
    return config;
}

// default

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentInsets = UIEdgeInsetsMake(10, 10, 10, 2);
        self.lineSpace = 15;
        self.itemHeight = 30;
        self.itemSpace = 15;
        self.itemCornerRaius = 3;
        self.itemColor = [UIColor hex:@"#F4F4F4"];
//        self.itemSelectedColor = [UIColor colorWithRed:231/255.0 green:33/255.0 blue:25/255.0 alpha:1.0];
          self.itemSelectedColor = AS_MAIN_COLOR;
        self.textMargin = 20;
        self.textColor = [UIColor darkGrayColor];
        self.textSelectedColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor whiteColor];
        self.sectionHeight = 50;
        self.sectionBtnVH = 60;
    }
    return self;
}

@end
