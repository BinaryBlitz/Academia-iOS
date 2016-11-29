//
//  ZPPChangePasswordVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPChangePasswordVC.h"

#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPServerManager+ZPPRegistration.h"

#import "ZPPConsts.h"

@implementation ZPPChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    self.mainTF = self.oldPasswordTextField;
    self.bottomConstraint = self.superViewBottomConstr;

    [self.oldPasswordTextField makeBordered];
    [self.userNewPasswordTextField makeBordered];
    [self.againPasswordTextField makeBordered];

    [self.doneButton addTarget:self
                        action:@selector(confirmNewPassword:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)checkAll {
//    if (![self checkPasswordTextFied:self.oldPasswordTextField]) {
//        [self accentTextField:self.oldPasswordTextField];
//        [self showWarningWithText:ZPPPasswordErrMessage];
//        return NO;
//    }
//
//    if (![self checkPasswordTextFied:self.userNewPasswordTextField]) {
//        [self accentTextField:self.userNewPasswordTextField];
//        [self showWarningWithText:ZPPPasswordErrMessage];
//        return NO;
//    }
//
//    if (![self checkPasswordEqualty:self.userNewPasswordTextField
//                             second:self.againPasswordTextField]) {
//        [self accentTextField:self.againPasswordTextField];
//        [self showWarningWithText:ZPPPaswordEqualtyErrMessage];
//        return NO;
//    }
//
//    return YES;

    return [self checkOldPassword] && [self checkNewPassword];
}

- (BOOL)checkOldPassword {
    if (![self checkPasswordTextFied:self.oldPasswordTextField]) {
        [self accentTextField:self.oldPasswordTextField];
        [self showWarningWithText:ZPPPasswordErrMessage];
        return NO;
    }
    return YES;
}


- (BOOL)checkNewPassword {

    if (![self checkPasswordTextFied:self.userNewPasswordTextField]) {
        [self accentTextField:self.userNewPasswordTextField];
        [self showWarningWithText:ZPPPasswordErrMessage];
        return NO;
    }

    if (![self checkPasswordEqualty:self.userNewPasswordTextField
                             second:self.againPasswordTextField]) {
        [self accentTextField:self.againPasswordTextField];
        [self showWarningWithText:ZPPPaswordEqualtyErrMessage];
        return NO;
    }

    return YES;

}

- (void)confirmNewPassword:(UIButton *)sender {
    if ([self checkAll]) {
        [self.doneButton startIndicating];

        [[ZPPServerManager sharedManager]
            PATChPasswordOldPassword:self.oldPasswordTextField.text
                         newPassword:self.userNewPasswordTextField.text
                          completion:^(ZPPPasswordChangeStatus status, NSError *err,
                                       NSInteger statusCode) {
                              [self.doneButton stopIndication];
                         //     [self clearFields];

                              switch (status) {
                                  case ZPPPasswordChangeStatusSuccess:
                                      [self showSuccessWithText:@"Пароль " @"обновлен" @"!"];
                                      [self clearFields];
                                      break;
                                  case ZPPPasswordChangeStatusOldWrong:
                                      [self showWarningWithText:@"Неверный старый " @"пароль"];
                                      break;
                                  case ZPPPasswordChangeStatusNewWrong:
                                      [self showWarningWithText:@"Новый " @"пароль не "
                                            @"подходит, " @"попробуйте "
                                            @"другой " @"пароль"];
                                      break;

                                  case ZPPPasswordChangeStatusUndefined:
                                      [self showWarningWithText:ZPPNoInternetConnectionMessage];
                                      break;

                                  default:
                                      break;
                              }

                          }];
    }
}

#pragma mark - support

- (void)configureButtons {
    [self.oldPasswordTextField makeBordered];
    [self.userNewPasswordTextField makeBordered];
    [self.againPasswordTextField makeBordered];
}

- (void)clearFields {
    self.oldPasswordTextField.text = @"";
    self.userNewPasswordTextField.text = @"";
    self.againPasswordTextField.text = @"";
}

@end
