#import <UIKit/UIKit.h>

@class ZPPOrderItem;

@interface ZPPOrderItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)configureWithOrderItem:(ZPPOrderItem *)orderItem;

@end
