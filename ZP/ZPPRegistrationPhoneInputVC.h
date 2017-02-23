//#import <UIKit/UIKit.h>
#import "ZPPRegistrationBaseVC.h"

@class REFormattedNumberField;
@class ZPPUser;

@interface ZPPRegistrationPhoneInputVC : ZPPRegistrationBaseVC

@property (weak, nonatomic) IBOutlet REFormattedNumberField *phoneNumberTextFiled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSuperviewConstraint;

//@property (strong, nonatomic) NSString *code;

- (ZPPUser *)user;

@property (weak, nonatomic) IBOutlet UIButton *rulesButton;

@end
