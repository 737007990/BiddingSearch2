//
//  ASHomeSearchViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/20.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASHomeSearchViewController.h"
#import "HomeListCell.h"
#import "LCSearchHistoryView.h"
#import "SearchConditionView.h"
#import "SearchOperation.h"
#import "GetSearchConditionOperation.h"
#import "ASBiddingDetailViewController.h"

//搜索按钮占寬
#define SearchBtnWidth 100

@interface ASHomeSearchViewController ()<UITableViewDelegate,UITableViewDataSource,LCSearchHistoryViewDelegate,UITextFieldDelegate,ASBaseModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *searchTableList;
//侧滑搜索条件栏视图容器
@property (nonatomic, strong) UIView *searchSideV;
@property (nonatomic, strong) SearchConditionView *conditionView;
//主界面视图容器
@property (nonatomic, strong) UIView *mainView;
//遮罩点击返回视图
@property (nonatomic, strong) UIView *backView;

//返回按钮
@property (nonatomic, strong) UIButton *backBtn;
//搜索框相关组件
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIImageView *searchImage;
@property (nonatomic, strong) UIButton *searchConditionBtn;

//搜索历史视图
@property (nonatomic, strong) LCSearchHistoryView *searchHistoryView;
//条件搜索接口
@property (nonatomic, strong) SearchOperation *searchOperation;
//获取搜索条件选项接口
@property (nonatomic, strong) GetSearchConditionOperation *getSearchConditionOperation;



@end

@implementation ASHomeSearchViewController
{
      BOOL _menuShow;
      BOOL _isSearching;
      NSString *_searchStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupContentView{
    [self addSearchHeadView];
    [self.mainView addSubview:self.tableView];
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.backView];
    [self.view addSubview:self.searchHistoryView];
    [self.searchSideV addSubview:self.conditionView];
    [self.view insertSubview:self.searchSideV aboveSubview:self.backView];
//    [self.view addSubview:self.searchSideV];
    [self addPanGesture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self.getSearchConditionOperation requestStart];
}
- (void)viewWillDisappear:(BOOL)animated {
       [super viewWillDisappear:YES];
     self.searchOperation.delegate = nil;
     self.getSearchConditionOperation.delegate = nil;
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomeListCell getCellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ASUSER_INFO_MODEL.isLogin) {
        HomeListCellModel *model = [self.searchTableList objectAtIndex:indexPath.row];
        ASBiddingDetailViewController *vc = [[ASBiddingDetailViewController alloc] init];
        vc.itemId = model.guid;
        [self toNextWithViewController:vc];
    }else{
        [self toLogin];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        [tableView tableViewDisplayWitMsg:@"暂无数据" ifNecessaryForRowCount:self.searchTableList.count];
    return self.searchTableList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeListCell cellIdentifier]];
    if (cell == nil) {
        cell = [[HomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[HomeListCell cellIdentifier]];
    }
    [cell configCellWIthData:[self.searchTableList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchClick];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //开始编辑
    self.searchHistoryView.hidden = NO;
    [self.view bringSubviewToFront:self.searchHistoryView];
    _backBtn.hidden = YES;
    self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 17 - SearchBtnWidth, 30);
    self.searchImage.frame = CGRectMake(15, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 15 - SearchBtnWidth, 30);
    _isSearching = YES;
    [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.searchHistoryView reloadData:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];
    _searchConditionBtn.hidden=YES;
}

#pragma mark LCSearchHistoryViewDelegate
- (void)searchHistory:(NSString *)searchStr {
    self.searchTF.text = searchStr;
   [self searchClick];
}

#pragma mark ASBaseModelDelegate
- (void)request:(id)request successWithData:(id)data{
    if (request == self.searchOperation) {
        //请求成功则页数+1
        if(self.searchOperation.getResultList.count>0){
            self.searchOperation.index +=1;
        }
        [self.searchTableList addObjectsFromArray:self.searchOperation.getResultList];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self saveSearchHistory];
    }else if(request == self.getSearchConditionOperation){
        [self.conditionView configWithSearchCondition:self.getSearchConditionOperation.searchConditionViewModel];
      
        [self.searchHistoryView configViewsWith:self.getSearchConditionOperation.searchConditionViewModel.tag andKey:@"searchHistory"];
    }
}

