#import <UIKit/UIKit.h>

@protocol ZPPNoInternetDelegate <NSObject>

- (void)tryAgainSender:(id)sender;

@end

@interface ZPPNoInternetConnectionVC : UIViewController

@property (weak, nonatomic) id <ZPPNoInternetDelegate> noInternetDelegate;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet UIImageView *centralLogo;

@end
