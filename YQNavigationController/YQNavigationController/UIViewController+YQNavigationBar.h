//
//  UIViewController+YQNavigationBar.h
//  YQNavigationController
//
//  Created by Xuyuqiang on 2018/10/30.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YQViewControllerShouldPop <NSObject>

//实现该方法，来控制pop返回,点击返回时，会调用该方法
- (BOOL)yq_currentViewControllerShouldPop;

@end

@interface UIViewController (YQNavigationBar)<YQViewControllerShouldPop>
//背景透明度
@property (nonatomic,strong) NSNumber *yq_NavBarAlpha; //默认是nil
//按钮颜色
@property (nonatomic,strong) UIColor *yq_NavBarTintColor; //默认是nil
//背景颜色,动画执行时，不起作用,和直接设置系统的无区别，待删除
//在willAppearView方法中可以改变,//点击返回时，(shouldPopItem解决生硬的问题）
@property (nonatomic,strong) UIColor *yq_NavBarBarTintColor; //默认是nil

//字体颜色在过渡动画中无法改变
//在willAppearView方法中可以改变,//点击返回时，(shouldPopItem解决颜色没变的问题）
@property (nonatomic,strong) UIColor *yq_NavBarTitleColor; //默认是nil

@property (nonatomic,assign) BOOL yq_hidenNavBar; //默认是NO

@end

NS_ASSUME_NONNULL_END
