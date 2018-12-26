//
//  ASWebDetailViewController.m
//  BiddingSearch
//
//  Created by 于风 on 2018/12/7.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASWebDetailViewController.h"

@interface ASWebDetailViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ASWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setupContentView{
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
   [self.currentNavigationController setTitleText:@"详情" viewController:self];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVIGATION_H, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT-NAVIGATION_H)];
    }
    return _webView;
}


@end
