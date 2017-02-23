#import "UIButton+ZPPButtonCategory.h"

@implementation UIButton (ZPPButtonCategory)

- (void)stopIndication {
  if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
  }

  for (UIView *v in self.subviews) {
    if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
      [v removeFromSuperview];
    }
  }

  self.enabled = YES;
}

- (void)startIndicating {
  [self startIndicatingWithType:UIActivityIndicatorViewStyleWhite];
}

- (void)startIndicatingWithType:(UIActivityIndicatorViewStyle)style {
  [self stopIndication];
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
  UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
  [v startAnimating];

  CGSize size = v.frame.size;

  v.frame = CGRectMake(8, (self.frame.size.height - size.height) / 2.0, v.frame.size.width, v.frame.size.height);

  [self addSubview:v];
  self.enabled = NO;
}

@end
