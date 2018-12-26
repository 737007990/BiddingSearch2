//
//  UIImage+Extension.h
//  gongchengbang
//
//  Created by YAS-Macmini2 on 15/9/14.
//  Copyright (c) 2015年 RaymondNi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+(UIImage *)resizeImage:(NSString *)imgName;

// 按指定尺寸 等比例压缩图片
+(UIImage *)scaleRatioWithImage:(UIImage*)image size:(CGSize)newSize;

// 按指定尺寸 压缩图片
+(UIImage*)scaleSimpleWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

// 图片由颜色值生成
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;

+(NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;

+(UIImage *)scaleImageImage:(UIImage *)image toKb:(NSInteger)kb;
@end
