//
//  AppDelegate.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/16.
//  Copyright © 2018 于风. All rights reserved.
//

#import "AppDelegate.h"
#import "ASGuideView.h"
#import "ASBiddingDetailViewController.h"
#import "ASLoginViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong) ASGuideView *guideView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.mainController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
    //切换正式和测试环境
    ASLOCATOR_MODEL.testModel = NO;
    //屏蔽或开启服务器返回数据log
    ASLOCATOR_MODEL.requestLogOut = YES;
    //显示或隐藏切换页面动画
    ASLOCATOR_MODEL.toBeACoolApp = KTestModel;
    //读取本地存储的用户信息
    ASUSER_INFO_MODEL.isHaveuserDicCacle;
    //键盘自动上弹界面
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    // Override point for customization after application launch.
    
    // 极光推送3.0.0及以后版本注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:ASAPP_INFO.pushAppKey
                          channel:ASAPP_INFO.pushChannelID
                 apsForProduction:KTestModel? 0:1
     ];
    
    //添加自定义消息通知
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //mob分享
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:ASAPP_INFO.qqAPPID appkey:ASAPP_INFO.qqAPPKEY];
        //微信
        [platformsRegister setupWeChatWithAppId:ASAPP_INFO.weixinAppId appSecret:ASAPP_INFO.weixinAppSecret];
    }];
    //微信支付
    //向微信注册,发起支付必须注册
    if(KTestModel){
           [WXApi registerApp:ASAPP_INFO.weixinAppId enableMTA:YES];
    }
    //启动引导页
    [self startUserguide];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *tokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString:@" " withString:@""];
    DMLog(@"apns -> 生成的devToken:%@", tokenStr);
    ASAPP_INFO.deviceTokenSring = tokenStr;
    ASAPP_INFO.deviceToken = deviceToken;
    //把deviceToken发送到我们的推送服务器
    //极光提交APNS注册后返回的deviceToken
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JPUSHService registerDeviceToken:ASAPP_INFO.deviceToken];
        ASAPP_INFO.jpushId = [JPUSHService registrationID];
        DMLog(@"get RegistrationID  %@",[JPUSHService registrationID]);
        [ASAPP_INFO uploadJPUSHRegistId];
    });
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    DMLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate
//自定义消息
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSNotification *notification1 =[NSNotification notificationWithName:ASLOCATOR_MODEL.DidRecevieMsg object:userInfo userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    DMLog(@"收到了自定义通知");
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    [self handleNotiWithNoti:notification];
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//这个警告是极光的错，没有更新api，我也没办法,可以屏蔽，但最好不要屏蔽，以免日后都不知道为什么崩了
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [self handleNotiWithNoti:response.notification];
     completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//统一处理通知消息
- (void)handleNotiWithNoti:(UNNotification *)noti{
    if([noti.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSDictionary * userInfo = noti.request.content.userInfo;
        [JPUSHService handleRemoteNotification:userInfo];
        //        远程通知
        NSString *msgType = [userInfo nullToBlankStringObjectForKey:@"user_message_type"];
        //判断是否是正确的推送格式
        if (msgType) {
            //判断登录
            if(ASUSER_INFO_MODEL.isLogin){
                switch (msgType.integerValue) {
                        //业务消息直接跳转到详情界面
                    case 1:{
                        NSString *item_id = [userInfo nullToBlankStringObjectForKey:@"item_id"];
                        ASBiddingDetailViewController *vc = [[ASBiddingDetailViewController alloc] init];
                        vc.itemId = item_id;
                        [self.mainController toNext:vc];
                    }
                        break;
                    case 2:
                        break;
                    default:
                        break;
                }
                //创建通知中心取消小圆点
                NSNotification *notification2 = [NSNotification notificationWithName:ASLOCATOR_MODEL.clearUnRead object:nil userInfo:userInfo];
                [[NSNotificationCenter defaultCenter] postNotification:notification2];
            }
            else{
                ASLoginViewController *vc = [[ASLoginViewController alloc] init];
                [self.mainController toNext:vc];
            }
        }
    }
    else {
        // 判断为本地通知
    }
}
#endif

// 支付宝NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //当是微信回调的时候
    if ([url.scheme hasPrefix:@"wx"])
    {   //微信支付的回调 分两种，一种是分享的回调，一种是支付的
        if ([url.absoluteString containsString:@"pay"]) {
            return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        else {
            
        }
    }
    else if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
             DMLog(@"result = %@",resultDic);
            //执行既定的支付回调方法,必须当前控制器是基于ASBaseViewController的才会有回调方法执行，因此所有本应用控制器都要基于ASBaseViewController
            ASBaseViewController *vc = (ASBaseViewController *)[ASCommonFunction getCurrentViewController];
            if([vc isKindOfClass:[ASBaseViewController class]]){
               [vc alipayResultMethod:resultDic];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            DMLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            DMLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

#pragma mark systemLifeCycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0) {
        NSNotification *notification1 =[NSNotification notificationWithName:ASLOCATOR_MODEL.bageAction object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
    }
    
    //网络变化与l用户登录的一些关系
    [ASLOCATOR_MODEL.manager startMonitoring];
    if(ASUSER_INFO_MODEL.isHaveuserDicCacle){
        if (ASUSER_INFO_MODEL.isLogin) {
             [ASUSER_INFO_MODEL loginWithToken];
        }
    }
    [ASAPP_INFO uploadJPUSHRegistId];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark selfMethod
-(void)startUserguide{
    NSString *key = @"CFBundleVersion";
    // 取出沙盒中存储的上次使用软件的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:key];
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion]) {
        _guideView = [[ASGuideView alloc] init];
        [self.window addSubview:_guideView];
        // 存储新版本
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
    }
}

@end
