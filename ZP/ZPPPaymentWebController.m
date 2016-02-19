//
//  ZPPPaymentWebController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPaymentWebController.h"

#import "UIViewController+ZPPViewControllerCategory.h"

//#import "UIViewController+ZPPValidationCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "DDLog.h"

//@import WebKit;

// static DDLogLevel

@interface ZPPPaymentWebController ()

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSURL *url;

@end

@implementation ZPPPaymentWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"ОПЛАТА";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    [self addCustomCloseButton];
    self.navigationController.navigationBar.translucent = YES;
    // self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];

    // self add

    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView =
        [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
    webView.navigationDelegate = self;
    // NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
    //   NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    //    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];

    self.webView = webView;
    
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:nsrequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
//    [self.webView loadRequest:nsrequest];
}

- (void)configureWithURL:(NSURL *)url {
    self.url = url;
    
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:nsrequest];

    //    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    //    [self.webView loadRequest:nsrequest];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%@", webView.URL.absoluteString);

    if (self.paymentDelegate) {
        [self.paymentDelegate didShowPageWithUrl:webView.URL sender:self];
    }

    // DDLogInfo(@"adr %@", webView.URL.absoluteString);
}

@end
