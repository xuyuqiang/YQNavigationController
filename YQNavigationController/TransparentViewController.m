//
//  TransparentViewController.m
//  testNav2
//
//  Created by Xuyuqiang on 2018/10/27.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "TransparentViewController.h"
#import "ViewController.h"

@interface TransparentViewController ()

@end

@implementation TransparentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yq_NavBarAlpha = @(0);
//    self.yq_NavBarTintColor = [UIColor whiteColor];
//    self.yq_NavBarBarTintColor = [UIColor orangeColor]; //不要设置
//    self.yq_NavBarTitleColor = [UIColor whiteColor];
}

- (void)btnClick {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
