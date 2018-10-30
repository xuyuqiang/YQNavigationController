//
//  ViewController.m
//  YQNavigationController
//
//  Created by Xuyuqiang on 2018/10/30.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "ViewController.h"
#import "TransparentViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.yq_NavBarAlpha = @(1);
//    self.yq_NavBarTitleColor = [UIColor blackColor];
    self.yq_NavBarBarTintColor = [UIColor whiteColor];
//    self.yq_NavBarTintColor = [UIColor blackColor];
}

- (void)btnClick {
    TransparentViewController *vc = [[TransparentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
