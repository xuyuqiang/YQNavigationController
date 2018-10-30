//
//  UnNavBarViewController.m
//  YQNavigationController
//
//  Created by Xuyuqiang on 2018/10/30.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "UnNavBarViewController.h"
#import "ViewController.h"
@interface UnNavBarViewController ()

@end

@implementation UnNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.yq_hidenNavBar = YES;
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
