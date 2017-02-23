#import <UIKit/UIKit.h>

@class ZPPGift;

@interface ZPPGiftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (void)configureWithGift:(ZPPGift *)gift;

- (void)setBadgeCount:(NSInteger)badgeCount;

@end
