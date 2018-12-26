//
//  MyHistoryListCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#define CELL_H 130

#import "MyHistoryListCell.h"
@interface MyHistoryListCell ()

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UILabel *industryL;
@property (nonatomic, strong) UILabel *areaL;
@property (nonatomic, strong) UILabel *timeL;

@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UIView *bacV;


@end
@implementation MyHistoryListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.bacV = [[UIView alloc]initWithFrame:CGRectMake(20, 20, AS_SCREEN_WIDTH-40, CELL_H-20)];
        self.bacV.backgroundColor = [UIColor whiteColor];
        self.bacV.layer.cornerRadius=4;
        self.bacV.layer.shadowColor=[UIColor hex:@"#E1E1F1"].CGColor;//设置阴影的颜色
        self.bacV.layer.shadowRadius=5;//设置阴影的宽度
        self.bacV.layer.shadowOffset=CGSizeMake(2, 2);//设置偏移
        self.bacV.layer.shadowOpacity=1;
        
        
        _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 7, 20, 20)];
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImgV.frame)+12, 2, CGRectGetWidth(self.bacV.frame)-24-CGRectGetWidth(self.titleImgV.frame), 30)];
        [_titleL setFont:[UIFont systemFontOfSize:16]];
        //        _titleL.numberOfLines = 0;
        //        [_titleL setTextColor:[UIColor grayColor]];
        
        _contentL = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_titleL.frame),CGRectGetWidth(self.bacV.frame)-24, 40)];
        [_contentL setFont:[UIFont systemFontOfSize:14]];
        _contentL.numberOfLines = 0;
        [_contentL setTextColor:[UIColor grayColor]];
        
        _industryL= [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_contentL.frame), CGRectGetWidth(_contentL.frame)/4, 40)];
        //          [_industryL setTextColor:[UIColor grayColor]];
        [_industryL setFont:[UIFont systemFontOfSize:14]];
        
        _areaL= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_industryL.frame), CGRectGetMaxY(_contentL.frame), CGRectGetWidth(_contentL.frame)/4, CGRectGetHeight(_industryL.frame))];
        //         [_areaL setTextColor:[UIColor grayColor]];
        [_areaL setFont:[UIFont systemFontOfSize:14]];
        
        _timeL= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_areaL.frame), CGRectGetMaxY(_contentL.frame), CGRectGetWidth(_contentL.frame)/2, CGRectGetHeight(_industryL.frame))];
        //        [_timeL setTextColor:[UIColor grayColor]];
        [_timeL setTextAlignment:NSTextAlignmentRight];
        [_timeL setFont:[UIFont systemFontOfSize:12]];
        
        //        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(10, CELL_H - 1, AS_SCREEN_WIDTH - 20, 1)];
        //        lineV.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        //
        [self.bacV addSubview:_titleImgV];
        [self.bacV addSubview:_titleL];
        [self.bacV addSubview:_contentL];
        [self.bacV addSubview:_industryL];
        [self.bacV addSubview:_areaL];
        [self.bacV addSubview:_timeL];
        
        [self addSubview:self.bacV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    if([data isKindOfClass:[NSDictionary class]]){
    
        [_titleL setText:[data noNullobjectForKey:@"tenderPname"]];
//暂时屏蔽
//        [_industryL setText:[data noNullobjectForKey:@"creatTime"]];
//        [_areaL setText:[data noNullobjectForKey:@"creatTime"]];
        [_timeL setText:[data noNullobjectForKey:@"creatTime"]];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[[data nullToBlankStringObjectForKey:@"tenderTname"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [_contentL setAttributedText:attrStr];
        self.tenderInfoId = [data noNullobjectForKey:@"tenderInfoId"];
        NSInteger value = (arc4random() % 4) + 1;
        [_titleImgV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"homeListImg%ld",(long)value]]];
    }
}

+ (NSString *)cellIdentifier{
    return @"HomeListCell";
}

+ (CGFloat)getCellH{
    return CELL_H;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

