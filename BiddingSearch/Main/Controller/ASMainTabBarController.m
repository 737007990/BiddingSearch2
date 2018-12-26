//
//  ASMainTabBarController.m
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#define ADD_IMAGE_W 20

#import "ASMainTabBarController.h"

#import "ASHomeViewController.h"
#import "ASServiceViewController.h"
#import "ASUserCenterViewController.h"
#import "ASTabBarView.h"
#import "UIView+Frame.h"


@interface ASMainTabBarController() <ASTabBarViewDelegate>
{
}
@property (nonatomic, strong) ASTabBarView *tabBarV;

@end

@implementation ASMainTabBarController

@synthesize tabBarV;

- (void)viewDidLoad {
    [super viewDidLoad];
//移动原点到navbar下方，暂不用
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBar.tintColor = AS_MAIN_COLOR;
    [self.currentNavigationController setTitleText:@"招投标大数据平台" viewController:self];
    self.tabBar.hidden = YES;
    tabBarV = [[ASTabBarView alloc] initWithFrame:CGRectMake(0, AS_SCREEN_HEIGHT -TABBAR_H, AS_SCREEN_WIDTH, TABBAR_H)];
    [tabBarV addTabBarButtonWithTitles:@[@"首页",@"消息",@"我的"]  ImageTexts:@[@"\U0000e7d5",@"\U0000e7f1",@"\U0000e7d6"] fillImageTexts:@[@"\U0000e7da",@"\U0000e80a",@"\U0000e7dd"]];
    tabBarV.delegate = self;
    [self.view addSubview:tabBarV];
}

-(ASNavigationController *)currentNavigationController {
    if (self.navigationController != nil && [self.navigationController isKindOfClass:[ASNavigationController class]]) {
        ASNavigationController * tempController = (ASNavigationController *)self.navigationController;
        return tempController;
    } else {
        return nil;
    }
}

#pragma mark ASTabBarViewDelegate
- (void)tabBar:(ASTabBarView *)tabBar didClickBtn:(NSInteger)index{
    [self setSelectedIndex:index-1];
    switch (index-1) {
        case 0:
            [self.currentNavigationController setTitleText:@"招投标大数据平台" viewController:self];
            break;
        case 1:
            [self.currentNavigationController setTitleText:@"服务" viewController:self];
            break;
        case 2:
            [self.currentNavigationController setTitleText:@"我的" viewController:self];
            break;
        default:
            break;
    }
}

#pragma mark selfMethod
- (void)dealloc {
    
}

@end
