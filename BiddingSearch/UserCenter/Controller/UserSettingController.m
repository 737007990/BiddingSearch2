//
//  UserSettingController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/19.
//  Copyright © 2018 于风. All rights reserved.
//

#import "UserSettingController.h"
#import "UserSettingCell.h"
#import "SetUserInfoOperation.h"

@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource,ASBaseModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) SetUserInfoOperation *setUserInfoOperation;

@end

@implementation UserSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupContentView{
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.currentNavigationController setTitleText:@"用户信息设置" viewController:self];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.setUserInfoOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UserSettingCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 3:{
            [self inputUserInfoWithType:indexPath.row];
        }
            break;
        case 4:{
           [self inputUserInfoWithType:indexPath.row];
        }
        default:
            [MBProgressHUD showError:@"暂未开放！" toView:self.view];
            break;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserSettingCell cellIdentifier]];
    if (cell == nil) {
        cell = [[UserSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserSettingCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    cell.headV.hidden = YES;
    cell.sw.hidden = YES;
    switch (indexPath.row) {
        case 0:
            cell.headV.hidden = NO;
            [cell.headV sd_setImageWithURL:[NSURL URLWithString:ASUSER_INFO_MODEL.userImageUrl] placeholderImage:[UIImage imageNamed:@"headImg"]];
            break;
        case 6:{
            cell.sw.hidden = NO;
            [cell.sw addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
            UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
            // 获取通知授权和设置
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
                {
                    DMLog(@"未选择");
                }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                    DMLog(@"未授权");
                    ASUSER_INFO_MODEL.pushOn = @"0";
                }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                    DMLog(@"已授权");
                    if (!ASUSER_INFO_MODEL.pushOn) {
                        ASUSER_INFO_MODEL.pushOn = @"1";
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    [cell.sw setOn:[ASUSER_INFO_MODEL.pushOn intValue]];
                });
            }];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark selfMethod
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

- (void)updateValue:(id)sender
{
    UISwitch *_mySwitch = (UISwitch *)sender;
    BOOL switchStatus = _mySwitch.on;
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    WeakSelf(self);
    //若是打开推送操作
    if (switchStatus) {
        // 获取通知授权和设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
            {
                DMLog(@"未选择");
            }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                DMLog(@"未授权");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    [_mySwitch setOn:[ASUSER_INFO_MODEL.pushOn intValue]];
                    [weakself toPushSetting];
                });
              
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                DMLog(@"已授权");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    weakself.setUserInfoOperation.userPushOn = _mySwitch.on? @"1":@"0";
                    [weakself.setUserInfoOperation requestStart];
                });
               
            }
        }];
    }
    //若是关闭推送操作
    else{
        // 获取通知授权和设置
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined)
            {
                DMLog(@"未选择");
            }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                DMLog(@"未授权");
            }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                DMLog(@"已授权");
                //回归主线程弹出ui
                 dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"关闭后将不再提醒消息" preferredStyle:UIAlertControllerStyleAlert];
                            [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                   [_mySwitch setOn:YES];
                            }]];
                            [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [_mySwitch setOn:NO];
                                    weakself.setUserInfoOperation.userPushOn = _mySwitch.on? @"1":@"0";
                                    [weakself.setUserInfoOperation requestStart];
                            }]];
                            [weakself presentViewController:vc animated:YES completion:nil];
                });
            }
        }];
    }
}
//弹框输入修改用户信息
- (void)inputUserInfoWithType:(NSInteger)typeN{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入" preferredStyle:UIAlertControllerStyleAlert];
    WeakSelf(self);
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                    UITextField*tf= alertController.textFields.firstObject;
                                                          if(!tf.text.isBlankString){
                                                              switch (typeN) {
                                                                  case 3:
                                                                      weakself.setUserInfoOperation.userName = tf.text;
                                                                      [weakself.setUserInfoOperation requestStart];
                                                                      break;
                                                                  case 4:
                                                                      if ([tf.text isValidEmail]) {
                                                                          weakself.setUserInfoOperation.userEmail = tf.text;
                                                                          [weakself.setUserInfoOperation requestStart];
                                                                      }
                                                                      else{
                                                                          [MBProgressHUD showError:@"请填写正确的邮箱地址！" toView:weakself.view];
                                                                      }
                                                                      break;
                                                                      
                                                                  default:
                                                                      break;
                                                              }
                                                          }
                                                          
                                                          
         }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField*textField) {
        textField.placeholder=@"请输入";
        
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if(request == self.setUserInfoOperation){
        //置空好刷新
        _tableDataList = nil;
        [self.tableView reloadData];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
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

- (NSMutableArray *)tableDataList{
    if(!_tableDataList){
        _tableDataList = [NSMutableArray array];
        NSArray *titleAry=@[@"头像",
                            @"手机号",
                            @"注册日期",
                            @"昵称",
                            @"e-mail",
                            @"QQ",
                            @"推送"];

        NSArray *subAry=@[@"",
                          ASUSER_INFO_MODEL.telephone? ASUSER_INFO_MODEL.telephone:@"",
                          @"",
                          ASUSER_INFO_MODEL.userName? ASUSER_INFO_MODEL.userName:@"",
                          ASUSER_INFO_MODEL.email? ASUSER_INFO_MODEL.email:@"",
                          ASUSER_INFO_MODEL.qq? ASUSER_INFO_MODEL.qq:@"",
                          @""];
        
        for (int n =0; n<titleAry.count; n++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[titleAry objectAtIndex:n],@"title",[subAry objectAtIndex:n],@"sub", nil];
            [_tableDataList addObject:dic];
        }
    }
    return _tableDataList;
}

- (SetUserInfoOperation *)setUserInfoOperation{
    if(!_setUserInfoOperation){
        _setUserInfoOperation = [[SetUserInfoOperation alloc]init];
    }
    _setUserInfoOperation.delegate = self;
    return _setUserInfoOperation;
}

@end
