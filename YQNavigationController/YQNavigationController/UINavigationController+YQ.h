//
//  UINavigationController+YQ.h
//  testNav2
//
//  Created by Xuyuqiang on 2018/10/29.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//** 注意 **//
//内部通过实现UINavigationControllerDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate协议方法实现效果
//所以会重写主类中部分协议方法，（后续如果发现主类，有实现这些协议的需求，会想办法分离）
//如果想要透明效果，不能设置几个属性，否则隐藏页面会有问题
//不能设置translucent = NO, 即 导航栏使用有半透明效果
//不能设置setBackgroundImage,所以想设置背景颜色可以设置BarTintColor,但会半透明
@interface UINavigationController (YQ)
@property (nonatomic,assign) BOOL yq_fullScreenPopGestureEnabled; //是否开始全屏滑动

//改变导航栏透明度，内部实现调用
- (void)yq_changeNavBarAlpha:(CGFloat)navBarAlpha;
@end

NS_ASSUME_NONNULL_END

//此方法实现风险点：
//由于隐藏，是通过navigationBar的子控件alpha实现，系统并无提供，而是自己根据视图结果设置
//如果系统修改其结果，将会失效

//部分问题：未解决 ， 默认导航栏 -> 透明导航栏 -> 默认导航栏
//1.侧滑有概率出现navigationBar 闪动的情况
//2.侧滑过半，松开，动画有些生硬

//不能设置setBackgroundImage，有些页面影响体验

//参考文章：
//https://www.jianshu.com/p/0e4c759901b4 (iOS导航栏透明平滑过渡的简单实现)
//https://www.jianshu.com/p/31f177158c9e (【iOS】让我们一次性解决导航栏的所有问题)
//https://www.jianshu.com/p/859a1efd2bbf (iOS: 记一次导航栏平滑过渡的实现)
//https://www.jianshu.com/p/454b06590cf1 (导航栏的平滑显示和隐藏 - 个人页的自我修养（1）)
