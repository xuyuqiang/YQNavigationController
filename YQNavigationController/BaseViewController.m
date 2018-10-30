//
//  BaseViewController.m
//  testNav2
//
//  Created by Xuyuqiang on 2018/10/27.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *a = self.navigationController.viewControllers;
    if (a.count > 1) {
        self.title = [NSString stringWithFormat:@"我是%lu个",(unsigned long)a.count];
    }
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = myButton;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    btn2.backgroundColor = [UIColor greenColor];
    [btn2 setTitle:@"popToRootViewController" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(btn2Click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightClick {
    
}

- (void)btnClick {
    if (_toVcString == nil) {
        BaseViewController *vc = [[BaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [[NSClassFromString(_toVcString) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)btn2Click {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
