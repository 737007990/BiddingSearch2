//
//  UserSettingCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/19.
//  Copyright © 2018 于风. All rights reserved.
//

#define  CELL_H 60
#import "UserSettingCell.h"

@implementation UserSettingCell
@synthesize subL;
@synthesize titleL;
@synthesize headV;
@synthesize sw;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, AS_SCREEN_WIDTH-40-150, CELL_H)];
        [titleL setFont:[UIFont fontWithName:@"iconfont" size:21]];
        subL = [[UILabel alloc] initWithFrame:CGRectMake(titleL.frame.origin.x + CGRectGetWidth(titleL.frame) + 10, 0, 130, CELL_H)];
        [subL setFont:[UIFont systemFontOfSize:18]];
        [subL setTextColor:[UIColor lightGrayColor]];
        [subL setTextAlignment:NSTextAlignmentRight];
        headV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subL.frame)-51, (CELL_H-50)/2, 50, 50)];
        [headV setContentMode:UIViewContentModeScaleAspectFit];
        sw = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subL.frame)-51, (CELL_H-30)/2, 51, 31)];
        UIView *lineV= [[UIView alloc] initWithFrame:CGRectMake(0, CELL_H -1, AS_SCREEN_WIDTH , 1)];
        [lineV setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self addSubview:titleL];
        [self addSubview:subL];
        [self addSubview:headV];
        [self addSubview:sw];
        [self addSubview:lineV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    [titleL setText:[data objectForKey:@"title"]];
    [subL setText:[data objectForKey:@"sub"]];
}

+ (NSString *)cellIdentifier{
    return @"UserSettingCell";
}

+ (CGFloat)getCellH{
    return CELL_H;
}


@end
