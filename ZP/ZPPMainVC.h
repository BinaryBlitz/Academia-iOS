@import UIKit;

#import "ZPPItemProtocol.h"

@class ZPPOrder;

@interface ZPPMainVC : UIViewController

@property (strong, nonatomic) ZPPOrder *order;

- (void)showRegistration;
- (void)addItemIntoOrder:(id <ZPPItemProtocol>)item;
- (void)showNoInternetScreen;

@end
