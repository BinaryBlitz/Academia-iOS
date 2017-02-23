@import Foundation;

@class ZPPOrder;

@protocol ZPPConfigureWithOrder <NSObject>

- (void)configureWithOrder:(ZPPOrder *)order;

@end
