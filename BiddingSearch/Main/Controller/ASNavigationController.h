//
//  ASNavigationController.h
//  SheQuEJia
//
//  Created by 朱芳煦 on 16/1/12.
//  Copyright © 2016年 Aisino. All rights reserved.
//
//  NavigationController
//  功能描述：项目中使用的通用导航控制器

#import <UIKit/UIKit.h>

@interface ASNavigationController : UINavigationController

#pragma mark - Setter

-(void)setTitleText:(NSString *)text viewController:(UIViewController *)viewController;

-(void)setLeftText:(NSString *)text target:(UIViewController *)target action:(SEL)action isCustom:(BOOL)isCustom;

-(void)setRightText:(NSString *)text target:(UIViewController *)target action:(SEL)action isCustom:(BOOL)isCustom;

-(void)setLeftView:(UIView *)view target:(UIViewController *)target action:(SEL)action;

-(void)setRightView:(UIView *)view target:(UIViewController *)target action:(SEL)action;

#pragma mark - Navigation

-(void)toBack;

-(void)toRoot;

-(void)toNext:(UIViewController *)viewController;

#pragma mark - animation
//页面切换动画
- (void)pushViewController:(UIViewController *)viewController  animatedType:(NSString *)animatedType  animatedSubtype:(NSString *)animatedSubtype;
- (void)toBackWithAnimatedType:(NSString *)animatedType  animatedSubtype:(NSString *)animatedSubtype;

@end
