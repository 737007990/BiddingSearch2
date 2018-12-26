//
//  ASNavigationController.m
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASNavigationController.h"

#define AS_NAVIGATION_FONT_SIZE (17)

@interface ASNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate,CAAnimationDelegate>

@end

@implementation ASNavigationController

#pragma mark - ClassMethod

+(void)initialize {
    //导航背景单色设置暂时用不着
//    UINavigationBar * navigationBar = [UINavigationBar appearance];
//   [navigationBar setBarTintColor:AS_MAIN_COLOR];

}

#pragma mark - Init

#pragma mark - LiftCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *bacV= [[UIView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, NAVIGATION_H)];
    CAGradientLayer *Layer = [ASCommonFunction setGradualChangingColor:bacV fromColor:[UIColor hex:@"#4D00FD"] toColor:[UIColor hex:@"#1C92FF"]];
    [bacV.layer insertSublayer:Layer atIndex:0];
    //美工给了图片，在工程里没删，不太好用
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar"] forBarMetrics:UIBarMetricsDefault];
      [self.navigationBar setBackgroundImage:[ASCommonFunction convertViewToImage:bacV] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - SystemDelegate (UITableViewDataSource, UITableViewDelegate)

#pragma mark - CustomDelegate

#pragma mark - EventResponse

#pragma mark - PrivateMethods

#pragma mark - Navigations

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        [self setLeftText:[NSString stringWithFormat:@"\U0000e7ed返回"] target:viewController action:@selector(toBack) isCustom:NO];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController  animatedType:(NSString *)animatedType  animatedSubtype:(NSString *)animatedSubtype {
    if ([animatedType isEqualToString:@"no"]) {
        [self pushViewController:viewController animated:YES];
    } else if ([animatedType isEqualToString:@"view"]) {   // 定义 viewController.view 视图动画
        viewController.view.frame = CGRectMake(0.0f, -AS_SCREEN_HEIGHT, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT*2);
        [self pushViewController:viewController animated:NO];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.3];
        [UIView setAnimationDelegate:self];
        //controller.view.center = CGPointMake(160.0f, 240.0f);
        viewController.view.frame = CGRectMake(0.0f, 0.0f, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT);
        [UIView commitAnimations];
    } else {
        // 自定义动画
        CATransition *transition = [CATransition animation];
        // 动画时间
        transition.duration = 0.5f;
        // 动画时间控制
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        // 是否代理
        transition.delegate = self;
        // 是否在当前层完成动画
        // transition.removedOnCompletion = NO;
        //type
        //    1.pageCurl   向上翻一页
        //    2.pageUnCurl 向下翻一页
        //    3.rippleEffect 滴水效果
        //    4.suckEffect 收缩效果，如一块布被抽走
        //    5.cube 立方体效果
        //    6.oglFlip 上下翻转效果
        //subtype
        // kCATransitionPush:   Core Animation过渡，新视图将旧视图推出去。有4种方式 kCATransitionFromTop | kCATransitionFromLeft ｜ kCATransitionFromBottom | kCATransitionFromRight
        // 动画类型
        transition.type = animatedType;
        // 动画进入方式
        transition.subtype = animatedSubtype;
        [self pushViewController:viewController animated:NO];
        // 动画事件
        [self.view.layer addAnimation:transition forKey:nil];
    }
}

- (void)toBackWithAnimatedType:(NSString *)animatedType  animatedSubtype:(NSString *)animatedSubtype{
        // 自定义动画
        CATransition *transition = [CATransition animation];
        // 动画时间
        transition.duration = 0.5f;
        // 动画时间控制
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        // 是否代理
        transition.delegate = self;
        // 是否在当前层完成动画
        // transition.removedOnCompletion = NO;
    
        //type
        //    1.pageCurl   向上翻一页
        //    2.pageUnCurl 向下翻一页
        //    3.rippleEffect 滴水效果
        //    4.suckEffect 收缩效果，如一块布被抽走
        //    5.cube 立方体效果
        //    6.oglFlip 上下翻转效果
        //subtype
        // kCATransitionPush:   Core Animation过渡，新视图将旧视图推出去。有4种方式 kCATransitionFromTop | kCATransitionFromLeft ｜ kCATransitionFromBottom | kCATransitionFromRight
        
        // 动画类型
        transition.type = animatedType;
        // 动画进入方式
        transition.subtype = animatedSubtype;
       [self popViewControllerAnimated:NO];        // 动画事件
       [self.view.layer addAnimation:transition forKey:nil];
}

-(void)toBack {
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

-(void)toRoot {
    [self.view endEditing:YES];
    [self popToRootViewControllerAnimated:YES];
}

-(void)toNext:(UIViewController *)viewController {
    [self pushViewController:viewController animated:YES];
}

#pragma mark - Setter

-(void)setTitleText:(NSString *)text viewController:(UIViewController *)viewController {
    UILabel * titleLable = [[UILabel alloc] init];
    [titleLable setFont:[UIFont boldSystemFontOfSize:20]];
    [titleLable setTextColor:[UIColor whiteColor]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setText:text];
    [titleLable sizeToFit];
    viewController.navigationItem.titleView = titleLable;
}

-(void)setLeftText:(NSString *)text target:(UIViewController *)target action:(SEL)action isCustom:(BOOL)isCustom {
    [self setNavigationBarWithText:text target:target action:action dir:YES isCustom:isCustom];
}

-(void)setRightText:(NSString *)text target:(UIViewController *)target action:(SEL)action isCustom:(BOOL)isCustom {
    [self setNavigationBarWithText:text target:target action:action dir:NO isCustom:isCustom];
}

-(void)setLeftView:(UIView *)view target:(UIViewController *)target action:(SEL)action {
    [self setNavigationBarWithView:view target:target action:action dir:YES];
}

-(void)setRightView:(UIView *)view target:(UIViewController *)target action:(SEL)action {
    [self setNavigationBarWithView:view target:target action:action dir:NO];
}

-(void)setNavigationBarWithView:(UIView *)view target:(UIViewController *)target action:(SEL)action dir:(BOOL)isLeft {
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    if (isLeft) {
        target.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        target.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

-(void)setNavigationBarWithText:(NSString *)text target:(UIViewController *)target action:(SEL)action dir:(BOOL)isLeft isCustom:(BOOL)isCustom {
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    
    if (isCustom) {
        [barButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:AS_NAVIGATION_FONT_SIZE], NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    } else {
        [barButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"iconfont" size:AS_NAVIGATION_FONT_SIZE], NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    
    if (isLeft) {
        target.navigationItem.leftBarButtonItem = barButtonItem;
    } else {
        target.navigationItem.rightBarButtonItem = barButtonItem;
    }
}

#pragma mark - Getter
-(UIViewController *)childViewControllerForStatusBarStyle{
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden{
    return self.visibleViewController;
}
@end
