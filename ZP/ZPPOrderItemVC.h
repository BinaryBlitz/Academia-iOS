@import UIKit;

@class ZPPOrder;
@class ZPPOrderItem;

@interface ZPPOrderItemVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

- (void)configureWithOrder:(ZPPOrder *)order item:(ZPPOrderItem *)orderItem;

@end
