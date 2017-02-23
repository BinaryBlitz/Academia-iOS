#import <UIKit/UIKit.h>

@class ZPPUser;

@interface ZPPRegistrationSuccesVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *greatingLabel;

- (void)setUser:(ZPPUser *)user;

@end
