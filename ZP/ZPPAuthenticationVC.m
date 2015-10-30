//
//  ZPPAuthenticationVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 29/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAuthenticationVC.h"

#import "ZPPServerManager+ZPPRegistration.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "ZPPUserManager.h"

@interface ZPPAuthenticationVC ()

@end

@implementation ZPPAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainTF = self.emailTextField;
    self.bottomConstraint = self.bottomSuperviewConstraint;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self addCustomCloseButton];
    [self setCustomBackButton];

    [self.emailTextField makeBordered];
    [self.passwordTextField makeBordered];

    [self.doneButton addTarget:self
                        action:@selector(doneAction:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)doneAction:(UIButton *)sender {
    if (![self checkEmailTextField:self.emailTextField]) {
        [self accentTextField:self.emailTextField];
        return;
    }

    if (![self checkPasswordTextFied:self.passwordTextField]) {
        [self accentTextField:self.emailTextField];
        return;
    }

    [self authenticateUser];
}

- (void)authenticateUser {
    [self.doneButton startIndicating];
    [[ZPPServerManager sharedManager] POSTAuthenticateUserWithEmail:self.emailTextField.text
        password:self.passwordTextField.text
        onSuccess:^(ZPPUser *user) {
            
            [self.doneButton stopIndication];
            
            [[ZPPUserManager sharedInstance] setUser:user];

            [self dismissViewControllerAnimated:YES completion:nil];
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [self.doneButton stopIndication];
            NSLog(@"err");
        }];
}

@end
