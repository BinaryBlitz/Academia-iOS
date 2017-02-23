#import <UIKit/UIKit.h>

@class HCSStarRatingView;

@interface ZPPStarsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end
