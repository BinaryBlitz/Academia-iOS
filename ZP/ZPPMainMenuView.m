#import "ZPPMainMenuView.h"

@implementation ZPPMainMenuView

- (void)showCompletion:(void (^)())completion {
  [UIView animateWithDuration:0.4 animations:^{
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  }                completion:^(BOOL finished) {
    if (completion) {
      completion();
    }
  }];
}

- (void)dismissCompletion:(void (^)())completion {
  [UIView animateWithDuration:0.4 animations:^{
    self.frame = CGRectMake(0,
        -self.frame.size.height,
        self.frame.size.width,
        self.frame.size.height);
  }                completion:^(BOOL finished) {

    if (completion) {
      completion();
    }
  }];
}

@end
