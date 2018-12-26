//
//  HJCCheckUpdateManager.m
//  HJCodification
//
//  Created by 卢希强 on 2018/1/3.
//  Copyright © 2018年 卢希强. All rights reserved.
//

#import "HJCCheckUpdateManager.h"
#import "HJCVersionModel.h"
#import <sys/utsname.h>

@implementation HJCCheckUpdateManager

+ (instancetype)shareInstance {
    static HJCCheckUpdateManager *shaerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!shaerInstance) {
            shaerInstance = [[self alloc] init];
        }
    });
    return shaerInstance;
}

- (BOOL)isNewVersion {
    //检测更新
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHECK_UPDATE] options:NSDataReadingUncached error:&error];
    if (jsonData) {
        NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        HJCVersionModel *versionModel = [HJCVersionModel yy_modelWithDictionary:dic];
        if ([self compareVersionOldVersion:nowVersion andNewVersion:versionModel.min_version_code]) {
            return YES;
        }
        else {
            if ([self compareVersionOldVersion:nowVersion andNewVersion:versionModel.version_name]) {
                return YES;
            }
            return NO;
        }
    }
    return NO;
}

- (void)checkUpdate {
    //检测更新
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHECK_UPDATE] options:NSDataReadingUncached error:&error];
    if (jsonData) {
        NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        HJCVersionModel *versionModel = [HJCVersionModel yy_modelWithDictionary:dic];
        if ([self compareVersionOldVersion:nowVersion andNewVersion:versionModel.min_version_code]) {
            DMLog(@"强制更新");
            [self mustUpdateTip:versionModel.update_url andMessage:versionModel.version_info];
        }
        else {
            if ([self compareVersionOldVersion:nowVersion andNewVersion:versionModel.version_name]) {
                DMLog(@"需要更新");
                [self updateTip:versionModel.update_url andMessage:versionModel.version_info];
            }
        }
    }
}

#pragma mark - 手动检测更新
- (void)checkUpdateBySelf {
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:CHECK_UPDATE] options:NSDataReadingUncached error:&error];
    if (jsonData) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
        HJCVersionModel *versionModel = [HJCVersionModel yy_modelWithDictionary:dic];
        if ([self compareVersionOldVersion:[ASAppInfo shareAppInfo].appVersion andNewVersion:versionModel.version_name]) {
            DMLog(@"需要更新");
            [self updateTip:versionModel.update_url andMessage:versionModel.version_info];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已是最新版本" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:confirmAction];
            [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:alertController animated:YES completion:nil];
        }
    }
}

//比较两个版本号大小 yes:需要更新 no：不需要更新
- (BOOL)compareVersionOldVersion:(NSString *)oldVersion andNewVersion:(NSString *)newVersion {
    NSArray *oldArray = [oldVersion componentsSeparatedByString:@"."];
    NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
    NSInteger count = (oldArray.count < newArray.count) ? oldArray.count : newArray.count;
    for (int i = 0; i < count; i++) {
        if ([oldArray[i] integerValue] > [newArray[i] integerValue]) {
            return NO;
        }
        if ([oldArray[i] integerValue] < [newArray[i] integerValue]) {
            return YES;
        }
    }
    if (oldArray.count < newArray.count) {
        for (NSInteger j = oldArray.count; j < newArray.count; j ++) {
            NSInteger k = [newArray[j] integerValue];
            if (k >= 1) {
                return YES;
            }
        }
        return NO;
    }
    else {
        return NO;
    }
}

//更新提醒
- (void)updateTip:(NSString *)url andMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到新版本" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"下次提醒" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success){}];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:alertController animated:YES completion:nil];
}

//强制更新提醒
- (void)mustUpdateTip:(NSString *)url andMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到新版本" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success){}];
        exit(1);
    }];
    [alertController addAction:confirmAction];
    [[[[UIApplication sharedApplication] delegate] window].rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)getViewUrlLastStr {
    NSString *str;
    if (ASUSER_INFO_MODEL.token) {
        str = [NSString stringWithFormat:@"&token=%@&os=iOS%@&version_name=%@&mobile_mode=%@&manufacturer=%@",ASUSER_INFO_MODEL.token, [[UIDevice currentDevice] systemVersion], [ASAppInfo shareAppInfo].appVersion, [self iphoneType], @"apple"];
    }
    else {
        str = [NSString stringWithFormat:@"&os=iOS%@&version_name=%@&mobile_mode=%@&manufacturer=%@",[[UIDevice currentDevice] systemVersion], [ASAppInfo shareAppInfo].appVersion, [self iphoneType], @"apple"];
    }
    return str;
}

- (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone6Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone6sPlus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhoneSE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone7Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPodTouch1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPodTouch2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPodTouch3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPodTouch4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPodTouch5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPadPro12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPadPro12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhoneSimulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhoneSimulator";
    
    return platform;
    
}

@end
