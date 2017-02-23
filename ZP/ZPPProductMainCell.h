#import <UIKit/UIKit.h>

@interface ZPPProductMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingridientsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToBasketButton;
@property (weak, nonatomic) IBOutlet UIView *topButtonView;

@end
