#import <UIKit/UIKit.h>

@class ZPPUser;

@interface ZPPRegistrationOtherInputVC : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextFild;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

- (void)setUser:(ZPPUser *)user;

@end
