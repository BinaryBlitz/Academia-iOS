//
//  ZPPPromoVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPromoVC.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "UIView+UIViewCategory.h"
#import "ZPPServerManager+ZPPPromoCodeManager.h"

#import "ZPPConsts.h"

@interface ZPPPromoVC ()

@end

@implementation ZPPPromoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.bottomConstraint = self.bottomConstr;
    self.mainTF = self.codeTextField;

    [self.codeTextField makeBordered];

    [self.doneButton addTarget:self
                        action:@selector(confirmCode:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - actions

- (void)confirmCode:(UIButton *)sender {
    if (![self checkPromoCodeTextField:self.codeTextField]) {
        [self accentTextField:self.codeTextField];
        [self showWarningWithText:ZPPPromoCodeErrorMessage];
    }

    [sender startIndicating];

    [[ZPPServerManager sharedManager] POSTPromocCode:self.codeTextField.text
        onSuccess:^{
            [sender stopIndication];
            [self showSuccessWithText:@"Код добавлен"];

            self.codeTextField.text = @"";
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [sender stopIndication];
            [self showWarningWithText:ZPPWrongCardNumber];
        }];
}

#pragma mark - support

- (BOOL)checkCode {
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

@end
