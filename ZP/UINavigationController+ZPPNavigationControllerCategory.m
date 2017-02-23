#import "UINavigationController+ZPPNavigationControllerCategory.h"

@implementation UINavigationController (ZPPNavigationControllerCategory)

- (void)presentTransparentNavigationBar {
  [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  [self.navigationBar setTranslucent:YES];
  [self.navigationBar setShadowImage:[UIImage new]];
  [self setNavigationBarHidden:NO animated:YES];
}

- (void)hideTransparentNavigationBar {
  [self setNavigationBarHidden:YES animated:NO];
  [self.navigationBar setBackgroundImage:[[UINavigationBar appearance]
          backgroundImageForBarMetrics:UIBarMetricsDefault]
                           forBarMetrics:UIBarMetricsDefault];
  [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
  [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
}

- (void)setCustomNavigationBackButton {
  UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 30.0f)];
  UIImage *backImage = [[UIImage imageNamed:@"back_button_normal.png"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
  [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  [backButton setTitle:@"Back" forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
  UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)popBack {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
