//
//  ZPPRegistrationOtherInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationOtherInputVC.h"
//#import "ZPPRegistrationServerManager.h"
#import "ZPPRegistrationSuccesVC.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import "ZPPUser.h"
#import "ZPPUserManager.h"

#import "UIButton+ZPPButtonCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPConsts.h"

#import <Crashlytics/Crashlytics.h>

static NSString *ZPPShowRegistrationResultSegueIdentifier =
    @"ZPPShowRegistrationResultSegueIdentifier";

static NSString *ZPPNameErrMessage = @"Введите имя";
static NSString *ZPPSurnameErrMaessage = @"Введите фамилию";
static NSString *ZPPEmailErrMessage = @"Введите e-mail";

@interface ZPPRegistrationOtherInputVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) ZPPUser *user;

@end

@implementation ZPPRegistrationOtherInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *arr = [NSMutableArray array];

    [arr addObject:self.nameTextField];
    [arr addObject:self.secondNameTextField];
    [arr addObject:self.emailTextFild];

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    //    [arr addObject:self.passwordTextField];
    //    [arr addObject:self.againPasswordTextField];

    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.secondNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

    self.textFields = [NSArray arrayWithArray:arr];

    for (UITextField *tf in self.textFields) {
        [tf makeBordered];
        tf.delegate = self;
    }

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self addCustomCloseButton];
    [self.navigationItem
        setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

- (void)setUser:(ZPPUser *)user {
    _user = user;
}

- (IBAction)saveProfileAction:(UIButton *)sender {
    [self saveAction:sender];
}

- (void)saveAction:(UIButton *)sender {
    if (![self chekAll]) {
        return;
    }

    [self configureUser];
    [sender startIndicating];
    [[ZPPServerManager sharedManager] POSTRegistrateUser:self.user
        onSuccess:^(ZPPUser *user) {
            [sender stopIndication];
            [[ZPPUserManager sharedInstance] setUser:user];

            self.user = user;

            [Answers logSignUpWithMethod:@"PHONE" success:@YES customAttributes:@{}];

            [self performSegueWithIdentifier:ZPPShowRegistrationResultSegueIdentifier sender:nil];
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [sender stopIndication];
        }];

    //  [ZPPRegistrationServerManager sharedManager] post
}

- (BOOL)chekAll {
    //    if (![self checkNameTextField:self.nameTextField]) {
    //        [self accentTextField:self.nameTextField];
    //        [self showWarningWithText:ZPPNameErrMessage];
    //        return NO;
    //    }
    //
    //    if (![self checkNameTextField:self.secondNameTextField]) {
    //        [self accentTextField:self.secondNameTextField];
    //        [self showWarningWithText:ZPPSurnameErrMaessage];
    //
    //        return NO;
    //    }
    //
    //    if (![self checkEmailTextField:self.emailTextFild]) {
    //        [self accentTextField:self.emailTextFild];
    //        [self showWarningWithText:ZPPEmailErrMessage];
    //        return NO;
    //    }
    //
    ////    if (![self checkPasswordTextFied:self.passwordTextField]) {
    ////        [self accentTextField:self.passwordTextField];
    ////        [self showWarningWithText:ZPPPasswordErrMessage];
    ////
    ////        return NO;
    ////    }
    ////
    ////    if (![self checkPasswordEqualty:self.passwordTextField
    ///second:self.againPasswordTextField]) {
    ////        [self accentTextField:self.againPasswordTextField];
    ////        [self showWarningWithText:ZPPPaswordEqualtyErrMessage];
    ////        return NO;
    ////    }
    //
    //    return YES;

    return [self checkCurrentNameTextField] && [self checkCurrentSecondNameTextField] &&
           [self checkCurrentEmailTextField];
}

- (BOOL)checkCurrentNameTextField {
    if (![self checkNameTextField:self.nameTextField]) {
        [self accentTextField:self.nameTextField];
        [self showWarningWithText:ZPPNameErrMessage];
        return NO;
    }
    return YES;
}

- (BOOL)checkCurrentSecondNameTextField {
    if (![self checkNameTextField:self.secondNameTextField]) {
        [self accentTextField:self.secondNameTextField];
        [self showWarningWithText:ZPPSurnameErrMaessage];

        return NO;
    }
    return YES;
}

- (BOOL)checkCurrentEmailTextField {
    if (![self checkEmailTextField:self.emailTextFild]) {
        [self accentTextField:self.emailTextFild];
        [self showWarningWithText:ZPPEmailErrMessage];
        return NO;
    }

    return YES;
}

//- (void)accentTextField:(UITextField *)tf {
//    [tf shakeView];
//    [tf becomeFirstResponder];
//}

- (void)configureUser {
    self.user.firstName = self.nameTextField.text;
    self.user.lastName = self.secondNameTextField.text;
    self.user.password = self.passwordTextField.text;
    self.user.email = self.emailTextFild.text;
    NSString *pushToken = [ZPPUserManager sharedInstance].pushToken;
    if (pushToken && ![pushToken isEqual:[NSNull null]]) {
        self.user.pushToken = pushToken;
    }
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.nameTextField]) {
        
        if([self checkCurrentNameTextField]) {
            [self.secondNameTextField becomeFirstResponder];
        } else {
            return NO;
        }
    } else if ([textField isEqual:self.secondNameTextField]) {
        
        if([self checkCurrentSecondNameTextField]) {
            [self.emailTextFild becomeFirstResponder];
        } else {
            return NO;
        }
    } else if([textField isEqual:self.emailTextFild]) {
        if([self checkCurrentEmailTextField]) {
            [self saveAction:self.saveButton];
        } else {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
// navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:ZPPShowRegistrationResultSegueIdentifier]) {
        ZPPRegistrationSuccesVC *destVC =
            (ZPPRegistrationSuccesVC *)segue.destinationViewController;

        [destVC setUser:self.user];
    }
}

@end
