@import UIKit;
@import WebKit;

@protocol ZPPPaymentViewDelegate <NSObject>

- (void)didShowPageWithUrl:(NSURL *)url sender:(UIViewController *)vc;
@end

@interface ZPPPaymentWebController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) id <ZPPPaymentViewDelegate> paymentDelegate;

- (void)configureWithURL:(NSURL *)url;

@end
