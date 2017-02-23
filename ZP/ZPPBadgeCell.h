#import <UIKit/UIKit.h>

@interface ZPPBadgeCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *badgesImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *badgesLabels;

@end
