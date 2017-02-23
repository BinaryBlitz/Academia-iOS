//#import <UIKit/UIKit.h>
#import "ZPPRegistrationBaseVC.h"

@class ZPPUser;

@interface ZPPRegistrationCodeInputVC : ZPPRegistrationBaseVC

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSuperviewConstraint;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *againCodeButton;

@property (strong, nonatomic) ZPPUser *user;
@property (strong, nonatomic) NSString *token;

////- (void)setUser:(ZPPUser *)user;
//- (void)setCode:(NSString *)code;

- (BOOL)checkCode;


@end
