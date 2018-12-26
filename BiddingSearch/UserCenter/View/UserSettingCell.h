//
//  UserSettingCell.h
//  BiddingSearch
//
//  Created by 于风 on 2018/12/19.
//  Copyright © 2018 于风. All rights reserved.
//

#import "ASTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSettingCell : ASTableViewCell
@property (nonatomic, strong) UILabel *subL;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *headV;
@property (nonatomic, strong) UISwitch *sw;
@end

NS_ASSUME_NONNULL_END
