//
//  ZPPPaymentWebController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPaymentWebController.h"

#import "UIViewController+ZPPViewControllerCategory.h"

@interface ZPPPaymentWebController ()

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ZPPPaymentWebController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  [self.navigationController.navigationBar setTitleTextAttributes:
      @{NSForegroundColorAttributeName: [UIColor whiteColor]}];

  [self addCustomCloseButton];
  self.navigationController.navigationBar.translucent = YES;

  // JS magic
  NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

  WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
  WKUserContentController *wkUController = [[WKUserContentController alloc] init];
  [wkUController addUserScript:wkUScript];

  WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
  wkWebConfig.userContentController = wkUController;
  WKWebView *webView =
      [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkWebConfig];
  webView.navigationDelegate = self;

  [self.view addSubview:webView];

  self.webView = webView;

  NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
  [self.webView loadRequest:nsrequest];
}

- (void)configureWithURL:(NSURL *)url {
  self.url = url;

  NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
  [self.webView loadRequest:nsrequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  if (self.paymentDelegate) {
    [self.paymentDelegate didShowPageWithUrl:webView.URL sender:self];
  }
}

@end
