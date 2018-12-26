//
//  ASServiceViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASServiceViewController.h"
#import "MyMsgListCell.h"
#import "MyMsgListOperation.h"
#import "ASBiddingDetailViewController.h"

#define SWITCH_H 50
@interface ASServiceViewController ()<UITableViewDelegate, UITableViewDataSource, ASBaseModelDelegate>
//容器与动画视图
@property (nonatomic, strong) UIView *headSwithV;
@property (nonatomic, strong) UIView *switchLine;
@property (nonatomic, strong) UILabel *pushRemindL;

//数据展示
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
//切换列表按钮list
@property (nonatomic, strong) NSMutableArray *switchBtnAry;
//当前列表类型
@property (nonatomic, strong) NSString *switchType;

@property (nonatomic, strong) MyMsgListOperation *myMsgListOperation;


@end

@implementation ASServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.currentNavigationController setTitleText:@"我的消息" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (ASUSER_INFO_MODEL.isLogin) {
       [self getListDataWithPageN:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.myMsgListOperation.delegate = nil;
}

- (void)setupOtherConfig{
    [self.view addSubview:self.headSwithV];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.pushRemindL];
}
//来回切换应用时会登录通知
- (void)loginAndLogOut{
     if (ASUSER_INFO_MODEL.isLogin) {
         WeakSelf(self);
         UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
         // 获取通知授权和设置
         [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
             if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
             {
                 DMLog(@"未选择");
             }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                 DMLog(@"未授权");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // UI更新代码
                    weakself.pushRemindL.alpha = 0.8;
                 });
             }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                 DMLog(@"已授权");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     // UI更新代码
                     weakself.pushRemindL.alpha = 0;
                 });
             }
         }];
     }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyMsgListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyMsgListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
    MyMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyMsgListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MyMsgListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MyMsgListCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.myMsgListOperation){
        if(self.myMsgListOperation.getResultList.count>0){
            self.myMsgListOperation.index+=1;
        }
        [self.tableDataList addObjectsFromArray:self.myMsgListOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)getListDataWithPageN:(NSInteger)pageN{
    if(pageN>0&&(self.tableDataList.count>=self.myMsgListOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else {
        if(pageN==0){
            [self.tableDataList removeAllObjects];
            [self.tableView reloadData];
        }
        self.myMsgListOperation.size =10;
        self.myMsgListOperation.index = pageN;
        self.myMsgListOperation.type = self.switchType;
        [self.myMsgListOperation requestStart];
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
    _switchType = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    DMLog(@"选择了%@",_switchType);
    [self getListDataWithPageN:0];
}

- (void)pushSettingSwitch:(UISwitch *)sw{
   
    
}

- (void)toPushSetting{
    if(kDeviceVersion>=10){
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success){
                
            }];
        } else {
            // Fallback on earlier versions
        }
    }
}

#pragma mark getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H+SWITCH_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H-SWITCH_H-TABBAR_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        WeakSelf(self);
        [_tableView addFooterWithCallback:^{
             if (ASUSER_INFO_MODEL.isLogin) {
                [weakself getListDataWithPageN:weakself.myMsgListOperation.index];
             }else{
                 [weakself.tableView footerEndRefreshing];
                 [weakself toLogin];
             }
        }];
        [_tableView addHeaderWithCallback:^{
            if (ASUSER_INFO_MODEL.isLogin) {
                 [weakself getListDataWithPageN:0];
            }
            else{
                [weakself.tableView headerEndRefreshing];
                [weakself toLogin];
            }
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
        _switchType = [NSString stringWithFormat:@"1"];
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
                    [btn setTitle:@"业务消息" forState:UIControlStateNormal];
                    break;
                case 1:
                    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [btn setTitle:@"系统消息" forState:UIControlStateNormal];
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

- (MyMsgListOperation *)myMsgListOperation{
    if(!_myMsgListOperation){
        _myMsgListOperation = [[MyMsgListOperation alloc]init];
    }
    _myMsgListOperation.delegate = self;
    return _myMsgListOperation;
}

- (UILabel *)pushRemindL{
    if(!_pushRemindL){
        _pushRemindL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame)-30, AS_SCREEN_WIDTH, 30)];
        _pushRemindL.alpha = 0;
        _pushRemindL.backgroundColor = [UIColor orangeColor];
        [_pushRemindL setTextColor:[UIColor whiteColor]];
        [_pushRemindL setTextAlignment:NSTextAlignmentCenter];
        _pushRemindL.userInteractionEnabled = YES;
        [_pushRemindL setText:@"点击前往开启推送"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPushSetting)];
        [_pushRemindL addGestureRecognizer:tap];
    }
    return _pushRemindL;
}

@end