- (void)request:(id)request failedWithError:(id)error{
    
}

#pragma mark selfMethod
- (void)toBack{
      if (_menuShow) {
            [self hiddenMenu];
      }
      else{
          [self.currentNavigationController popViewControllerAnimated:NO];
      }
}
//搜索取消按钮
- (void)cancelClick {
     if (_isSearching) {
        [self.view endEditing:YES];
        self.searchHistoryView.hidden = YES;
        _backBtn.hidden = NO;
        _isSearching = NO;
        self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 54 - SearchBtnWidth, 30);
        self.searchImage.frame = CGRectMake(52, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 52 - SearchBtnWidth, 30);
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        self.searchTF.text = _searchStr;
          _searchConditionBtn.hidden=NO;
    }
    else {
        [self.view endEditing:NO];
        [self.searchTF becomeFirstResponder];
        self.searchHistoryView.hidden = NO;
        [self.view bringSubviewToFront:self.searchHistoryView];
        _backBtn.hidden = YES;
        _isSearching = YES;
        self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 17 - SearchBtnWidth, 30);
        self.searchImage.frame = CGRectMake(15, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 15 - SearchBtnWidth, 30);
        [_searchBtn setTitle:@"取消" forState:UIControlStateNormal];
         _searchConditionBtn.hidden=YES;
       
    }
}

//搜索
- (void)searchClick {
    [self.view endEditing:YES];
    self.searchHistoryView.hidden = YES;
    
    _isSearching = NO;
    _backBtn.hidden = NO;
    _searchStr = self.searchTF.text;
    self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 54 - SearchBtnWidth, 30);
    self.searchImage.frame = CGRectMake(52, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 52 - SearchBtnWidth, 30);
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
   
     _searchConditionBtn.hidden=NO;
    [self getSearchResultListAtPage:0];
}
//请求搜索结果
- (void)getSearchResultListAtPage:(NSInteger)pageN{
    if(pageN>0&&(self.searchTableList.count>=self.searchOperation.total.integerValue)){
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    }else{
        if (pageN==0) {
            [self.searchTableList removeAllObjects];
            [self.tableView reloadData];
        }
        self.searchOperation.index =pageN;
        self.searchOperation.size=10;
        self.searchOperation.keyWord =self.searchTF.text;
        self.searchOperation.params = [self.conditionView getSelectedItem];
        [self.searchOperation requestStart];
   }
}

- (void)saveSearchHistory{
    if (self.searchTF.text.length > 0 && !self.searchTF.text.isBlankString) {
        NSMutableArray *searchDataArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchHistory"]];
        BOOL isRepeat = NO;//是否是重复搜索内容
        NSArray *tempArray = [NSArray arrayWithArray:searchDataArray];
        for (NSString *searchStr in tempArray) {
            if ([searchStr isEqualToString:self.searchTF.text]) {
                [searchDataArray removeObject:searchStr];
                [searchDataArray insertObject:self.searchTF.text atIndex:0];
                isRepeat = YES;
                continue;
            }
        }
        if (!isRepeat) {
            [searchDataArray insertObject:self.searchTF.text atIndex:0];
        }
        while (searchDataArray.count > 15) {
            [searchDataArray removeLastObject];
        }
        //保存
        NSArray *saveArray = [NSArray arrayWithArray:searchDataArray];
        [[NSUserDefaults standardUserDefaults] setObject:saveArray forKey:@"searchHistory"];
    }
}




#pragma mark - 添加边缘侧滑手势
- (void)addPanGesture {
    // 添加边缘手势
    UIScreenEdgePanGestureRecognizer *rightGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
     // 指定右缘滑动
    rightGes.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:rightGes];
      // 指定左边缘滑动
    UIPanGestureRecognizer *leftGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu:)];
    [self.backView addGestureRecognizer:leftGes];
    
}

