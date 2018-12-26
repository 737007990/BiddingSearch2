//
//  ImageBanner.h
//  zaibopian
//
//  Created by luxiqiang on 15/11/1.
//  Copyright © 2015年 luxq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJCBannerModel.h"

@class ImageBanner;

@protocol ImageBannerDelegate<NSObject>
@optional
-(void)didSelectImage:(ImageBanner *)imageBannerView AndSelectIndex:(NSInteger) selectIndex;

@end
@interface ImageBanner : UIView

@property (nonatomic,weak)id<ImageBannerDelegate> delegate;
@property (nonatomic,strong)NSArray * imageArray;
@property (nonatomic,assign)CGFloat autoScrollTimeInterval;
@property (nonatomic, strong) UIPageControl *pageControl;

-(instancetype)initWithFrame:(CGRect)frame AndWithImageArray:(NSArray *)imageArray;
+(instancetype)imageBannerWithFrame:(CGRect)frame AndWithImageArray:(NSArray *)imageArray;

- (void)reloadData:(NSMutableArray *)imageArray;
@end
