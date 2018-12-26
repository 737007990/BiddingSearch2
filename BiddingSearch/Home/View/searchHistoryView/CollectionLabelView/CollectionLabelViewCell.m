//
//  CollectionLabelViewCell.m
//  BiddingSearch
//
//  Created by 于风 on 2018/11/27.
//  Copyright © 2018 于风. All rights reserved.
//

#import "CollectionLabelViewCell.h"
#import "CollectionLabelFlowConfig.h"

@interface CollectionLabelViewCell ()

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CollectionLabelViewCell

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [CollectionLabelFlowConfig shareConfig].itemColor;
        _titleLabel.textColor = [CollectionLabelFlowConfig shareConfig].textColor;
        _titleLabel.font = [CollectionLabelFlowConfig shareConfig].textFont;
        _titleLabel.layer.cornerRadius = [CollectionLabelFlowConfig shareConfig].itemCornerRaius;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.borderColor = JKColor(180, 180, 180, 1.0).CGColor;
        _titleLabel.layer.borderWidth = 0.5;
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)configCellWithTitle:(CollectionLabelViewModel *)titleModel {
    self.titleLabel.frame = self.bounds;
    self.titleLabel.text = titleModel.title;
}

- (void)setBeSelected:(BOOL)beSelected {
    _beSelected = beSelected;
    if (beSelected) {
        self.titleLabel.backgroundColor = [CollectionLabelFlowConfig shareConfig].itemSelectedColor;
        self.titleLabel.textColor = [CollectionLabelFlowConfig shareConfig].textSelectedColor;
    }else {
        self.titleLabel.backgroundColor = [CollectionLabelFlowConfig shareConfig].itemColor;
        self.titleLabel.textColor = [CollectionLabelFlowConfig shareConfig].textColor;
    }
}

@end
