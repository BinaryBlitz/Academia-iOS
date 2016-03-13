//
//  ZPPRegistrationCodeInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationCodeInputVC.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "ZPPRegistrationOtherInputVC.h"
#import "ZPPUserManager.h"
//#import "ZPPUser.h"
#import "UIView+UIViewCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "ZPPSmsVerificationManager.h"
#import "ZPPServerManager+ZPPRegistration.h"

#import <Crashlytics/Crashlytics.h>

#import "ZPPConsts.h"

static NSString *ZPPShowRegistrationOtherScreenSegueIdentifier =
    @"ZPPShowRegistrationOtherScreenSegueIdentifier";

static NSString *ZPPCodeWarningMessage = @"Неправильный код";
@interface ZPPRegistrationCodeInputVC ()  //<UITextFieldDelegate>

//@property (strong, nonatomic) ZPPUser *user;

//@property (strong, nonatomic) NSString *code;
@end

@implementation ZPPRegistrationCodeInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[ZPPSmsVerificationManager shared] canSendAgain]) {
        [[ZPPSmsVerificationManager shared] startTimer];
    }

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self setButtonTextForTime:[ZPPSmsVerificationManager shared].currentTime];
    __weak typeof(self) weakSelf = self;
    [ZPPSmsVerificationManager shared].timerCounter = ^(NSInteger time) {

        [weakSelf setButtonTextForTime:time];
    };

    self.mainTF = self.codeTextField;
    self.bottomConstraint = self.bottomSuperviewConstraint;

    [self.codeTextField makeBordered];
    //    self.codeTextField.delegate = self;

    [self.againCodeButton addTarget:self
                             action:@selector(sendAgain)
                   forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setCustomBackButton];
    [self addCustomCloseButton];

    //  [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.codeTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setUser:(ZPPUser *)user {
//    _user = user;
//}

//- (void)setCode:(NSString *)code {
//    _code = code;
//}

#pragma mark - action

- (IBAction)submitCodeAction:(id)sender {
    //    if (![self checkCode]) {
    //        [self accentTextField:self.codeTextField];
    //        [self showWarningWithText:ZPPCodeWarningMessage];
    //    } else {
    //      [[ZPPSmsVerificationManager shared] invalidateTimer];

    UIButton *b = (UIButton *)sender;
    [b startIndicating];
    [[ZPPServerManager sharedManager] verifyPhoneNumber:self.user.phoneNumber
        code:self.codeTextField.text
        token:self.token
        onSuccess:^(NSString *token) {
            if (token) {
                [[ZPPServerManager sharedManager] getCurrentUserWithToken:token
                    onSuccess:^(ZPPUser *user) {
                        [b stopIndication];
                        [Answers logLoginWithMethod:@"PHONE"
                                            success:@YES
                                   customAttributes:@{}];
                        
                        [[ZPPUserManager sharedInstance] setUser:user];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    onFailure:^(NSError *error, NSInteger statusCode) {
                        [b stopIndication];
                        [self showWarningWithText:ZPPNoInternetConnectionMessage];

                    }];
            } else {
                [b stopIndication];
                [self performSegueWithIdentifier:ZPPShowRegistrationOtherScreenSegueIdentifier
                                          sender:nil];
            }

            //[b stopIndication];

            //            if (user.firstName) {
            //                [[ZPPUserManager sharedInstance] setUser:user];
            //
            //                [self dismissViewControllerAnimated:YES completion:nil];
            //            }

        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [b stopIndication];

            if (statusCode == 403) {
                [self accentTextField:self.codeTextField];
                [self showWarningWithText:ZPPCodeWarningMessage];
            }

            //                if (statusCode == 422) {
            //                    [self
            //                    performSegueWithIdentifier:ZPPShowRegistrationOtherScreenSegueIdentifier
            //                                              sender:nil];
            //                }
            //
        }];

    //[self performSegueWithIdentifier:ZPPShowRegistrationOtherScreenSegueIdentifier
    // sender:nil];
    //    }
}

- (BOOL)checkCode {
//    NSLog(@"text field %@ code %@", self.codeTextField.text, self.token);

    return NO;//[self.codeTextField.text isEqual:self.code];

    //   return [self.codeTextField.text isEqualToString:self.code];
    // return YES;
}

- (void)sendAgain {
    if (![[ZPPSmsVerificationManager shared] canSendAgain]) {
        return;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[ZPPServerManager sharedManager] sendSmsToPhoneNumber:self.user.phoneNumber
        onSuccess:^(NSString *tmpToken) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self showSuccessWithText:@"Код отправлен"];
            [[ZPPSmsVerificationManager shared] startTimer];

        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self showWarningWithText:ZPPNoInternetConnectionMessage];
        }];
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ZPPShowRegistrationOtherScreenSegueIdentifier]) {
        ZPPRegistrationOtherInputVC *destVC =
            (ZPPRegistrationOtherInputVC *)segue.destinationViewController;

        ZPPUser *user = [self user];

        [destVC setUser:user];
    }
}

#pragma mark - support

- (void)setButtonTextForTime:(NSInteger)time {
    NSAttributedString *text;
    if (time != -1) {
        time = ZPPMaxCount - time;

        NSString *timeString = [NSString
            stringWithFormat:@"До повторной отправки %ld " @"секунд",
                             (long)time];

        text = [[NSAttributedString alloc] initWithString:timeString attributes:@{}];
    } else {
        NSDictionary *underlineAttribute =
            @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
        text = [[NSAttributedString alloc] initWithString:@"Отправить повторно"
                                               attributes:underlineAttribute];
    }

    [self.againCodeButton setAttributedTitle:text forState:UIControlStateNormal];
}

@end
