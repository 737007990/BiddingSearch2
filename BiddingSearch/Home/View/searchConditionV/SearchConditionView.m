//
//  SearchConditionView.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/22.
//  Copyright © 2018 于风. All rights reserved.
//

#import "SearchConditionView.h"
#import "LeeDatePickerView.h"
#import "XDAutoresizeLabelFlow.h"

@interface SearchConditionView()
@property (nonatomic, strong) NSMutableArray *searchConditionList;
@property (nonatomic, strong) NSMutableArray *mainArray;
@property (nonatomic, strong) SearchConditionViewModel *dataModel;
@property (nonatomic, strong) XDAutoresizeLabelFlow *recordView;



@end

@implementation SearchConditionView
- (instancetype)initWithFrame:(CGRect)frame{
     self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark configWithModel 配置组件显示
- (void)configWithSearchCondition:(SearchConditionViewModel *)model{
    self.dataModel = model;
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    NSArray *sectionTitle = @[@"地区(多选)",@"行业(多选)",@"发布时间",@"标段分类(多选)",@"标段金额估价(单位：万元)",@"是否允许联合投标"];
    _mainArray = [self getModelArrayWithModel:model];
    
    // collectionview
    WeakSelf(self)
    self.recordView = [[XDAutoresizeLabelFlow alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) titles:_mainArray sectionTitle:sectionTitle showSectionTitles:YES alwaysShowSection:YES isCustomization:self.isCustomization selectedHandler:^(NSIndexPath *indexPath, NSMutableArray *titleItems) {
        NSMutableArray *array1 =weakself.recordView.selectedItems[indexPath.section];
        if(array1.count==0){
            weakself.recordView.isHide= NO;
        }
    }];
    self.recordView.selectMark=YES;
 
    
    self.recordView.deleteHandler = ^(NSIndexPath *indexPath) {
        NSMutableArray *array1 =weakself.recordView.selectedItems[indexPath.section];
        if(array1.count>0||weakself.recordView.isHide){
            weakself.recordView.isHide=!weakself.recordView.isHide;
        }
        
    };
   
    self.recordView.footerHandler= ^(NSInteger section,NSMutableDictionary *dic){
        if (section ==2) { //d发布时间
            [LeeDatePickerView showLeeDatePickerViewWithStyle:LeeDatePickerViewStyle_StartAndEnd
                                               formatterStyle:LeeDatePickerViewDateFormatterStyle_yMd
                                                        block:^(NSArray<NSDate *> *dateArray) {
                                                            NSDate *startDate = [dateArray objectAtIndex:0];
                                                            NSDate *endDate = [dateArray objectAtIndex:1];
                                                            if([startDate isEarlierThanDate:endDate]){
                                                                NSString *dateStr=[NSString stringWithFormat:@"%@-%@",[ASCommonFunction NSDateToNSString:startDate],[ASCommonFunction NSDateToNSString:endDate]];
                                                                XDAutoresizeLabelTitleModel *titleModel= [[weakself.mainArray objectAtIndex:2] lastObject];
                                                                [titleModel setTitle:dateStr];
                                                                [weakself.recordView reloadData];
                                                            }
                                                            else {
                                                                [MBProgressHUD showError:@"请选择正确的时间范围！"toView:weakself.superview];
                                                            }
                                                            
                                                        }];
        }
        else if(section == 4){//标段金额估价
            NSString *dataStr=[NSString stringWithFormat:@"%@-%@万",[dic objectForKey:@"start"],[dic objectForKey:@"end"]];
            XDAutoresizeLabelTitleModel *titleModel= [[weakself.mainArray objectAtIndex:4] lastObject];
            [titleModel setTitle:dataStr];
            [weakself.recordView reloadData];
        }
    };
    
    self.recordView.footerBtnHandler=^(NSInteger index){
        if (index==1) {//重置
          weakself.mainArray= [weakself getModelArrayWithModel:weakself.dataModel];
            [weakself.recordView reloadAllWithTitles: weakself.mainArray];
        }else if (index ==2){//搜索
            weakself.searchHander();
        }
    };
    [self addSubview:self.recordView];
}


- (NSMutableArray *)getModelArrayWithModel:(SearchConditionViewModel *)model{
   NSMutableArray *array = [NSMutableArray array];
    //0地区
    NSMutableArray *region=[NSMutableArray arrayWithArray:model.region];
    for (NSInteger n=0; n<region.count;n++) {
        NSDictionary *dic = [region objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [region replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:region];
    //1 行业
    NSMutableArray *sector=[NSMutableArray arrayWithArray:model.sector];
    for (NSInteger n=0; n<sector.count;n++) {
        NSDictionary *dic = [sector objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [sector replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:sector];
    //2 公告时间
    NSMutableArray *nt_starttime=[NSMutableArray arrayWithArray:model.nt_starttime];
    for (NSInteger n=0; n<nt_starttime.count;n++) {
        NSDictionary *dic = [nt_starttime objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [nt_starttime replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:nt_starttime];
    
  
    //3 标段分类
    NSMutableArray *section_class=[NSMutableArray arrayWithArray:model.section_class];
    for (NSInteger n=0; n<section_class.count;n++) {
        NSDictionary *dic = [section_class objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [section_class replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:section_class];
    
    //4标段金额估价
    NSMutableArray *price=[NSMutableArray arrayWithArray:model.price];
    for (NSInteger n=0; n<price.count;n++) {
        NSDictionary *dic = [price objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [price replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:price];
    
    //5是否允许联合投标
    NSMutableArray *is_partner=[NSMutableArray arrayWithArray:model.is_partner];;
    for (NSInteger n=0; n<is_partner.count;n++) {
        NSDictionary *dic = [is_partner objectAtIndex:n];
        XDAutoresizeLabelTitleModel *TitleModel = [[XDAutoresizeLabelTitleModel alloc]init];
        TitleModel.title = [dic objectForKey:@"value"];
        TitleModel.titleId =  [dic objectForKey:@"id"];
        TitleModel.selected = NO;
        [is_partner replaceObjectAtIndex:n withObject:TitleModel];
    }
    [array addObject:is_partner];
    return array;
}

//拼接q搜索请求数据
- (NSMutableDictionary *)getSelectedItem{
    NSMutableDictionary *selectedDic = [NSMutableDictionary dictionary];
    //地区
    NSMutableArray *region = [NSMutableArray array];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[0]) {
        if (TitleModel.selected) {
            NSDictionary *datadic = [NSDictionary dictionaryWithObjectsAndKeys:TitleModel.title,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
            [region addObject:datadic];
        }
    }
    [selectedDic setObject:region forKey:@"region"];
    //行业
    NSMutableArray *sector = [NSMutableArray array];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[1]) {
        if (TitleModel.selected) {
             NSDictionary *datadic = [NSDictionary dictionaryWithObjectsAndKeys:TitleModel.title,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
            [sector addObject:datadic];
        }
    }
      [selectedDic setObject:sector forKey:@"sector"];
    //发布时间
    NSDictionary *nt_starttime = [NSDictionary dictionary];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[2]) {
        if (TitleModel.selected) {
            nt_starttime = [NSDictionary dictionaryWithObjectsAndKeys:TitleModel.title,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
        }
    }
    [selectedDic setObject:nt_starttime forKey:@"nt_starttime"];
    
    //标段分类
    NSMutableArray *section_class = [NSMutableArray array];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[3]) {
        if (TitleModel.selected) {
              NSDictionary *datadic = [NSDictionary dictionaryWithObjectsAndKeys:TitleModel.title,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
            [section_class addObject:datadic];
        }
    }
    [selectedDic setObject:section_class forKey:@"section_class"];
    
    //标段金额估价
    NSDictionary *price = [NSDictionary dictionary];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[4]) {
        if (TitleModel.selected) {
            //后台要求去掉万字传给他
            price = [NSDictionary dictionaryWithObjectsAndKeys:[TitleModel.title safeSubstringToIndex:TitleModel.title.length-1] ,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
        }
    }
    [selectedDic setObject:price forKey:@"price"];
    
    //联合竞标
    NSDictionary *is_partner = [NSDictionary dictionary];
    for ( XDAutoresizeLabelTitleModel *TitleModel in self.mainArray[5]) {
        if (TitleModel.selected) {
            is_partner =  [NSDictionary dictionaryWithObjectsAndKeys:TitleModel.title,@"value",@(TitleModel.titleId.integerValue),@"id", nil];
        }
    }
     [selectedDic setObject:is_partner forKey:@"is_partner"];
    return selectedDic;
}


#pragma mark getter




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
