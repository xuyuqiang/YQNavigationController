//
//  BaseTopWebViewController.m
//  BOMI
//
//  Created by xuyuqiang on 2018/8/15.
//  Copyright © 2018年 bomi. All rights reserved.
//

#import "BaseWebViewController.h"
//#import <WebViewJavascriptBridge.h>
//#import "AppService.h"

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条
//@property (nonatomic, strong) WebViewJavascriptBridge* bridge;
@end

@implementation BaseWebViewController

-(void)dealloc
{
    [self.webView removeObserver:self
                      forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self
                      forKeyPath:@"title"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) wself = self;
//    CGFloat y = isIphoneX?88.f:64.f;
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, YQ_Screen_Width, YQ_Screen_Height)];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];

    //    WKWebViewConfiguration *configuration =
    //    [[WKWebView alloc] initWithFrame:CGRectMake(0, y, YQ_Screen_Width, YQ_Screen_Height-y) configuration:nil];
    webView.allowsBackForwardNavigationGestures = YES;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    [webView addObserver:self
              forKeyPath:@"estimatedProgress"
                 options:0
                 context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:_progressView];
    CGFloat h = 3.f;
    _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, h);
    _progressView.trackTintColor= [UIColor clearColor];
    _progressView.progressTintColor = [UIColor blueColor];
    //JSBridge init
//    [WebViewJavascriptBridge enableLogging];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
//    [_bridge setWebViewDelegate:self];
//    
//    //公共参数协议
//    [_bridge registerHandler:@"getClient" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"js->getClient%@", data);
//        responseCallback([AppService shared].getClient.yy_modelToJSONString);
//    }];
//    
//    //copy到原生剪贴板
//    [_bridge registerHandler:@"copy" handler:^(NSString *data, WVJBResponseCallback responseCallback) {
//        NSLog(@"js->copy%@",data);
//        @try {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            pasteboard.string = data;
//        } @catch (NSException *exception) {
//            responseCallback(@"exception");
//            return;
//        } @finally {
//            
//        }
//        responseCallback(@"success");
//    }];
//    
//    [_bridge registerHandler:@"setTitle" handler:^(NSString *data, WVJBResponseCallback responseCallback) {
//        NSLog(@"js->setTittle%@", data);
//        wself.title = data;
//        responseCallback(@"success");
//    }];
    
    
    //eg:
    //    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
    if (self.url.length > 0) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    } else {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"eg.html" ofType:nil];
//        NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        [webView loadHTMLString:html baseURL:nil];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://asstest.balikk.com:1234/ml/help.html#/rule"]]];
    }
}

- (void)setUrl:(NSString *)url
{
    _url = [url copy];
    if (self.webView) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    }
}

- (void)registerHandler:(NSString *)handlerName handler:(WebHandler)handler
{
//    [_bridge registerHandler:handlerName handler:handler];
}

//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.webView.title;
    } else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)backClick:(UIButton *)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让进度条显示
    self.progressView.hidden = NO;
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"url:%@",navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@-error:%@",webView.URL.absoluteString,error);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%@-error:%@",webView.URL.absoluteString,error);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (BOOL)isJumpToExternalAppWithURL:(NSURL *)URL{
    NSSet *validSchemes = [NSSet setWithArray:@[@"http", @"https"]];
    return ![validSchemes containsObject:URL.scheme];
}

- (void)loadWithUrlStr:(NSString*)urlStr
{
    if (urlStr.length > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                        cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
            [self.webView loadRequest:webRequest];
        });
    }
}

@end
