//
//  ASUserCenterViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASUserCenterViewController.h"
#import "UserCenterCell.h"

#import "ASMyCustomizationController.h"
#import "MySettingViewController.h"
#import "MyFavorListController.h"
#import "MyOrderController.h"
#import "MyHistoryListViewController.h"
#import "UserSettingController.h"

@interface ASUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDataList;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIButton *headImgBtn;
@property (nonatomic, strong) UILabel *nameL;

@end

@implementation ASUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupOtherConfig{
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UserCenterCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ASUSER_INFO_MODEL.isLogin) {
        switch (indexPath.row) {
            case 0:{//我的收藏
                   MyFavorListController *vc = [[MyFavorListController alloc] init];
                   [self toNextWithViewController:vc];
                }
                break;
            case 1:
            { //浏览历史
                MyHistoryListViewController *vc = [[MyHistoryListViewController alloc] init];
               [self toNextWithViewController:vc];
            }
                break;
            case 2:{//我的定制
                ASMyCustomizationController *vc = [[ASMyCustomizationController alloc] init];
               [self toNextWithViewController:vc];
            }
                break;
            case 3:{//我的账户
                MyOrderController *vc = [[MyOrderController alloc] init];
              [self toNextWithViewController:vc];
            }
                break;
                
            default:
                break;
        }
    }else{
        [self toLogin];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGRectGetHeight(self.headView.frame);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.tableDataList.count];
    return self.tableDataList.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserCenterCell cellIdentifier]];
    if (cell == nil) {
        cell = [[UserCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UserCenterCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.tableDataList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark selfMethod
- (void)loginAndLogOut{
     if(ASUSER_INFO_MODEL.isLogin){
        [self.nameL setText:ASUSER_INFO_MODEL.userName];
    }
    else {
        [self.nameL setText:@"请登录"];
    }
}

- (void)userNameTap{
    if(ASUSER_INFO_MODEL.isLogin){
      
    }
    else {
        [self toLogin];
    }
}
//系统设置
- (void)toSetting{
    if(ASUSER_INFO_MODEL.isLogin){
        MySettingViewController *vc =[[MySettingViewController alloc] init];
        [self toNextWithViewController:vc];
    }
    else{
        [self toLogin];
    }
}
//用户设置
- (void)toUserSetting{
    if(ASUSER_INFO_MODEL.isLogin){
        UserSettingController *vc =[[UserSettingController alloc] init];
        [self toNextWithViewController:vc];
    }
    else{
        [self toLogin];
    }
}

#pragma mark getter
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSMutableArray *)tableDataList{
    if(!_tableDataList){
        //我来组成数据，坑爹的
        _tableDataList = [NSMutableArray array];
        NSArray *titleAry = @[@"我的收藏",@"我的浏览",@"我的定制",@"我的账户"];
        NSArray *imageTextAry = @[@"\U0000e62b",@"\U0000e62c",@"\U0000e616",@"\U0000e66a"];
        NSArray *colorStart = @[@"#B5EB45",@"#FBD249",@"#88F3E2",@"#C32AFF"];
        NSArray *colorEnd = @[@"#7ED321",@"#F5A623",@"#50E3C2",@"#9013FE"];
        for (int n =0; n<titleAry.count; n++) {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            [dataDic setValue:[titleAry objectAtIndex:n] forKey:@"nameL"];
            [dataDic setValue:[imageTextAry objectAtIndex:n] forKey:@"imageL"];
            [dataDic setValue:[colorStart objectAtIndex:n] forKey:@"colorStart"];
            [dataDic setValue:[colorEnd objectAtIndex:n] forKey:@"colorEnd"];
            [_tableDataList addObject:dataDic];
        }
    }
    return _tableDataList;
}

-(UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, iPhoneX ? 160:140)];
        UIView *backv= [[UIView alloc]initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, iPhoneX ?140:120)];
        [backv setBackgroundColor:[UIColor whiteColor]];
        self.headImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, iPhoneX ? 43:23, 70, 70)];
        UIImageView *imgV = [[UIImageView alloc] init];
        [imgV sd_setImageWithURL:[NSURL URLWithString:ASUSER_INFO_MODEL.userImageUrl] placeholderImage:[UIImage imageNamed:@"headImg"]];
        [self.headImgBtn setBackgroundImage:imgV.image forState:UIControlStateNormal];
        self.headImgBtn.layer.borderColor = AS_MAIN_COLOR.CGColor;
        self.headImgBtn.layer.borderWidth = 1;
        self.headImgBtn.clipsToBounds = YES;
        self.headImgBtn.layer.cornerRadius = CGRectGetHeight(self.headImgBtn.frame)/2;
        [self.headImgBtn addTarget:self action:@selector(toUserSetting)];
        [backv addSubview: self.headImgBtn];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX( self.headImgBtn.frame)+20,  self.headImgBtn.frame.origin.y+CGRectGetHeight( self.headImgBtn.frame)/2 -11, AS_SCREEN_WIDTH-CGRectGetMaxX( self.headImgBtn.frame)- 40-40, 22)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userNameTap)];
        self.nameL.userInteractionEnabled = YES;
        [self.nameL addGestureRecognizer:tap];
        
        if(ASUSER_INFO_MODEL.isLogin){
            [self.nameL setText:ASUSER_INFO_MODEL.userName];
        }
        else {
            [self.nameL setText:@"请登录"];
        }
        [backv addSubview:self.nameL];
        
        UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameL.frame), self.headImgBtn.frame.origin.y, 40, 40)];
        [settingBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:28]];
        [settingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [settingBtn setTitle:@"\U0000e607" forState:UIControlStateNormal];
        [settingBtn addTarget:self action:@selector(toSetting)];
        [backv addSubview:settingBtn];
        [_headView addSubview:backv];
    }
    return _headView;
}


@end
