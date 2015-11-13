//
//  UIButton+ZPPButtonCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

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

    //    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    //    [self stopIndication];
    //    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc]
    //        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //    [v startAnimating];
    //
    //    // v.frame = CGRectMake(0, 0, 10, 10);
    //    // v.center = self.center;
    //
    //    CGSize size = v.frame.size;
    //
    //    v.frame = CGRectMake(8, (self.frame.size.height - size.height) / 2.0, v.frame.size.width,
    //                         v.frame.size.height);
    //
    //    [self addSubview:v];
    //
    //    self.enabled = NO;
}

- (void)startIndicatingWithType:(UIActivityIndicatorViewStyle)style {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self stopIndication];
    UIActivityIndicatorView *v =
        [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [v startAnimating];

    // v.frame = CGRectMake(0, 0, 10, 10);
    // v.center = self.center;

    CGSize size = v.frame.size;

    v.frame = CGRectMake(8, (self.frame.size.height - size.height) / 2.0, v.frame.size.width,
                         v.frame.size.height);

    [self addSubview:v];

    self.enabled = NO;
}

@end
