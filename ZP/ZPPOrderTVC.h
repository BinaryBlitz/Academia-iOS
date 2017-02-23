@import UIKit;

@class ZPPOrder;

@interface ZPPOrderTVC : UITableViewController

@property (strong, nonatomic, readonly) ZPPOrder *order;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
