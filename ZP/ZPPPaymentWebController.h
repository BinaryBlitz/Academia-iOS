//
//  ZPPPaymentWebController.h
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;
@import WebKit;

@protocol ZPPPaymentViewDelegate <NSObject>
- (void) didShowPageWithUrl: (NSURL *) url sender:(UIViewController *)vc;
@end


@interface ZPPPaymentWebController : UIViewController <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, weak) id <ZPPPaymentViewDelegate> paymentDelegate;

- (void)configureWithURL:(NSURL *)url;

@end
