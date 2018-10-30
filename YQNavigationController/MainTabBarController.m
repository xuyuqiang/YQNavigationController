//
//  MainTabBarController.m
//  CFer
//
//  Created by 徐宇强 on 2017/8/1.
//  Copyright © 2017年 yn. All rights reserved.
//

#import "MainTabBarController.h"
#import "ViewController.h"
#import "UnNavBarViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewController *vc  = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.title = @"默认->透明->默认";
    [self addChildViewController:nav];
    
    UnNavBarViewController *vc2  = [[UnNavBarViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    vc2.title = @"无->默认";
    [self addChildViewController:nav2];
    
//    UnTopViewController2 *vc3  = [[UnTopViewController2 alloc] init];
//    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
//    vc3.title = @"无->透明";
//    [self addChildViewController:nav3];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s",__func__);
}
@end
