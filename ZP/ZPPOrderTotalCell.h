#import <UIKit/UIKit.h>

@class ZPPOrder;

@interface ZPPOrderTotalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryPriceLabel;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
