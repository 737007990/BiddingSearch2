//
//  ASGuideView.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/3/10.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASGuideView.h"
#import "UIButton+HPExtension.h"

#define GUIDEIMAGENUMBER            3

@interface ASGuideView()
{
    UIScrollView *scrollView;
}
@end

@implementation ASGuideView

- (instancetype)init
{
    if(self = [super init])
    {
        self.frame = CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT);
        [self createContentView];
        [self createItems];
    }
    return self;
}

- (void)createContentView
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(AS_SCREEN_WIDTH * GUIDEIMAGENUMBER, AS_SCREEN_HEIGHT);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
}

- (void)createItems
{
    NSArray *images = images = @[[self getGuideImageforIndex:0],[self getGuideImageforIndex:1],[self getGuideImageforIndex:2]];
    for (int i = 0 ; i < images.count ; i++)
    {
        CGRect itemFrame = CGRectMake(AS_SCREEN_WIDTH * i, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT);
        UIImageView *imageItem = [[UIImageView alloc] initWithFrame:itemFrame];
        imageItem.image = images[i];
        [scrollView addSubview:imageItem];
    }
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake((GUIDEIMAGENUMBER-1) * AS_SCREEN_WIDTH + 100, AS_SCREEN_HEIGHT - 80, AS_SCREEN_WIDTH - 100 * 2, 45);
    commitBtn.layer.cornerRadius = 45/2;
    commitBtn.layer.masksToBounds = YES;
    commitBtn.backgroundColor = [UIColor hex:@"#46BBFF"];
    [commitBtn setTitle:@"立即体验" forState:UIControlStateNormal];

    [commitBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
    [commitBtn addTarget:self action:@selector(hideGuideView) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:commitBtn];
}

- (void)showGuideView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hideGuideView
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(2, 2);
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        self.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//这里的引导页是用小图拼凑生成的大图
- (UIImage *)getGuideImageforIndex:(NSInteger)imageIndex{
    UIImage *img = nil;
    UIView *imageBacV = [[UIView alloc] initWithFrame:self.frame];
    [imageBacV setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageBacV.frame)/7, CGRectGetWidth(imageBacV.frame), 33)];
    [titleL setTextColor:[UIColor hex:@"#5365EC"]];
    [titleL setFont:[UIFont systemFontOfSize:24]];
    [titleL setTextAlignment:NSTextAlignmentCenter];
    [imageBacV addSubview:titleL];
    
    UILabel *subL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleL.frame)+23, CGRectGetWidth(imageBacV.frame), 25)];
    [subL setTextColor:[UIColor hex:@"#5365EC"]];
    [subL setFont:[UIFont systemFontOfSize:18]];
    [subL setTextAlignment:NSTextAlignmentCenter];
    [imageBacV addSubview:subL];
    
    UIImageView *mainImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subL.frame)+52, CGRectGetWidth(imageBacV.frame), CGRectGetHeight(imageBacV.frame)*1/3)];
       [mainImgV setContentMode:UIViewContentModeScaleAspectFit];
    [imageBacV addSubview:mainImgV];
    switch (imageIndex) {
        case 0:
            [titleL setText:@"体验感升级"];
            [subL setText:@"企业、项目一键式管理"];
            [mainImgV setImage:[UIImage imageNamed:@"gm1"]];
            break;
        case 1:
            [titleL setText:@"视觉轻量化"];
            [subL setText:@"更简洁、更轻量"];
            [mainImgV setImage:[UIImage imageNamed:@"gm2"]];
            break;
        case 2:
            [titleL setText:@"定制化服务"];
            [subL setText:@"像会员一样定制基建"];
            [mainImgV setImage:[UIImage imageNamed:@"gm3"]];
            break;
            
        default:
            break;
    }
    
    UIImageView *p1 = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(imageBacV.frame)-60)/2, CGRectGetMaxY(mainImgV.frame)+50, 20, 8)];
    [p1 setImage:[UIImage imageNamed:imageIndex==0? @"gmp2.png":@"gmp1.png"]];
    [p1 setContentMode:UIViewContentModeScaleAspectFit];
      [imageBacV addSubview:p1];
    UIImageView *p2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(p1.frame), p1.frame.origin.y, 20, 8)];
    [p2 setImage:[UIImage imageNamed:imageIndex==1? @"gmp2.png":@"gmp1.png"]];
      [p2 setContentMode:UIViewContentModeScaleAspectFit];
     [imageBacV addSubview:p2];
    UIImageView *p3 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(p2.frame), p2.frame.origin.y, 20, 8)];
    [p3 setImage:[UIImage imageNamed:imageIndex==2? @"gmp2.png":@"gmp1.png"]];
      [p3 setContentMode:UIViewContentModeScaleAspectFit];
    [imageBacV addSubview:p3];
    img = [ASCommonFunction convertViewToImage:imageBacV];
    
    return img;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
