#import <UIKit/UIKit.h>

@interface ZPPProductsIngridientsCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ingredientsImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ingredientsLabels;

@end
