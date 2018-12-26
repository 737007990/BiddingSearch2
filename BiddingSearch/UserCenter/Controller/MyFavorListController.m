//
//  MyFavorListController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/6.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyFavorListController.h"
#import "MyFavorListCell.h"
#import "MyFavorListOperation.h"
#import "ASBiddingDetailViewController.h"
@interface MyFavorListController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) MyFavorListOperation *myFavorListOperation;

@end

@implementation MyFavorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupOtherConfig{
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"我的收藏" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getListDataWithPageN:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myFavorListOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyFavorListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *itemDic = [self.tableDataList objectAtIndex:indexPath.row];
    ASBiddingDetailViewController *vc = [[ASBiddingDetailViewController alloc] init];
    vc.itemId = [itemDic nullToBlankStringObjectForKey:@"guid"];
   [self toNextWithViewController:vc];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyFavorListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyFavorListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MyFavorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyFavorListCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myFavorListOperation){
        if(self.myFavorListOperation.getResultList.count>0){
            self.myFavorListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.myFavorListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.myFavorListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.myFavorListOperation.size =10;
        self.myFavorListOperation.index = pageN;
        [self.myFavorListOperation requestStart];
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
            [weakself getListDataWithPageN:weakself.myFavorListOperation.index];
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

- (MyFavorListOperation *)myFavorListOperation{
    if(!_myFavorListOperation){
        _myFavorListOperation = [[MyFavorListOperation alloc]init];
    }
     _myFavorListOperation.delegate = self;
    return _myFavorListOperation;
}

@end
