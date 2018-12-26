//
//  ASLaunchScreenViewController.m
//  hxxdj
//
//  Created by aisino on 16/3/21.
//  Copyright © 2016年 aisino. All rights reserved.
//

#import "ASLaunchScreenViewController.h"

@interface ASLaunchScreenViewController ()

@end

@implementation ASLaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imaV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AS_SCREEN_WIDTH, AS_SCREEN_HEIGHT)];
    [imaV setImage:[UIImage imageNamed:@"startImage"]];
    [self.view addSubview:imaV];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
