//
//  MyHistoryListViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyHistoryListViewController.h"
#import "MyHistoryListCell.h"
#import "MyHistoryListOperation.h"
#import "ASBiddingDetailViewController.h"

@interface MyHistoryListViewController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) MyHistoryListOperation *myHistoryListOperation;

@end

@implementation MyHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"我的浏览" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getListDataWithPageN:0];
}

- (void)setupOtherConfig{
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myHistoryListOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyHistoryListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyHistoryListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ASBiddingDetailViewController *vc = [[ASBiddingDetailViewController alloc] init];
    vc.itemId = cell.tenderInfoId;
    [self toNextWithViewController:vc];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyHistoryListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MyHistoryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyHistoryListCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myHistoryListOperation){
        if(self.myHistoryListOperation.getResultList.count>0){
            self.myHistoryListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.myHistoryListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.myHistoryListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.myHistoryListOperation.size =10;
        self.myHistoryListOperation.index = pageN;
        [self.myHistoryListOperation requestStart];
    }
}

#pragma mark getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        WeakSelf(self);
        [_tableView addFooterWithCallback:^{
            [weakself getListDataWithPageN:weakself.myHistoryListOperation.index];
        }];
        [_tableView addHeaderWithCallback:^{
            [weakself getListDataWithPageN:0];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)tableDataList{
    if(!_tableDataList){
        //我来组成数据，坑爹的
        _tableDataList = [NSMutableArray array];
    }
    return _tableDataList;
}

- (MyHistoryListOperation *)myHistoryListOperation{
    if(!_myHistoryListOperation){
        _myHistoryListOperation = [[MyHistoryListOperation alloc]init];
    }
      _myHistoryListOperation.delegate = self;
    return _myHistoryListOperation;
}

@end
