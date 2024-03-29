#import "ZPPPasswordRenewCodeInput.h"
#import "ZPPPasswordRenewPasswordInput.h"

static NSString *ZPPPasswordRenewPasswordInputIdentifier =
    @"ZPPPasswordRenewPasswordInputIdentifier";

@implementation ZPPPasswordRenewCodeInput

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.nextRenewButton addTarget:self
                           action:@selector(nextButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextButtonAction:(UIButton *)sender {
  if ([self checkCode]) {
    [self showPasswordInput];
  }
}

- (void)showPasswordInput {
  ZPPPasswordRenewPasswordInput *vc = (ZPPPasswordRenewPasswordInput *) [self.storyboard
      instantiateViewControllerWithIdentifier:ZPPPasswordRenewPasswordInputIdentifier];

  [vc configureWithUser:self.user code:self.token];

  [self.navigationController pushViewController:vc animated:YES];
}

@end
