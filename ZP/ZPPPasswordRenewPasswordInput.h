#import "ZPPChangePasswordVC.h"

@class ZPPUser;

@interface ZPPPasswordRenewPasswordInput : ZPPChangePasswordVC

@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (void)configureWithUser:(ZPPUser *)user code:(NSString *)code;

@end
