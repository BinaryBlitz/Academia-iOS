@import Foundation;

@class ZPPAddress;

@protocol ZPPAddressDelegate <NSObject>

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender;

@end
