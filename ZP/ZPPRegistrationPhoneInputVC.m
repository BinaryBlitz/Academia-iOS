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
#import "UIButton+ZPPButtonCategory.h"
#import <REFormattedNumberField.h>
#import "ZPPRegistrationCodeInputVC.h"
#import "ZPPUser.h"

//#import "ZPPSmsVerificationManager.h"
//#import "ZPPServerManager.h"
#import "ZPPServerManager+ZPPRegistration.h"

#import "ZPPConsts.h"

#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"

static NSString *ZPPShowNumberEnterScreenSegueIdentifier =
    @"ZPPShowNumberEnterScreenSegueIdentifier";

static NSString *ZPPShowAuthenticationSegueIdentifier = @"ZPPShowAuthenticationSegueIdentifier";

// static NSString *ZPPPhoneWarningMessage = @"Формат номера неправильный";

@interface ZPPRegistrationPhoneInputVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSString *code;

@end

@implementation ZPPRegistrationPhoneInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.phoneNumberTextFiled.delegate = self;
    // self.phoneNumberTextFiled.tag = 102;

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.mainTF = (UITextField *)self.phoneNumberTextFiled;
    self.bottomConstraint = self.bottomSuperviewConstraint;

    self.phoneNumberTextFiled.format = @"(XXX) XXX-XX-XX";

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
    [self.phoneNumberTextFiled becomeFirstResponder];
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
    if ([self checkPhoneTextField:self.phoneNumberTextFiled]) {
        NSString *number = self.user.phoneNumber;  // self.phoneNumberTextFiled.text;

        [sender startIndicating];

        [[ZPPServerManager sharedManager] sendSmsToPhoneNumber:number
            onSuccess:^(NSString *tmpToken) {
                [sender stopIndication];
                self.code = tmpToken;
                [self performSegueWithIdentifier:ZPPShowNumberEnterScreenSegueIdentifier
                                          sender:nil];

            }
            onFailure:^(NSError *error, NSInteger statusCode) {
                [sender stopIndication];
                [self showWarningWithText:ZPPNoInternetConnectionMessage];
            }];

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
        [destVC setToken:self.code];
        //        self.code = nil;
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
