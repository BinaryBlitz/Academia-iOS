//
//  UIViewController+ZPPViewControllerCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UIViewController+ZPPViewControllerCategory.h"
#import <TSMessage.h>

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
    //    UIImage *backBtn = [UIImage imageNamed:@"arrowBack"];
    //    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    self.navigationItem.backBarButtonItem.title = @"";
    //    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
    //    self.navigationItem.backBarButtonItem =
    //        [[UIBarButtonItem alloc] initWithTitle:@""
    //                                         style:UIBarButtonItemStyleBordered
    //                                        target:nil
    //                                        action:nil];
    //
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    self.navigationController.navigationBar.backIndicatorImage = [[UIImage
    //    imageNamed:@"arrowBack"]
    //        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    self.navigationController.navigationBar.backIndicatorTransitionMaskImage =
    //        [UIImage imageNamed:@"arrowBack"];

    UIBarButtonItem *backButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];

    [self.navigationController.navigationBar
        setBackIndicatorImage:[UIImage imageNamed:@"arrowBack"]];
    [self.navigationController.navigationBar
        setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"arrowBack"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)addPictureToNavItemWithNamePicture:(NSString *)name {
    self.navigationItem.titleView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
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

- (void)dismisVC {
    [self dismissViewControllerAnimated:YES
                             completion:^{

                             }];
}

- (UIButton *)buttonWithImageName:(NSString *)imgName {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
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
    //    [TSMessage showNotificationInViewController:self.navigationController
    //                                          title:@"Ошибка"
    //                                       subtitle:message
    //                  type:TSMessageNotificationTypeWarning];
    //    [TSMessage showNotificationWithTitle:@"Ошибка"
    //                                subtitle:message
    //                                    type:TSMessageNotificationTypeWarning];

    [TSMessage showNotificationInViewController:self.navigationController
                                          title:@"Ошибка"
                                       subtitle:message
                                          image:nil
                                           type:TSMessageNotificationTypeWarning
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}

@end
