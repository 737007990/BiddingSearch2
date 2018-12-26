//
//  MyMsgListCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/14.
//  Copyright © 2018 于风. All rights reserved.
//
#define  CELL_H 90
#import "MyMsgListCell.h"
@interface MyMsgListCell ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UIView *bacV;

@end
@implementation MyMsgListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.bacV = [[UIView alloc]initWithFrame:CGRectMake(20, 10, AS_SCREEN_WIDTH-40, CELL_H-10)];
        self.bacV.backgroundColor = [UIColor whiteColor];
        self.bacV.layer.cornerRadius=4;
        self.bacV.layer.shadowColor=[UIColor hex:@"#E1E1F1"].CGColor;//设置阴影的颜色
        self.bacV.layer.shadowRadius=5;//设置阴影的宽度
        self.bacV.layer.shadowOffset=CGSizeMake(2, 2);//设置偏移
        self.bacV.layer.shadowOpacity=1;
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.bacV.frame)-20, 20)];
        //        [_titleL setBackgroundColor:AS_MAIN_COLOR];
        [_titleL setFont:[UIFont systemFontOfSize:17]];
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(_titleL.frame.origin.x, CGRectGetMaxY(_titleL.frame),CGRectGetWidth(_titleL.frame), 40)];
        [_contentL setFont:[UIFont systemFontOfSize:14]];
        _contentL.numberOfLines = 0;
        [_contentL setTextColor:[UIColor lightGrayColor]];

        [ self.bacV addSubview:_titleL];
        [ self.bacV addSubview:_contentL];
        [self addSubview:self.bacV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    [_titleL setText:[data noNullobjectForKey:@"createTime"]];
    [_contentL setText:[data noNullobjectForKey:@"content"]];
    self.tenderInfoId = [data noNullobjectForKey:@"itemId"];
}

- (void)btnClicked{
    
}

+ (NSString *)cellIdentifier{
    return @"MyHistoryListCell";
}

+ (CGFloat)getCellH{
    return CELL_H;
}

@end
