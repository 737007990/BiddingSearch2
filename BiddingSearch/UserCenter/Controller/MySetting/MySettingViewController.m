//
//  MySettingViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/5.
//  Copyright © 2018 于风. All rights reserved.
//

#import "MySettingViewController.h"
#import "MySettingCell.h"
#import "ResetPassWordController.h"
#import "HJCAppShareViewController.h"

@interface MySettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.currentNavigationController setTitleText:@"我的设置" viewController:self];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MySettingCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //检查更新
            [[HJCCheckUpdateManager shareInstance] checkUpdateBySelf];
        }
            break;
        case 3:{
            ResetPassWordController *vc = [[ResetPassWordController alloc] init];
         [self toNextWithViewController:vc];
         }
            break;
        case 4:{
            HJCAppShareViewController *vc = [[HJCAppShareViewController alloc] init];
          [self toNextWithViewController:vc];
        }
        default:
            [MBProgressHUD showSuccess:@"开发中。。。" toView:self.view];
            break;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGRectGetHeight(self.footerView.frame);
}

#pragma mark UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return self.footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MySettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[MySettingCell cellIdentifier]];
    if (cell == nil) {
        cell = [[MySettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MySettingCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark selfMethod
- (void)comfirmLogOut{
    WeakSelf(self);
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself logOut];
    }]];
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

//暂时屏蔽关于
- (NSMutableArray *)tableDataList{
    if(!_tableDataList){
        _tableDataList = [NSMutableArray array];
        NSArray *titleAry=@[@"应用更新",
//                            @"关于",
                            @"意见反馈",
                            @"使用帮助",
                            @"更改密码",
                            @"分享APP"];
        NSString *verStr=nil;
        if ([[HJCCheckUpdateManager shareInstance] isNewVersion]) {
           verStr = [NSString stringWithFormat:@"有新版本更新"];
        }
        else {
            verStr = [NSString stringWithFormat:@"当前版本V%@", [ASAppInfo shareAppInfo].appVersion];
        }
        NSArray *subAry=@[verStr,
//                          @"",
                          @"",
                          @"",
                          @"",
                          @""];
        
        for (int n =0; n<titleAry.count; n++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[titleAry objectAtIndex:n],@"title",[subAry objectAtIndex:n],@"sub", nil];
            [_tableDataList addObject:dic];
        }
    }
    return _tableDataList;
}

- (UIView *)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, 100)];
        UIButton *resignBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 40, AS_SCREEN_WIDTH-60, 46)];
        resignBtn.layer.cornerRadius = 23;
        resignBtn.layer.borderColor = AS_MAIN_COLOR.CGColor;
        resignBtn.layer.borderWidth = 1;
        resignBtn.clipsToBounds = YES;
        [resignBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [resignBtn setTitleColor:AS_MAIN_COLOR forState:UIControlStateNormal];
        [resignBtn addTarget:self action:@selector(comfirmLogOut)];
        resignBtn.userInteractionEnabled = YES;
        [_footerView addSubview:resignBtn];
    }
    return _footerView;
}

@end
