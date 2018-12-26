//
//  CollectionLabelView.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CollectionLabelView.h"
#import "CollectionLabelViewFlowLayout.h"
#import "CollectionLabelViewCell.h"
#import "CollectionLabelFlowConfig.h"
#import "CollectionLabelHeader.h"
static NSString *const cellId = @"cellId";
static NSString *const headerId = @"flowHeaderID";

@interface CollectionLabelView () <UICollectionViewDataSource, UICollectionViewDelegate, CollectionLabelViewFlowLayoutDataSource>

@property (nonatomic,strong) UICollectionView   *collection;
@property (nonatomic,strong) NSArray            *sectionData;
@property (nonatomic,assign) NSInteger numberCount;
@property (nonatomic,copy)   selectedHandler  handler;
@property (nonatomic,strong) NSMutableArray     *data;//总数据源，不建议直接修改

@property (nonatomic, strong) CollectionLabelViewFlowLayout *layout;

@property (nonatomic, assign) BOOL headVDefault; //拥有默认的section头部样式

@end

@implementation CollectionLabelView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles sectionTitle:(NSArray *)sectionTitle  showSectionTitles:(BOOL)showSection selectedHandler:(nonnull selectedHandler)handler  {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        if (!titles) {
            self.data = @[@[]].mutableCopy;
        }
        else {
            self.data = titles.mutableCopy;
        }
        self.sectionData = sectionTitle;
        
        self.headVDefault = showSection;
        self.handler = handler;
        [self setup];
    }
    return self;
}

- (void)setup {
    _layout = [[CollectionLabelViewFlowLayout alloc] init];
    _layout.dataSource = self;
    _layout.headVDefault= self.headVDefault;
   
    self.collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    self.collection.backgroundColor = [CollectionLabelFlowConfig shareConfig].backgroundColor;
    
    self.collection.allowsMultipleSelection = YES;
    self.collection.scrollEnabled = YES;
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerClass:[CollectionLabelHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
  
    
    [self.collection registerClass:[CollectionLabelViewCell class] forCellWithReuseIdentifier:cellId];
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
           CollectionLabelHeader *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
            headerV.indexPath = indexPath;
            headerV.haveDeleteBtn = NO;
            headerV.titleString = [self.sectionData safeObjectAtIndex:indexPath.section] ? : @"";
            headerV.deleteActionBlock = ^(NSIndexPath *indexPath) {
            };
            reusableview = headerV;
        }
    }
    else if (kind == UICollectionElementKindSectionFooter) {
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionLabelViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
   CollectionLabelViewModel *model = self.data[indexPath.section][indexPath.item];
    [cell configCellWithTitle:model];
    if (self.selectMark) {
        
        cell.beSelected = model.selected;
        
    }else {
        cell.beSelected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectMark) {
        if(self.mutiSelectMark){
            NSMutableArray *array= self.data[indexPath.section];
            for(NSInteger n=0;n< array.count;n++){
                CollectionLabelViewModel *m = array[n];
                if(indexPath.row ==n){
                    m.selected = !m.selected;
                }
            }
        }
        else{
            NSMutableArray *array=self.data[indexPath.section];
            for(NSInteger n=0;n< array.count;n++){
               CollectionLabelViewModel *m = array[n];
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
        CollectionLabelViewModel *model = self.data[indexPath.section][indexPath.row];
       self.handler(indexPath, model);
    }
    [UIView performWithoutAnimation:^{
        [self.collection reloadSections:[[NSIndexSet alloc] initWithIndex: indexPath.section]];
        //刷新操作
    }];
}

#pragma mark - MSSAutoresizeLabelFlowLayout 代理方法
- (NSString *)titleForLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionLabelViewModel *model = self.data[indexPath.section][indexPath.item];
    return model.title;
}

- (void)insertLabelWithTitle:(CollectionLabelViewModel *)titleItem atIndex:(NSUInteger)index inSection:(NSUInteger)section animated:(BOOL)animated {
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

