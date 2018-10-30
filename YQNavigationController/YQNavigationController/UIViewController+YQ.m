//
//  UIViewController+YQ.m
//  testNav2
//
//  Created by Xuyuqiang on 2018/10/27.
//  Copyright © 2018年 Xuyuqiang. All rights reserved.
//

#import "UIViewController+YQ.h"
#import <objc/runtime.h>
#import "UINavigationController+YQ.h"
//定义常量 必须是C语言字符串
static char *yqNavBarAlphaKey = "yqNavBarAlphaKey";
static char *yqNavBarTintColorKey = "yqNavBarTintColorKey";
static char *yqNavBarBarTintColorKey = "yqNavBarBarTintColorKey";
static char *yqNavBarTitleColorKey = "yqNavBarTitleColorKey";

static char *yqNavBarHidenKey = "yqNavBarHidenKey";

@implementation UIViewController (YQ)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self yq_swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(yq_viewWillAppear:)];
        [self yq_swizzleSEL:@selector(viewWillDisappear:) withSEL:@selector(yq_viewWillDisappear:)];
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

- (void)yq_viewWillAppear:(BOOL)animated {
    if (self.yq_hidenNavBar) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if (self.yq_NavBarTitleColor) {
        NSDictionary *dic = @{NSForegroundColorAttributeName:self.yq_NavBarTitleColor};
        self.navigationController.navigationBar.titleTextAttributes = dic;
    }
    
    if (self.yq_NavBarBarTintColor) {
        self.navigationController.navigationBar.barTintColor = self.yq_NavBarBarTintColor;
    }
    [self yq_viewWillAppear:animated];
}

- (void)yq_viewWillDisappear:(BOOL)animated {
    if (self.yq_hidenNavBar) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [self yq_viewWillDisappear:animated];
}

- (NSNumber *)yq_NavBarAlpha {
    return objc_getAssociatedObject(self, yqNavBarAlphaKey);
}

- (void)setYq_NavBarAlpha:(NSNumber *)yq_NavBarAlpha {
    if ([yq_NavBarAlpha floatValue] > 1) {
        yq_NavBarAlpha = @(1);
    }
    if ([yq_NavBarAlpha floatValue] <= 0) {
        yq_NavBarAlpha = @(0);
    }
    
    [self.navigationController yq_changeNavBarAlpha:[yq_NavBarAlpha floatValue]];
    objc_setAssociatedObject(self, yqNavBarAlphaKey, yq_NavBarAlpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setYq_NavBarTintColor:(UIColor *)yq_NavBarTintColor {
    self.navigationController.navigationBar.tintColor = yq_NavBarTintColor;
    objc_setAssociatedObject(self, yqNavBarTintColorKey, yq_NavBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yq_NavBarTintColor {
    return objc_getAssociatedObject(self, yqNavBarTintColorKey);
}

- (void)setYq_NavBarBarTintColor:(UIColor *)yq_NavBarBarTintColor {
    self.navigationController.navigationBar.barTintColor = yq_NavBarBarTintColor;
    objc_setAssociatedObject(self, yqNavBarBarTintColorKey, yq_NavBarBarTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIColor *)yq_NavBarBarTintColor {
    return objc_getAssociatedObject(self, yqNavBarBarTintColorKey);
}

- (void)setYq_hidenNavBar:(BOOL)yq_hidenNavBar {
    objc_setAssociatedObject(self, yqNavBarHidenKey, @(yq_hidenNavBar), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)yq_hidenNavBar {
    return [objc_getAssociatedObject(self, yqNavBarHidenKey) boolValue];
}

- (void)setYq_NavBarTitleColor:(UIColor *)yq_NavBarTitleColor {
    NSDictionary *dic = @{NSForegroundColorAttributeName:yq_NavBarTitleColor};
    self.navigationController.navigationBar.titleTextAttributes = dic;
    objc_setAssociatedObject(self, yqNavBarTitleColorKey, yq_NavBarTitleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)yq_NavBarTitleColor {
    return objc_getAssociatedObject(self, yqNavBarTitleColorKey);
}
@end
