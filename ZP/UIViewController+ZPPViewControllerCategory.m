//
//  UIViewController+ZPPViewControllerCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPNoInternetConnectionVC.h"
#import "CWStatusBarNotification.h"

@import VBFPopFlatButton;
@import MBProgressHUD;

@implementation UIViewController (ZPPViewControllerCategory)

- (void)setCustomBackButton {
    UIButton *backButton = [self buttonWithImageName:@"arrowBack"];
    [backButton addTarget:self
                   action:@selector(popBack)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setCustomNavigationBackButtonWithTransition {
    UIBarButtonItem *backButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];

    [self.navigationController.navigationBar
        setBackIndicatorImage:[UIImage imageNamed:@"arrowBack"]];
    [self.navigationController.navigationBar
        setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"arrowBack"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)addPictureToNavItemWithNamePicture:(NSString *)name {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCustomCloseButton {
    UIButton *closeButton = [self buttonWithImageName:@"cross"];
    [closeButton addTarget:self
                    action:@selector(dismisVC)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = closeButtonItem;
}

- (UIButton *)addRightButtonWithName:(NSString *)name {
    UIButton *closeButton = [self buttonWithImageName:name];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = closeButtonItem;

    return closeButton;
}

- (void)dismisVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)buttonWithImageName:(NSString *)imgName {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25.0f, 25.0f)];
    backButton.tintColor = [UIColor whiteColor];
    UIImage *backImage =
        [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];

    return backButton;
}

- (UITableViewCell *)parentCellForView:(id)theView {
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        } else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}

- (void)showWarningWithText:(NSString *)message {
    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    [notification displayNotificationWithMessage:message forDuration:2.0f];
}

- (void)showSuccessWithText:(NSString *)text {
    VBFPopFlatButton *button = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)
                                                            buttonType:buttonOkType
                                                           buttonStyle:buttonPlainStyle
                                                 animateToInitialState:YES];

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.customView = button;
    hud.label.text = text;
    hud.mode = MBProgressHUDModeCustomView;
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2];
}

- (void)showNoInternetVC {
    if (![self respondsToSelector:@selector(tryAgainSender:)]) {
        return;
    }

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ZPPNoInternetConnectionVC *vc =
        [sb instantiateViewControllerWithIdentifier:@"ZPPNoInternetConnectionVCIdentifier"];

    vc.noInternetDelegate = self;

    [self presentViewController:vc animated:YES completion:nil];
}

@end
