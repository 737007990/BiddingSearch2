//
//  XDAutoresizeLabelFlow.m
//  XDAutoresizeLabelFlow
//
//  Created by Celia on 2018/4/11.
//  Copyright © 2018年 HP. All rights reserved.
//

#import "XDAutoresizeLabelFlow.h"
#import "XDAutoresizeLabelFlowLayout.h"
#import "XDAutoresizeLabelFlowCell.h"
#import "XDAutoresizeLabelFlowConfig.h"
#import "XDAutoresizeLabelFlowHeader.h"
#import "CollectionFooter.h"
#import "CollectionFootBtnView.h"

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"flowHeaderID";
static NSString *const footerId = @"flowFooterID";
static NSString *const footerBtnId = @"flowFooterBtnID";


@interface XDAutoresizeLabelFlow () <UICollectionViewDataSource, UICollectionViewDelegate, XDAutoresizeLabelFlowLayoutDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UICollectionView   *collection;
@property (nonatomic,strong) NSArray            *sectionData;
@property (nonatomic,assign) NSInteger numberCount;
@property (nonatomic,copy)   selectedHandler  handler;
@property (nonatomic,strong) NSMutableArray     *data;//总数据源，不建议直接修改

@property (nonatomic, strong) XDAutoresizeLabelFlowLayout *layout;

@property (nonatomic, assign) BOOL headVDefault; //拥有默认的section头部样式
@property (nonatomic, assign) BOOL alwaysShowHeadDefault;//当rows=0时仍然显示headv；

@end

@implementation XDAutoresizeLabelFlow

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles sectionTitle:(NSArray *)sectionTitle  showSectionTitles:(BOOL)showSection alwaysShowSection:(BOOL)awaysShow isCustomization:(BOOL)isCustomization  selectedHandler:(selectedHandler)handler {
    self = [super initWithFrame:frame];
    if (self) {
       
       
        if (!titles) {
           self.data = @[@[]].mutableCopy;
        }
        else {
           self.data = titles.mutableCopy;
        }
        self.sectionData = sectionTitle;
        self.handler = handler;
        self.headVDefault = showSection;
        self.alwaysShowHeadDefault = awaysShow;
        self.isCustomization = isCustomization;
        [self setup];
    }
    return self;
}

