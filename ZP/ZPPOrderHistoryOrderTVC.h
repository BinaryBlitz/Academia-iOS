@import UIKit;

@class ZPPOrder;

@interface ZPPOrderHistoryOrderTVC : UITableViewController

@property (strong, nonatomic, readonly) ZPPOrder *order;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
