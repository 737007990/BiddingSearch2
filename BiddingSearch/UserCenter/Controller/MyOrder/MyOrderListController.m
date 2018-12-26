//
//  MyOrderListController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MyOrderListController.h"
#import "MyOrderListCell.h"
#import "MyOrderListOperation.h"
#import "MyInvoiceInfoController.h"

#define SWITCH_H 50
@interface MyOrderListController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate,MyOrderListCellDelegate>
//容器与动画视图
@property (nonatomic, strong) UIView *headSwithV;
@property (nonatomic, strong) UIView *switchLine;
//数据展示
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
//切换列表按钮list
@property (nonatomic, strong) NSMutableArray *switchBtnAry;
//当前列表类型
@property (nonatomic, strong) NSString *switchType;

@property (nonatomic, strong) MyOrderListOperation *myOrderListOperation;
@end

@implementation MyOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"充值记录" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getListDataWithPageN:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myOrderListOperation.delegate = nil;
}

- (void)setupOtherConfig{
    [self.view addSubview:self.headSwithV];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyOrderListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyOrderListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MyOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyOrderListCell cellIdentifier]];
        cell.delegate =self;
    }
    cell.indexPath = indexPath;
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark MyOrderListCellDelegate
- (void)invoiceGetBtnClicked:(NSIndexPath *)indexPath{
    MyOrderListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    MyInvoiceInfoController *vc = [[MyInvoiceInfoController alloc] init];
    vc.orderId = cell.OrderId;
    [self toNextWithViewController:vc];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myOrderListOperation){
        if(self.myOrderListOperation.getResultList.count>0){
            self.myOrderListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.myOrderListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.myOrderListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.myOrderListOperation.size =10;
        self.myOrderListOperation.index = pageN;
        self.myOrderListOperation.invoice_state = self.switchType;
        [self.myOrderListOperation requestStart];
    }
}

- (void)switchBtnClicked:(UIButton *)btn{
    for (UIButton *b in self.switchBtnAry) {
        if (b.tag == btn.tag) {
            [b setTitleColor:AS_MAIN_COLOR forState:UIControlStateNormal];
        }else{
            [b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [_switchLine setFrame:CGRectMake((btn.tag -1)*(AS_SCREEN_WIDTH/2), SWITCH_H-1, AS_SCREEN_WIDTH/2, 1)];
    [UIView commitAnimations];
    _switchType = [NSString stringWithFormat:@"%ld",(long)btn.tag-1];
    DMLog(@"选择了%@",_switchType);
    [self getListDataWithPageN:0];
}

#pragma mark getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+SWITCH_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H-SWITCH_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        WeakSelf(self);
        [_tableView addFooterWithCallback:^{
            [weakself getListDataWithPageN:weakself.myOrderListOperation.index];
        }];
        [_tableView addHeaderWithCallback:^{
            [weakself getListDataWithPageN:0];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)tableDataList{
    if(!_tableDataList){
        //我来组成数据，
        _tableDataList = [NSMutableArray array];
    }
    return _tableDataList;
}
- (NSMutableArray *)switchBtnAry{
    if(!_switchBtnAry){
        //我来组成数据，
        _switchBtnAry = [NSMutableArray array];
    }
    return _switchBtnAry;
}
- (NSString *)switchType{
    if(!_switchType){
        //我来组成数据，
        _switchType = [NSString stringWithFormat:@"0"];
    }
    return _switchType;
}



- (UIView *)headSwithV{
    if(!_headSwithV){
        _headSwithV = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, SWITCH_H)];
        NSInteger total = 2;
        for (int n=0;n<total;n++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(n*(AS_SCREEN_WIDTH/2), 0, AS_SCREEN_WIDTH/2, SWITCH_H)];
            switch (n) {
                case 0:
                    [btn setTitleColor:AS_MAIN_COLOR forState:UIControlStateNormal];
                    [btn setTitle:@"未开票" forState:UIControlStateNormal];
                    break;
                case 1:
                    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [btn setTitle:@"已开票" forState:UIControlStateNormal];
                    break;
                    
                default:
                    break;
            }
            [btn addTarget:self tag:n+1 action:@selector(switchBtnClicked:)];
            [_headSwithV addSubview:btn];
            [self.switchBtnAry addObject:btn];
        }
        _switchLine = [[UIView alloc] initWithFrame:CGRectMake(0, SWITCH_H-1, AS_SCREEN_WIDTH/2, 1)];
        [_switchLine setBackgroundColor:AS_MAIN_COLOR];
        [_headSwithV addSubview:_switchLine];
    }
    return _headSwithV;
}

- (MyOrderListOperation *)myOrderListOperation{
    if(!_myOrderListOperation){
        _myOrderListOperation = [[MyOrderListOperation alloc]init];
    }
     _myOrderListOperation.delegate = self;
    return _myOrderListOperation;
}

@end
