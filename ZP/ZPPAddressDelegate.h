@import Foundation;
#import "ZPPAddress.h"

@protocol ZPPAddressDelegate <NSObject>

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender;

@end