- (void)showMenu:(UIScreenEdgePanGestureRecognizer *)pan {
    if (!_menuShow) {
        CGPoint p = [pan locationInView:self.view];
        self.mainView.frame = CGRectMake(p.x < AS_SCREEN_WIDTH * 0.2 ? -AS_SCREEN_WIDTH * 0.8 : p.x-AS_SCREEN_WIDTH,NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT-NAVIGATION_H);
        CGFloat searchSideVPointX =  p.x-AS_SCREEN_WIDTH * 0.2 ;
        self.searchSideV.frame = CGRectMake(searchSideVPointX > 0 ? p.x : AS_SCREEN_WIDTH * 0.2, 0, AS_SCREEN_WIDTH * 0.8, AS_SCREEN_HEIGHT);
        self.backView.alpha = 0.4 * (p.x > AS_SCREEN_WIDTH * 0.8 ?  AS_SCREEN_WIDTH-p.x: AS_SCREEN_WIDTH * 0.8) / AS_SCREEN_WIDTH;
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            if (p.x < AS_SCREEN_WIDTH * 0.5) {
                [self showMenu];
            }
            else {
                [self hiddenMenu];
            }
        }
    }
}

- (void)dismissMenu:(UIScreenEdgePanGestureRecognizer *)pan {
    if (_menuShow) {
        CGPoint p = [pan locationInView:self.view];
       
        self.mainView.frame = CGRectMake(p.x < AS_SCREEN_WIDTH * 0.2 ? -AS_SCREEN_WIDTH*0.8 : p.x-AS_SCREEN_WIDTH, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H);
        CGFloat searchSideVPointX = p.x-AS_SCREEN_WIDTH*0.2;
        self.searchSideV.frame = CGRectMake(searchSideVPointX > 0 ? p.x : AS_SCREEN_WIDTH * 0.2, 0, AS_SCREEN_WIDTH * 0.8, AS_SCREEN_HEIGHT);
        self.backView.alpha = 0.4 * (p.x > AS_SCREEN_WIDTH * 0.8 ?  AS_SCREEN_WIDTH-p.x: AS_SCREEN_WIDTH * 0.8) / AS_SCREEN_WIDTH;
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            if (p.x < AS_SCREEN_WIDTH * 0.5) {
                [self showMenu];
            }
            else {
                [self hiddenMenu];
            }
        }
    }
}

- (void)backViewTap:(UITapGestureRecognizer *)tap {
    if (_menuShow) {
        [self hiddenMenu];
    }
}

- (void)showMenu {
     __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.searchSideV.frame = CGRectMake(AS_SCREEN_WIDTH * 0.2, 0, AS_SCREEN_WIDTH * 0.8, AS_SCREEN_HEIGHT);
        weakSelf.mainView.frame = CGRectMake(-AS_SCREEN_WIDTH * 0.8, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H);
        weakSelf.backView.alpha = 0.4;
    } completion:^(BOOL finished) {
        weakSelf.backView.alpha = 0.4;
        self->_menuShow = YES;
    }];
}

- (void)hiddenMenu {
    [UIView animateWithDuration:0.2 animations:^{
        self.searchSideV.frame = CGRectMake(AS_SCREEN_WIDTH, 0, AS_SCREEN_WIDTH * 0.8, AS_SCREEN_HEIGHT);
        self.mainView.frame = CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.alpha = 0;
        self->_menuShow = NO;
    }];
}

- (void)showAndHideMenu{
   
    if (_menuShow) {
        [self hiddenMenu];
    }
    else{
        [self showMenu];
    }
}


#pragma mark getter
- (NSMutableArray *)searchTableList {
    if (!_searchTableList) {
        _searchTableList = [NSMutableArray array];
    }
    return _searchTableList;
}

- (void)addSearchHeadView {
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
    [headView setImage:[UIImage imageNamed:@"nav_bar"]];
    headView.userInteractionEnabled=YES;
    
    [self.view addSubview:headView];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"icon_return_press"] forState:UIControlStateHighlighted];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    [_backBtn setFrame:CGRectMake(0, iPhoneX ? 38 : 18, 44, 44)];
    [_backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_backBtn];
  
        self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 54 - SearchBtnWidth, 30);
        self.searchImage.frame = CGRectMake(52, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 52 - SearchBtnWidth, 30);
 
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(AS_SCREEN_WIDTH - SearchBtnWidth, iPhoneX ? 37 : 17, 60, 44);
   
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    
    [_searchBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_searchBtn];
    
    _searchConditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchConditionBtn.frame = CGRectMake(CGRectGetMaxX(_searchBtn.frame), iPhoneX ? 37 : 17, 40, 44);
    [_searchConditionBtn.titleLabel setFont:[UIFont fontWithName:@"iconfont" size:20]];
    [_searchConditionBtn setTitle:@"\U0000e69c" forState:UIControlStateNormal];
    
    [_searchConditionBtn addTarget:self action:@selector(showAndHideMenu) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_searchConditionBtn];
    
    [self.searchImage addSubview:self.searchTF];
    [headView addSubview:self.searchImage];
}

