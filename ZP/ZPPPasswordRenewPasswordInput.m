//
//  ZPPPasswordRenewPasswordInput.m
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPasswordRenewPasswordInput.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import "ZPPAuthenticationVC.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPUser.h"

@interface ZPPPasswordRenewPasswordInput ()

@property (strong, nonatomic) ZPPUser *user;
@property (strong, nonatomic) NSString *code;

@end

@implementation ZPPPasswordRenewPasswordInput

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.okButton addTarget:self
                    action:@selector(okButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureWithUser:(ZPPUser *)user code:(NSString *)code {
  self.user = user;
  self.code = code;
}

- (void)okButtonAction:(UIButton *)sender {
  if ([self checkNewPassword]) {
    [sender startIndicating];
    [[ZPPServerManager sharedManager] renewPasswordWithNumber:self.user.phoneNumber
                                                         code:self.code
                                                     password:self.userNewPasswordTextField.text
                                                    onSuccess:^{
                                                      [sender stopIndication];
                                                      [self showSuccessWithText:@"Пароль обновлен!"];
                                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (2 * NSEC_PER_SEC)),
                                                          dispatch_get_main_queue(), ^{
                                                            [self popToAuthenticationScreen];
                                                          });
                                                    }
                                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                                      [sender stopIndication];
                                                      [self showWarningWithText:ZPPNoInternetConnectionMessage];
                                                    }];
  }
}

- (void)popToAuthenticationScreen {
  UIViewController *destVC = nil;
  for (UIViewController *vc in self.navigationController.viewControllers) {
    if ([vc isKindOfClass:[ZPPAuthenticationVC class]]) {
      destVC = vc;
    }
  }

  if (!destVC) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  } else {
    [self.navigationController popToViewController:destVC animated:YES];
  }
}

@end
