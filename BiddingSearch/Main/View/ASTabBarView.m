//
//  ASTabBarView.m
//  SheQuEJia
//
//  Created by 段兴杰 on 16/1/28.
//  Copyright © 2016年 Aisino. All rights reserved.
//

#import "ASTabBarView.h"


#define TABBAR_HEIGHT 49

@interface ASTabBarView ()

@property (nonatomic, strong) UILabel *messageNumsLabel;
@property (nonatomic, strong) NSArray *imgStrAry;
@property (nonatomic, strong) NSArray *imgFillStrAry;


@end


@implementation ASTabBarView
@synthesize delegate;
@synthesize messageNumsLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
        [lineV setBackgroundColor:[UIColor hex:@"#E1E1F1"]];
        lineV.layer.shadowColor=[UIColor lightGrayColor].CGColor;//设置阴影的颜色
        lineV.layer.shadowRadius=3;//设置阴影的宽度
        lineV.layer.shadowOffset=CGSizeMake(0, -2);//设置偏移
        lineV.layer.shadowOpacity=1;
        self.clipsToBounds=NO;
        [self addSubview:lineV];
    }
    return self;
}

//当视图销毁时注销这些通知接收
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASLOCATOR_MODEL.DidRecevieMsg object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASLOCATOR_MODEL.clearUnRead object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASLOCATOR_MODEL.loginNotistr object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASLOCATOR_MODEL.bageAction object:self];
}

- (void)addTabBarButtonWithTitles:(NSArray *)titles ImageTexts:(NSArray *)imageTexts fillImageTexts:(NSArray *)fillImageTexts{
    self.imgStrAry = imageTexts;
    self.imgFillStrAry=fillImageTexts;
    
    for (int n =0; n<titles.count; n++) {
        UIView *bacv = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)/titles.count)*n, 1, CGRectGetWidth(self.frame)/titles.count, TABBAR_H)];
        [bacv setBackgroundColor:AS_CONTROLLER_BACKGROUND_COLOR];
        UILabel * imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bacv.frame), TABBAR_HEIGHT/3*2)];
        [imageLabel setFont:[UIFont fontWithName:@"iconfont" size:25]];
        [imageLabel setText:[imageTexts objectAtIndex:n]];
        [imageLabel setTextAlignment:NSTextAlignmentCenter];
        
        //通知消息角标的配置
        switch (n) {
            case 1:{
                messageNumsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageLabel.frame)/2 +2, 4, 12,12)];
                messageNumsLabel.backgroundColor = [UIColor redColor];
                messageNumsLabel.font = [UIFont boldSystemFontOfSize:10];
                messageNumsLabel.textColor = [UIColor whiteColor];
                messageNumsLabel.layer.cornerRadius = 6;
                messageNumsLabel.clipsToBounds = YES;//切出圆角
                messageNumsLabel.textAlignment = NSTextAlignmentCenter;
                messageNumsLabel.hidden = YES;
                [imageLabel addSubview:messageNumsLabel];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:ASLOCATOR_MODEL.DidRecevieMsg object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNumsLabelHiddenAction:) name:ASLOCATOR_MODEL.clearUnRead object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLoginSuccessAction:) name:ASLOCATOR_MODEL.loginNotistr object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bageAction:) name:ASLOCATOR_MODEL.bageAction object:nil];
            }
                break;
            default:
                break;
        }

        [bacv addSubview:imageLabel];
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(imageLabel.frame), CGRectGetWidth(bacv.frame), TABBAR_HEIGHT/3)];
        [titleLabel setText:[titles objectAtIndex:n]];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [bacv addSubview:titleLabel];
        
        //首次显示第一个蓝色
        switch (n) {
            case 0:
                    [imageLabel setTextColor:AS_MAIN_COLOR];
                    [titleLabel setTextColor:AS_MAIN_COLOR];
                    [imageLabel setText:[self.imgFillStrAry objectAtIndex:n]];
                break;
            default:
                    [imageLabel setTextColor:[UIColor lightGrayColor]];
                    [titleLabel setTextColor:[UIColor lightGrayColor]];
                break;
        }

        UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bacv.frame), TABBAR_HEIGHT)];
        [itemBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        itemBtn.tag = n+1;
        [bacv addSubview:itemBtn];
        [self addSubview:bacv];
    }
}

#pragma mark 点击tabbar按钮的操作
- (void)itemBtnClicked:(UIButton *)sender{
    //当点击消息按钮时去掉角标
    switch (sender.tag) {
        case 2:
            [self messageNumsLabelHiddenAction:self];
            break;
        default:
            break;
    }
    //子视图数组的0位是一条灰色分界线，因此直接用tag值即可
    
    for (NSInteger n=1;n<self.subviews.count;n++) {
         UIView *v = [self.subviews objectAtIndex:n];
        if (n == sender.tag) {
            for ( id l in v.subviews) {
                if ([l isKindOfClass:[UILabel class]]) {
                    UILabel *lable = l;
                    if([lable.font.fontName isEqualToString:@"iconfont"]){
                        [lable setText:[self.imgFillStrAry objectAtIndex:sender.tag-1]];
                    }
                      [lable setTextColor:AS_MAIN_COLOR];
                }
            }
        }
        else {
            for (id l in v.subviews) {
                if ([l isKindOfClass:[UILabel class]]) {
                    [l setTextColor:[UIColor lightGrayColor]];
                     UILabel *lable = l;
                    if([lable.font.fontName isEqualToString:@"iconfont"]){
                        [lable setText:[self.imgStrAry objectAtIndex:n-1]];
                    }
                }
            }
        }
    }
    if ([delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
        [delegate tabBar:self didClickBtn:sender.tag];
    }
}

#pragma  mark selfMethod
//收到通知时动作，同步服务器传来的bage数，暂时屏蔽显示消息数
- (void)notificationAction:(NSNotification *)noti {
//    NSString *bageN = [[noti.userInfo nullToBlankStringObjectForKey:@"aps"] nullToBlankStringObjectForKey:@"badge"];
//    messageNumsLabel.text = [NSString stringWithFormat:@"%@",bageN];
    messageNumsLabel.hidden = NO;
    [UIApplication sharedApplication].applicationIconBadgeNumber = [messageNumsLabel.text integerValue];
}
//点击消息列表则清除bage，暂时屏蔽显示消息数
- (void)messageNumsLabelHiddenAction:(id)sender {
    messageNumsLabel.hidden = YES;
//    messageNumsLabel.text = @"0";
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
//当用户点击icon进入程序，则直接读bage数来确定未读消息
- (void)bageAction:(id)sender{
    messageNumsLabel.hidden = NO;
//    messageNumsLabel.text = [NSString stringWithFormat:@"%ld", (long)[UIApplication sharedApplication].applicationIconBadgeNumber];
}

- (void)notificationLoginSuccessAction:(id)sender {
    //判断登录成功后 是否有未读消息  以此来显示是否显示小圆点  后期功能 暂时保留
}


@end
