//
//  UITableView+HPTableView.m
//  HPCurrentFrameTest
//
//  Created by Celia on 2017/8/15.
//  Copyright © 2017年 skyApple. All rights reserved.
//

#import "UITableView+HPTableView.h"

@implementation UITableView (HPTableView)

+ (instancetype)initFrame:(CGRect)frame style:(UITableViewStyle)style backgroundColor:(UIColor *)bgColor {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:frame style:style];
    tableV.backgroundColor = bgColor;
    
    return tableV;
}

+ (instancetype)initFrame:(CGRect)frame style:(UITableViewStyle)style backgroundColor:(UIColor *)bgColor separatorStyle:(UITableViewCellSeparatorStyle)sepStyle {
    
    UITableView *tableV = [UITableView initFrame:frame style:style backgroundColor:bgColor];
    tableV.separatorStyle = sepStyle;
    
    return tableV;
}

+ (instancetype)initFrame:(CGRect)frame style:(UITableViewStyle)style backgroundColor:(UIColor *)bgColor headerView:(UIView *)headerView {
    
    UITableView *tableV = [UITableView initFrame:frame style:style backgroundColor:bgColor];
    tableV.tableHeaderView = headerView;
    
    return tableV;
}

//添加一个方法
- (void)tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount {
    UIView *emptyView;
    if(rowCount==0)
    {
        emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, self.bounds.size.height)];
        emptyView.backgroundColor = [UIColor hex:@"#f5f5f5"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty"]];
        imageView.frame = CGRectMake((AS_SCREEN_WIDTH - imageView.image.size.width) / 2, (self.bounds.size.height - imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
        [emptyView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 31, AS_SCREEN_WIDTH, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = message;
        label.textColor = [UIColor hex:@"#0x405266"];
        label.font = [UIFont systemFontOfSize:13];
        [emptyView addSubview:label];
        self.backgroundView = emptyView;;
    }
    else
    {
        self.backgroundView = nil;
    }
}

@end
