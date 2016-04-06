//
//  UIViewController+ZPPViewControllerCategory.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

@interface UIViewController (ZPPViewControllerCategory)

- (void)setCustomBackButton;
- (void)setCustomNavigationBackButtonWithTransition;
- (void)addCustomCloseButton;
- (UITableViewCell *)parentCellForView:(id)theView;
- (void)showWarningWithText:(NSString *)message;
- (void)addPictureToNavItemWithNamePicture:(NSString *)name;
- (void)showSuccessWithText:(NSString *)text;
- (UIButton *)addRightButtonWithName:(NSString *)name;
- (void)showNoInternetVC;

@end
