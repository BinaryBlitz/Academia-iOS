#import "ZPPProductsBaseTVC.h"
#import "ZPPConfigureWithOrder.h"

@class ZPPOrder;

@interface ZPPAnotherProductsTVC : ZPPProductsBaseTVC <ZPPConfigureWithOrder>

- (void)configureWithStuffs:(NSArray *)stuffs;
- (void)configureWithOrder:(ZPPOrder *)order;

@end
