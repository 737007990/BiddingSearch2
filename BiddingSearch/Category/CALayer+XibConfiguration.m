//
//  CALayer+XibConfiguration.m
//  gongchengbang
//
//  Created by __Margin on 15/10/21.
//  Copyright © 2015年 RaymondNi. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)

-(void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
-(UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
