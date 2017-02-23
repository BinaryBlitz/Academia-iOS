#import <UIKit/UIKit.h>

@class ZPPStuff;

@interface ZPPProductAnotherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addProductButton;

- (void)configureWithStuff:(ZPPStuff *)stuff;

- (void)setBadgeCount:(NSInteger)badgeCount;

@end
