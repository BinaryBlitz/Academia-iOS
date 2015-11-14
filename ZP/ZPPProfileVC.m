//
//  ZPPProfileVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProfileVC.h"
#import "ZPPUserManager.h"

#import "ZPPCustomTextField.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"

#import "UIViewController+ZPPValidationCategory.h"

#import "UITableViewController+ZPPTVCCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPServerManager+ZPPRegistration.h"

#import "ZPPConsts.h"

static NSString *ZPPChangePasswordVCIdentifier = @"ZPPChangePasswordVCIdentifier";

@interface ZPPProfileVC ()

@end
@implementation ZPPProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self setCustomNavigationBackButtonWithTransition];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];

    [self.nameTextField makeBordered];
    [self.secondNameTextField makeBordered];
    [self.emailTextField makeBordered];
    [self.saveProfileButton makeBordered];
    [self.changePasswordButton makeBordered];

    [self.changePasswordButton addTarget:self
                                  action:@selector(showPasswordChanger)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.saveProfileButton addTarget:self
                               action:@selector(saveAction:)
                     forControlEvents:UIControlEventTouchUpInside];

    [self updateScreen];
}

- (void)saveAction:(UIButton *)sender {
    ZPPUser *u = [ZPPUserManager sharedInstance].user;

    NSString *name;
    NSString *lastName;
    NSString *email;
    if (![self.nameTextField.text isEqualToString:u.firstName]) {
        if (![self checkNameTextField:self.nameTextField]) {
            [self accentTextField:self.nameTextField];
            return;
        } else {
            name = self.nameTextField.text;
        }
    }

    if (![self.secondNameTextField.text isEqualToString:u.lastName]) {
        if (![self checkNameTextField:self.secondNameTextField]) {
            [self accentTextField:self.secondNameTextField];
            return;
        } else {
            lastName = self.secondNameTextField.text;
        }
    }

    if (![self.emailTextField.text isEqualToString:u.email]) {
        if (![self checkEmailTextField:self.emailTextField]) {
            [self accentTextField:self.emailTextField];
            return;
        } else {
            email = self.emailTextField.text;
        }
    }

    if (name || lastName || email) {
        __weak typeof(self) weakSelf = self;
        [sender startIndicatingWithType:UIActivityIndicatorViewStyleGray];
        [[ZPPServerManager sharedManager] PATCHUpdateUserWithName:name
            lastName:lastName
            email:email
            onSuccess:^{

                [sender stopIndication];
                if (name) {
                    u.firstName = name;
                }
                if (lastName) {
                    u.lastName = lastName;
                }

                if (email) {
                    u.email = email;
                }

                [[ZPPUserManager sharedInstance] setUser:u];
                [weakSelf updateScreen];

                [weakSelf showSuccessWithText:@"Данные обновлены!"];

            }
            onFailure:^(NSError *error, NSInteger statusCode) {
                [sender stopIndication];
                [self showWarningWithText:ZPPNoInternetConnectionMessage];

            }];
    }
}

- (void)updateScreen {
    ZPPUser *u = [ZPPUserManager sharedInstance].user;
    self.nameTextField.text = u.firstName;
    self.secondNameTextField.text = u.lastName;
    self.emailTextField.text = u.email;
}

- (IBAction)logOutAction:(UIButton *)sender {
    [[ZPPUserManager sharedInstance] userLogOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self dismissViewControllerAnimated:YES
                                                completion:^{

                                                }];
                   });
}

- (void)showPasswordChanger {
    UIViewController *vc =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPChangePasswordVCIdentifier];

    [self.navigationController pushViewController:vc animated:YES];
}

@end
