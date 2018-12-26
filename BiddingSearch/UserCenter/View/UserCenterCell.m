//
//  UserCenterCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/3.
//  Copyright © 2018 于风. All rights reserved.
//
#define  CELL_H 60

#import "UserCenterCell.h"

@implementation UserCenterCell
@synthesize imageL;
@synthesize nameL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        imageL = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 27, 27)];
        [imageL setFont:[UIFont fontWithName:@"iconfont" size:26]];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(imageL.frame.origin.x + CGRectGetWidth(imageL.frame) + 10, 0, 150, CELL_H)];
        [nameL setFont:[UIFont systemFontOfSize:17]];
        
        UIView *lineV= [[UIView alloc] initWithFrame:CGRectMake(20, CELL_H -1, AS_SCREEN_WIDTH - 20, 1)];
        [lineV setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1]];
        
        [self addSubview:imageL];
        [self addSubview:nameL];
        [self addSubview:lineV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    NSDictionary *dic = (NSDictionary *)data;
      [nameL setText:[dic objectForKey:@"nameL"]];
    [imageL setText:[dic objectForKey:@"imageL"]];
    
    
    if (![[self.layer.sublayers lastObject] isKindOfClass:[CAGradientLayer class]]) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)[UIColor hex:[data objectForKey:@"colorStart"]].CGColor, (id)[UIColor hex:[data objectForKey:@"colorEnd"]].CGColor];
        //gradientLayer.locations = @[@0, @0.5, @1];// 默认就是均匀分布
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.frame = imageL.frame;
        gradientLayer.mask = imageL.layer;
        imageL.layer.frame = gradientLayer.bounds;
        [self.layer addSublayer:gradientLayer];
    }
}

+ (NSString *)cellIdentifier{
    return @"UserCenterCell";
}

+ (CGFloat)getCellH{
    return CELL_H;
}

@end
