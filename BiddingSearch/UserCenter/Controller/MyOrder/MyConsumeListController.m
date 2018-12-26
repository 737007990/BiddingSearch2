
//
//  MyConsumeListController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/11.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyConsumeListController.h"
#import "MyConsumeListOperation.h"
#import "MyConsumeListCell.h"

@interface MyConsumeListController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) MyConsumeListOperation *myConsumeListOperation;

@end

@implementation MyConsumeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"我的消费" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getListDataWithPageN:0];
}

- (void)setupOtherConfig{
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myConsumeListOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyConsumeListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MyConsumeListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyConsumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyConsumeListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MyConsumeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyConsumeListCell cellIdentifier]];
        
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myConsumeListOperation){
        if(self.myConsumeListOperation.getResultList.count>0){
            self.myConsumeListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.myConsumeListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.myConsumeListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.myConsumeListOperation.size =10;
        self.myConsumeListOperation.index = pageN;
        [self.myConsumeListOperation requestStart];
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
            [weakself getListDataWithPageN:weakself.myConsumeListOperation.index];
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

- (MyConsumeListOperation *)myConsumeListOperation{
    if(!_myConsumeListOperation){
        _myConsumeListOperation = [[MyConsumeListOperation alloc]init];
    }
    _myConsumeListOperation.delegate = self;
    return _myConsumeListOperation;
}

@end

