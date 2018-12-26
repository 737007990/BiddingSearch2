//
//  LCSearchHistoryView.m
//  learningCloud
//
//  Created by 卢希强 on 2017/3/27.
//  Copyright © 2017年 wxr. All rights reserved.
//

#import "LCSearchHistoryView.h"
#import "LCSearchHistoryTableViewCell.h"
#import "CollectionLabelView.h"
#import "CollectionLabelViewModel.h"
#define COLLECTION_H 100
#define HEAD_H 44
#define CELL_H 44

@interface LCSearchHistoryView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) CollectionLabelView *collectionLabelView;
@end

static NSString *LCSEARCHHISTORYCELL = @"LCSEARCHHISTORYCELL";
@implementation LCSearchHistoryView {
    NSString *_key;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xf5f5f5];
    }
    return self;
}

- (void)configViewsWith:(NSMutableArray *)labelArray andKey:(NSString *)key{
        NSMutableArray *tag=[NSMutableArray arrayWithArray:labelArray];
        for (NSInteger n=0; n<tag.count;n++) {
            NSDictionary *dic = [tag objectAtIndex:n];
            CollectionLabelViewModel *TitleModel = [[CollectionLabelViewModel alloc]init];
            TitleModel.title = [dic objectForKey:@"value"];
            TitleModel.titleId =  [dic objectForKey:@"id"];
            TitleModel.selected = NO;
            [tag replaceObjectAtIndex:n withObject:TitleModel];
        }
    WeakSelf(self);
    _collectionLabelView = [[CollectionLabelView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), COLLECTION_H) titles:@[tag] sectionTitle:@[@"热门搜索"] showSectionTitles:YES selectedHandler:^(NSIndexPath *indexPath, CollectionLabelViewModel *titleItems) {
        NSString *searchStr = titleItems.title;
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(searchHistory:)]) {
            [weakself.delegate searchHistory:searchStr];
        }
        [weakself.dataArray insertObject:searchStr atIndex:0];
        //保存数据
        NSArray *saveArray = [NSArray arrayWithArray:weakself.dataArray];
        [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:self->_key];
    }];
    _key = key;
    NSArray *dataArray = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    [self.dataArray removeAllObjects];
    for (NSString *searchStr in dataArray) {
        [self.dataArray addObject:searchStr];
    }
    [self addSubview:self.mainTableView];
    
}

#pragma mark -getter
- (UITableView *)mainTableView {
    if (!_mainTableView ) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, self.frame.size.height)];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.backgroundColor =[UIColor colorWithRGB:0xffffff];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerNib:[UINib nibWithNibName:@"LCSearchHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:LCSEARCHHISTORYCELL];
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -UITableViewDataSource
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyViewScroll)]) {
        [self.delegate historyViewScroll];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.dataArray.count];
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_H;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataArray.count <= 0) {
        return COLLECTION_H;
    }
    return COLLECTION_H +HEAD_H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, HEAD_H+COLLECTION_H)];
    headView.backgroundColor =  [UIColor colorWithRGB:(0xffffff)];
    
    [headView addSubview:_collectionLabelView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, HEAD_H+COLLECTION_H-1, AS_SCREEN_WIDTH - 24, 1)];
    lineView.backgroundColor =  [UIColor colorWithRGB:(0xf5f5f5)];
    [headView addSubview:lineView];
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15+COLLECTION_H, 150, 15)];
    searchLabel.text = (self.dataArray.count > 0) ? @"搜索历史" : @"暂无搜索历史";
    searchLabel.font = [UIFont systemFontOfSize:14];
    searchLabel.textAlignment = NSTextAlignmentLeft;
    [searchLabel setTextColor: [UIColor colorWithRGB:(0x999999)]];
    [headView addSubview:searchLabel];
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(AS_SCREEN_WIDTH - 60, COLLECTION_H, 60, 44);
    [clearBtn setBackgroundColor:[UIColor clearColor]];
    [clearBtn setTitle:@"清空历史" forState:UIControlStateNormal];
    [clearBtn setTitleColor: [UIColor colorWithRGB:(0x4fafec)] forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [clearBtn addTarget:self action:@selector(clearHistory:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:clearBtn];
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCSearchHistoryTableViewCell *searchHistoryCell = [tableView dequeueReusableCellWithIdentifier:LCSEARCHHISTORYCELL forIndexPath:indexPath];
    searchHistoryCell.titleLabel.text = self.dataArray[indexPath.row];
    searchHistoryCell.deleteBtn.tag = indexPath.row;
    [searchHistoryCell.deleteBtn addTarget:self action:@selector(deleteHistory:) forControlEvents:UIControlEventTouchUpInside];
    return searchHistoryCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchStr = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchHistory:)]) {
        [self.delegate searchHistory:searchStr];
    }
    [self.dataArray removeObject:searchStr];
    [self.dataArray insertObject:searchStr atIndex:0];
    //保存数据
    NSArray *saveArray = [NSArray arrayWithArray:self.dataArray];
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:_key];
}

#pragma mark -按钮点击事件
- (void)clearHistory:(UIButton *)sender {
    [self.dataArray removeAllObjects];
    //保存数据
    NSArray *saveArray = [NSArray arrayWithArray:self.dataArray];
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:_key];
    [self.mainTableView reloadData];
}

- (void)deleteHistory:(UIButton *)sender {
    //删除历史
    [self.dataArray removeObjectAtIndex:sender.tag];
    //保存数据
    NSArray *saveArray = [NSArray arrayWithArray:self.dataArray];
    [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:_key];
    [self.mainTableView reloadData];
}

- (void)reloadData:(NSArray *)dataArray {
    [self.dataArray removeAllObjects];
    for (NSString *searchStr in dataArray) {
        [self.dataArray addObject:searchStr];
    }
    [self.mainTableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
