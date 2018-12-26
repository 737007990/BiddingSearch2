//
//  CollectionLabelFlowConfig.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CollectionLabelFlowConfig.h"

@implementation CollectionLabelFlowConfig

+ (CollectionLabelFlowConfig *)shareConfig {
    static CollectionLabelFlowConfig *config;
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
        self.lineSpace = 10;
        self.itemHeight = 25;
        self.itemSpace = 10;
        self.itemCornerRaius = 3;
        self.itemColor = [UIColor clearColor];
        self.itemSelectedColor = [UIColor colorWithRed:231/255.0 green:33/255.0 blue:25/255.0 alpha:1.0];
        self.textMargin = 20;
        self.textColor = [UIColor darkGrayColor];
        self.textSelectedColor = [UIColor whiteColor];
        self.textFont = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor whiteColor];
        self.sectionHeight = 40;
    }
    return self;
}

@end
