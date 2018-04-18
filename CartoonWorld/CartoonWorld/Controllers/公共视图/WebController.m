//
//  WebController.m
//  CartoonWorld
//
//  Created by dundun on 2017/6/30.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "WebController.h"
#import <WebKit/WebKit.h>

@interface WebController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WebController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACK_WHITE;
    [self.view addSubview:self.webView];
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _webView.navigationDelegate = self;
        _webView.backgroundColor = COLOR_BACK_WHITE;
    }
    return _webView;
}

// 开始加载
- (void)startRequest
{
    [ActivityManager showLoadingInView:self.view];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"结束");
    self.title = webView.title;
    [ActivityManager dismissLoadingInView:self.view status:ShowSuccess];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"失败");
    [ActivityManager dismissLoadingInView:self.view status:ShowFailure];
}

@end