- (void)setup {
    _layout = [[XDAutoresizeLabelFlowLayout alloc] init];
    _layout.dataSource = self;
    _layout.headVDefault= self.headVDefault;
    _layout.alwaysShowHeadDefault=self.alwaysShowHeadDefault;
    self.collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    self.collection.backgroundColor = [XDAutoresizeLabelFlowConfig shareConfig].backgroundColor;
    
    self.collection.allowsMultipleSelection = YES;
    self.collection.scrollEnabled = YES;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[XDAutoresizeLabelFlowHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collection registerClass:[CollectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
     [self.collection registerClass:[CollectionFootBtnView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerBtnId];

    [self.collection registerClass:[XDAutoresizeLabelFlowCell class] forCellWithReuseIdentifier:cellId];
    [self addSubview:self.collection];
    
}

- (void)reloadAllWithTitles:(NSArray *)titles {
    if (!titles.count || ![titles[0] isKindOfClass:[NSArray class]]) {
        self.data = @[titles].mutableCopy;
    }else {
        self.data = [titles mutableCopy];
    }
    [self.collection reloadData];
}

- (void)reloadData{
     [self.collection reloadData];
}

- (CGSize)getContentSize{
    return self.collection.collectionViewLayout.collectionViewContentSize;
}

- (void)setSelectMark:(BOOL)selectMark {
    _selectMark = selectMark;
}

- (void)showDatePicker:(UITapGestureRecognizer *)sender{
    if (self.footerHandler) {
        //数据由日期选择器回调，这里给个空数据即可
         NSMutableDictionary *dic = [NSMutableDictionary dictionary];
           self.footerHandler(sender.view.tag,dic);
    }

}

- (void)footerBtnClicked:(UITapGestureRecognizer *)sender{
     self.footerBtnHandler(sender.view.tag);
}

#pragma mark - TextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CollectionFooter *footerV = (CollectionFooter*)textField.superview;
    if (textField.tag == STARTTEXT_TAG) {
        if(footerV.startTF.text.length>0&&footerV.endTF.text.length>0){
            if (footerV.startTF.text.integerValue<footerV.endTF.text.integerValue) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:footerV.startTF.text forKey:@"start"];
                [dic setObject:footerV.endTF.text forKey:@"end"];
                self.footerHandler(footerV.indexPath.section,dic);
            }
            else{
                [MBProgressHUD showError:@"请按从小到大格式输入" toView:self.window];
            }
        }
    }
    else if (textField.tag == ENDTEXT_TAG){
        if(footerV.startTF.text.length>0&&footerV.endTF.text.length>0){
            if (footerV.startTF.text.integerValue<footerV.endTF.text.integerValue) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:footerV.startTF.text forKey:@"start"];
                [dic setObject:footerV.endTF.text forKey:@"end"];
                self.footerHandler(footerV.indexPath.section,dic);
            }
            else{
                [MBProgressHUD showError:@"请按从小到大格式输入" toView:self.window];
            }
        }
        else {
            [MBProgressHUD showError:@"请输入完整信息" toView:self.window];
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - collectionview 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    NSArray *array = self.data[section];
    return array.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
     UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if(_headVDefault){
            XDAutoresizeLabelFlowHeader *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
            headerV.indexPath = indexPath;
            headerV.haveDeleteBtn =  NO;
            headerV.titleString = [self.sectionData safeObjectAtIndex:indexPath.section] ? : @"";
            [headerV setlineViewShow: indexPath.section==0? NO:YES];
            headerV.deleteActionBlock = ^(NSIndexPath *indexPath) {
                if (self.deleteHandler) {
                    self.deleteHandler(indexPath);
                    [UIView performWithoutAnimation:^{
                             [self.collection reloadSections:[[NSIndexSet alloc] initWithIndex: indexPath.section]];
                        //刷新操作
                    }];
                    
                }
            };
            reusableview = headerV;
        }
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        //配置发布时间筛选
        if (indexPath.section == 2) {
            CollectionFooter *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
            footerV.indexPath = indexPath;
            BOOL canAddMaskBtn = YES;
            for(id v in footerV.subviews){
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn =v;
                    if(btn.tag ==2){
                        canAddMaskBtn = NO;
                    }
                }
            }
            if(canAddMaskBtn){
                UIButton *maskBtnV = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(footerV.frame), CGRectGetHeight(footerV.frame))];
                [maskBtnV setBackgroundColor:[UIColor clearColor]];
                maskBtnV.tag = indexPath.section;
                [maskBtnV addTarget:self action:@selector(showDatePicker:)];
                [footerV addSubview:maskBtnV];
            }
           //配置数据
           //当用户输入值时往cell上显示，没有值或清空时footerview的值也要清空
            XDAutoresizeLabelTitleModel *model= [self.data[indexPath.section] lastObject];
            if(![model.title isContainChinese]){
               NSArray *strAry = [model.title componentsSeparatedByString:@"-"];
               [footerV setStringtoStart:[strAry objectAtIndex:0] endString:[strAry objectAtIndex:1]];
            }else{
                  [footerV setStringtoStart:@"" endString:@""];
            }
             reusableview = footerV;
        }
        else if (indexPath.section == 4){   //配置标段金额估价
            CollectionFooter *footerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId forIndexPath:indexPath];
            footerV.indexPath = indexPath;
            footerV.startTF.delegate = self;
            footerV.endTF.delegate = self;
            //复用时删掉遮罩btn
            for(id v in footerV.subviews){
                if ([v isKindOfClass:[UIButton class]]) {
                    UIButton *btn =v;
                    [btn removeFromSuperview];
                }
            }
            //当用户输入值时往cell上显示，没有值或清空时footerview的值也要清空
            XDAutoresizeLabelTitleModel *model= [self.data[indexPath.section] lastObject];
            //当第一次点击自定义的时候，item上的字为“自定义”不含-，因此这个时候不需要加载数据到输入框
            if([model.title containsString:@"-"]){
                NSArray *strAry = [model.title componentsSeparatedByString:@"-"];
                //去掉最后一个万字
                NSString *endStr =[strAry objectAtIndex:1];
                [footerV setStringtoStart:[strAry objectAtIndex:0] endString:[endStr safeSubstringToIndex:endStr.length -1]];
            }else{
                [footerV setStringtoStart:@"" endString:@""];
            }
            reusableview = footerV;
        }
        else if(indexPath.section == self.data.count-1){
            CollectionFootBtnView *footerBtnV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerBtnId forIndexPath:indexPath];
            [footerBtnV.resetBtn addTarget:self action:@selector(footerBtnClicked:)];
            [footerBtnV.searchBtn addTarget:self action:@selector(footerBtnClicked:)];
            if (self.isCustomization) {
                 [footerBtnV.searchBtn setTitle:@"保存" forState:UIControlStateNormal];
            }
            footerBtnV.indexPath = indexPath;
            reusableview =footerBtnV;
        }
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDAutoresizeLabelFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    XDAutoresizeLabelTitleModel *model = self.data[indexPath.section][indexPath.item];
    [cell configCellWithTitle:model];
    if (self.selectMark) {

        cell.beSelected = model.selected;

    }else {
        cell.beSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0||indexPath.section==1||indexPath.section==3) {
        self.mutiSelectMark=YES;
        
    }
    else{
        self.mutiSelectMark=NO;
        
        if (indexPath.section == 2) {
              NSMutableArray *array= self.data[indexPath.section];
            if(indexPath.row == array.count-1){
                _layout.show_nt_starttime=YES;
                [self.collection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }
            else{
                _layout.show_nt_starttime=NO;
                [self.collection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }
        }
        else if (indexPath.section == 4){
            NSMutableArray *array= self.data[indexPath.section];
            if(indexPath.row == array.count-1){
                _layout.show_price=YES;
                [self.collection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }
            else{
                _layout.show_price=NO;
                [self.collection reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            }
        }
    }
    if (self.selectMark) {
        if(self.mutiSelectMark){
            NSMutableArray *array= self.data[indexPath.section];
            for(NSInteger n=0;n< array.count;n++){
                XDAutoresizeLabelTitleModel *m = array[n];
                if(indexPath.row ==n){
                    m.selected = !m.selected;
                }
            }
        }
        else{
            NSMutableArray *array=self.data[indexPath.section];
            for(NSInteger n=0;n< array.count;n++){
                XDAutoresizeLabelTitleModel *m = array[n];
                if(indexPath.row ==n){
                    m.selected =YES;
                }
                else
                {
                    m.selected = NO;
                }
            }
        }
    }
    if (self.handler) {
//        self.selectedItems = @[@[].mutableCopy].mutableCopy;
//        for ( XDAutoresizeLabelTitleModel *m in self.data[indexPath.section]) {
//            if (m.selected) {
//                [self.selectedItems[indexPath.section] addObject:m];
//
//            }
//        }
//        self.handler(indexPath, self.selectedItems);
    }
    [UIView performWithoutAnimation:^{
        [self.collection reloadSections:[[NSIndexSet alloc] initWithIndex: indexPath.section]];
        //刷新操作
    }];
}

#pragma mark - MSSAutoresizeLabelFlowLayout 代理方法
- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    XDAutoresizeLabelTitleModel *model = self.data[indexPath.section][indexPath.item];
    return model.title;
}

- (void)insertLabelWithTitle:(XDAutoresizeLabelTitleModel *)titleItem atIndex:(NSUInteger)index inSection:(NSUInteger)section animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
    
    [self.data[section] insertObject:titleItem atIndex:index];
    [self performBatchUpdatesWithAction:UICollectionUpdateActionInsert indexPaths:@[indexPath] animated:animated];
}

- (void)insertLabelsWithTitles:(NSArray *)titles atIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section animated:(BOOL)animated {
    NSArray *indexPaths = [self indexPathsWithIndexes:indexes inSection:section];
    [self.data[section] insertObjects:titles atIndexes:indexes];
    [self performBatchUpdatesWithAction:UICollectionUpdateActionInsert indexPaths:indexPaths animated:animated];
}

- (void)deleteLabelAtIndex:(NSUInteger)index inSection:(NSUInteger)section animated:(BOOL)animated {
    [self deleteLabelsAtIndexes:[NSIndexSet indexSetWithIndex:index] inSection:section animated:animated];
}

- (void)deleteLabelsAtIndexes:(NSIndexSet *)indexes inSection:(NSUInteger)section animated:(BOOL)animated {
    NSArray *indexPaths = [[[self indexPathsWithIndexes:indexes inSection:section] reverseObjectEnumerator] allObjects];
      NSMutableArray *array =[NSMutableArray arrayWithArray:self.data[section]];
    if (array.count>= indexPaths.count) {
        for (NSIndexPath *n in indexPaths ) {
            [array removeObjectAtIndex:n.row];
        }
        [self.data replaceObjectAtIndex:section withObject:array];
        
        [self performBatchUpdatesWithAction:UICollectionUpdateActionDelete indexPaths:indexPaths animated:animated];
    }
   
}

- (void)performBatchUpdatesWithAction:(UICollectionUpdateAction)action indexPaths:(NSArray *)indexPaths animated:(BOOL)animated {
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [self.collection performBatchUpdates:^{
        switch (action) {
            case UICollectionUpdateActionInsert:
                [self.collection insertItemsAtIndexPaths:indexPaths];
                break;
            case UICollectionUpdateActionDelete:
                [self.collection deleteItemsAtIndexPaths:indexPaths];
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if (!animated) {
            [UIView setAnimationsEnabled:YES];
        }
    }];
}

- (NSArray *)indexPathsWithIndexes:(NSIndexSet *)set inSection:(NSUInteger)section {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:set.count];
    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        [indexPaths addObject:indexPath];
    }];
    return [indexPaths copy];
}


@end

