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

    v.layer.borderColor = [UIColor blackColor].CGColor;
    v.layer.borderWidth = 2.0f;

    [self setNeedsStatusBarAppearanceUpdate];

    // self.phoneNumberTextFiled.text = @"+7 ";
    // self.phoneNumberTextFiled.delegate = self;
    //[self registerForKeyboardNotifications];

    //    DGTAuthenticateButton *authButton;
    //    authButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession
    //    *session,
    //                                                                             NSError *error) {
    //        if (session.userID) {
    //            // TODO: associate the session userID with your user model
    //            NSString *msg = [NSString stringWithFormat:@"Phone number: %@",
    //            session.phoneNumber];
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are logged in!"
    //                                                            message:msg
    //                                                           delegate:nil
    //                                                  cancelButtonTitle:@"OK"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //        } else if (error) {
    //            NSLog(@"Authentication error: %@", error.localizedDescription);
    //        }
    //    }];
    //    authButton.center = self.view.center;
    //    [self.view addSubview:authButton];

    //  [self.navigationController setCustomNavigationBackButton];
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
    //
    //    [[Digits sharedInstance] authenticateWithCompletion:^(DGTSession *session, NSError *error)
    //    {
    //
    //    }];

    if ([self checkPhoneTextField:self.phoneNumberTextFiled]) {
        [self performSegueWithIdentifier:ZPPShowNumberEnterScreenSegueIdentifier sender:nil];
    } else {
        [self.phoneNumberTextFiled.superview shakeView];
    }
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

//- (BOOL)textField:(UITextField *)textField
//    shouldChangeCharactersInRange:(NSRange)range
//                replacementString:(NSString *)string {
////    NSString *totalString = [NSString stringWithFormat:@"%@%@", textField.text, string];
////
////    // if it's the phone number textfield format it.
////    if (textField.tag == 102) {
////        if (range.length == 1) {
////            // Delete button was hit.. so tell the method to delete the last char.
////            textField.text = [self formatPhoneNumber:totalString deleteLastChar:YES];
////        } else {
////            textField.text = [self formatPhoneNumber:totalString deleteLastChar:NO];
////        }
////        return false;
////    }
////
//
//    if (range.location <= 2 ) {
//        return NO;
//    }
//    return YES;
//}
//
//- (NSString *)formatPhoneNumber:(NSString *)simpleNumber deleteLastChar:(BOOL)deleteLastChar {
//    if (simpleNumber.length == 0)
//        return @"";
//    // use regex to remove non-digits(including spaces) so we are left with just the numbers
//    NSError *error = NULL;
//    NSRegularExpression *regex =
//        [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]"
//                                                  options:NSRegularExpressionCaseInsensitive
//                                                    error:&error];
//    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber
//                                                   options:0
//                                                     range:NSMakeRange(0, [simpleNumber length])
//                                              withTemplate:@""];
//
//    // check if the number is to long
//    if (simpleNumber.length > 10) {
//        // remove last extra chars.
//        simpleNumber = [simpleNumber substringToIndex:10];
//    }
//
//    if (deleteLastChar) {
//        // should we delete the last digit?
//        simpleNumber = [simpleNumber substringToIndex:[simpleNumber length] - 1];
//    }
//
//    // 123 456 7890
//    // format the number.. if it's less then 7 digits.. then use this regex.
//    if (simpleNumber.length < 7)
//        simpleNumber = [simpleNumber
//            stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
//                                      withString:@"($1) $2"
//                                         options:NSRegularExpressionSearch
//                                           range:NSMakeRange(0, [simpleNumber length])];
//
//    else  // else do this one..
//        simpleNumber = [simpleNumber
//            stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
//                                      withString:@"($1) $2-$3"
//                                         options:NSRegularExpressionSearch
//                                           range:NSMakeRange(0, [simpleNumber length])];
//    return simpleNumber;
//}

- (ZPPUser *)user {
    ZPPUser *user = [[ZPPUser alloc] init];

    NSString *phoneNumber =
        [NSString stringWithFormat:@"+7%@", self.phoneNumberTextFiled.unformattedText];

    user.phoneNumber = phoneNumber;
    return user;
}

@end
