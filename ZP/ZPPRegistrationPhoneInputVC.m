//
//  ZPPRegistrationPhoneInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationPhoneInputVC.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import <DigitsKit/DigitsKit.h>
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import <REFormattedNumberField.h>
#import "ZPPRegistrationCodeInputVC.h"
#import "ZPPUser.h"

#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"

static NSString *ZPPShowNumberEnterScreenSegueIdentifier =
    @"ZPPShowNumberEnterScreenSegueIdentifier";

static NSString *ZPPShowAuthenticationSegueIdentifier = @"ZPPShowAuthenticationSegueIdentifier";

static NSString *ZPPPhoneWarningMessage = @"Формат номера неправильный";

@interface ZPPRegistrationPhoneInputVC () <UITextFieldDelegate>

@end

@implementation ZPPRegistrationPhoneInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.phoneNumberTextFiled.delegate = self;
    // self.phoneNumberTextFiled.tag = 102;

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.mainTF = (UITextField *)self.phoneNumberTextFiled;
    self.bottomConstraint = self.bottomSuperviewConstraint;

    self.phoneNumberTextFiled.format = @"(XXX) XXX-XXXX";

    UIView *v = self.phoneNumberTextFiled.superview;

    [v makeBordered];

    [self setNeedsStatusBarAppearanceUpdate];

    UITapGestureRecognizer *gr =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];

    gr.numberOfTapsRequired = 1;
    gr.numberOfTouchesRequired = 1;

    [self.phoneNumberTextFiled.superview addGestureRecognizer:gr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];

    [self addCustomCloseButton];
    // [self setCustomBackButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //  [self.phoneNumberTextFiled becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)acceptAction:(UIButton *)sender {
    //
    //    [[Digits sharedInstance] authenticateWithCompletion:^(DGTSession *session, NSError *error)
    //    {
    //
    //    }];

    if ([self checkPhoneTextField:self.phoneNumberTextFiled]) {
        [self performSegueWithIdentifier:ZPPShowNumberEnterScreenSegueIdentifier sender:nil];
    } else {
        [self.phoneNumberTextFiled.superview shakeView];
        [self showWarningWithText:ZPPPhoneWarningMessage];
    }
}
- (IBAction)showAuthentication:(UIButton *)sender {
    [self performSegueWithIdentifier:ZPPShowAuthenticationSegueIdentifier sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ZPPShowNumberEnterScreenSegueIdentifier]) {
        ZPPRegistrationCodeInputVC *destVC =
            (ZPPRegistrationCodeInputVC *)segue.destinationViewController;

        ZPPUser *user = [self user];

        [destVC setUser:user];
    }
}

#pragma mark - UITextFieldDelegate

- (ZPPUser *)user {
    ZPPUser *user = [[ZPPUser alloc] init];

    NSString *phoneNumber =
        [NSString stringWithFormat:@"+7%@", self.phoneNumberTextFiled.unformattedText];

    user.phoneNumber = phoneNumber;
    return user;
}

- (void)dismissKeyboard {
    [self.phoneNumberTextFiled resignFirstResponder];
}

@end
