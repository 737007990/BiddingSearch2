//
//  ASMyCustomizationController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/4.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASMyCustomizationController.h"
#import "CustomizationItemCell.h"
#import "ASAddCustomizationController.h"
#import "GetCustomizationListOperation.h"
#import "DeleteCustomizationOperation.h"

@interface ASMyCustomizationController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate,CustomizationItemCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;

@property (nonatomic, strong) UIButton *customizationBtn;
//获取定制列表
@property (nonatomic, strong) GetCustomizationListOperation *getCustomizationListOperation;
//删除定制项目
@property (nonatomic, strong) DeleteCustomizationOperation *deleteCustomizationOperation;

@end

@implementation ASMyCustomizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupOtherConfig{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.customizationBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"我的定制" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getListDataWithPageN:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.getCustomizationListOperation.delegate=nil;
    self.deleteCustomizationOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [CustomizationItemCell getCellH];
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
    CustomizationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:[CustomizationItemCell cellIdentifier]];
    if (cell == nil) {
        cell = [[CustomizationItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CustomizationItemCell cellIdentifier]];
        cell.delegate = self;
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark CustomizationItemCellDelegate
- (void)deletBtnClickWithItemId:(NSString *)itemId{
    WeakSelf(self);
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"删除" message:@"确定要删除该定制条目吗？" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakself.deleteCustomizationOperation.deleteId = itemId;
        [weakself.deleteCustomizationOperation requestStart];
    }]];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.getCustomizationListOperation){
        if(self.getCustomizationListOperation.getResultList.count>0){
            self.getCustomizationListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.getCustomizationListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
    else if(self.deleteCustomizationOperation){
        [MBProgressHUD showSuccess:@"删除成功！" toView:self.view];
        [self getListDataWithPageN:0];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)toAddCustomization{
    ASAddCustomizationController *vc = [[ASAddCustomizationController alloc]init];
    [self toNextWithViewController:vc];
}

- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.getCustomizationListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.getCustomizationListOperation.size =10;
        self.getCustomizationListOperation.index = pageN;
        [self.getCustomizationListOperation requestStart];
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
            [weakself getListDataWithPageN:weakself.getCustomizationListOperation.index];
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
- (UIButton *)customizationBtn{
    if(!_customizationBtn){
        _customizationBtn = [[UIButton alloc]initWithFrame:CGRectMake(AS_SCREEN_WIDTH-70, AS_SCREEN_HEIGHT-100, 50, 50)];
        [_customizationBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:30]];
        [_customizationBtn setTitle:@"\U0000e767" forState:UIControlStateNormal];
        _customizationBtn.layer.cornerRadius= 25;
        _customizationBtn.clipsToBounds = YES;
        CAGradientLayer *layer = [ASCommonFunction setVerticalGradualChangingColor:_customizationBtn fromColor:[UIColor hex:@"#6EB3EE"] toColor:[UIColor hex:@"#3878D9"]];
        [_customizationBtn.layer insertSublayer:layer atIndex:0];
        [_customizationBtn addTarget:self action:@selector(toAddCustomization)];
    }
    return _customizationBtn;
}

- (GetCustomizationListOperation *)getCustomizationListOperation{
    if(!_getCustomizationListOperation){
        _getCustomizationListOperation = [[GetCustomizationListOperation alloc]init];
    }
      _getCustomizationListOperation.delegate = self;
    return _getCustomizationListOperation;
}

- (DeleteCustomizationOperation *)deleteCustomizationOperation{
    if(!_deleteCustomizationOperation){
        _deleteCustomizationOperation = [[DeleteCustomizationOperation alloc] init];
    }
    _deleteCustomizationOperation.delegate = self;
    return _deleteCustomizationOperation;
}
@end
