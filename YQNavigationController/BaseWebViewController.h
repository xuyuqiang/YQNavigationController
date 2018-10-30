//
//  BaseTopWebViewController.h
//  BOMI
//
//  Created by xuyuqiang on 2018/8/15.
//  Copyright © 2018年 bomi. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

typedef void (^WebResponseCallback)(id responseData);
typedef void (^WebHandler)(id data, WebResponseCallback responseCallback);

@interface BaseWebViewController : BaseViewController
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;

//注册h5调用方法
- (void)registerHandler:(NSString *)handlerName handler:(WebHandler)handler;
@end
