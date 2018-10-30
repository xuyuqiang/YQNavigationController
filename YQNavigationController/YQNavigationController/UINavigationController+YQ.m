//
//  UINavigationController+YQ.m
//  testNav2
//
//  Created by Xuyuqiang on 2018/10/29.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "UINavigationController+YQ.h"
#import "UIViewController+YQ.h"
#import <objc/runtime.h>

static char *yqNavigationfullScreenPopGestureEnabledKey = "yqNavigationfullScreenPopGestureEnabledKey";

@interface UINavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UINavigationBarDelegate>

@end
@implementation UINavigationController (YQ)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self yq_swizzleSEL:@selector(_updateInteractiveTransition:) withSEL:@selector(yq_updateInteractiveTransition:)];
        [self yq_swizzleSEL:@selector(pushViewController:animated:) withSEL:@selector(yq_pushViewController:animated:)];
        [self yq_swizzleSEL:@selector(popToRootViewControllerAnimated:) withSEL:@selector(yq_popToRootViewControllerAnimated:)];
        [self yq_swizzleSEL:@selector(popViewControllerAnimated:) withSEL:@selector(yq_popViewControllerAnimated:)];
        [self yq_swizzleSEL:@selector(popToViewController:animated:) withSEL:@selector(yq_popToViewController:animated:)];

        [self yq_swizzleSEL:@selector(viewDidLoad) withSEL:@selector(yq_viewDidLoad)];
        
    });
}

+ (void)yq_swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setYq_fullScreenPopGestureEnabled:(BOOL)yq_fullScreenPopGestureEnabled {
    objc_setAssociatedObject(self, yqNavigationfullScreenPopGestureEnabledKey, @(yq_fullScreenPopGestureEnabled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)yq_fullScreenPopGestureEnabled {
    return [objc_getAssociatedObject(self, yqNavigationfullScreenPopGestureEnabledKey) boolValue];
}

- (void)yq_viewDidLoad {
    [self yq_viewDidLoad];
    self.delegate = self;
    //获取侧滑控制权，方便禁止侧滑操作
    self.interactivePopGestureRecognizer.delegate = self;
    if (self.yq_fullScreenPopGestureEnabled) {
        id target = self.interactivePopGestureRecognizer.delegate;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

//兼容栈顶隐藏TabBar的问题
- (void)yq_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count == 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [self yq_pushViewController:viewController animated:animated];
}

- (void)yq_popViewControllerAnimated:(BOOL)animated {
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 2];
    [self yq_changeNavBarStatus:popToVC];
    [self yq_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)yq_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self yq_popToViewController:viewController animated:animated];
    return [self yq_popToViewController:viewController animated:animated];
}

- (void)yq_popToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *popToVC = self.viewControllers[0];
    [self yq_changeNavBarStatus:popToVC];
    [self yq_popToRootViewControllerAnimated:animated];
}

//通过alpha值改变
- (void)yq_updateInteractiveTransition:(CGFloat)percentComplete{
    [self yq_updateInteractiveTransition:percentComplete];
    UIViewController *topVC = self.topViewController;
//    NSLog(@"topVc - %@",NSStringFromClass([topVC class]));
    if(topVC){
        //通过transitionCoordinator拿到转场的两个控制器上下文信息
        id <UIViewControllerTransitionCoordinator> coordinator =  topVC.transitionCoordinator;
        if(coordinator != nil){
            //拿到源控制器和目的控制器的透明度(每个控制器都单独保存了一份)
            UIViewController *fromVC = [coordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [coordinator viewControllerForKey:UITransitionContextToViewControllerKey];
            NSNumber *fromVCAlpha = fromVC.yq_NavBarAlpha;
            NSNumber *toVCAlpha  = toVC.yq_NavBarAlpha;
            if (fromVCAlpha != nil && toVCAlpha != nil) {
                //再通过源,目的控制器的导航条透明度和转场的进度(percentComplete)计算转场时导航条的透明度
                CGFloat newAlpha   = [fromVCAlpha floatValue] + (([toVCAlpha floatValue] - [fromVCAlpha floatValue] ) * percentComplete);
                [self yq_changeNavBarAlpha:newAlpha];
            }
            
            //改变tintColor
            UIColor *fromTintColor = fromVC.yq_NavBarTintColor;
            UIColor *toTintColor = toVC.yq_NavBarTintColor;
            
            if (fromTintColor != nil && toTintColor != nil) {
                self.navigationBar.tintColor = [self averageColor:fromTintColor toColor:toTintColor percent:percentComplete];
            }
        }
    }
}

- (UIColor *)averageColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromR = 0;
    CGFloat fromG = 0;
    CGFloat fromB = 0;
    CGFloat fromA = 0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromA];
    
    CGFloat toR = 0;
    CGFloat toG = 0;
    CGFloat toB = 0;
    CGFloat toA = 0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toA];
    
    CGFloat nowR = fromR + (toR - fromR)*percent;
    CGFloat nowG = fromG + (toG - fromG)*percent;
    CGFloat nowB = fromB + (toB - fromB)*percent;
    CGFloat nowA = fromA + (toA - fromA)*percent;
    return [UIColor colorWithRed:nowR green:nowG blue:nowB alpha:nowA];
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if (context.isCancelled) {
        NSTimeInterval cancellDuration = context.transitionDuration * context.percentComplete;
        [UIView animateWithDuration:cancellDuration animations:^{
            UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
            NSNumber *fromVCAlpha  = fromVc.yq_NavBarAlpha;
            if (fromVCAlpha != nil) {
                [self yq_changeNavBarAlpha:[fromVCAlpha floatValue]];
            }
            UIColor *tintColor = fromVc.yq_NavBarTintColor;
            if (tintColor != nil) {
                self.navigationBar.tintColor = tintColor;
            }
        }];
    } else {
        NSTimeInterval finishDuration = context.transitionDuration * (1 - context.percentComplete);
        [UIView animateWithDuration:finishDuration animations:^{
            UIViewController *toVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
            NSNumber *toVCAlpha  = toVc.yq_NavBarAlpha;
            if (toVCAlpha != nil) {
                [self yq_changeNavBarAlpha:[toVCAlpha floatValue]];
            }
            UIColor *tintColor = toVc.yq_NavBarTintColor;
            if (tintColor != nil) {
                self.navigationBar.tintColor = tintColor;
            }
        }];
    }
}

