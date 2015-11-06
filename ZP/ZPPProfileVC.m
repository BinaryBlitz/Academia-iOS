//
//  ZPPProfileVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProfileVC.h"
#import "ZPPUserManager.h"

#import "ZPPCustomTextField.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"

#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPConsts.h"

static NSString *ZPPChangePasswordVCIdentifier = @"ZPPChangePasswordVCIdentifier";

@interface ZPPProfileVC ()

@end
@implementation ZPPProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self setCustomNavigationBackButtonWithTransition];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    ZPPUser *u = [ZPPUserManager sharedInstance].user;

    [self.nameTextField makeBordered];
    [self.secondNameTextField makeBordered];
    [self.emailTextField makeBordered];
    [self.saveProfileButton makeBordered];
    [self.changePasswordButton makeBordered];

    self.nameTextField.text = u.firstName;
    self.secondNameTextField.text = u.lastName;
    self.emailTextField.text = u.email;

    [self.changePasswordButton addTarget:self
                                  action:@selector(showPasswordChanger)
                        forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveAction:(id)sender {
    ZPPUser *u = [ZPPUserManager sharedInstance].user;
    if (![self.nameTextField.text isEqualToString:u.firstName]) {
    }

    if (![self.secondNameTextField.text isEqualToString:u.lastName]) {
    }

    if (![self.emailTextField.text isEqualToString:u.email]) {
    }
}

- (IBAction)logOutAction:(UIButton *)sender {
    [[ZPPUserManager sharedInstance] userLogOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self dismissViewControllerAnimated:YES
                                                completion:^{

                                                }];
                   });
}

- (void)showPasswordChanger {
    UIViewController *vc =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPChangePasswordVCIdentifier];

    [self.navigationController pushViewController:vc animated:YES];
}

@end
