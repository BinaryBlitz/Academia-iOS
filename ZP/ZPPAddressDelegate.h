@import Foundation;
@import LMGeocoder;

@protocol ZPPAddressDelegate <NSObject>

- (void)configureWithAddress:(LMAddress *)address sender:(id)sender;

@end
