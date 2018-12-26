//
//  ASRegisterPromiseDetailViewController.m
//  hxxdj
//
//  Created by aisino on 16/3/20.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASRegisterPromiseDetailViewController.h"

@interface ASRegisterPromiseDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webV;

@end

@implementation ASRegisterPromiseDetailViewController
@synthesize webV;
@synthesize webURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupContentView{
     [self.currentNavigationController setTitleText:@"用户注册协议" viewController:self];
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT - self.currentNavigationController.navigationBar.size.height - AS_STATUS_BAR_H)];
    webV.delegate = self;
    [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webURL]]];
    [webV setScalesPageToFit:YES];
    [self.view addSubview:webV];
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
