//
//  ZPPPasswordRenewPhoneInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPasswordRenewPhoneInputVC.h"
#import "UIButton+ZPPButtonCategory.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPSmsVerificationManager.h"

#import "ZPPPasswordRenewCodeInput.h"

#import "ZPPUser.h"

#import "UIView+UIViewCategory.h"

#import <REFormattedNumberField.h>

static NSString
    *ZPPUserNotExistMessage = @"Пользователь с таким номером не "
                              @"зарегистрирован";  // TODO

static NSString *ZPPPasswordRenewCodeInputIdentifier = @"ZPPPasswordRenewCodeInputIdentifier";



@implementation ZPPPasswordRenewPhoneInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.doneButton addTarget:self
                        action:@selector(doneAction:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)doneAction:(UIButton *)sender {
    //  [sender startIndicating];
    if (![self checkPhoneTextField:self.phoneNumberTextFiled]) {
        [self.phoneNumberTextFiled.superview shakeView];
        [self.phoneNumberTextFiled becomeFirstResponder];
        [self showWarningWithText:ZPPPhoneWarningMessage];

    } else {
        [sender startIndicating];
        [[ZPPServerManager sharedManager]
            checkUserWithPhoneNumber:[self user].phoneNumber
                          completion:^(ZPPUserStatus status, NSError *err, NSInteger stausCode) {
                              //[sender stopIndication];

                              switch (status) {
                                  case ZPPUserStatusExist:
                                      [self sendCode];
                                      break;
                                  case ZPPUserStatusNotExist:
                                      [sender stopIndication];
                                      [self showWarningWithText:ZPPUserNotExistMessage];
                                      break;

                                  case ZPPUserStatusUndefined:
                                      [sender stopIndication];
                                      [self showWarningWithText:ZPPNoInternetConnectionMessage];
                                      break;

                                  default:
                                      [sender stopIndication];
                                      break;
                              }
                          }];
    }
}

- (void)sendCode {
    
//    NSInteger code = arc4random() % 10000;
//    
//    self.code = [NSString stringWithFormat:@"%ld", (long)code];
//    NSString *number = self.user.phoneNumber;
//    
//    
//    [[ZPPSmsVerificationManager shared] POSTCode:self.code toNumber:number onSuccess:^{
//        [self.doneButton stopIndication];
//        
//        [self showCodeInput];
//        
//    } onFailure:^(NSError *error, NSInteger statusCode) {
//        [self.doneButton stopIndication];
//        
//        [self showWarningWithText:ZPPNoInternetConnectionMessage];
//        
//    }];
    

}

- (void)showCodeInput {
    ZPPPasswordRenewCodeInput *vc = [self.storyboard instantiateViewControllerWithIdentifier:ZPPPasswordRenewCodeInputIdentifier];
    
    [vc setUser:[self user]];
 //   [vc setCode:self.code];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
