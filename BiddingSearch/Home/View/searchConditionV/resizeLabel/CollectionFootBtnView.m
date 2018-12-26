//
//  CollectionFootBtnView.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/26.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CollectionFootBtnView.h"

@implementation CollectionFootBtnView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - 视图布局
- (void)createInterface {
    _resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-180, 10, 80, 40)];
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:_resetBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(CGRectGetHeight(_resetBtn.frame)/2, CGRectGetHeight(_resetBtn.frame)/2)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame=_resetBtn.bounds;
    maskLayer.path=maskPath.CGPath;
    _resetBtn.layer.mask=maskLayer;
    [_resetBtn setBackgroundColor:[UIColor hex:@"#76BAF1"]];
    _resetBtn.tag =1;
    [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_resetBtn.frame), _resetBtn.frame.origin.y, CGRectGetWidth(_resetBtn.frame), CGRectGetHeight(_resetBtn.frame))];
    UIBezierPath *maskPath1=[UIBezierPath bezierPathWithRoundedRect:_searchBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(CGRectGetHeight(_searchBtn.frame)/2, CGRectGetHeight(_searchBtn.frame)/2)];
    CAShapeLayer *maskLayer1=[[CAShapeLayer alloc]init];
    maskLayer1.frame=_searchBtn.bounds;
    maskLayer1.path=maskPath1.CGPath;
    _searchBtn.layer.mask=maskLayer1;
    [_searchBtn setBackgroundColor:AS_MAIN_COLOR];
    _searchBtn.tag=2;
    [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self addSubview:_resetBtn];
    [self addSubview:_searchBtn];
}



@end
