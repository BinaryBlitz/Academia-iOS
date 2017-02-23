#import <UIKit/UIKit.h>

extern NSString *const ZPPPasswordErrMessage;
extern NSString *const ZPPPromoCodeErrorMessage;
extern NSString *const ZPPPaswordEqualtyErrMessage;
extern NSString *const ZPPPhoneWarningMessage;

@class REFormattedNumberField;

@interface UIViewController (ZPPValidationCategory)

- (BOOL)checkPhoneTextField:(REFormattedNumberField *)textField;

- (BOOL)checkEmailTextField:(UITextField *)textField;
- (BOOL)checkNameTextField:(UITextField *)textField;
- (BOOL)checkPasswordTextFied:(UITextField *)textField;
- (BOOL)checkPasswordEqualty:(UITextField *)firstField second:(UITextField *)secondTextField;

- (BOOL)checkPromoCodeTextField:(UITextField *)textField;

- (void)accentTextField:(UITextField *)tf;
@end
