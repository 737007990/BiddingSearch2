//
//  CustomizationItemCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/4.
//  Copyright © 2018 于风. All rights reserved.
//

#define  CELL_H 200
#define  COLLECTION_H 40
#import "CustomizationItemCell.h"
#import "CollectionLabelView.h"

@interface CustomizationItemCell()
@property (nonatomic, strong) UIImageView *titleImgV;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *areaL;
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UILabel *industryL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *isPartnerL;


@property (nonatomic, strong) CollectionLabelView *sectionClassV;


@property (nonatomic, strong) UIView *bacV;
@end

@implementation CustomizationItemCell
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
        
        
        _titleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImgV.frame)+12, 10, CGRectGetWidth(self.bacV.frame)-24-CGRectGetWidth(self.titleImgV.frame)-40, 30)];
        [_titleL setFont:[UIFont systemFontOfSize:22]];
     
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleL.frame), _titleImgV.frame.origin.y, 30, 30)];
        [_deleteBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:25]];
        [_deleteBtn setTitle:@"\U0000e6b4" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked)];
        
        _areaL =[[UILabel alloc] initWithFrame:CGRectMake(_titleImgV.frame.origin.x, CGRectGetMaxY(_titleL.frame)+10, (CGRectGetWidth(self.bacV.frame)-20)/2, 20)];
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_areaL.frame), _areaL.frame.origin.y, CGRectGetWidth(_areaL.frame), CGRectGetHeight(_areaL.frame))];
        
        _industryL = [[UILabel alloc] initWithFrame:CGRectMake(_areaL.frame.origin.x, CGRectGetMaxY(_areaL.frame)+10, CGRectGetWidth(_areaL.frame), CGRectGetHeight(_areaL.frame))];
        
        _priceL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_industryL.frame), _industryL.frame.origin.y, CGRectGetWidth(_industryL.frame), CGRectGetHeight(_industryL.frame))];
        
        _isPartnerL = [[UILabel alloc] initWithFrame:CGRectMake(_industryL.frame.origin.x, CGRectGetMaxY(_industryL.frame)+15, CGRectGetWidth(self.bacV.frame)-20, 20)];
        [_isPartnerL setFont:[UIFont systemFontOfSize:14]];
        
        _sectionClassV = [[CollectionLabelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_isPartnerL.frame), CGRectGetWidth(_isPartnerL.frame), COLLECTION_H) titles:@[@[]] sectionTitle:@[@"标段分类"] showSectionTitles:NO selectedHandler:^(NSIndexPath *indexPath, CollectionLabelViewModel *titleItems) {
          
        }];
        _sectionClassV.userInteractionEnabled = NO;
        
        [self.bacV addSubview:_titleImgV];
        [self.bacV addSubview:_titleL];
        [self.bacV addSubview:_deleteBtn];
        [self.bacV addSubview:_areaL];
        [self.bacV addSubview:_timeL];
        [self.bacV addSubview:_industryL];
        [self.bacV addSubview:_priceL];
        [self.bacV addSubview:_isPartnerL];

        [self.bacV addSubview:_sectionClassV];
        
        [self addSubview:self.bacV];
    }
    return self;
}

- (void)configCellWIthData:(id)data{
    if([data isKindOfClass:[NSDictionary class]]){
        [_titleImgV setImage:[UIImage imageNamed:@"customization"]];
        
        [_titleL setText:[data nullToBlankStringObjectForKey:@"name"]];
        
        NSMutableString *regionString = [NSMutableString string];
        for (NSString *str in [data nullToBlankStringObjectForKey:@"region"]) {
            [regionString appendString:[NSString stringWithFormat:@"%@,",str]];
        }
        [_areaL setText:[NSString stringWithFormat:@"地区:%@",regionString]];
        
        [_timeL setText:[NSString stringWithFormat:@"发布时间：%@",[data nullToBlankStringObjectForKey:@"nt_starttime"]]];
        
        NSMutableString *sectorString = [NSMutableString string];
        for (NSString *str in [data nullToBlankStringObjectForKey:@"sector"]) {
            [sectorString appendString:[NSString stringWithFormat:@"%@,",str]];
        }
        [_industryL setText:[NSString stringWithFormat:@"行业:%@",sectorString]];
        
        [_priceL setText:[NSString stringWithFormat:@"标段估价：%@",[data nullToBlankStringObjectForKey:@"price"]]];
        
        [_isPartnerL setText:[NSString stringWithFormat:@"是否允许联合投标：%@",[data nullToBlankStringObjectForKey:@"isPartner"]]];
        
        NSMutableArray *sectionClassAry = [NSMutableArray arrayWithArray:[data nullToBlankStringObjectForKey:@"sectionClass"]];
        for (NSInteger n =0;n<sectionClassAry.count;n++) {
            CollectionLabelViewModel *TitleModel = [[CollectionLabelViewModel alloc]init];
            TitleModel.title = [sectionClassAry objectAtIndex:n];
            TitleModel.titleId = @"";
            TitleModel.selected = NO;
            [sectionClassAry replaceObjectAtIndex:n withObject:TitleModel];
        }

        [_sectionClassV reloadAllWithTitles:sectionClassAry];
        
        _itemId = [data nullToBlankStringObjectForKey:@"id"];
    }
}

- (void)deleteBtnClicked{
    if([self.delegate respondsToSelector:@selector(deletBtnClickWithItemId:)]){
        [self.delegate deletBtnClickWithItemId:self.itemId];
    }
}

+ (NSString *)cellIdentifier{
    return @"CustomizationItemCell";
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

