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
    if (![self checkPasswordTextFied:self.userNewPasswordTextField]) {
        [self accentTextField:self.userNewPasswordTextField];
        [self showWarningWithText:ZPPPasswordErrMessage];
        return NO;
    }

    return YES;
}

- (void)confirmNewPassword:(UIButton *)sender {
    if ([self checkAll]) {
        [self.doneButton startIndicating];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.doneButton stopIndication];
                           [self showSuccessWithText:@"Пароль обновлен!"];

                       });
    }
}

#pragma mark - support

- (void)configureButtons {
    [self.oldPasswordTextField makeBordered];
    [self.userNewPasswordTextField makeBordered];
    [self.againPasswordTextField makeBordered];
}

@end
