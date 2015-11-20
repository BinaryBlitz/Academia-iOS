//
//  ZPPCustomLabel.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCustomLabel.h"

@implementation ZPPCustomLabel

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(copy:);
}

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.text];
}

@end
