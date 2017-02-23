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
