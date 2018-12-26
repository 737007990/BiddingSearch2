//
//  ASHomeViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/17.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASHomeViewController.h"
#import "ImageBanner.h"
#import "HomeListCell.h"
#import "ASHomeSearchViewController.h"
#import "HomeBannerGetOperation.h"
#import "HomeListGetOperation.h"
#import "ASBiddingDetailViewController.h"
#import "ASWebDetailViewController.h"
#import "MySearchBar.h"

@interface ASHomeViewController ()<ImageBannerDelegate,UITableViewDelegate,UITableViewDataSource,ASBaseModelDelegate>
//轮播
@property (nonatomic, strong) ImageBanner *bannerView;
//轮播p图片数据容器
@property (nonatomic, strong) NSMutableArray *bannerArray;
//主table
@property (nonatomic, strong) UITableView *tableView;
//列表数据数组
@property (nonatomic, strong) NSMutableArray *homeTableList;
//俩请求
@property (nonatomic, strong) HomeBannerGetOperation *homeBannerGetOperation;
@property (nonatomic, strong) HomeListGetOperation *homeListGetOperation;
//搜索框背景容器
@property (nonatomic, strong) UIImageView *searchBacV;
//搜索框
@property (nonatomic, strong) MySearchBar *searchBar;
//搜索按钮
@property (nonatomic, strong) UIButton *searchBtn;


@end

@implementation ASHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupContentView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBacV];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if(self.homeTableList.count==0||self.bannerArray.count==0){
        [self.homeBannerGetOperation requestStart];
        [self getHomeListAtPage:0];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.homeBannerGetOperation.delegate=nil;
    self.homeListGetOperation.delegate=nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomeListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ASUSER_INFO_MODEL.isLogin) {
         HomeListCellModel *model = [self.homeTableList objectAtIndex:indexPath.row];
        ASBiddingDetailViewController *vc = [[ASBiddingDetailViewController alloc] init];
        vc.itemId = model.guid;
      [self toNextWithViewController:vc];
    }else{
         [self toLogin];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGRectGetHeight(self.bannerView.frame);
    }
    else {
        return 0.01;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (200>scrollView.contentOffset.y>0) {
        self.searchBacV.alpha =scrollView.contentOffset.y/200;
    }
}

#pragma mark UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.bannerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.homeTableList.count];
    return self.homeTableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[HomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HomeListCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.homeTableList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -ImageBannerDelegate 轮播图回调
- (void)didSelectImage:(ImageBanner *)imageBannerView AndSelectIndex:(NSInteger)selectIndex{
    HJCBannerModel *model = [self.bannerArray objectAtIndex:selectIndex];
    ASWebDetailViewController *vc = [[ASWebDetailViewController alloc] init];
    vc.url = model.url;
   [self toNextWithViewController:vc];
}

#pragma mark selfMethod 一些私有方法
- (void)toSearchV{
    ASHomeSearchViewController *vc=[[ASHomeSearchViewController alloc] init];
    [self.currentNavigationController pushViewController:vc animated:NO];
//   [self toNextWithViewController:vc];
}

- (void)getHomeListAtPage:(NSInteger)page{
    //有数据且列表数据大于等于请求到的数据总量则停止请求操作
    if(page>0&&(self.homeTableList.count>=self.homeListGetOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } else{
        //请求page为0时则清除所有数据，判定为刷新操作
        if(page==0){
            [self.homeTableList removeAllObjects];
            [self.tableView reloadData];
        }
        //其它正常操作，不请求成功不page++
        self.homeListGetOperation.index = page;
        self.homeListGetOperation.size=10;
        [self.homeListGetOperation requestStart];
    }
}

#pragma mark ASBaseModelDelegate 网络请求回调
- (void)request:(id)request successWithData:(id)data{
    if (request == self.homeBannerGetOperation) {
        self.bannerArray = self.homeBannerGetOperation.getResultList;
        [self.bannerView reloadData:self.bannerArray];
    } else if (request == self.homeListGetOperation){
        //请求成功则页数+1
        if(self.homeListGetOperation.getResultList.count>0){
            self.homeListGetOperation.index+=1;
        }
        [self.homeTableList addObjectsFromArray:self.homeListGetOperation.getResultList];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }
}

- (void)request:(id)request failedWithError:(id)error{

}

#pragma mark getter 获取各种对象lifecycle
- (ImageBanner *)bannerView {
    if (!_bannerView) {
        _bannerView = [[ImageBanner alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_WIDTH * 3 / 5) AndWithImageArray:self.bannerArray];
         [_bannerView addSubview:self.searchBtn];
    }
    _bannerView.delegate = self;
    return _bannerView;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)homeTableList {
    if (!_homeTableList) {
        _homeTableList = [NSMutableArray array];
    }
    return _homeTableList;
}

- (UITableView *)tableView{
    __weak typeof(self) weakSelf = self;
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - TABBAR_H) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        //根治tableview自动往状态栏下面跑的方法
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView addFooterWithCallback:^{
            [weakSelf getHomeListAtPage:weakSelf.homeListGetOperation.index];
           
        }];
           [_tableView addHeaderWithCallback:^{
                  [weakSelf getHomeListAtPage:0];
           }];
    }
    return _tableView;
}

- (HomeBannerGetOperation *)homeBannerGetOperation{
    if(!_homeBannerGetOperation){
        _homeBannerGetOperation = [[HomeBannerGetOperation alloc]init];
       
    }
     _homeBannerGetOperation.delegate = self;
    return _homeBannerGetOperation;
}

- (HomeListGetOperation *)homeListGetOperation{
    if(!_homeListGetOperation){
        _homeListGetOperation = [[HomeListGetOperation alloc]init];
    }
     _homeListGetOperation.delegate = self;
    return _homeListGetOperation;
}

- (UIButton *)searchBtn{
    if(!_searchBtn){
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(AS_SCREEN_WIDTH*0.85, 30, AS_SCREEN_WIDTH*0.1, AS_SCREEN_WIDTH*0.1)];
        _searchBtn.backgroundColor = [UIColor clearColor];
        [_searchBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:24]];
        [_searchBtn setTitle:@"\U0000e7e0" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(toSearchV)];
    }
    return _searchBtn;
}

- (UIImageView *)searchBacV{
    if(!_searchBacV){
        _searchBacV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
        _searchBacV.alpha = 0;
        [_searchBacV setImage:[UIImage imageNamed:@"nav_bar"]];
        _searchBacV.userInteractionEnabled=YES;
        _searchBar = [[MySearchBar alloc] initWithFrame: CGRectMake(20, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 40, 30)];
        _searchBar.placeholder = @"搜索";
        _searchBar.userInteractionEnabled = NO;
        [_searchBacV addSubview:_searchBar];
        UIButton *maskBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_searchBacV.frame), CGRectGetHeight(_searchBacV.frame))];
        [maskBtn setBackgroundColor:[UIColor clearColor]];
        [maskBtn addTarget:self action:@selector(toSearchV)];
        [_searchBacV addSubview:maskBtn];
    }
    return _searchBacV;
}




@end
