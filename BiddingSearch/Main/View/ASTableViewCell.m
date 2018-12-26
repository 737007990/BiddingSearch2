//
//  ASTableViewCell.m
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASTableViewCell.h"

@implementation ASTableViewCell
@synthesize cellData;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWIthData:(id)data{
    
}

+ (CGFloat)getCellH{
    return 40;
}

+ (NSString *)cellIdentifier{
    return @"cellIdentifier";
}

@end