- (void)yq_changeNavBarStatus:(UIViewController *)toVc {
    NSNumber *n = toVc.yq_NavBarAlpha;
    if (n != nil) {
        [self yq_changeNavBarAlpha:[n floatValue]];
    }
    UIColor *tintColor = toVc.yq_NavBarTintColor;
    if (tintColor != nil) {
        self.navigationBar.tintColor = tintColor;
    }
    UIColor *barTintColor = toVc.yq_NavBarBarTintColor;
    if (barTintColor != nil) {
        self.navigationBar.barTintColor = barTintColor;
    }
    
    UIColor *titleColor = toVc.yq_NavBarTitleColor;
    if (titleColor != nil) {
        NSDictionary *dic = @{NSForegroundColorAttributeName:titleColor};
        self.navigationBar.titleTextAttributes = dic;
    }
}

- (void)yq_changeNavBarAlpha:(CGFloat)navBarAlpha{
    if (self.navigationBar.subviews.count <= 0) {
        return;
    }
    UIView *backgroundView = self.navigationBar.subviews.firstObject;
    if (self.navigationBar.isTranslucent) {
        UIImageView *backgroundImageView = backgroundView.subviews.firstObject;//分割线
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            backgroundImageView.alpha = navBarAlpha;
        } else {
            if (backgroundView.subviews.count >= 2) {
                UIView *visualEffectView = backgroundView.subviews[1]; //
                visualEffectView.alpha = navBarAlpha;
            }
        }
        
    } else {
        //测试,当isTranslucent = NO时，alpha设置失效，下述方法不起作用
        backgroundView.alpha = navBarAlpha;
    }
    
    // 对导航栏下面那条线做处理
    self.navigationBar.clipsToBounds = navBarAlpha == 0.0;
}

#pragma mark - UINavigationControllerDelegate
//松开手势时，即将显示时处理,通过动画处理导航栏的变化
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *vc = navigationController.topViewController;
    if (vc != nil) {
        id<UIViewControllerTransitionCoordinator> coor = vc.transitionCoordinator;
        if (coor != nil) {
            if (@available(iOS 10.0, *)) {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealInteractionChanges:context];
                }];
            } else {
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    [self dealInteractionChanges:context];
                }];
            }
        }
    }
}

#pragma mark - UINavigationBarDelegate
//pop按钮时处理
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= navigationBar.items.count) {//  点击返回按钮
        UIViewController *topVc = self.topViewController;
        BOOL shouldPop = YES;
        if ([topVc respondsToSelector:@selector(yq_currentViewControllerShouldPop)]) {
            shouldPop = [topVc yq_currentViewControllerShouldPop];
        }
        if (shouldPop) {
            UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 2];
            [self yq_changeNavBarStatus:popToVC];
            [self popViewControllerAnimated:YES];
        } else {
            return NO;
        }
    } else if (self.viewControllers.count < navigationBar.items.count) {
        return YES;
    }
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate
//这里栈顶控制器也会有一个侧滑事件，需要禁止掉
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return false;
    }
    
    UIViewController *topVc = self.topViewController;
    if ([topVc respondsToSelector:@selector(yq_currentViewControllerShouldPop)]) {
        return [topVc yq_currentViewControllerShouldPop];
    }
    return YES;
}
@end
