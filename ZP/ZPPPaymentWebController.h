//
//  ZPPPaymentWebController.h
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class MyClass;             //define class, so protocol can see MyClass
@protocol ZPPPaymentViewDelegate <NSObject>   //define delegate protocol
- (void) didShowPageWithUrl: (NSURL *) url sender:(UIViewController *)vc;  //define delegate method to be implemented within another class
@end //end protocol


@import WebKit;

@interface ZPPPaymentWebController : UIViewController <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, weak) id <ZPPPaymentViewDelegate> paymentDelegate;

- (void)configureWithURL:(NSURL *)url;




@end