- (LCSearchHistoryView *)searchHistoryView {
    if (!_searchHistoryView) {
        _searchHistoryView = [[LCSearchHistoryView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - (NAVIGATION_H))];
        _searchHistoryView.delegate = self;
     
            _searchHistoryView.hidden = YES;
            _backBtn.hidden = NO;
            self.searchTF.frame = CGRectMake(2, 0, AS_SCREEN_WIDTH - 54 - SearchBtnWidth, 30);
            self.searchImage.frame = CGRectMake(52, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 52 - SearchBtnWidth, 30);
    }
    return _searchHistoryView;
}

- (UITableView *)tableView{
    __weak typeof(self) weakSelf = self;
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - NAVIGATION_H) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView addFooterWithCallback:^{
            [weakSelf getSearchResultListAtPage:weakSelf.searchOperation.index];
        }];
        [_tableView addHeaderWithCallback:^{
             [weakSelf getSearchResultListAtPage:0];
        }];
    }
    return _tableView;
}

-(UIView *)searchSideV{
    if(!_searchSideV){
        _searchSideV = [[UIView alloc] initWithFrame:CGRectMake(AS_SCREEN_WIDTH, 0, AS_SCREEN_WIDTH*0.8, CGRectGetHeight(self.view.frame))];
    }
    return _searchSideV;
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, CGRectGetHeight(self.view.frame)-NAVIGATION_H)];
        _mainView.backgroundColor = [UIColor colorWithRGB:(0xDCE7F3)];
    }
    return _mainView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, CGRectGetHeight(self.view.frame))];
        _backView.backgroundColor = [UIColor colorWithRGB:(0x000000)];
        _backView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewTap:)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (UIImageView *)searchImage {
    if (!_searchImage) {
        _searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, iPhoneX ? 45 : 25, AS_SCREEN_WIDTH - 15 - 60, 32)];
          _searchImage.image = [UIImage imageWithColor:[UIColor colorWithRGB:(0xffffff)]
                                                  size:CGSizeMake(AS_SCREEN_WIDTH - 72, 35)];
        _searchImage.layer.cornerRadius = 4.0f;
        [_searchImage.layer setMasksToBounds:YES];
        _searchImage.userInteractionEnabled = YES;
    }
    return _searchImage;
}


- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 2, AS_SCREEN_WIDTH - 12 - 60, 30)];
        _searchTF.placeholder = @"请输入关键字";
        [_searchTF setValue:[UIColor colorWithRGB:(0xa5a5a5)] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTF.textColor = [UIColor colorWithRGB:(0x666666)];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, 30, 30);
        leftBtn.userInteractionEnabled = NO;
        [leftBtn setImage:[UIImage imageNamed:@"Searchbar_icon"] forState:UIControlStateNormal];
        _searchTF.leftView = leftBtn;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.borderStyle = UITextBorderStyleNone;
        _searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _searchTF.keyboardType = UIKeyboardTypeDefault;
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.delegate = self;
    }
    return _searchTF;
}

- (SearchConditionView *)conditionView{
    WeakSelf(self);
    if(!_conditionView){
        _conditionView = [[SearchConditionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.searchSideV.frame), CGRectGetHeight(self.searchSideV.frame))];
        _conditionView.searchHander=^(){
            [weakself searchClick];
            [weakself hiddenMenu];
        };
    }
    return _conditionView;
}


- (SearchOperation *)searchOperation{
    if(!_searchOperation){
        _searchOperation = [[SearchOperation alloc] init];
    }
    _searchOperation.delegate = self;
    return _searchOperation;
}

- (GetSearchConditionOperation *)getSearchConditionOperation{
    if(!_getSearchConditionOperation){
        _getSearchConditionOperation = [[GetSearchConditionOperation alloc] init];
    }
    _getSearchConditionOperation.delegate = self;
    return _getSearchConditionOperation;
}


@end
