//
//  ZPPCustomTouchTransperentView.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

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
