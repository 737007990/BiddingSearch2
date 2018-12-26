//
//  CollectionFooter.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/26.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CollectionFooter.h"
@interface CollectionFooter ()


@end

@implementation CollectionFooter
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
    _startTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, (CGRectGetWidth(self.frame)-60)/2, 30)];
    _startTF.layer.borderColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0  alpha:1.0].CGColor;
    [_startTF setKeyboardType:UIKeyboardTypeNumberPad];
    _startTF.layer.borderWidth = 0.5;
    _startTF.layer.cornerRadius= 15;
    _startTF.tag = STARTTEXT_TAG;
    [_startTF setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_startTF.frame), _startTF.frame.origin.y, 20, CGRectGetHeight(_startTF.frame))];
    [lineL setText:@"一"];
    [lineL setTextColor:[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0  alpha:1.0]];
    [lineL setTextAlignment:NSTextAlignmentCenter];
                                                               
    _endTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineL.frame), _startTF.frame.origin.y, CGRectGetWidth(_startTF.frame), CGRectGetHeight(_startTF.frame))];
    _endTF.layer.borderColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0  alpha:1.0].CGColor;
    [_endTF setKeyboardType:UIKeyboardTypeNumberPad];
    _endTF.layer.borderWidth = 0.5;
    _endTF.layer.cornerRadius=15;
    _endTF.tag = ENDTEXT_TAG;
    [_endTF setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_startTF];
    [self addSubview:lineL];
    [self addSubview:_endTF];
    
}

- (void)setStringtoStart:(NSString *)startStr endString:(NSString *)endString{
    [_startTF setText:startStr];
    [_endTF setText:endString];
}



@end
