#import "ZPPCustomTouchTransperentView.h"

@implementation ZPPCustomTouchTransperentView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  for (UIView *subview in self.subviews) {
    if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
      return YES;
    }
  }
  return NO;
}
@end
