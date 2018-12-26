//
//  HJCAppShareViewController.m
//  HJCodification
//
//  Created by 卢希强 on 2018/2/28.
//  Copyright © 2018年 卢希强. All rights reserved.
//

#import "HJCAppShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface HJCAppShareViewController () 

@property (nonatomic, strong) UIImageView *QRImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *titleLabel1;

@property (nonatomic, strong) UILabel *titleLabel2;

@property (nonatomic, strong) UILabel *titleLabel3;

@property (nonatomic, strong) UILabel *titleLabel4;

@end

@implementation HJCAppShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupContentView{
    self.view.backgroundColor = [UIColor hex:@"#ffffff"];
    [self.view addSubview:self.QRImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.titleLabel1];
    [self.view addSubview:self.titleLabel2];
    [self.view addSubview:self.titleLabel3];
    [self.view addSubview:self.titleLabel4];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.QRImageView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [self.titleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel1.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [self.titleLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel2.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [self.titleLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel3.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.currentNavigationController setTitleText:@"分享" viewController:self];
    [self.currentNavigationController setRightText:@"\U0000e7ee" target:self action:@selector(shareBtnAction) isCustom:NO];
}

- (void)backBtnClcik:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - privite method
- (void)shareBtnAction{
    NSArray* imageArray = @[[UIImage imageNamed:@"QRCode.png"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"招投标大数据"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://app.fubangnet.com/hjebid/ipa/BiddingSearch.ipa"]
                                          title:@"招投标大数据"
                                           type:SSDKContentTypeAuto];
    //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
    [ShareSDK showShareActionSheet:nil
                       customItems:nil
                       shareParams:shareParams
                sheetConfiguration:nil
                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                [MBProgressHUD showSuccess:@"分享成功！" toView:self.view];
                break;
            }
            case SSDKResponseStateFail:
            {
                [MBProgressHUD showSuccess:@"分享失败！" toView:self.view];
                break;
            }
            default:
                break;
        }
    }];
  }
}

#pragma mark -getter
- (UIImageView *)QRImageView {
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCode"]];
        CGSize imageSize = [UIImage imageNamed:@"QRCode"].size;
        _QRImageView.frame = CGRectMake((AS_SCREEN_WIDTH - imageSize.width) / 2, NAVIGATION_H+40, imageSize.width, imageSize.height);
    }
    return _QRImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor hex:@"#4a4a4a"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"扫码下载招投标大数据APP";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)titleLabel1 {
    if (!_titleLabel1) {
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.textColor = [UIColor hex:@"#4a4a4a"];
        _titleLabel1.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel1.text = @"招投标大数据";
        _titleLabel1.textAlignment = NSTextAlignmentCenter;
        _titleLabel1.numberOfLines = 0;
    }
    return _titleLabel1;
}

- (UILabel *)titleLabel2 {
    if (!_titleLabel2) {
        _titleLabel2 = [[UILabel alloc] init];
        _titleLabel2.textColor = [UIColor hex:@"#4a4a4a"];
        _titleLabel2.font = [UIFont systemFontOfSize:17];
        _titleLabel2.text = @"【内容全面，分类清晰；全文检索，实时更新】";
        _titleLabel2.textAlignment = NSTextAlignmentCenter;
        _titleLabel2.numberOfLines = 0;
    }
    return _titleLabel2;
}

- (UILabel *)titleLabel3 {
    if (!_titleLabel3) {
        _titleLabel3 = [[UILabel alloc] init];
        _titleLabel3.textColor = [UIColor hex:@"4a4a4a"];
        _titleLabel3.font = [UIFont systemFontOfSize:17];
        _titleLabel3.text = @"招投标大数据APP，欢迎下载使用！";
        _titleLabel3.textAlignment = NSTextAlignmentCenter;
        _titleLabel3.numberOfLines = 0;
    }
    return _titleLabel3;
}

- (UILabel *)titleLabel4 {
    if (!_titleLabel4) {
        _titleLabel4 = [[UILabel alloc] init];
        _titleLabel4.textColor = [UIColor hex:@"#4a4a4a"];
        _titleLabel4.font = [UIFont systemFontOfSize:17];
        _titleLabel4.text = @"华杰也将持续推出更多“互联网+工程咨询产品”为大家服务，感谢您的关注和支持！";
        _titleLabel4.textAlignment = NSTextAlignmentCenter;
        _titleLabel4.numberOfLines = 0;
    }
    return _titleLabel4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
