@import UIKit;

#import "ZPPItemProtocol.h"
#import "ZPPMainVCDelegate.h"

@class ZPPOrder;

@interface ZPPMainVC : UIViewController

@property (strong, nonatomic) ZPPOrder *order;
@property (nonatomic, weak) id <ZPPMainVCDelegate> delegate;

- (void)showRegistration;
- (void)addItemIntoOrder:(id <ZPPItemProtocol>)item;
- (void)showNoInternetScreen;
- (void)showMenu;

@end
